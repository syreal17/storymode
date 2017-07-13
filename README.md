# storymode
Primitive ascii adventure game targeted more towards storytelling than survivalism. All written in Ada. Built to be a roguelike engine adaptable to allegorical dungeons and immersive stories. Created to learn Ada by practice.

## Building storymode
Download GNAT either from apt-get or from [Ada Core Libre](http://libre.adacore.com/tools/gnat-gpl-edition/).

```
cd src
gnatmake main.adb
./main
```

Or open `storymode.gpr` with GPS and build using that IDE.

Current terminal/console dimensions of output are based on a Windows 120x30 command prompt. Such dimensions allow for a near perfect illusion of movement using only the primitive basic Ada library "Put" command.

## Features

* Player movement
* Room-based exploration
* Custom rooms and dungeons
* Triggers that display text
* Secret rooms
* Simple monsters
* Simple combat
* Simple monster pathfinding (gravitate towards player, ignoring walls)
