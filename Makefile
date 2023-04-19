#
# (C) Copyright 2002-2006
# Wolfgang Denk, DENX Software Engineering, wd@denx.de.
#
# SPDX-License-Identifier:	GPL-2.0+
#

# fw_printenv is supposed to run on the target system, which means it should be
# built with cross tools. Although it may look weird, we only replace "HOSTCC"
# with "CC" here for the maximum code reuse of scripts/Makefile.host.
HOSTCC = $(CORSS_PREFIX)-gcc

CFLAGS+=-I./ -DUSE_HOSTCC

# Compile for a hosted environment on the target
HOST_EXTRACFLAGS  = $(patsubst -I%,-idirafter%, $(filter -I%, $(UBOOTINCLUDE))) \
		-idirafter $(srctree)/tools/env \
		-DUSE_HOSTCC \
		-DTEXT_BASE=$(TEXT_BASE)

OBJ=fw_env.o crc32.o ctype.o linux_string.o env_attr.o env_flags.o fw_env_main.o

all: fw_printenv

debug:
	echo $(CFLAGS)

fw_printenv: debug $(OBJ)
	$(CC) $(CFLAGS) -static $(OBJ) -o fw_printenv
	$(CORSS_PREFIX)strip fw_printenv

clean:
	rm -rf fw_env.o crc32.o ctype.o linux_string.o env_attr.o env_flags.o fw_env_main.o fw_printenv

