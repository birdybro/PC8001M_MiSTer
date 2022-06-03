verilator \
-cc -exe --public --trace --savable \
--compiler msvc +define+SIMULATION=1 \
-O3 --x-assign fast --x-initial fast --noassert \
--converge-limit 6000 \
-Wno-fatal \
--top-module top sim.v \
../rtl/PC8001M.v \
../rtl/ps2key.v \
../rtl/rtc.v \
../rtl/pcg8253.v \
../rtl/psg891x.v \
../rtl/cmt.v \
../rtl/fz80.v \
../rtl/crtc.v \
../rtl/sram.v \
../rtl/biosrom.v \
../rtl/extrom.v
