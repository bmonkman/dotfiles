# dotfiles

Shared shell and git config for macOS and Linux (including WSL), plus Hammerspoon config for macOS.

## New Mac

1. Install [Homebrew](https://brew.sh), then the tools and apps this config uses:

   ```sh
   brew bundle --file=~/path/to/dotfiles/Brewfile
   ```

2. Install [oh-my-zsh](https://ohmyz.sh), then the two plugins it doesn't ship with:

   ```sh
   git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
   git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
   ```

   The oh-my-zsh installer replaces `~/.zshrc`, so do this before step 3.

3. Link the config into your home directory:

   ```sh
   ln -sf ~/path/to/dotfiles/.zshrc ~/.zshrc
   ln -sf ~/path/to/dotfiles/.gitconfig ~/.gitconfig
   ln -s ~/path/to/dotfiles/.hammerspoon ~/.hammerspoon
   ```

4. Create the machine-local files (see below). On a Mac, `~/.gitconfig.local` usually looks like:

   ```ini
   [user]
   	signingkey = <your key id>
   [credential]
   	helper = osxkeychain
   ```

5. Set up GPG for signed commits. Import your key with `gpg --import`. Then make gpg ask for the passphrase in a macOS dialog:

   ```sh
   echo "pinentry-program $(brew --prefix)/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
   gpgconf --kill gpg-agent
   ```

6. Sign in to the CLIs: `gh auth login`, `gcloud auth login`, `aws configure`, and turn on CLI integration in the 1Password app.

7. Create `~/.nvm` (`mkdir ~/.nvm`) so the Homebrew nvm has somewhere to install Node versions. Then open a new terminal.

8. Open Hammerspoon and grant it Accessibility access when asked.

## Machine-local files

Each machine's own settings go in files that aren't checked in:

- `~/.zshrc.local` is sourced before oh-my-zsh loads. Put SSH agent setup, `BROWSER`, extra PATH entries and `CLOUDSDK_HOME` here. Set `CLOUDSDK_HOME` only if gcloud completion doesn't work, which means the oh-my-zsh gcloud plugin didn't find the SDK. Point it at the SDK's install folder.
- `~/.gitconfig.local` is included at the end of `.gitconfig`. Put `user.signingkey` and `gpg.program` here, plus any credential helper beyond gh.
- `~/.secret.sh`, if it exists, is sourced for tokens.

## Linux / WSL

Install the same tools with your package manager. Skip `pinentry-mac` and the casks. Then follow steps 2–4 and skip the Hammerspoon link. `keychain` is a common choice for the SSH agent in `~/.zshrc.local`.
