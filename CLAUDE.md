# AYON workbench

This is a **multi-repo workspace**, not an application. The root is its own git repo (mani config, VS Code tasks and helper scripts only);
the Ynput repos listed in `mani.yaml` are cloned into subfolders and are gitignored here. Each is an independent git repo.

- Before any git operation run `git rev-parse --show-toplevel` and make sure you are in the intended repo, not the workspace root.
- Repos, descriptions, URLs and tags: `mani.yaml` (`mani list projects`). Not all of them are necessarily cloned. The `workbench` project is the root itself, which is where workbench-level tasks run.
- Platform is Windows. Task commands run through Git Bash (`shell:` is set at the top of `mani.yaml`, since mani defaults to PowerShell on Windows; the Linux VM uses `mani-linux.yaml`). Windows tooling (`pwsh`, `.bat`, `uv`, `pyenv`) is called from inside them.
- Folder layout, all relative to the workbench root:
  - root: Ynput repos only (`ayon-*`, `ash`, `ops-repo-automation`, `pytest-ayon`, ...), each an independent git repo.
  - `extras/`: anything extra: notes and summaries, or repos from other orgs (`Kitsu-for-Docker`, `HuskStandaloneSubmitter`, `ayon-loki`, `ayon-recipes`, `houdini_PRTROP`, `cacert.pem`, ...).
  - `scripts/`: helper scripts used by mani tasks (`upload-addon.py` and its uv project, `local-ssl.sh`, the `.env` with server URL/key, machine setup scripts).
  - `tmp/`: scratch files (logs, packages, jupyter), cleared every now and then.
  - `tests/`: test scripts and test data.
  - Contents of `extras/`, `tmp/` and `tests/` are ignored by git.
- The AYON server (e.g. docker) runs on a Linux VM with this same workbench cloned. There the config is `mani-linux.yaml`. Select it with `mani -c mani-linux.yaml run <task>`, or make it the default by swapping the files: `mani run to-linux` (defined in `mani.yaml`, has its own `shell: bash -c`) renames `mani.yaml` -> `mani-win.yaml` and `mani-linux.yaml` -> `mani.yaml`; `mani run to-win` (defined in `mani-linux.yaml`) undoes it, and must run before `git pull`. Never commit the swapped files from the VM. `MANI_CONFIG` does NOT work, because mani ignores it when a `mani.yaml` is in the current folder or a parent, and then every task prints only its header with no error: bash shell and only the server tasks (`server-*`, `frontend-live`, `project-*`, `kitsu-update`), under the same names. They are duplicated from `mani.yaml` on purpose, so when you change one, change it in both files (except `to-linux` / `to-win`, which exist in one file each).
## Deterministic commands: use mani, not ad-hoc shell

All workspace commands are mani tasks in `mani.yaml` (`mani describe tasks` lists them, `mani run <task> --describe` shows one).
Select repos with `-p <repo>` (folder name, e.g. `ayon-core`), `--tags <tag>` or nothing (default: every non-optional repo); pass task parameters as trailing `KEY=value`.
`.vscode/tasks.json` only wraps these same tasks for the VS Code UI.

Repos tagged `optional` (e.g. `houdini_PRTROP`) are kept for reference only: they have `sync: false`, `mani sync` skips them, and tasks without `-p`/`--tags` skip them. Never clone, update or run anything on them unless explicitly asked; then use `-p <repo>` (clone with `mani sync -p <repo> --ignore-sync-state`). `--all` includes them, so avoid it. Repos that aren't cloned are skipped silently.

Tags are set by hand (full legend in the header of `mani.yaml`): a kind (`addon`, `utility`, `server`, `api`, `app`, `example`, `test`, `ci`, `docs`, `reference`), `essential` (minimum for running an AYON server with a pipeline), a category for app addons (`3d`, `2d-draw`, `2d-comp`), topic tags that relate repos (app/service names like `houdini` or `kitsu`, functions like `prod-track`, `farm-manager`, `media-player`, plus `docker`, `frontend`), and `optional`. A tag that would only repeat one repo's own name isn't used. No task selects by tag yet. For browsing: `mani list projects --tags <tag>`. Careful: `--tags X` also matches `optional` repos carrying `X`, so for anything that changes a repo use `--tags-expr 'X && !optional'`.

