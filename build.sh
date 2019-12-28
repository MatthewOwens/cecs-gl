#!/bin/sh
clear

echo "checking for cecs updates on master"
git submodule update --remote

make && ./game
