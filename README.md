# Mario (is) Missing!

Disassembly of Mario is Missing! for the Super Nintendo Entertainment System.

Not of any of the other ports as those are in leagues of their own.

Also because I wanted to learn SNES asm :P

Supports the only release of Mario is Missing!. Takes .sfc format (headerless).

For WSL2 Ubuntu. Probably also works on actual Linux.

Run `./install` to set up asar

Run `./configure` to split banks from the supported rom

Run `./build` to make a new rom from assembly

## About

Still incredibly WIP!

## Notes

The game uses a ton of graphics optimizations, so that will be one of my goals to figure out.

Music is somewhat figured out! Still more hoops to jump through, but it's getting there!

General game text uses lossless compression, using replacement. Don't know the specific algorithm and its probably tailored anyways.
