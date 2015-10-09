Symbols
*******

This directory contain symbols that you can import in GNS3.

Rules
=====

* All symbols must be provided as a SVG file
* A file named symbol.txt should exist and contain symbol licence
* Try to keep a small file size
* Max height 70px unless you have a specific reason


Resize a svg
============

If the height of your SVG is too big. You can resize it with
a tools understanding SVG.

For imagemagick you need a version with rsvg (often it's OK on Linux).
For installating it  on mac with Homebrew:

```
brew install imagemagick --with-librsvg
```

For resizing with a height of 70:

```
convert symbols/firefox.svg -resize x70 firefox.svg
```
