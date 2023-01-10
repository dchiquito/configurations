# zsh-custom
My personal zsh custom directory, containing my personal plugins and themes.

# Installation
1. Clone the repository somewhere (we will assume `/home/git/zsh-custom/`)
1. Add the following line to your `.zshrc`:
```
ZSH_CUSTOM=/home/git/zsh-custom
```

# Plugins

## cdg
An alias for `cd` relative to a central git root.

I found myself typing `cd ~/git/my-repo` frequently, so now I can just type `cdg my-repo`.
This plugin also provides autocomplete, so it is slightly more involved than a simple alias.

This plugin assumes that you keep you keep your git repositories under `~/git` (as I do).
To change this, set `GIT_ROOT` in your `.zshrc` file.

## gitinit
A utility for quickly and easily cloning new GitHub repositories.

This function takes two arguments, the GitHub owner and the name of the repository.

If the repository contains a `setup.py`, `virtualenvwrapper` will be used to set up a new python virtual environment, and the repository will be installed automatically into that venv.

The newly cloned repository will be stored in your `GIT_ROOT`.

# Themes

## dchiquito
A very minimal theme that is designed around frequent use of Python repositories with the [virtualenvwrapper](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/virtualenvwrapper) plugin.

I personally like two-line prompts because they have ample screen space to show various plugin information on the first line, leaving the second line almost empty.
This makes the theme usable in narrow screens without the command wrapping around prematurely.

When inside a git repository, the path shown is relative to the repository root.

The repository root is shown in green if the repository is a Python repo and virtualenvwrapper has activated correctly.
Otherwise, it will show the incorrect virtual environment name in red, or a warning that no virtual environment is active.
If inside a git repository that does not contain a `setup.py`, nothing virtual environment related is shown.

I have found that different fonts render the "▶" icon in the prompt with different widths. I use [Cousine](https://fonts.google.com/specimen/Cousine), so the prompt works as intended with that font.
