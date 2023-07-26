# Makefile for building around Armbian and Xuantie-Ubuntu repos...
# W/ help from https://makefiletutorial.com/

files := FILENAME FILENAMEONE FILENAMETWO FILENAMETHREE FILENAMEFOUR FILENAMEFIVE
YES:	$(files)
FILENAME:
	sh ./01_git_sync.sh
FILENAMEONE:
	sh ./02_build_opensbi.sh
FILENAMETWO:
	sh ./03_build_uboot.sh
FILENAMETHREE:
	sh ./04_build_linux.sh
FILENAMEFOUR:
	sudo sh ./05_generate_boot.sh
FILENAMEFIVE:
	sudo sh ./06_generate_debian_console_root.sh
