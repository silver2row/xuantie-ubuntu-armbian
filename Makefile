files:= FILENAME FILENAMEONE FILENAMETWO FILENAMETHREE FILENAMEFOUR FILENAMEFIVE

YES: $(files)

FILENAME:
	./01_git_sync.sh
FILENAMEONE:
	./02_build_opensbi.sh
FILENAMETWO:
	./03_build_uboot.sh
FILENAMETHREE:
	./04_build_linux.sh
FILENAMEFOUR:
	sudo ./05_generate_boot.sh
FILENAMEFIVE:
	sudo ./06_generate_debian_console_root.sh
