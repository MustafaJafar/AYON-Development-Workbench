# AYON-Development-Workbench

The AYON Development Workbench repository offers a straightforward example of how to set up your workspace for AYON development with the help of VSCode tasks. Just a few clicks and you'll have your workspace ready, along with numerous VSCode tasks that act as high-level commands to aid you in your everyday development activities.

Drawing inspiration from the early days of AYON development, when all add-ons were housed in a single directory and managed with just a few commands. However, since each add-on now resides in its own repository, managing them from one place has become more challenging. Hence, this repo simplifies the process, making it more efficient so you can spend less time setting up and more time creating.

## Features of the AYON Development Workbench:
> [!IMPORTANT]  
> This setup is currently only functional on Windows within VSCode. However, feel free to draw inspiration from it and adapt the workflow to suit your preferences.

Here's a quick peek at what this repository offers, but you'll probably want to dive in and explore it yourself.

- The commands are designed to be relative to your working directory, which means there's no need for a specific directory name. You can copy and paste `.vscode` directory wherever you prefer.
- It includes a command for cloning some essential official repositories at once, as well as an individual command for fetching an official repo based on you input.
- There's a command available for updating the development environment of both the launcher and core repositories.
- You can create and upload addon zip files using a simple command.
- Commands are provided for initializing and running AYON documentation.
- It also offers commands for updating your dependency packages by specifying input repo.
- It also offers key settings to add the client code of multiple repositories as sources, enabling the Python extension to search for function definitions.
