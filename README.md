# Blockstorm Blitz

Blockstorm Blitz is a breakout-style NES(Nintendo Entertainment System) game programmed in assembly. It is still a heavy work in progress, and there's tons of thongs I want to add.

## Compiling

1. Clone this repository
2. Download [code.visualstudio.com/download](VS Code) (or use the [vscode.dev](browser version))
3. In VS Code, install an extension named "ca65 Macro Assembler Language Support"
4. Download [cc65.github.io/getting-started.htm](cc65) and unzip it to `C:\cc65`
5. In VS Code, press `Ctrl+Shift+B` and then click `ca65: Assemble and Link Current File`

## Playing

Simply take the `.nes` file you just built and run it using any NES emulator (such as [https://github.com/SourMesen/Mesen2](Mesen)).

## Extra tools

- To make the compilation process less tedious, go to `Terminal>Configure Default Build Task...` and set it to `ca65: Assemble and Link Current File`
- To edit `default.chr` (the file containing the sprite + background bitmaps), download [https://w.atwiki.jp/yychr/](YYCHR) (and make sure the format is `2BPP NES`)
- To edit `levelData.lvl` (the file containing the game's level data), download [github.com/Merlin1247/NBLevelEditor](NBLevelEditor)

## Contributing

Feel free to make any changes you see fit! If you have a feature suggestion or bug, [https://github.com/Merlin1247/blockstorm-blitz/issues](create an Issue). If you have a more general programming question, message me on Discord.

