# dotfiles

Personal macOS config tracked as a bare git repo against `$HOME`.

## Install

```sh
git clone --bare git@github.com:taras-lysyi/dotfiles.git "$HOME/dotfiles"
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
config config status.showUntrackedFiles no
config checkout            # may need to back up clashing files first
```

Add the `config` alias to your shell rc to keep using it after install.

## What's tracked

| Area      | Path                       |
| --------- | -------------------------- |
| Shell     | `.zshrc`, `.vimrc`         |
| Editor    | `.config/nvim/`            |
| Terminal  | `.config/kitty/`, `.config/ghostty/`, `.config/alacritty/` |
| Multiplex | `.tmux.conf`, `.config/zellij/` |
| Window    | `.config/aerospace/`, `.config/karabiner/` |
| Files     | `.config/yazi/`            |
| Misc      | `.config/tuicr/` (review comments), `.claude/CLAUDE.md` |
| Agent     | `.pi/agent/` (AGENTS, prompts, selected skills) |

## What's not tracked (gitignored)

- `.tmux/plugins/` — TPM bootstraps from `.tmux.conf` on first run (`prefix + I`)
- `.config/zellij/plugins/*.wasm` — fetched from upstream releases
- `.pi/` runtime (`cache/`, `sessions/`, `auth*`, `tasks/`, etc.) — only `AGENTS.md`, `APPEND_SYSTEM.md`, `prompts/`, and `skills/{worktree,humanizer}` are tracked

## Post-install

1. **tmux plugins**: `tmux new -s init` → `prefix + I`
2. **zellij plugins**: download into `~/.config/zellij/plugins/`
   - [`zjstatus.wasm`](https://github.com/dj95/zjstatus/releases/latest)
   - [`zellij_forgot.wasm`](https://github.com/karimould/zellij-forgot/releases/latest)
3. **nvim plugins**: open `nvim`, lazy.nvim auto-installs from `lazy-lock.json`
4. **fonts**: install [FiraCode Nerd Font](https://www.nerdfonts.com/)
