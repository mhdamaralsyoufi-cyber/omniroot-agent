import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

const apiProxy = {
  target: 'http://127.0.0.1:5001',
  changeOrigin: true,
};

const proxy = {
  '/New_Session': apiProxy,
  '/Query': apiProxy,
  '/settings': apiProxy,
  '/get_settings': apiProxy,
  '/History': apiProxy,
  '/Sessions': apiProxy,
  '/Delete': apiProxy,
  '/test': apiProxy,
  '/health': apiProxy,
  '/api': apiProxy,
};

export default defineConfig({
  plugins: [react()],
  optimizeDeps: {
    exclude: ['lucide-react'],
  },
  server: {
    host: '0.0.0.0',
    proxy,
  },
  preview: {
    host: '0.0.0.0',
    port: 5173,
    proxy,
  },
});
