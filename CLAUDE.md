# AYON workbench

This is a **multi-repo workspace**, not an application. The root is its own git repo (mani config, VS Code tasks and helper scripts only);
the Ynput repos listed in `mani.yaml` are cloned into subfolders and are gitignored here. Each is an independent git repo.

- Before any git operation run `git rev-parse --show-toplevel` and make sure you are in the intended repo, not the workspace root.
- Repos, descriptions, URLs and tags: `mani.yaml` (`mani list projects`). Not all of them are necessarily cloned. The `workbench` project is the root itself, which is where workbench-level tasks run.
- Platform is Windows. Task commands run through Git Bash (`shell:` is set at the top of `mani.yaml`, since mani defaults to PowerShell on Windows; on the Linux VM change it to `bash -c`, see below). Windows tooling (`pwsh`, `.bat`, `uv`, `pyenv`) is called from inside them.
- Folder layout, all relative to the workbench root:
  - root: Ynput repos only (`ayon-*`, `ash`, `ops-repo-automation`, `pytest-ayon`, ...), each an independent git repo.
  - `extras/`: anything extra: notes and summaries, or repos from other orgs (`Kitsu-for-Docker`, `HuskStandaloneSubmitter`, `ayon-loki`, `ayon-recipes`, `houdini_PRTROP`, ...).
  - `scripts/`: helper scripts used by mani tasks (`upload-addon.py` and its uv project, `local-ssl.sh`, the `.env` with server URL/key, machine setup scripts).
  - `tmp/`: scratch files (logs, packages, jupyter), cleared every now and then.
  - `tests/`: test scripts and test data.
  - Contents of `extras/`, `tmp/` and `tests/` are ignored by git.
- The AYON server (e.g. docker) runs on a Linux VM with this same workbench cloned. The only difference there is the shell: change the first `shell:` line of `mani.yaml` to `shell: bash -c` (a local edit, never committed; update with `git pull --autostash`). The Windows-only tasks (launcher, services, ...) also show up there; ignore them.
## Deterministic commands: use mani, not ad-hoc shell

Commands that finish by themselves and need no keyboard input are mani tasks in `mani.yaml` (`mani describe tasks` lists them, `mani run <task> --describe` shows one). Commands that run until closed, or need a real terminal, are VS Code-only tasks (see below).
Select repos with `-p <repo>` (folder name, e.g. `ayon-core`), `--tags <tag>` or nothing (default: every non-optional repo); pass task parameters as trailing `KEY=value`.
Most mani tasks have a thin VS Code wrapper in `.vscode/tasks.json` that just calls mani, so the command is the same whether I click or you type.

Repos tagged `optional` (e.g. `houdini_PRTROP`) are kept for reference only: they have `sync: false`, `mani sync` skips them, and tasks without `-p`/`--tags` skip them. Never clone, update or run anything on them unless explicitly asked; then use `-p <repo>` (clone with `mani sync -p <repo> --ignore-sync-state`). `--all` includes them, so avoid it. Repos that aren't cloned are skipped silently.

Tags are set by hand (full legend in the header of `mani.yaml`): a kind (`addon`, `utility`, `server`, `api`, `app`, `example`, `test`, `ci`, `docs`, `reference`), `essential` (minimum for running an AYON server with a pipeline), a category for app addons (`3d`, `2d-draw`, `2d-comp`), topic tags that relate repos (app/service names like `houdini` or `kitsu`, functions like `prod-track`, `farm-manager`, `media-player`, plus `docker`, `frontend`), and `optional`. A tag that would only repeat one repo's own name isn't used. No task selects by tag yet. For browsing: `mani list projects --tags <tag>`. Careful: `--tags X` also matches `optional` repos carrying `X`, so for anything that changes a repo use `--tags-expr 'X && !optional'`.

