import './styles.css';

const root = document.querySelector('#app');

if (!root) {
  throw new Error('Elemento raiz #app não encontrado.');
}

root.innerHTML = `
  <main class="boot-screen" aria-labelledby="game-title">
    <section class="boot-panel">
      <p class="eyebrow">HTML5 GAME FOUNDATION</p>
      <h1 id="game-title">BOLT <span>·</span> AVENTURA</h1>
      <p class="boot-copy">Runtime web inicializado.</p>
      <p class="boot-status" role="status">Fundação técnica em construção</p>
    </section>
  </main>
`;
