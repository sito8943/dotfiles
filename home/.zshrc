# ~/.zshrc — symlinked from $DOTFILES/home/.zshrc
# Machine-only or secret settings go in ~/.dotfiles-custom/shell/.{exports,aliases,functions,zshrc}

# Where this repo lives. ~/.dotfiles is a symlink to the real checkout.
export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

# ── Base PATH ────────────────────────────────────────────────────────────────
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

# ── Oh My Zsh ────────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# Custom plugins (zsh-autosuggestions, zsh-syntax-highlighting) live in
# $ZSH/custom/plugins (oh-my-zsh default), installed by bin/install.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting copypath)

# Homebrew completions before compinit so oh-my-zsh picks them up once.
fpath=(/opt/homebrew/share/zsh/site-functions $fpath)

source "$ZSH/oh-my-zsh.sh"

# ── Shared dotfiles ──────────────────────────────────────────────────────────
for file in "$DOTFILES"/home/.{exports,aliases,functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

export PATH="$DOTFILES/bin:$PATH"

# ── Languages & runtimes (each guarded: missing tool = skipped) ──────────────

# Rust / Cargo
[ -s "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Node via nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# PHP & Composer from Homebrew (brew "php" → /opt/homebrew/bin, already in PATH).
# Other versions: brew install php@8.3 && brew unlink php && brew link --force php@8.3
export PATH="$HOME/.composer/vendor/bin:$PATH"

# .NET (global install)
[ -d /usr/local/share/dotnet ] && export PATH="/usr/local/share/dotnet:$PATH"

# Android SDK
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools"

# Console Ninja (VS Code extension)
[ -d "$HOME/.console-ninja/.bin" ] && export PATH="$HOME/.console-ninja/.bin:$PATH"

# ── Modern CLI tools (only if installed) ─────────────────────────────────────
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"
command -v fzf    &>/dev/null && source <(fzf --zsh)
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"

# SSH keys from macOS keychain
ssh-add --apple-use-keychain 2>/dev/null

# macOS defaults NOFILE to "unlimited", which the kernel clamps to a tiny value
# for real open() calls → "Too many open files" in big test runs / bundlers.
ulimit -n 65536

# ── Machine-local overrides (not committed) ──────────────────────────────────
for file in ~/.dotfiles-custom/shell/.{exports,aliases,functions,zshrc}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# ── SDKMAN — MUST stay at the end of the file ────────────────────────────────
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
