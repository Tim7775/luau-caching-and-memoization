### Project Setup
[Rokit](https://github.com/rojo-rbx/rokit) and [Node.js](https://nodejs.org) are required to setup the project.
- Run `rokit install` in the project directory to install the required tools.
- Run `npm install` to install npm dependencies.

### Testing
[Roblox Studio](https://create.roblox.com/docs/studio/setting-up-roblox-studio) is required to run unit tests.

In VSCode you can run tests by opening the command palette (ctrl+shift+P) and selecting: `Tasks: Run test Task`.

In other editors you can run tests by following these steps:
- Build the project via `rojo build --output test/test.rbxl`
- Open the generated Roblox file.
- Run the game and the results will be printed to the output.
