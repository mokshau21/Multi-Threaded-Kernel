#!/bin/bash
sudo apt update 
sudo apt install nasm # used to install nasm
sudo apt install qemu-system-x86 # used to install qemu emulator
qemu-system-x86_64 # used to run qemu emulator
nasm -f bin ./boot.asm -o ./boot.bin # used to convert .asm file to binary file.
ndisasm ./boot.bin # this is a deassembler which is used to convert binary file to assembly level instruction.
qemu-system-x86_64 -hda ./boot.bin # this command is used to run our boot loader in qemu emulator..