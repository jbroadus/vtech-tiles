#!/bin/bash

STL_DIR="$(pwd)/stl"
mkdir -p ${STL_DIR}

for t in {a..z} {1..10}; do
    openscad -o ${STL_DIR}/tile_${t}.stl -D "which_tile=tile_${t}" tile.scad 
done