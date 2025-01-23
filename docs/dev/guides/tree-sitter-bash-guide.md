# Tree-sitter Bash Integration Guide

## Overview

This guide provides a lightweight Tree-sitter integration for Bash syntax parsing using globally installed tools with minimal project footprint.

## Prerequisites

- Volta installed globally
- Node.js installed globally
- Git installed

## Installation

1. Create tools directory and install grammar:

   ```bash
   mkdir -p tools/treesitter/grammars
   cd tools/treesitter/grammars
   git clone --depth 1 https://github.com/tree-sitter/tree-sitter-bash
   cd tree-sitter-bash
   npm install
   npm audit fix
   tree-sitter generate
   ```

2. Verify installation:

   ```bash
   tree-sitter test
   ```

3. To update the grammar:

   ```bash
   cd tools/treesitter/grammars/tree-sitter-bash
   git pull
   npm install
   tree-sitter generate
   ```

4. To remove the grammar:

   ```bash
   rm -rf tools/treesitter/grammars/tree-sitter-bash
   ```

## Usage

### Testing Grammar

```bash
cd tools/treesitter/grammars/tree-sitter-bash
tree-sitter test
```

### Updating Grammar

```bash
cd tools/treesitter/grammars/tree-sitter-bash
git pull
npm install
tree-sitter generate
```

```bash
cd /Users/shaneholloman/Dropbox/shane/git/_sources/cops/tools/treesitter/grammars/tree
-sitter-bash && tree-sitter generate && tree-sitter build && tree-sitter parse /Users/shaneholloman/Dropbox/shane/git/_sources/cops/co
ps-setup.sh
```
