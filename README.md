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

## Features

* Player movement
* Room-based exploration
* Custom rooms and dungeons
* Triggers that display text
* Secret rooms
