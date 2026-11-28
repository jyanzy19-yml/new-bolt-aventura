#!/usr/bin/env python3
"""Validate BOLT project guidance, Claude Code metadata and local Markdown links."""
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


def claude_files(folder: str) -> list[Path]:
    base = ROOT / folder
    if not base.exists():
        WARNINGS.append(f"{folder}: directory not present")
        return []
    return sorted(base.rglob("SKILL.md")) if folder.endswith("/skills") else sorted(base.rglob("*.md"))


def check_claude_files(folder: str, required: tuple[str, ...]) -> int:
    files = claude_files(folder)
    for path in files:
        fields, _ = frontmatter(path)
        for key in required:
            if not fields.get(key):
                ERRORS.append(f"{path.relative_to(ROOT)}: frontmatter field '{key}' is missing")
        if folder.endswith("/skills") and fields.get("name") != path.parent.name:
            ERRORS.append(f"{path.relative_to(ROOT)}: skill name does not match directory")
    return len(files)


def check_unique_metadata(folder: str, key: str) -> int:
    seen: dict[str, Path] = {}
    checked = 0
    for path in claude_files(folder):
        fields, _ = frontmatter(path)
        value = fields.get(key, "")
        if not value:
            continue
        checked += 1
        if value in seen:
            ERRORS.append(
                f"{path.relative_to(ROOT)}: duplicate {key} '{value}' "
                f"(also in {seen[value].relative_to(ROOT)})"
            )
        else:
            seen[value] = path
        if folder.endswith("/agents"):
            tools_value = fields.get("tools", "")
            allowed = {"Read", "Grep", "Glob"}
            declared = {item.strip() for item in tools_value.split(",") if item.strip()}
            if not declared or not declared.issubset(allowed):
                ERRORS.append(
                    f"{path.relative_to(ROOT)}: advisory agent must remain read-only; "
                    f"allowed tools are Read, Grep, Glob (found '{tools_value}')"
                )
    return checked


def check_required_files() -> None:
    required = (
        ".claude/skills/router/SKILL.md",
        ".claude/skills/html5-game-architecture/SKILL.md",
        ".claude/skills/web-game-qa/SKILL.md",
        ".claude/skills/bolt-regression-engineering/SKILL.md",
        ".claude/skills/bolt-android-release-readiness/SKILL.md",
        ".claude/agents/architecture-reviewer.md",
        ".claude/agents/android-release-auditor.md",
        ".claude/agents/persistence-integrity-auditor.md",
        "docs/production/COLLABORATION_STATE.md",
        "docs/production/AGENT_ACCESS_SETUP.md",
        "docs/production/HANDOFF_TEMPLATE.md",
    )
    for relative in required:
        if not (ROOT / relative).is_file():
            ERRORS.append(f"Required project file is missing: {relative}")


def is_legacy_godot_reference(path: Path) -> bool:
    """Allow historical documents to mention removed Godot paths without masking new broken links."""
    try:
        relative = path.relative_to(ROOT.resolve()).as_posix()
    except ValueError:
        return False
    return (
        relative.startswith(("scenes/", "resources/"))
        or (relative.startswith("scripts/") and relative != "scripts/validate_project_docs.py")
        or (relative.startswith("tests/") and relative.endswith((".gd", ".uid")))
        or relative.startswith(".claude/skills/godot-")
        or relative.startswith(".claude/skills/bolt-godot-debugging/")
        or relative == ".claude/agents/godot-integration-reviewer.md"
        or relative in {
            ".godot-version", "project.godot", "export_presets.cfg", "icon.svg.import",
            ".github/workflows/godot-validation.yml",
            ".github/workflows/android-debug-export.yml",
        }
    )


def check_markdown_links() -> int:
    candidates = [ROOT / "README.md", ROOT / "CLAUDE.md", ROOT / "AGENTS.md", ROOT / "MASTER_DIRECTIVE.md"]
    base = ROOT / "docs"
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
            resolved = (source.parent / unquote(parsed.path)).resolve()
            try:
                resolved.relative_to(ROOT.resolve())
            except ValueError:
                ERRORS.append(f"{source.relative_to(ROOT)}: link escapes repository: {target}")
                continue
            if not resolved.exists():
                if is_legacy_godot_reference(resolved):
                    WARNINGS.append(
                        f"{source.relative_to(ROOT)}: historical Godot reference retained: {target}"
                    )
                else:
                    ERRORS.append(f"{source.relative_to(ROOT)}: broken local link: {target}")
            checked += 1
    return checked


def main() -> int:
    skills = check_claude_files(".claude/skills", ("name", "description"))
    agents = check_claude_files(".claude/agents", ("name", "description"))
    commands = check_claude_files(".claude/commands", ("description",))
    links = check_markdown_links()
    unique_skills = check_unique_metadata(".claude/skills", "name")
    unique_agents = check_unique_metadata(".claude/agents", "name")

    if skills < 43:
        ERRORS.append(f"Expected at least 43 active skills in the HTML5 baseline; found {skills}")
    if agents < 11:
        ERRORS.append(f"Expected at least 11 specialist agents in the current baseline; found {agents}")
    if commands < 6:
        ERRORS.append(f"Expected at least 6 BOLT workflow commands; found {commands}")

    check_required_files()

    docs_index = read(ROOT / "docs/README.md")
    if r"## Skills e agentes\n" in docs_index:
        ERRORS.append("docs/README.md: literal escaped newline found in Skills section")

    print("BOLT documentation validation")
    print(
        f"Skills: {skills} ({unique_skills} unique) | "
        f"Agents: {agents} ({unique_agents} unique, read-only) | "
        f"Commands: {commands} | Local Markdown links: {links}"
    )
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
