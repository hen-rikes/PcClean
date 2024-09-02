@echo off

set LIBS=-l .\lib\raylib.lib -l opengl32 -l gdi32 -l winmm 
set FLAGS=--wincrt=none -g0
set FILES=src/main.c3 src/raylib_bindings.c3
c3c %FLAGS% %LIBS% compile %FILES%
