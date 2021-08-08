# Makefile for PrettyPoi (prettypoi.asm)

# (c) Copyright 2021, Daniel Neville

# This file is part of PrettyPoi.
#
# PrettyPoi is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# PrettyPoi is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Foobar.  If not, see <https://www.gnu.org/licenses/>.


.PHONY = help clean all pretty27 pretty47 burn27 burn47 \
  read27 read47 show27eep show47eep


# The main output files, aside from their extensions, have a common filename.
MAIN_STEM := prettypoi
STEM_27 := pretty27
STEM_47 := pretty47

# Files to "burn" into MCU memories
HEX_FILE_27 := ${STEM_27}.hex
HEX_FILE_47 := ${STEM_47}.hex
DUMP_FILE_27 := dump27.hex
DUMP_FILE_47 := dump47.hex

# Assembler
# gpasm is in the Ubuntu gputils package.
ASM := gpasm
# Programmer
# pk2cmd is available from Microchip
PROG := pk2cmd

help:
	@echo "Custom code for 3-RGBLED Ninja poi from Home of Poi"
	@echo "Target MCU: PIC16F1827 (also PIC16D1847)"
	@echo "make help:        Display this message."
	@echo "make clean:       Remove generated files such as object files."
	@echo "make all:         Build both ${HEX_FILE_27} and ${HEX_FILE_47}."
	@echo "make pretty27:    Build ${HEX_FILE_27} for the PIC16F1827."
	@echo "make pretty47:    Build ${HEX_FILE_47} for the PIC16F1847."
	@echo "make burn27:      Program the PIC16F1827 MCU with ${PROG}."
	@echo "make burn47:      Program the PIC16F1847 MCU with ${PROG}."
	@echo "make read27:      Read the PIC16F1827 and save to ${DUMP_FILE_27}."
	@echo "make read47:      Read the PIC16F1847 and save to ${DUMP_FILE_47}."
	@echo "make show27eep:   Display the PIC16F1827's EEPROM."
	@echo "make show47eep:   Display the PIC16F1847's EEPROM."

clean:
	rm -f ${STEM_27}.o
	rm -f ${STEM_27}.elf
	rm -f ${STEM_27}.cod
	rm -f ${STEM_27}.lst
	rm -f ${HEX_FILE_27}
	rm -f ${DUMP_FILE_27}
	rm -f ${STEM_47}.o
	rm -f ${STEM_47}.elf
	rm -f ${STEM_47}.cod
	rm -f ${STEM_47}.lst
	rm -f ${HEX_FILE_47}
	rm -f ${DUMP_FILE_47}

all: ${HEX_FILE_27} ${HEX_FILE_47}

pretty27: ${HEX_FILE_27}

pretty47: ${HEX_FILE_47}

${HEX_FILE_27}: ${MAIN_STEM}.asm $(wildcard *.inc) $(wildcard *.h)
	${ASM} -o ${HEX_FILE_27} -p p16f1827 ${MAIN_STEM}.asm
	@echo "✅ Hex file" '"'"${HEX_FILE_27}"'"' "is ready to burn"\
		"(with" '"make burn27"'")."

${HEX_FILE_47}: ${MAIN_STEM}.asm $(wildcard *.inc) $(wildcard *.h)
	${ASM} -o ${HEX_FILE_47} -p p16f1847 ${MAIN_STEM}.asm
	@echo "✅ Hex file" '"'"${HEX_FILE_47}"'"' "is ready to burn"\
		"(with" '"make burn47"'")."

burn27: ${HEX_FILE_27}
	${PROG} -PPIC16F1827 -M -F${CURDIR}/${HEX_FILE_27}

burn47: ${HEX_FILE_47}
	${PROG} -PPIC16F1847 -M -F${CURDIR}/${HEX_FILE_47}

read27:
	${PROG} -PPIC16F1827 -GF${CURDIR}/${DUMP_FILE_27}

read47:
	${PROG} -PPIC16F1847 -GF${CURDIR}/${DUMP_FILE_47}

show27eep:
	${PROG} -PPIC16F1827 -GE0-FF

show47eep:
	${PROG} -PPIC16F1847 -GE0-FF
