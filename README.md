# Blockstorm Blitz

Blockstorm Blitz is a breakout-style NES(Nintendo Entertainment System) game programmed in assembly. It is still a heavy work in progress, and there's tons of thongs I want to add.

## Compiling

1. Clone this repository
2. Download [VS Code](code.visualstudio.com/download) (or use the [browser version](vscode.dev))
3. In VS Code, install the extension "ca65 Macro Assembler Language Support"
4. Download [cc65](cc65.github.io/getting-started.htm) and unzip it to `C:\cc65`
5. In VS Code, press `Ctrl+Shift+B` and then click `ca65: Assemble and Link Current File`

## Playing

Simply take the `.nes` file you just built and run it using any* NES emulator.
(Note: The game currently relies on unofficial CPU opcodes($9C and $9E) not implemented correctly by some emulators. I highly recommend using the latest version of [Mesen](https://github.com/SourMesen/Mesen2) for this reason, and many others.)

## Extra tools

- To make the compilation process less tedious, go to `Terminal>Configure Default Build Task...` and set it to `ca65: Assemble and Link Current File`
- To edit `default.chr` (the file containing the sprite + background bitmaps), download a tile-editing tool such as [YYCHR](https://w.atwiki.jp/yychr/) (and make sure the format is `2BPP NES`)
- To edit `levelData.lvl` (the file containing the game's level data), download [NBLevelEditor](github.com/Merlin1247/NBLevelEditor)

## Contributing

Feel free to make any changes you see fit! If you have a feature suggestion or bug, [create an Issue](https://github.com/Merlin1247/blockstorm-blitz/issues). If you have a more general programming question, message me on Discord.

