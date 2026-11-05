# dotfiles

Shared shell, git and GPG config for macOS and Linux (including WSL), plus Hammerspoon config for macOS.

Most files in your home directory are symlinks to this repo, so editing `~/.zshrc` edits the repo's copy. Commit from here to keep machines in sync.

Claude Code's config (`CLAUDE.md`, settings, hooks, herdr config) lives in a separate private repo, [bmonkman/claude-code-dotfiles](https://github.com/bmonkman/claude-code-dotfiles), checked out as `~/.claude`. Step 3 below installs it.

## Setting up a machine

These steps work whether you run them yourself or ask Claude to.

- Steps marked **(you)** need a person: a password, a browser sign-in, a key file or a macOS permission dialog. Claude should stop at these and ask, or give you the command to run with `!`.
- Every step says how to tell it's already done, so you can re-run the whole list after a failure.
- Never overwrite a real file. Move it aside first (`mv ~/.zshrc ~/.zshrc.pre-dotfiles`). Replacing an existing symlink is fine.
- Finish with [Check it worked](#check-it-worked).

### 1. Install tools

**macOS**

1. **(you)** Install [Homebrew](https://brew.sh). It asks for your password and installs Apple's command line tools, which include git. Skip if `brew --version` works.
2. Clone this repo. Skip if `~/work/bmonkman/dotfiles` exists.

   ```sh
   git clone https://github.com/bmonkman/dotfiles.git ~/work/bmonkman/dotfiles
   ```

3. Install everything in the Brewfile. Re-running only installs what's missing.

   ```sh
   brew bundle --file=~/work/bmonkman/dotfiles/Brewfile
   ```

   **(you)** Homebrew won't install from a third-party tap until you trust it, so terraform fails the first time. Run `brew trust hashicorp/tap`, then re-run the bundle.

**Linux / WSL**

1. **(you)** Install zsh, GnuPG and keychain, and make zsh your shell: `sudo apt install zsh gnupg keychain` and `chsh -s $(which zsh)`. Skip what's done: `echo $SHELL` ends in `zsh`, and `gpg --version` and `keychain --version` work. GnuPG comes from apt rather than Homebrew so there's only one gpg and one gpg-agent on the machine.
2. **(you)** Install [Homebrew on Linux](https://docs.brew.sh/Homebrew-on-Linux). It asks for your password. Skip if `brew --version` works. The commit checks need git 2.54 or newer, and Homebrew is the easiest way to get it, since distro packages are usually older.
3. Clone this repo (same command as macOS step 2), then install the tools:

   ```sh
   brew install git git-lfs gh git-secrets pre-commit zoxide fzf bat jq pyenv tilt circleci doctl herdr zsh-autosuggestions zsh-syntax-highlighting
   ```

4. **(you)** Install the 1Password CLI from [1Password's apt repository](https://developer.1password.com/docs/cli/get-started/#install). Use apt rather than Homebrew here: the apt package sets up the group permissions `op` needs to connect to the 1Password app. Skip if `dpkg -s 1password-cli` succeeds and `command -v op` prints `/usr/bin/op`. If `op` resolves anywhere else, another copy is shadowing the apt one, so remove it (for Homebrew's: `brew uninstall --cask 1password-cli`).
5. Install nvm with its [install script](https://github.com/nvm-sh/nvm#installing-and-updating). Skip if `~/.nvm/nvm.sh` exists.

### 2. Sign in to GitHub

**(you)** Run `gh auth login` and choose HTTPS. Skip if `gh auth status` shows you're logged in.

This comes before anything else that talks to GitHub. `.gitconfig` makes gh git's credential helper for GitHub, so git uses gh's token and there's no SSH key to manage.

### 3. Claude Code config

Install the private Claude config repo into `~/.claude`. Its script backs up any files Claude Code has already created there. Skip if `~/.claude/.git` exists.

```sh
gh api repos/bmonkman/claude-code-dotfiles/contents/install.sh -H "Accept: application/vnd.github.raw" | bash
```

Then follow the per-machine steps in `~/.claude/README.md` (`settings.local.json`, plugins). If Claude is doing this setup, it should re-read `~/.claude/CLAUDE.md` once installed.

### 4. oh-my-zsh

Skip if `~/.oh-my-zsh` exists. `--unattended` stops the installer from switching into a new shell partway through. The installer writes a starter `~/.zshrc`, which the symlink in step 5 replaces.

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
```

The autosuggestions and syntax-highlighting plugins come from Homebrew (step 1), not from oh-my-zsh, so `brew upgrade` updates them. `.zshrc` loads them itself.

### 5. Link the config

Move aside any of these that exist as real files (not symlinks), then link:

```sh
DOTFILES=~/work/bmonkman/dotfiles
ln -sf $DOTFILES/.zshrc ~/.zshrc
ln -sf $DOTFILES/.gitconfig ~/.gitconfig
ln -sf $DOTFILES/.gitignore_global ~/.gitignore_global
ln -sfn $DOTFILES/git-hooks ~/.git-hooks
ln -sfn $DOTFILES/.hammerspoon ~/.hammerspoon   # macOS only
```

Then create the pre-commit framework's hook template. New clones copy it, and it runs a repo's `.pre-commit-config.yaml` if it has one. Until it exists, `git init` and `git clone` warn that the template is missing. Skip if `~/.git-template/hooks/pre-commit` exists.

```sh
pre-commit init-templatedir ~/.git-template
```

### 6. Machine-local files

These hold each machine's own settings and aren't checked in.

`~/.zshrc.local` is sourced before oh-my-zsh loads. It's optional, so skip it if nothing below applies.

- Linux: start the SSH agent with `eval $(keychain --eval --quiet --agents ssh)`.
- WSL: also add `export BROWSER=wslview`, so links open in the Windows browser.
- Any machine: set `CLOUDSDK_HOME` only if gcloud completion doesn't work, which means the oh-my-zsh gcloud plugin didn't find the SDK. Point it at the SDK's install folder.

**(you)** `~/.gitconfig.local` is included at the end of `.gitconfig`. It needs your signing key ID, so do step 7 first if the key isn't imported yet. Claude can work out the contents, but you write the file: the Claude config's hooks block Claude from changing git config.

```ini
[user]
	signingkey = <key id>
```

Get the key ID from `gpg --list-secret-keys --keyid-format long`. It's the part after the slash on the `sec` line (e.g. `rsa4096/E44C6C1F3DEA82D0`). If there's more than one key, ask which to use. On macOS, also add `[credential] helper = osxkeychain` so the Keychain stores passwords for hosts other than GitHub.

`~/.secret.sh`, if it exists, is sourced for tokens. Create it only if you have tokens to put in it.

### 7. GPG signing

1. Import your secret key from 1Password and mark it as fully trusted. Skip if `gpg --list-secret-keys` already shows it.

   ```sh
   op read "op://Private/GPG Private Key/notesPlain" | gpg --import
   echo "0F34E5D27DDB67FA0D647651E44C6C1F3DEA82D0:6:" | gpg --import-ownertrust
   ```

   **(you)** `op` needs the 1Password app's CLI integration (step 8). On macOS, the terminal app also needs access to other apps' data: System Settings → Privacy & Security → App Data, then restart the terminal. Without it, `op` can't reach the app and asks for your account password instead.
2. Install the agent settings. Run these together, since `cp` resets the file before the macOS line is added:

   ```sh
   mkdir -p -m 700 ~/.gnupg
   cp ~/work/bmonkman/dotfiles/gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf
   # macOS: ask for the passphrase in a macOS dialog, which works from GUI apps too
   [[ $OSTYPE == darwin* ]] && echo "pinentry-program $(brew --prefix)/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
   gpgconf --kill gpg-agent
   ```

   This file is copied, not linked, because the macOS line is a path that doesn't exist on Linux.

### 8. Other sign-ins and extras

- `gh alias set --clobber co 'pr checkout'`
- **(you)** `gcloud auth login`, and `aws configure` or `aws sso login`, if this machine needs them.
- **(you)** macOS: in the 1Password app, turn on Settings → Developer → Integrate with 1Password CLI.
- macOS: run `mkdir -p ~/.nvm`. The Homebrew version of nvm needs it.
- **(you)** macOS: open Hammerspoon and grant it Accessibility access when asked. The app hotkeys at the top of `.hammerspoon/bindings.lua` name the terminal, editor, browser and so on, so change them there if you switch apps.

Open a new terminal before checking.

## Check it worked

Run each one in a new terminal:

| Command | Expect |
|---|---|
| `ls -l ~/.zshrc ~/.gitconfig ~/.gitignore_global ~/.git-hooks` | Each is a link into the dotfiles repo |
| `zsh -ic true` | No output. Any warning means a tool is missing |
| `zsh -ic "bindkey '^R'"` | `history-incremental-search-backward` |
| `git --version` | 2.54 or newer |
| `git -C ~/work/bmonkman/dotfiles hook list pre-commit` | Includes `commit-checks` |
| `command -v git-secrets` | A path |
| `git config user.signingkey` | Your key ID |
| `echo test \| gpg --clearsign` | A signed message. **(you)** The first run asks for your passphrase |
| `gh auth status` | Logged in |
| `gh alias list` | Includes `co` |
| `git -C ~/.claude status -sb` | A branch line, so `~/.claude` is the Claude config repo |

## Commit checks

`git-hooks/check-commit` runs before every commit in every repo. It blocks AWS keys (using git-secrets) and any staged line containing the do-not-commit marker listed in the script. `.gitconfig` registers it as a config-based hook (`hook.commit-checks`). Git runs that in addition to each repo's own hooks, so repo hooks such as git-lfs's and the pre-commit framework's keep working.

- It needs git 2.54 or newer. Older versions, including the git that ships with macOS at `/usr/bin/git`, skip the check without saying so. Homebrew's git comes first on PATH, so terminals use the newer version. GUI apps that use the system git don't run the check.
- If git-secrets isn't installed, the check blocks the commit and says so.
