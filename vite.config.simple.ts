// Temporary minimal vite config for development
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import svgr from 'vite-plugin-svgr';
import path from 'path';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
	plugins: [
		react(),
		svgr(),
		tailwindcss(),
	],

	resolve: {
		alias: {
			'@': path.resolve(__dirname, './src'),
			'shared': path.resolve(__dirname, './shared'),
			'worker': path.resolve(__dirname, './worker'),
		},
	},

	define: {
		'process.env.NODE_ENV': JSON.stringify(
			process.env.NODE_ENV || 'development',
		),
		global: 'globalThis',
	},

	server: {
		port: 5173,
		host: true,
	},

	build: {
		sourcemap: true,
	},
});