function roundedRect(context, x, y, width, height, radius, fill, stroke = null) {
  const r = Math.min(radius, width / 2, height / 2);
  context.beginPath();
  context.moveTo(x + r, y);
  context.lineTo(x + width - r, y);
  context.quadraticCurveTo(x + width, y, x + width, y + r);
  context.lineTo(x + width, y + height - r);
  context.quadraticCurveTo(x + width, y + height, x + width - r, y + height);
  context.lineTo(x + r, y + height);
  context.quadraticCurveTo(x, y + height, x, y + height - r);
  context.lineTo(x, y + r);
  context.quadraticCurveTo(x, y, x + r, y);
  context.closePath();
  context.fillStyle = fill;
  context.fill();
  if (stroke) {
    context.strokeStyle = stroke;
    context.lineWidth = 2;
    context.stroke();
  }
}

/**
 * Original vector/blockout renderer for the first playable W1-L1 slice.
 * This is gameplay-readable placeholder art, not the approved final art style.
 */
export class W1L1CanvasRenderer {
  #surface;
  #context;
  #state = null;

  constructor(surface) {
    if (!surface?.context || typeof surface.clear !== 'function') {
      throw new TypeError('W1L1CanvasRenderer exige uma CanvasSurface.');
    }
    this.#surface = surface;
    this.#context = surface.context;
  }

  setState(state) {
    this.#state = state;
  }

  render({ level, player, camera }) {
    const context = this.#context;
    const state = this.#state ?? {
      objective: 'Explore as ruínas',
      objectiveIndex: 0,
      objectiveCount: 4,
      enemy: level.enemy,
      message: '',
      interactPrompt: '',
      time: 0,
      completed: false,
      secretFound: false,
      checkpointActive: false,
    };

