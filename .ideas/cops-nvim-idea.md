# LazyVim Setup

My manual setup is below. Need fully tested yet. It installs and work, but you will note brew installation messages I haven't paid any attention to yet.

## Install Deps

```sh
  shaneholloman @ bird.yoyo.io  ~  brew install curl fzf ripgrep fd lazygit
curl  is already installed but outdated (so it will be upgraded).
==> Downloading <https://ghcr.io/v2/homebrew/core/curl/manifests/8.12.0>
######################################################################### 100.0%
==> Fetching curl
==> Downloading <https://ghcr.io/v2/homebrew/core/curl/blobs/sha256:59ac285d151a1>
######################################################################### 100.0%
==> Downloading <https://ghcr.io/v2/homebrew/core/fzf/manifests/0.59.0>
######################################################################### 100.0%
==> Fetching fzf
==> Downloading <https://ghcr.io/v2/homebrew/core/fzf/blobs/sha256:6a5bc7c9c07094>
######################################################################### 100.0%
==> Downloading <https://ghcr.io/v2/homebrew/core/ripgrep/manifests/14.1.1>
######################################################################### 100.0%
==> Fetching ripgrep
==> Downloading <https://ghcr.io/v2/homebrew/core/ripgrep/blobs/sha256:b8bf5e73c9>
######################################################################### 100.0%
==> Downloading <https://ghcr.io/v2/homebrew/core/fd/manifests/10.2.0-1>
######################################################################### 100.0%
==> Fetching fd
==> Downloading <https://ghcr.io/v2/homebrew/core/fd/blobs/sha256:df54657784547cb>
######################################################################### 100.0%
==> Downloading <https://ghcr.io/v2/homebrew/core/lazygit/manifests/0.45.2>
######################################################################### 100.0%
==> Fetching lazygit
==> Downloading <https://ghcr.io/v2/homebrew/core/lazygit/blobs/sha256:3e9810c588>
######################################################################### 100.0%
==> Pouring curl--8.12.0.arm64_sequoia.bottle.tar.gz
==> Caveats
curl is keg-only, which means it was not symlinked into /opt/homebrew,
because macOS already provides this software and installing another version in
parallel can cause all kinds of trouble.

If you need to have curl first in your PATH, run:
  echo 'export PATH="/opt/homebrew/opt/curl/bin:$PATH"' >> ~/.zshrc

For compilers to find curl you may need to set:
  export LDFLAGS="-L/opt/homebrew/opt/curl/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/curl/include"

For pkg-config to find curl you may need to set:
  export PKG_CONFIG_PATH="/opt/homebrew/opt/curl/lib/pkgconfig"

zsh completions have been installed to:
  /opt/homebrew/opt/curl/share/zsh/site-functions
==> Summary
🍺  /opt/homebrew/Cellar/curl/8.12.0: 535 files, 4.2MB
==> Running `brew cleanup curl`...
Removing: /opt/homebrew/Cellar/curl/8.11.1... (531 files, 4.1MB)
Removing: /Users/shaneholloman/Library/Caches/Homebrew/curl_bottle_manifest--8.11.1... (15.2KB)
Removing: /Users/shaneholloman/Library/Caches/Homebrew/curl--8.11.1... (1.4MB)
==> Pouring fzf--0.59.0.arm64_sequoia.bottle.tar.gz
==> Caveats
To set up shell integration, see:
  <https://github.com/junegunn/fzf#setting-up-shell-integration>
To use fzf in Vim, add the following line to your .vimrc:
  set rtp+=/opt/homebrew/opt/fzf
==> Summary
🍺  /opt/homebrew/Cellar/fzf/0.59.0: 19 files, 4.4MB
==> Running `brew cleanup fzf`...
==> Pouring ripgrep--14.1.1.arm64_sequoia.bottle.tar.gz
==> Caveats
zsh completions have been installed to:
  /opt/homebrew/share/zsh/site-functions
==> Summary
🍺  /opt/homebrew/Cellar/ripgrep/14.1.1: 14 files, 6MB
==> Running `brew cleanup ripgrep`...
==> Pouring fd--10.2.0.arm64_sequoia.bottle.1.tar.gz
==> Caveats
zsh completions have been installed to:
  /opt/homebrew/share/zsh/site-functions
==> Summary
🍺  /opt/homebrew/Cellar/fd/10.2.0: 14 files, 2.8MB
==> Running `brew cleanup fd`...
==> Pouring lazygit--0.45.2.arm64_sequoia.bottle.tar.gz
🍺  /opt/homebrew/Cellar/lazygit/0.45.2: 6 files, 18.6MB
==> Running `brew cleanup lazygit`...
==> Caveats
==> curl
curl is keg-only, which means it was not symlinked into /opt/homebrew,
because macOS already provides this software and installing another version in
parallel can cause all kinds of trouble.

If you need to have curl first in your PATH, run:
  echo 'export PATH="/opt/homebrew/opt/curl/bin:$PATH"' >> ~/.zshrc

For compilers to find curl you may need to set:
  export LDFLAGS="-L/opt/homebrew/opt/curl/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/curl/include"

For pkg-config to find curl you may need to set:
  export PKG_CONFIG_PATH="/opt/homebrew/opt/curl/lib/pkgconfig"

zsh completions have been installed to:
  /opt/homebrew/opt/curl/share/zsh/site-functions
==> fzf
To set up shell integration, see:
  <https://github.com/junegunn/fzf#setting-up-shell-integration>
To use fzf in Vim, add the following line to your .vimrc:
  set rtp+=/opt/homebrew/opt/fzf
==> ripgrep
zsh completions have been installed to:
  /opt/homebrew/share/zsh/site-functions
==> fd
zsh completions have been installed to:
  /opt/homebrew/share/zsh/site-functions
  shaneholloman @ bird.yoyo.io
```

## Install lazyVim

```sh
git clone <https://github.com/LazyVim/starter> ~/.config/nvim
rm -rf ~/.config/nvim/.git
```

## Open nvim

Open a new terminal.

Then open nvim. This will be slow at first, sometimes blank screen: `nvim`

## Test Health

Run `:LazyHealth`

## My Health Results so far

```sh
# how to save the results??
```

## Install GitHub theme

<https://github.com/projekt0n/github-nvim-theme?tab=readme-ov-file>
