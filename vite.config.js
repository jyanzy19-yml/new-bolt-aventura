import { defineConfig } from 'vitest/config';

export default defineConfig({
  base: './',
  server: { host: '0.0.0.0' },
  build: { target: 'es2022', sourcemap: true, emptyOutDir: true },
  test: { include: ['tests/**/*.test.js'], environment: 'node' },
});
