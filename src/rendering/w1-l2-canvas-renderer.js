function panel(context, x, y, width, height, fill, stroke = null) {
  context.fillStyle = fill;
  context.fillRect(x, y, width, height);
  if (stroke) {
    context.strokeStyle = stroke;
    context.lineWidth = 2;
    context.strokeRect(x, y, width, height);
  }
}

/** W1-L2 placeholder renderer. Readable blockout, not approved final art. */
export class W1L2CanvasRenderer {
  #surface;
  #context;
  #state = null;

  constructor(surface) {
    if (!surface?.context || typeof surface.clear !== 'function') {
      throw new TypeError('W1L2CanvasRenderer exige CanvasSurface.');
    }
    this.#surface = surface;
    this.#context = surface.context;
  }

  setState(state) {
    this.#state = state;
  }

  render({ level, player, camera }) {
    const ctx = this.#context;
    const state = this.#state ?? {
      objective: 'Explore a avenida',
      objectiveIndex: 0,
      objectiveCount: 4,
      enemies: [],
      combat: { playerHealth: 5, maxPlayerHealth: 5, activeWeaponShortLabel: 'PISTOLA', projectiles: [], beams: [] },
      message: '',
      interactPrompt: '',
      time: 0,
      completed: false,
      secretFound: false,
    };
    this.#surface.clear('#07101d');
    this.#drawBackdrop(ctx, camera);
    ctx.save();
    ctx.translate(-camera.x, -camera.y);
    this.#drawGeometry(ctx, level);
    this.#drawLandmarks(ctx, level, state);
    for (const enemy of state.enemies) if (enemy.alive) this.#drawEnemy(ctx, enemy, state.time);
    this.#drawCombat(ctx, state.combat);
    this.#drawPlayer(ctx, player, state);
    ctx.restore();
    this.#drawHud(ctx, level, state);
    return {
      levelId: level.id,
      livingEnemies: state.enemies.filter((enemy) => enemy.alive).length,
      activeProjectiles: state.combat.projectiles.length,
      activeBeams: state.combat.beams.length,
      completed: state.completed,
    };
  }

  #drawBackdrop(ctx, camera) {
    const gradient = ctx.createLinearGradient(0, 0, 0, 450);
    gradient.addColorStop(0, '#081326');
    gradient.addColorStop(0.62, '#142c42');
    gradient.addColorStop(1, '#1b3346');
    ctx.fillStyle = gradient;
    ctx.fillRect(0, 0, 800, 450);
    ctx.save();
    ctx.globalAlpha = 0.32;
    for (let i = 0; i < 24; i += 1) {
      const x = i * 220 - camera.x * 0.2;
      const h = 95 + ((i * 43) % 105);
      ctx.fillStyle = i % 2 ? '#17394c' : '#102a3e';
      ctx.fillRect(x, 350 - h, 130, h + 100);
      ctx.fillStyle = '#4d9aa6';
      for (let row = 0; row < 4; row += 1) {
        ctx.fillRect(x + 18, 270 - h + row * 22, 8, 10);
        ctx.fillRect(x + 48, 270 - h + row * 22, 8, 10);
      }
    }
    ctx.restore();
    const glow = ctx.createRadialGradient(580 - camera.x * 0.08, 90, 8, 580 - camera.x * 0.08, 90, 190);
    glow.addColorStop(0, 'rgba(68, 214, 224, .22)');
    glow.addColorStop(1, 'rgba(68, 214, 224, 0)');
    ctx.fillStyle = glow;
    ctx.fillRect(0, 0, 800, 260);
  }

  #drawGeometry(ctx, level) {
    for (const solid of level.geometry.solids) {
      const floor = solid.id === 'cybercore-street-floor';
      const gradient = ctx.createLinearGradient(0, solid.y, 0, solid.y + solid.height);
      gradient.addColorStop(0, floor ? '#3a5665' : '#2a4659');
      gradient.addColorStop(1, '#101f30');
      ctx.fillStyle = gradient;
      ctx.fillRect(solid.x, solid.y, solid.width, solid.height);
      panel(ctx, solid.x, solid.y, solid.width, 5, '#65929a');
      for (let x = solid.x + 20; x < solid.x + solid.width - 10; x += 76) {
        ctx.fillStyle = 'rgba(125, 176, 185, .18)';
        ctx.fillRect(x, solid.y + 18, 2, Math.max(8, Math.min(26, solid.height - 18)));
      }
    }
    for (const platform of level.geometry.oneWayPlatforms) {
      panel(ctx, platform.x, platform.y, platform.width, platform.height, '#274b60');
      panel(ctx, platform.x, platform.y, platform.width, 4, '#71d8d4');
      for (let x = platform.x + 16; x < platform.x + platform.width - 8; x += 40) {
        panel(ctx, x, platform.y + 5, 3, 6, '#557b89');
      }
    }
  }

  #drawLandmarks(ctx, level, state) {
    for (const item of level.landmarks) {
      if (item.kind === 'station') {
        panel(ctx, item.x, item.y + 40, item.width, item.height - 40, '#1b3448', '#5c8794');
        panel(ctx, item.x - 18, item.y + 28, item.width + 36, 18, '#456b79');
        panel(ctx, item.x + 35, item.y + 95, 72, 112, '#0a1b2a', '#4f9da7');
        panel(ctx, item.x + 160, item.y + 85, 170, 12, '#67d4d0');
      } else if (item.kind === 'repeater') {
        panel(ctx, item.x + 70, item.y + 10, 22, item.height - 10, '#2a4659', '#5e9da6');
        panel(ctx, item.x + 22, item.y + 54, 118, 14, '#3c6878');
        const pulse = 0.5 + Math.sin(state.time * 3) * 0.5;
        ctx.save();
        ctx.globalAlpha = state.repeaterActive ? 0.8 : 0.2 + pulse * 0.25;
        ctx.fillStyle = '#73e5d9';
        ctx.beginPath();
        ctx.arc(item.x + 81, item.y + 38, 28 + pulse * 8, 0, Math.PI * 2);
        ctx.fill();
        ctx.restore();
        panel(ctx, item.x + 74, item.y + 28, 14, 30, state.repeaterActive ? '#b6f6d0' : '#d8bd75');
      } else if (item.kind === 'terminal') {
        panel(ctx, item.x, item.y, item.width, item.height, state.secretFound ? '#2b665d' : '#243f53', '#79d9d4');
        panel(ctx, item.x + 13, item.y + 14, 48, 5, '#e2c477');
        panel(ctx, item.x + 13, item.y + 29, 38, 3, '#75c8c9');
      } else if (item.kind === 'sign') {
        panel(ctx, item.x + 52, item.y + 32, 12, item.height - 32, '#405b6b');
        panel(ctx, item.x, item.y, item.width, 52, '#203d52', '#68c7ca');
        panel(ctx, item.x + 15, item.y + 16, 88, 5, '#e0c37b');
      } else if (item.kind === 'plaza') {
        panel(ctx, item.x, item.y + 70, item.width, item.height - 70, '#203c50', '#5a8794');
        panel(ctx, item.x + 20, item.y + 56, item.width - 40, 14, '#5b8792');
      }
    }
  }

  #drawEnemy(ctx, enemy, time) {
    const bob = enemy.archetype === 'watch-drone' ? Math.sin(time * 6 + enemy.x) * 5 : 0;
    if (enemy.archetype === 'watch-drone') {
      ctx.fillStyle = '#4a6074';
      ctx.beginPath();
      ctx.ellipse(enemy.x + enemy.width / 2, enemy.y + enemy.height / 2 + bob, enemy.width / 2, enemy.height / 2, 0, 0, Math.PI * 2);
      ctx.fill();
      panel(ctx, enemy.x + 11, enemy.y + 10 + bob, 12, 5, '#f1c66e');
      ctx.fillStyle = 'rgba(100, 220, 230, .22)';
      ctx.beginPath();
      ctx.arc(enemy.x + enemy.width / 2, enemy.y + enemy.height / 2 + bob, 23, 0, Math.PI * 2);
      ctx.fill();
    } else if (enemy.archetype === 'patrol-sentinel') {
      panel(ctx, enemy.x + 5, enemy.y + 5, enemy.width - 10, enemy.height - 12, '#526d79', '#d2a76c');
      panel(ctx, enemy.x + (enemy.direction > 0 ? 25 : 7), enemy.y + 14, 9, 5, '#ffcf76');
      panel(ctx, enemy.x + 4, enemy.y + enemy.height - 8, 12, 8, '#1b2c3b');
      panel(ctx, enemy.x + enemy.width - 16, enemy.y + enemy.height - 8, 12, 8, '#1b2c3b');
    } else {
      panel(ctx, enemy.x + 3, enemy.y + 7 + bob, enemy.width - 6, enemy.height - 14, '#80634b', '#d9b17a');
      panel(ctx, enemy.x + (enemy.direction > 0 ? 24 : 7), enemy.y + 17 + bob, 8, 4, '#d8e8dc');
      panel(ctx, enemy.x + 7, enemy.y + enemy.height - 9, 10, 8, '#243442');
      panel(ctx, enemy.x + 26, enemy.y + enemy.height - 9, 10, 8, '#243442');
    }
    const barWidth = enemy.width;
    panel(ctx, enemy.x, enemy.y - 9, barWidth, 3, '#263b4b');
    panel(ctx, enemy.x, enemy.y - 9, barWidth * Math.max(0, enemy.health) / (enemy.archetype === 'patrol-sentinel' ? 4 : enemy.archetype === 'watch-drone' ? 2 : 3), 3, '#e1b96e');
  }

  #drawCombat(ctx, combat) {
    for (const projectile of combat.projectiles) {
      ctx.fillStyle = projectile.owner === 'player' ? '#8cf4e8' : '#f2a36e';
      ctx.beginPath();
      ctx.arc(projectile.x + projectile.width / 2, projectile.y + projectile.height / 2, Math.max(3, projectile.width / 2), 0, Math.PI * 2);
      ctx.fill();
    }
    for (const beam of combat.beams) {
      ctx.save();
      ctx.globalAlpha = Math.max(0.25, beam.remainingSeconds / beam.durationSeconds);
      ctx.fillStyle = '#8af5ec';
      ctx.shadowColor = '#6de8df';
      ctx.shadowBlur = 12;
      ctx.fillRect(beam.x, beam.y, beam.width, beam.height);
      ctx.restore();
    }
  }

  #drawPlayer(ctx, player, state) {
    const body = player.body;
    if (state.combat.invulnerable && Math.floor(state.time * 18) % 2 === 0) return;
    ctx.fillStyle = '#152d3d';
    ctx.fillRect(body.x + 4, body.y + 22, body.width - 8, body.height - 22);
    panel(ctx, body.x + 3, body.y + 3, body.width - 6, 25, '#c3d8d7', '#5ed2d5');
    panel(ctx, body.x + (player.facing > 0 ? 17 : 5), body.y + 12, 11, 7, '#102332');
    panel(ctx, body.x + (player.facing > 0 ? 19 : 7), body.y + 14, 7, 3, '#8cf0e7');
    panel(ctx, body.x + 6, body.y + body.height - 7, 8, 7, '#718c99');
    panel(ctx, body.x + body.width - 14, body.y + body.height - 7, 8, 7, '#718c99');
  }

  #drawHud(ctx, level, state) {
    ctx.save();
    panel(ctx, 14, 12, 772, 76, 'rgba(4, 13, 25, .88)', 'rgba(112, 206, 210, .5)');
    ctx.fillStyle = '#83e2dc';
    ctx.font = '800 11px system-ui, sans-serif';
    ctx.fillText('MUNDO 01 / CYBERCORE', 30, 31);
    ctx.fillStyle = '#f1f6f4';
    ctx.font = '700 16px system-ui, sans-serif';
    ctx.fillText(level.title, 30, 55);
    ctx.fillStyle = '#b8cdd2';
    ctx.font = '600 12px system-ui, sans-serif';
    ctx.fillText(state.objective, 350, 40, 380);
    panel(ctx, 350, 58, 380, 5, '#304b5b');
    panel(ctx, 350, 58, 380 * ((state.objectiveIndex + (state.completed ? 1 : 0)) / state.objectiveCount), 5, '#69d6d2');
    ctx.fillStyle = '#f1d58b';
    ctx.font = '800 11px system-ui, sans-serif';
    ctx.fillText('VIDA', 30, 78);
    for (let i = 0; i < state.combat.maxPlayerHealth; i += 1) {
      panel(ctx, 68 + i * 16, 69, 11, 9, i < state.combat.playerHealth ? '#edb56d' : '#344755');
    }
    ctx.fillStyle = '#8ce6df';
    ctx.fillText('ARMA: ' + state.combat.activeWeaponShortLabel, 180, 78);
    if (state.secretFound) {
      ctx.fillStyle = '#e5c77c';
      ctx.fillText('REGISTRO RECUPERADO', 330, 78);
    }
    if (state.message) {
      panel(ctx, 140, 364, 520, 54, 'rgba(4, 13, 24, .92)', 'rgba(103, 222, 218, .6)');
      ctx.fillStyle = '#b9f4eb';
      ctx.font = '700 12px system-ui, sans-serif';
      ctx.textAlign = 'center';
      ctx.fillText(state.message, 400, 395, 485);
      ctx.textAlign = 'left';
    }
    if (state.interactPrompt) {
      panel(ctx, 180, 318, 440, 34, 'rgba(4, 13, 24, .94)', '#e4c77a');
      ctx.fillStyle = '#f4e4b7';
      ctx.font = '800 11px system-ui, sans-serif';
      ctx.textAlign = 'center';
      ctx.fillText(state.interactPrompt, 400, 340, 410);
      ctx.textAlign = 'left';
    }
    if (state.completed) {
      ctx.fillStyle = 'rgba(2, 8, 16, .78)';
      ctx.fillRect(0, 0, 800, 450);
      panel(ctx, 175, 125, 450, 200, '#10283a', '#7ae1d8');
      ctx.fillStyle = '#8de9df';
      ctx.textAlign = 'center';
      ctx.font = '800 13px system-ui, sans-serif';
      ctx.fillText('CYBERCORE · W1-L2', 400, 174);
      ctx.fillStyle = '#f5f7f2';
      ctx.font = '900 30px system-ui, sans-serif';
      ctx.fillText('REPETIDOR RESTAURADO', 400, 220);
      ctx.fillStyle = '#c4d7d8';
      ctx.font = '600 13px system-ui, sans-serif';
      ctx.fillText('A passagem para a Fábrica de Ecos está aberta.', 400, 254);
      ctx.textAlign = 'left';
    }
    ctx.restore();
  }
}
