# dotfiles

Shared shell and git config for macOS and Linux (including WSL), plus Hammerspoon config for macOS.

The files in your home directory are symlinks to this repo, so editing `~/.zshrc` edits the repo's copy. Commit from here to keep machines in sync.

## New Mac

1. Install [Homebrew](https://brew.sh), clone this repo, then install the tools and apps this config uses:

   ```sh
   git clone git@github.com:bmonkman/dotfiles.git ~/work/bmonkman/dotfiles
   brew bundle --file=~/work/bmonkman/dotfiles/Brewfile
   ```

2. Follow [Install on any machine](#install-on-any-machine).

3. Set up GPG for signed commits. Import your key with `gpg --import`. Then make gpg ask for the passphrase in a macOS dialog:

   ```sh
   mkdir -p -m 700 ~/.gnupg
   echo "pinentry-program $(brew --prefix)/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
   gpgconf --kill gpg-agent
   ```

4. Sign in to the CLIs: `gh auth login`, `gcloud auth login`, `aws configure`, and turn on CLI integration in the 1Password app.

5. Run `mkdir ~/.nvm` so the Homebrew nvm has somewhere to install Node versions.

6. Open Hammerspoon and grant it Accessibility access when asked. The app hotkeys at the top of `.hammerspoon/bindings.lua` name the terminal, editor, browser and so on, so change them there if you switch apps.

7. Open a new terminal.

## Linux / WSL

Install zsh and make it your shell (`chsh -s $(which zsh)`). Then install the tools. The commit checks need git 2.54 or newer, which most distro packages don't have yet, so [Homebrew on Linux](https://docs.brew.sh/Homebrew-on-Linux) is the simplest way to get git along with the rest:

```sh
brew install git git-lfs gh git-secrets pre-commit zoxide fzf bat jq pyenv
```

Install nvm with its own [install script](https://github.com/nvm-sh/nvm#installing-and-updating), then follow [Install on any machine](#install-on-any-machine) and skip the Hammerspoon link. `keychain` is a common choice for the SSH agent in `~/.zshrc.local`.

## Install on any machine

1. Install [oh-my-zsh](https://ohmyz.sh), then the two plugins it doesn't ship with. `--unattended` stops the installer from switching into a new shell partway through. The installer writes a starter `~/.zshrc`, which the symlink in step 2 replaces.

   ```sh
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
   git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
   git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
   ```

2. Symlink the config into your home directory. `ln -sf` replaces any existing file, so back up one you want to keep first (e.g. `mv ~/.zshrc ~/.zshrc.pre-dotfiles`).

   ```sh
   DOTFILES=~/work/bmonkman/dotfiles
   ln -sf $DOTFILES/.zshrc ~/.zshrc
   ln -sf $DOTFILES/.gitconfig ~/.gitconfig
   ln -sf $DOTFILES/.gitignore_global ~/.gitignore_global
   ln -sfn $DOTFILES/git-hooks ~/.git-hooks
   ln -sfn $DOTFILES/.hammerspoon ~/.hammerspoon   # macOS only
   ```

3. Create the pre-commit framework's hook template. New clones copy it, and it runs a repo's `.pre-commit-config.yaml` if it has one. Until this exists, `git init` and `git clone` warn that the template is missing.

   ```sh
   pre-commit init-templatedir ~/.git-template
   ```

4. Create the machine-local files (see below).

## Commit checks

`git-hooks/check-commit` runs before every commit in every repo. It blocks AWS keys (using git-secrets) and any staged line containing the do-not-commit marker listed in the script. `.gitconfig` registers it as a config-based hook (`hook.commit-checks`). Git runs that in addition to each repo's own hooks in `.git/hooks`, so repo hooks such as git-lfs's and the pre-commit framework's keep working.

- It needs git 2.54 or newer. Older versions, including the git that ships with macOS at `/usr/bin/git`, skip the check without saying so. Homebrew's git comes first on PATH, so terminals use the newer version. GUI apps that use the system git don't run the check.
- If git-secrets isn't installed, the check blocks the commit and says so.

## Machine-local files

Each machine's own settings go in files that aren't checked in:

- `~/.zshrc.local` is sourced before oh-my-zsh loads. Put SSH agent setup, `BROWSER`, extra PATH entries and `CLOUDSDK_HOME` here. Set `CLOUDSDK_HOME` only if gcloud completion doesn't work, which means the oh-my-zsh gcloud plugin didn't find the SDK. Point it at the SDK's install folder.
- `~/.gitconfig.local` is included at the end of `.gitconfig`. Put `user.signingkey` and `gpg.program` here, plus any credential helper beyond gh. On a Mac it usually looks like:

  ```ini
  [user]
  	signingkey = <your key id>
  [credential]
  	helper = osxkeychain
  ```

- `~/.secret.sh`, if it exists, is sourced for tokens.
