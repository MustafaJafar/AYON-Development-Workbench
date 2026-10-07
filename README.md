# AYON-Development-Workbench

The AYON Development Workbench repository offers a straightforward example of how to set up your workspace for AYON development with the help of VSCode tasks. Just a few clicks and you'll have your workspace ready, along with numerous VSCode tasks that act as high-level commands to aid you in your everyday development activities.

Drawing inspiration from the early days of AYON development, when all add-ons were housed in a single directory and managed with just a few commands. However, since each add-on now resides in its own repository, managing them from one place has become more challenging. Hence, this repo simplifies the process, making it more efficient so you can spend less time setting up and more time creating.

## Features of the AYON Development Workbench:
> [!IMPORTANT]  
> This setup is currently only functional on Windows within VSCode. However, feel free to draw inspiration from it and adapt the workflow to suit your preferences.

Here's a quick peek at what this repository offers, but you'll probably want to dive in and explore it yourself.

- The commands are designed to be relative to your working directory, which means there's no need for a specific directory name. You can copy and paste `mani.yaml`, `scripts` and `.vscode` wherever you prefer.
- It includes commands for cloning all the repos listed in `mani.yaml` at once, or just one (`mani sync -p <repo>`).
- There's a command available for updating the development environment of both the launcher and core repositories.
- You can create and upload addon zip files using a simple command.
- Commands are provided for initializing and running AYON documentation.
- It also offers commands for updating your dependency packages by specifying input repo.
- It also offers key settings to add the client code of multiple repositories as sources, enabling the Python extension to search for function definitions.

> [!NOTE]  
> [upload-addon.py](scripts/upload-addon.py) expects some dev initialization,
> you can use my [setup-my-dev-env.ps1](scripts/setup-my-dev-env.ps1) via
> ```
> ./scripts/setup-my-dev-env.ps1
> ```
> or manually, after [installing uv](https://docs.astral.sh/uv/getting-started/installation/), via
> ```
> cd scripts
> uv sync
> ```
> `mani run addon-upload` / `addons-upload-all` then run the script with `uv run`, which also creates the environment on first use.

## How the commands are organised
There are two kinds of commands. Both show up in the VS Code task picker (Terminal > Run Task).

- **mani tasks** ([`mani.yaml`](mani.yaml), install [mani](https://github.com/alajmo/mani)): commands that finish by themselves, need no keyboard input, or work across many repos. For example the git helpers (`status`, `update-default`, `update-branch`, ...), addon packaging and upload, dependency packages, docker server updates and the docs install. Run them in a terminal (`mani run <task>`), let Claude run them, or click the matching VS Code task: most of them have a thin wrapper in `.vscode/tasks.json` that just calls mani. `mani describe tasks` lists them, `mani list projects` shows the repos with their tags, and `mani sync -p ayon-core` clones one repo.
- **VS Code-only tasks** (`.vscode/tasks.json`, no mani task behind them): commands that run until you close them or need a real terminal. They run directly in the VS Code terminal, so you keep colours, prompts and Ctrl-C. These are the launcher (dev, staging, production), the ShotGrid and ftrack services, the live server log, the frontend dev server, Jupyter, the ngrok tunnel, docker prune and project backup/restore.

Why the split: mani runs a task without a terminal. Its output is plain and prefixed with the repo name, a command cannot ask y/N, and mani's `tty: true` does nothing on Windows. On the other hand, a task with several steps is much simpler in mani (the Kitsu processor reads its version from `package.py`, so it stays there although it runs until stopped).

Rule of thumb for a new command: it finishes by itself, needs no input, has several steps or touches several repos: a mani task (plus a wrapper if you want a button). A single command that runs until you stop it, or needs input: a VS Code task. [`CLAUDE.md`](CLAUDE.md) tells Claude Code the same: it runs the mani tasks and does not start the VS Code-only ones.

## Folder layout
- root: Ynput repos only, one folder per repo.
- `extras/`: anything extra, like notes or summaries, or repos from other orgs (e.g. `HuskStandaloneSubmitter`).
- `scripts/`: helper scripts used by the mani tasks (upload, setup, `.env`).
- `tmp/`: scratch files; clear it whenever you like.
- `tests/`: test scripts and test data.

## Linux VM
The VM clones this same workbench. The only difference there is the shell mani runs tasks with:
- In `mani.yaml`, change the first `shell:` line to `shell: bash -c`. It's a local edit: never commit it from the VM.
- Update with `git pull --autostash`, which sets that edit aside and puts it back (a plain `git pull` refuses when the incoming change touches `mani.yaml`).
- The Windows-only tasks (launcher, services, ...) also show up on the VM; just ignore them.