| Command | Purpose |
|---|---|
| `mani sync` / `mani sync -p <repo> --ignore-sync-state` | Clone missing repos, skipping `optional` ones unless named with `-p` + the flag (`mani sync` doesn't recurse submodules) |
| `mani run submodules` | Init/update submodules |
| `mani run status` / `remotes` | Branch + status / remotes |
| `mani run update-default` (all non-optional repos; or `--tags essential` / `3d` / ..., `-p X`) | Checkout each repo's default branch (`main`, `develop`, ... from `origin/HEAD`) and pull; skips dirty repos |
| `mani run update-branch -p <repo> BRANCH=<b>` | Fetch, checkout and pull a branch from `origin` (also one pushed after your last fetch, like a new PR branch, draft or not) |
| `mani run update-branch-remote -p <repo> BRANCH=<remote>:<branch>` | A PR branch from a fork, as GitHub shows it: adds the remote `https://github.com/<remote>/<repo>.git` if missing and checks out a local branch `<remote>/<branch>` tracking it |
| `mani run add-remote -p <repo> REMOTE=<user>` | Add `https://github.com/<user>/<repo>.git` as remote `<user>` (default `MustafaJafar`) |
| `mani run tag-latest -p <repo>` / `tag-checkout -p <repo> TAG=<t>` | Detach HEAD on the latest / a given tag (addons with services) |
| `mani run ruff-check\|ruff-fix -p <repo> [FILE=<path>]` | Ruff on a repo or one file |
| `mani run addon-package -p <repo>` | Zip an addon into `tmp/packages` |
| `mani run addon-upload -p <repo>` | Zip an addon and upload it to my server |
| `mani run addons-upload-all` | Clear `tmp/packages`, package all addons (every repo tagged `addon`; it takes a while), upload them |
| `mani run launcher-env` / `launcher-build-upload` | Launcher env, build + upload installer (running the launcher is a VS Code task) |
| `mani run core-env` | ayon-core env |
| `mani run deptool-install`, `deptool-create[-upload] BUNDLE=<b> OUTPUT_DIR=<p>` | Dependency packages (`-upload` also uploads) |
| `mani run shotgrid-install`, `ftrack-install`, `kitsu-processor-install` | Install the addon service tooling |
| `mani run kitsu-processor [SSL_CERT=<path>]` | Run the Kitsu processor service from code (long-running; it reads its addon version from `package.py`). The ShotGrid and ftrack services are VS Code tasks |
| `mani run docker-clone [DOCKER_REPO=<repo>]` | `git clone https://github.com/ynput/$DOCKER_REPO.git` (default `ayon-docker`; skipped if the folder exists). A task, not a mani project, because mani can't expand env vars in a project url |
| `mani run server-update\|restart\|rebuild\|log\|release [DOCKER_REPO=<repo>]` | Docker compose operations for the deployed server. `DOCKER_REPO` is the docker repo folder (default `ayon-docker`); `log` takes `SERVICE=<compose service>` (default `server`) |
| `mani run kitsu-update` | Pull + rebuild the local Kitsu server |
| `mani run docs-init\|docs-run` | ayon-documentation Docusaurus site (install / serve) |

## VS Code-only tasks (started by me, not by Claude)

These have no mani task: they run until closed or need a real terminal (colours, prompts, Ctrl-C), and mani runs tasks without a terminal (plain prefixed output, no stdin, and `tty: true` does nothing on Windows). I start them from VS Code. Don't start them unless asked; if asked, start them in the background and read the log only when asked.

| VS Code task | What it runs |
|---|---|
| Run Live Launcher Production / Staging / Dev | `ayon-launcher/tools/ayon_console.bat` with no flag / `--use-staging` / `--use-dev` |
| Launch publish report viewer, Launch Tray Publisher in Dev | `ayon_console.bat --use-dev publish-report-viewer` / `--use-dev addon traypublisher launch` |
| Run Shotgrid / ftrack Services, Leecher, Processor | `pwsh service_tools/manage.ps1 services\|leecher\|processor --variant <bundle>` in the addon repo (the ShotGrid services task also sets `SHOTGUN_API_CACERTS`) |
| Show Live AYON Server Log, Run Live Frontend | `docker compose logs -f` in the docker repo, `yarn dev` in `<docker repo>/server/ayon-frontend` |
| Backup a Project, Import a Project | `make dump` / `make restore projectname=<project>` in the docker repo |
| Prune Docker | `docker image prune -a` (asks y/N) |
| Launch Jupyter, Make Docs Online | `jupyter notebook --notebook-dir tmp`, `ngrok http 3000` |

The Kitsu processor is the exception: it runs until stopped but is a mani task (`kitsu-processor`), because it has to read its addon version from `package.py`.

## Conventions
- Default branches differ per repo (`develop` for most addons, `main` for `ayon-docker`, `ayon-pipeline-tests`, ...). Never assume `main`; read `origin/HEAD` (what `update-default` does).
- Origin is the upstream Ynput repo; forks (mine and other contributors') are extra remotes, added with `add-remote`.
- Never push, force-push or delete branches unless asked. `addons-upload-all`, `launcher-build-upload`, `*-create-upload` and the `*-upload` tasks change state outside the repo (my AYON server): only run them when explicitly asked.
- Local SSL: for a local `ayon-docker` behind a self-signed cert, pass the merged CA bundle (certifi + local CA) as a parameter, e.g. `mani run addon-upload -p ayon-core SSL_CERT=<path>/caddy_certifi_merged_ca_cert.pem`. Server-facing tasks source `scripts/local-ssl.sh` (bash, since `shell:` is Git Bash), which exports `SSL_CERT_FILE` and `REQUESTS_CA_BUNDLE` from it. Without `SSL_CERT` nothing changes: `SSL_CERT_FILE` / `REQUESTS_CA_BUNDLE` set in the calling shell are inherited as usual. New server-facing tasks should source it too.
- `scripts/.env` holds `AYON_SERVER_URL` / `AYON_API_KEY` for uploads and services (placeholder values are committed; never commit a real key). Some tasks copy it into the target repo.
- Uploads need the one-time dev setup in `scripts/setup-my-dev-env.ps1` (pyenv, uv, then `uv sync` in `scripts`; `uv run` also does it on first use). Poetry is only still needed for the ayon-kitsu processor service, whose `manage.ps1` calls `poetry run`.
- Adding a command: if it finishes by itself and needs no input, add a task to `mani.yaml` (use `$(basename "$PWD")` for the repo name, `target: {projects: [x]}` for repo-specific ones, `target: {projects: [workbench]}` for workbench-level ones; `target: {cwd: true}` does NOT work for that), add a row to the table above, and a thin wrapper in `.vscode/tasks.json` if wanted. If it runs until closed or needs input, add a VS Code task with the command directly, and a row to the VS Code-only table instead.
- Adding a repo: add it to `mani.yaml` (one-line `desc`, tags; `path: extras/<name>` if it is not a Ynput repo), then `mani sync -p <repo>`. `ayon*/` and `extras/` are already gitignored; otherwise add the folder to `.gitignore`.
- `.vscode/settings.json` lists client folders in `python.analysis.extraPaths`, including the DCC install paths and the dependency package version (`ayon_<stamp>_windows.zip`); update those when the machine or the dependency package changes.
