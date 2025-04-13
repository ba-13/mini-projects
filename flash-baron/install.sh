#!/bin/bash

pip install pyinstaller
pyinstaller --onefile --add-data "baron333.pickle:." flash_baron.py
