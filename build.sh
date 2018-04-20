#!/bin/bash

# concat source files into single PDE for distribution
cat ./src/*.pde > ./dist/XTouch.pde

# copy distribution file to all example projects
cd ./examples
ls | xargs -n 1 cp ../dist/XTouch.pde