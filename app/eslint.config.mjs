import js from '@eslint/js';
import tsParser from '@typescript-eslint/parser';
import tsPlugin from '@typescript-eslint/eslint-plugin';

// Globals de Node.js que necesitas
const nodeGlobals = {
  process: 'readonly',
  console: 'readonly',
  __dirname: 'readonly',
  module: 'readonly',
  require: 'readonly',
  exports: 'readonly',
};

export default [
  {
    files: ['**/*.ts'],
    ignores: ['tests/**/*', '**/*.test.ts'],
    languageOptions: {
      parser: tsParser,
      parserOptions: {
        ecmaVersion: 2020,
        sourceType: 'module',
      },
      globals: nodeGlobals, // 👈 aquí declaras los globals
    },
    plugins: {
      '@typescript-eslint': tsPlugin,
    },
    rules: {
      ...js.configs.recommended.rules,
      ...tsPlugin.configs.recommended.rules,
      semi: ['error', 'always'],
      quotes: ['error', 'single'],
    },
  },
];
