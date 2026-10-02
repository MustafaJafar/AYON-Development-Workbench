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

## Claude Code / mani
Commands now live in [`mani.yaml`](mani.yaml) (install [mani](https://github.com/alajmo/mani)), which is the single source of truth:
- `mani sync` clones every repo listed there (`mani sync -p ayon-core` for one); `mani list projects` shows them with tags.
- `mani describe tasks` lists the tasks: git helpers (`status`, `update-default`, `add-remote`, ...), addon packaging/upload, launcher, dependency packages, addon services, docker server and docs.
- `mani-linux.yaml` has just the server tasks for the Linux VM, under the same names (`export MANI_CONFIG=mani-linux.yaml`).
- `.vscode/tasks.json` just wraps those tasks for the VS Code UI (so the commands are the same whether you click or type).
- [`CLAUDE.md`](CLAUDE.md) tells Claude Code about the layout and which command to use for what.


## Folder layout
- root: Ynput repos only, one folder per repo.
- `extras/`: anything extra, like notes or summaries, or repos from other orgs (e.g. `HuskStandaloneSubmitter`).
- `scripts/`: helper scripts used by the mani tasks (upload, setup, `.env`).
- `tmp/`: scratch files; clear it whenever you like.
- `tests/`: test scripts and test data.
