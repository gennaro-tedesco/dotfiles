#!/bin/bash

git pull
# sudo make distclean
sudo make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
