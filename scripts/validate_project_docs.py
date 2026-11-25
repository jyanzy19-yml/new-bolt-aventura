#!/usr/bin/env python3
"""Validate BOLT's project guidance, Claude Code metadata and local Markdown links."""
from __future__ import annotations

import re
import sys
from pathlib import Path
from urllib.parse import unquote, urlsplit

ROOT = Path(__file__).resolve().parents[1]
ERRORS: list[str] = []
WARNINGS: list[str] = []


def read(path: Path) -> str:
    try:
        return path.read_text(encoding="utf-8")
    except Exception as exc:
        ERRORS.append(f"{path.relative_to(ROOT)}: cannot read file: {exc}")
        return ""


def frontmatter(path: Path) -> tuple[dict[str, str], str]:
    content = read(path)
    match = re.match(r"\A---\s*\n(.*?)\n---\s*(?:\n|$)", content, re.S)
    if not match:
        ERRORS.append(f"{path.relative_to(ROOT)}: missing YAML frontmatter")
        return {}, content
    fields: dict[str, str] = {}
    for line in match.group(1).splitlines():
        item = re.match(r"^([A-Za-z0-9_-]+):\s*(.*)$", line)
        if item:
            fields[item.group(1)] = item.group(2).strip().strip('"').strip("'")
    return fields, content


def check_claude_files(folder: str, required: tuple[str, ...]) -> int:
    base = ROOT / folder
    if not base.exists():
        WARNINGS.append(f"{folder}: directory not present")
        return 0
    files = sorted(base.rglob("SKILL.md")) if folder.endswith("/skills") else sorted(base.rglob("*.md"))
    for path in files:
        fields, _ = frontmatter(path)
        for key in required:
            if not fields.get(key):
                ERRORS.append(f"{path.relative_to(ROOT)}: frontmatter field '{key}' is missing")
        if folder.endswith("/skills") and fields.get("name") != path.parent.name:
            ERRORS.append(f"{path.relative_to(ROOT)}: skill name does not match directory")
    return len(files)


def check_markdown_links() -> int:
    candidates = [ROOT / "README.md", ROOT / "CLAUDE.md", ROOT / "AGENTS.md", ROOT / "MASTER_DIRECTIVE.md"]
    for folder in ("docs",):
        base = ROOT / folder
        if base.exists():
            candidates.extend(base.rglob("*.md"))
    checked = 0
    pattern = re.compile(r"(?<!!)\[[^\]]*\]\(([^)]+)\)")
    for source in sorted(set(candidates)):
        if not source.is_file():
            continue
        content = read(source)
        for raw in pattern.findall(content):
            target = raw.strip().split()[0].strip("<>")
            parsed = urlsplit(target)
            if parsed.scheme or target.startswith("//") or not parsed.path:
                continue
            local = unquote(parsed.path)
            resolved = (source.parent / local).resolve()
            try:
                resolved.relative_to(ROOT.resolve())
            except ValueError:
                ERRORS.append(f"{source.relative_to(ROOT)}: link escapes repository: {target}")
                continue
            if not resolved.exists():
                ERRORS.append(f"{source.relative_to(ROOT)}: broken local link: {target}")
            checked += 1
    return checked


def main() -> int:
    skills = check_claude_files(".claude/skills", ("name", "description"))
    agents = check_claude_files(".claude/agents", ("name", "description"))
    commands = check_claude_files(".claude/commands", ("description",))
    links = check_markdown_links()

    if skills < 35:
        ERRORS.append(f"Expected at least 35 skills in the current baseline; found {skills}")
    if agents < 8:
        ERRORS.append(f"Expected at least 8 specialist agents in the current baseline; found {agents}")
    if commands < 6:
        ERRORS.append(f"Expected at least 6 BOLT workflow commands; found {commands}")

    required_collaboration_docs = (
        "docs/production/COLLABORATION_STATE.md",
        "docs/production/AGENT_ACCESS_SETUP.md",
        "docs/production/HANDOFF_TEMPLATE.md",
    )
    for relative in required_collaboration_docs:
        if not (ROOT / relative).is_file():
            ERRORS.append(f"Required collaboration document is missing: {relative}")

    docs_index = read(ROOT / "docs/README.md")
    if r"## Skills e agentes\n" in docs_index:
        ERRORS.append("docs/README.md: literal escaped newline found in Skills section")

    print("BOLT documentation validation")
    print(f"Skills: {skills} | Agents: {agents} | Commands: {commands} | Local Markdown links: {links}")
    for warning in WARNINGS:
        print(f"WARNING: {warning}")
    for error in ERRORS:
        print(f"ERROR: {error}")
    if ERRORS:
        print(f"FAILED: {len(ERRORS)} issue(s)")
        return 1
    print("PASSED")
    return 0


if __name__ == "__main__":
    sys.exit(main())
