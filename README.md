# dotfiles

Shared shell and git config for macOS and Linux (including WSL). Install by symlinking:

```sh
ln -s ~/path/to/dotfiles/.zshrc ~/.zshrc
ln -s ~/path/to/dotfiles/.gitconfig ~/.gitconfig
```

Each machine's own settings go in local files that aren't checked in:

- `~/.zshrc.local` is sourced before oh-my-zsh loads. Put SSH agent setup, `BROWSER`, extra PATH entries and `CLOUDSDK_HOME` here. Set `CLOUDSDK_HOME` only if the gcloud SDK isn't in one of the places the oh-my-zsh gcloud plugin already checks.
- `~/.gitconfig.local` is included at the end of `.gitconfig`. Put `user.signingkey` and `gpg.program` here, plus any credential helper beyond gh (e.g. `osxkeychain`).
- `~/.secret.sh`, if it exists, is sourced for tokens.