| Command | Purpose |
|---|---|
| `mani sync` / `mani sync -p <repo> --ignore-sync-state` | Clone missing repos, skipping `optional` ones unless named with `-p` + the flag (`mani sync` doesn't recurse submodules) |
| `mani run submodules` | Init/update submodules |
| `mani run status` / `remotes` | Branch + status / remotes |
| `mani run update-default` (all non-optional repos; or `--tags essential` / `3d` / ..., `-p X`) | Checkout each repo's default branch (`main`, `develop`, ... from `origin/HEAD`) and pull; skips dirty repos |
| `mani run update-branch -p <repo> BRANCH=<b>` | Checkout + pull a specific branch |
| `mani run add-remote -p <repo> REMOTE=<user>` | Add `https://github.com/<user>/<repo>.git` as remote `<user>` (default `MustafaJafar`) |
| `mani run tag-latest -p <repo>` / `tag-checkout -p <repo> TAG=<t>` | Detach HEAD on the latest / a given tag (addons with services) |
| `mani run ruff-check\|ruff-fix -p <repo> [FILE=<path>]` | Ruff on a repo or one file |
| `mani run addon-package -p <repo>` | Zip an addon into `tmp/packages` |
| `mani run addon-upload -p <repo>` | Zip an addon and upload it to my server |
| `mani run addons-upload-all` | Clear `tmp/packages`, package my usual addons (hard-coded `-p` list in the task), upload them |
| `mani run launcher-env` / `launcher-dev\|staging\|prod` / `launcher-build-upload` | Launcher env, run from code, build + upload installer |
| `mani run core-env`, `traypublisher-dev`, `publish-report-viewer` | ayon-core env and dev-bundle launches |
| `mani run deptool-install`, `deptool-create[-upload] BUNDLE=<b> OUTPUT_DIR=<p>` | Dependency packages (`-upload` also uploads) |
| `mani run shotgrid-*`, `ftrack-*`, `kitsu-processor[-install]` | Install and run addon services from code (`BUNDLE=<variant>`) |
| `mani run server-update\|restart\|rebuild\|log\|log-live\|release [DOCKER_REPO=<repo>]` | Docker compose operations for the server. `DOCKER_REPO` is the docker repo folder (default `ayon-docker`); `log`/`log-live` take `SERVICE=<compose service>` (default `server`) |
| `mani run frontend-live [DOCKER_REPO=<repo>]` | Frontend dev server from `<docker repo>/server/ayon-frontend` |
| `mani run project-backup\|project-restore PROJECT=<name> [DOCKER_REPO=<repo>]` | Dump / restore a project (`sudo make`) |
| `mani run kitsu-update` | Pull + rebuild the local Kitsu server |
| `mani run docs-init\|docs-run\|docs-online` | ayon-documentation Docusaurus site / ngrok tunnel |
| `mani run jupyter` | Jupyter in `tmp/jupyter` |

## Conventions
- Default branches differ per repo (`develop` for most addons, `main` for `ayon-docker`, `ayon-pipeline-tests`, ...). Never assume `main`; read `origin/HEAD` (what `update-default` does).
- Origin is the upstream Ynput repo; forks (mine and other contributors') are extra remotes, added with `add-remote`.
- Never push, force-push or delete branches unless asked. `server-prune`, `project-restore`, `addons-upload-all`, `launcher-build-upload`, `*-create-upload` and the `*-upload` tasks change state outside the repo (docker images, DB, my AYON server): only run them when explicitly asked.
- Local SSL: for a local `ayon-docker` behind a self-signed cert, pass the merged CA bundle (certifi + local CA) as a parameter, e.g. `mani run launcher-dev SSL_CERT=<path>/caddy_certifi_merged_ca_cert.pem`. Server-facing tasks source `scripts/local-ssl.sh` (bash, since `shell:` is Git Bash), which exports `SSL_CERT_FILE` and `REQUESTS_CA_BUNDLE` from it. Without `SSL_CERT` nothing changes: `SSL_CERT_FILE` / `REQUESTS_CA_BUNDLE` set in the calling shell are inherited as usual. New server-facing tasks should source it too.
- `scripts/.env` holds `AYON_SERVER_URL` / `AYON_API_KEY` for uploads and services (placeholder values are committed; never commit a real key). Some tasks copy it into the target repo.
- Uploads need the one-time dev setup in `scripts/setup-my-dev-env.ps1` (pyenv, uv, then `uv sync` in `scripts`; `uv run` also does it on first use). Poetry is only still needed for the ayon-kitsu processor service, whose `manage.ps1` calls `poetry run`.
- Adding a helper: add a task to `mani.yaml` (use `$(basename "$PWD")` for the repo name, `target: {projects: [x]}` for repo-specific ones, `target: {projects: [workbench]}` for workbench-level ones; `target: {cwd: true}` does NOT work for that), add a row above, and a thin task in `.vscode/tasks.json` if wanted.
- Adding a repo: add it to `mani.yaml` (one-line `desc`, tags; `path: extras/<name>` if it is not a Ynput repo), then `mani sync -p <repo>`. `ayon*/` and `extras/` are already gitignored; otherwise add the folder to `.gitignore`.
- `.vscode/settings.json` lists client folders in `python.analysis.extraPaths`, including the DCC install paths and the dependency package version (`ayon_<stamp>_windows.zip`); update those when the machine or the dependency package changes.