    this.#surface.clear('#07111e');
    this.#drawBackdrop(context, camera);
    context.save();
    context.translate(-camera.x, -camera.y);
    this.#drawWorld(context, level);
    this.#drawLandmarks(context, level, state);
    this.#drawEnemy(context, state.enemy, state.time);
    this.#drawPlayer(context, player, state.time);
    context.restore();
    this.#drawHud(context, level, state);
    return {
      levelId: level.id,
      player: 1,
      landmarks: level.landmarks.length,
      enemy: 1,
      objectiveIndex: state.objectiveIndex,
      completed: state.completed,
    };
  }

  #drawBackdrop(context, camera) {
    const gradient = context.createLinearGradient(0, 0, 0, 450);
    gradient.addColorStop(0, '#081426');
    gradient.addColorStop(0.58, '#10283b');
    gradient.addColorStop(1, '#1b3040');
    context.fillStyle = gradient;
    context.fillRect(0, 0, 800, 450);

    context.save();
    context.globalAlpha = 0.34;
    for (let index = 0; index < 18; index += 1) {
      const worldX = index * 250;
      const x = worldX - camera.x * 0.18;
      const height = 70 + ((index * 37) % 100);
      context.fillStyle = index % 3 === 0 ? '#17384a' : '#10283a';
      context.fillRect(x, 290 - height, 100 + (index % 3) * 18, height + 160);
      context.fillStyle = '#4f91a3';
      for (let row = 0; row < 4; row += 1) {
        context.fillRect(x + 16, 305 - height + row * 22, 5, 8);
        context.fillRect(x + 42, 305 - height + row * 22, 5, 8);
      }
    }
    context.restore();

    const glowX = 590 - camera.x * 0.08;
    const glow = context.createRadialGradient(glowX, 105, 8, glowX, 105, 190);
    glow.addColorStop(0, 'rgba(56, 211, 224, 0.20)');
    glow.addColorStop(1, 'rgba(56, 211, 224, 0)');
    context.fillStyle = glow;
    context.fillRect(0, 0, 800, 300);
    context.fillStyle = 'rgba(103, 224, 225, 0.16)';
    context.fillRect(0, 352, 800, 2);
  }

  #drawWorld(context, level) {
    for (const solid of level.geometry.solids) {
      const floor = solid.id === 'cybercore-floor';
      const gradient = context.createLinearGradient(0, solid.y, 0, solid.y + solid.height);
      gradient.addColorStop(0, floor ? '#314c5c' : '#253d50');
      gradient.addColorStop(1, '#101f30');
      context.fillStyle = gradient;
      context.fillRect(solid.x, solid.y, solid.width, solid.height);
      context.fillStyle = '#5c8290';
      context.fillRect(solid.x, solid.y, solid.width, 5);
      context.fillStyle = 'rgba(4, 12, 22, 0.45)';
      context.fillRect(solid.x, solid.y + 9, solid.width, 3);
      for (let x = solid.x + 24; x < solid.x + solid.width - 12; x += 86) {
        context.fillStyle = 'rgba(120, 165, 174, 0.16)';
        context.fillRect(x, solid.y + 24, 2, Math.min(22, solid.height - 24));
      }
    }

    for (const platform of level.geometry.oneWayPlatforms) {
      context.fillStyle = '#27495b';
      context.fillRect(platform.x, platform.y, platform.width, platform.height);
      context.fillStyle = '#6bd5d2';
      context.fillRect(platform.x, platform.y, platform.width, 4);
      context.fillStyle = 'rgba(3, 12, 24, 0.55)';
      context.fillRect(platform.x + 8, platform.y + platform.height - 3, platform.width - 16, 3);
      for (let x = platform.x + 18; x < platform.x + platform.width - 8; x += 42) {
        context.fillStyle = '#426b79';
        context.fillRect(x, platform.y + 5, 3, 6);
      }
    }

    for (let x = 0; x < 3600; x += 240) {
      context.fillStyle = 'rgba(121, 173, 177, 0.13)';
      context.fillRect(x + 18, 560, 48, 2);
      context.fillRect(x + 98, 574, 22, 2);
    }
  }

  #drawLandmarks(context, level, state) {
    for (const landmark of level.landmarks) {
      if (landmark.kind === 'pod') {
        roundedRect(context, landmark.x, landmark.y, landmark.width, landmark.height, 18, '#1c394b', '#6bcbd0');
        roundedRect(context, landmark.x + 15, landmark.y + 12, 82, 92, 12, '#0c1d2b', '#3e8294');
        context.fillStyle = 'rgba(100, 225, 230, 0.20)';
        context.fillRect(landmark.x + 24, landmark.y + 22, 64, 72);
        context.fillStyle = '#d6b66a';
        context.fillRect(landmark.x + 8, landmark.y + 108, 96, 5);
      } else if (landmark.kind === 'mast') {
        context.fillStyle = '#314e60';
        context.fillRect(landmark.x + 19, landmark.y, 8, landmark.height);
        context.fillStyle = '#5acbd0';
        context.fillRect(landmark.x, landmark.y + 12, 46, 5);
        context.fillRect(landmark.x + 5, landmark.y + 28, 36, 3);
        context.beginPath();
        context.arc(landmark.x + 23, landmark.y + 12, 14 + Math.sin(state.time * 2) * 2, 0, Math.PI * 2);
        context.strokeStyle = 'rgba(92, 223, 225, 0.65)';
        context.stroke();
      } else if (landmark.kind === 'arch') {
        context.fillStyle = '#293e50';
        context.fillRect(landmark.x, landmark.y + 34, 28, landmark.height - 34);
        context.fillRect(landmark.x + landmark.width - 28, landmark.y + 34, 28, landmark.height - 34);
        context.fillRect(landmark.x + 8, landmark.y + 24, landmark.width - 16, 20);
        context.fillStyle = '#70c5c4';
        context.fillRect(landmark.x + 16, landmark.y + 43, 5, landmark.height - 52);
      } else if (landmark.kind === 'terminal') {
        const found = state.secretFound;
        roundedRect(context, landmark.x, landmark.y, landmark.width, landmark.height, 8, found ? '#2d665f' : '#263f50', found ? '#9ce7bd' : '#65d4d4');
        context.fillStyle = found ? '#b8f4ca' : '#e0c46e';
        context.fillRect(landmark.x + 15, landmark.y + 15, 38, 5);
        context.fillRect(landmark.x + 15, landmark.y + 28, 28, 3);
        context.fillRect(landmark.x + 15, landmark.y + 39, 34, 3);
      } else if (landmark.kind === 'shelter') {
        context.fillStyle = '#203b4d';
        context.fillRect(landmark.x, landmark.y + 35, landmark.width, landmark.height - 35);
        context.fillStyle = '#416b78';
        context.fillRect(landmark.x - 14, landmark.y + 24, landmark.width + 28, 18);
        context.fillStyle = '#0d1e2c';
        context.fillRect(landmark.x + 32, landmark.y + 65, 62, landmark.height - 65);
        context.fillRect(landmark.x + 132, landmark.y + 65, 62, landmark.height - 65);
        context.fillStyle = '#70d7d1';
        context.fillRect(landmark.x + 105, landmark.y + 74, 16, 4);
      } else if (landmark.kind === 'beacon') {
        const pulse = 0.5 + 0.5 * Math.sin(state.time * 3);
        context.fillStyle = '#263f51';
        context.fillRect(landmark.x + 33, landmark.y + 14, 18, 92);
        context.fillStyle = '#e2c477';
        context.fillRect(landmark.x + 22, landmark.y + 82, 40, 8);
        context.save();
        context.globalAlpha = 0.25 + pulse * 0.35;
        context.beginPath();
        context.arc(landmark.x + 42, landmark.y + 25, 34 + pulse * 10, 0, Math.PI * 2);
        context.fillStyle = '#71e4dc';
        context.fill();
        context.restore();
        context.fillStyle = state.checkpointActive ? '#b6f6d0' : '#5bd2d3';
        context.fillRect(landmark.x + 37, landmark.y + 18, 10, 28);
      }
    }

    const enemy = state.enemy;
    if (enemy) {
      context.fillStyle = 'rgba(4, 10, 18, 0.35)';
      context.fillRect(enemy.x - 4, enemy.y + enemy.height - 2, enemy.width + 8, 5);
    }
  }

  #drawEnemy(context, enemy, time) {
    if (!enemy) return;
    const bob = Math.sin(time * 8) * 2;
    roundedRect(context, enemy.x, enemy.y + bob, enemy.width, enemy.height - 8, 7, '#7c5a42', '#d9a66a');
    context.fillStyle = '#c8e4db';
    context.fillRect(enemy.x + (enemy.direction > 0 ? 27 : 8), enemy.y + 11 + bob, 8, 5);
    context.fillStyle = '#f4c46f';
    context.fillRect(enemy.x + 17, enemy.y + 2 + bob, 8, 4);
    context.fillStyle = '#26303a';
    context.fillRect(enemy.x + 6, enemy.y + enemy.height - 10, 10, 8);
    context.fillRect(enemy.x + 27, enemy.y + enemy.height - 10, 10, 8);
  }

  #drawPlayer(context, player, time) {
    const body = player.body;
    const bob = player.state === 'grounded' ? Math.sin(time * 9) * 1.5 : 0;
    if (player.state === 'dashing') {
      context.save();
      context.globalAlpha = 0.22;
      context.fillStyle = '#75e5e5';
      context.fillRect(body.x - player.facing * 30, body.y + 8, body.width, body.height - 12);
      context.restore();
    }
    context.fillStyle = '#152c3c';
    context.fillRect(body.x + 4, body.y + 22 + bob, body.width - 8, body.height - 22);
    roundedRect(context, body.x + 3, body.y + 3 + bob, body.width - 6, 25, 7, '#c3d8d7', '#5ed2d5');
    context.fillStyle = '#102332';
    context.fillRect(body.x + (player.facing > 0 ? 17 : 5), body.y + 12 + bob, 11, 7);
    context.fillStyle = '#8cf0e7';
    context.fillRect(body.x + (player.facing > 0 ? 19 : 7), body.y + 14 + bob, 7, 3);
    context.fillStyle = '#718c99';
    context.fillRect(body.x + 6, body.y + body.height - 7, 8, 7);
    context.fillRect(body.x + body.width - 14, body.y + body.height - 7, 8, 7);
    context.fillStyle = '#e0bf70';
    context.fillRect(body.x + 12, body.y + 29 + bob, 6, 4);
  }

  #drawHud(context, level, state) {
    context.save();
    roundedRect(context, 16, 14, 768, 70, 12, 'rgba(5, 14, 26, 0.86)', 'rgba(110, 197, 207, 0.45)');
    context.fillStyle = '#83e2dc';
    context.font = '800 11px system-ui, sans-serif';
    context.fillText('MUNDO 01  /  CYBERCORE', 32, 34);
    context.fillStyle = '#f2f6f5';
    context.font = '700 16px system-ui, sans-serif';
    context.fillText(level.title, 32, 58);
    context.fillStyle = '#b4cbd1';
    context.font = '600 12px system-ui, sans-serif';
    context.fillText(state.objective, 360, 43);
    context.fillStyle = '#365362';
    context.fillRect(360, 58, 360, 5);
    context.fillStyle = '#69d6d2';
    context.fillRect(360, 58, 360 * ((state.objectiveIndex + (state.completed ? 1 : 0)) / state.objectiveCount), 5);

    if (state.secretFound) {
      context.fillStyle = '#e5c77c';
      context.font = '700 10px system-ui, sans-serif';
      context.fillText('REGISTRO OPCIONAL', 32, 76);
    }
    if (state.checkpointActive) {
      context.fillStyle = '#9ce7bd';
      context.font = '700 10px system-ui, sans-serif';
      context.fillText('SINCRONIZADO', 190, 76);
    }

    if (state.message) {
      roundedRect(context, 150, 365, 500, 52, 9, 'rgba(4, 13, 24, 0.91)', 'rgba(103, 222, 218, 0.55)');
      context.fillStyle = '#b9f4eb';
      context.font = '700 12px system-ui, sans-serif';
      context.textAlign = 'center';
      context.fillText(state.message, 400, 395, 460);
      context.textAlign = 'left';
    }
    if (state.interactPrompt) {
      roundedRect(context, 205, 315, 390, 34, 8, 'rgba(4, 13, 24, 0.92)', '#e4c77a');
      context.fillStyle = '#f4e4b7';
      context.font = '800 11px system-ui, sans-serif';
      context.textAlign = 'center';
      context.fillText(state.interactPrompt, 400, 337, 360);
      context.textAlign = 'left';
    }
    if (state.enemyContact) {
      context.fillStyle = '#f3c47d';
      context.font = '800 11px system-ui, sans-serif';
      context.fillText('UNIDADE DE MANUTENÇÃO EM MOVIMENTO', 32, 106);
    }
    if (state.completed) {
      context.fillStyle = 'rgba(2, 8, 16, 0.78)';
      context.fillRect(0, 0, 800, 450);
      roundedRect(context, 175, 125, 450, 200, 18, '#10283a', '#7ae1d8');
      context.fillStyle = '#8de9df';
      context.textAlign = 'center';
      context.font = '800 13px system-ui, sans-serif';
      context.fillText('CYBERCORE  ·  W1-L1', 400, 174);
      context.fillStyle = '#f5f7f2';
      context.font = '900 30px system-ui, sans-serif';
      context.fillText('FASE CONCLUÍDA', 400, 220);
      context.fillStyle = '#c4d7d8';
      context.font = '600 13px system-ui, sans-serif';
      context.fillText('Primeiro ponto de sincronização ativado.', 400, 254);
      context.fillText('W1-L2 será a próxima etapa da campanha.', 400, 278);
      context.textAlign = 'left';
    }
    context.restore();
  }
}
