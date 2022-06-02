# [NEC PC-8001](https://en.wikipedia.org/wiki/PC-8000_series) for [MiSTer](https://mister-devel.github.io/MkDocs_MiSTer/)

This is a port of [@radiojunkbox](https://github.com/radiojunkbox)'s [pc8001m](https://github.com/radiojunkbox/pc8001m) core to MiSTer FPGA

![](doc/pc8001m.jpg)

## Keyboard layout

![](doc/keyboard.jpg)

## To-Do

* Figure out video
* Load BIOS (have to substitue the MIF loading for an sdram module and loading to SDRAM probably, but might not even be copyright covered anymore, it's pretty old, who knows, could probably load as MIF for now)
* convert font rom data to MIF and load it (likely not under a strong copyright issue)
* Be able to load ROMs (d88 is standard from TOSEC) (same as above, substitute current MIF loading)
* Map keyboard somehow
