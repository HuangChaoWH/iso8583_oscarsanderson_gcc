CC = gcc
AS =
LINK = g++
RM = rm

OBJDIR   = objs

OUTDIR   = outs

SRC = 
SRC += $(SRC_COMMON) 
SRC += $(SRC_DEMO) 
SRC += $(SRC_BEHCHMARK) 

SRC_COMMON = \
	   lib/dl_iso8583.c \
	   lib/dl_iso8583_common.c \
	   lib/dl_iso8583_defs_1987.c \
	   lib/dl_iso8583_defs_1993.c \
	   lib/dl_iso8583_fields.c \
	   lib/dl_mem.c \
	   lib/dl_output.c \
	   lib/dl_str.c \
	   lib/dl_time.c \
	   lib/dl_timer.c	\

SRC_DEMO      = demo.c 
SRC_BEHCHMARK = benchmark.c

SRC_BASE        = $(notdir $(basename $(SRC)))
SRC_COMMON_BASE = $(notdir $(basename $(SRC_COMMON)))

OBJS         = $(addprefix $(OBJDIR)/, $(addsuffix .o, $(SRC_BASE)))
COMMON_OBJS  = $(addprefix $(OBJDIR)/, $(addsuffix .o, $(SRC_COMMON_BASE)))

TARGETS = $(OUTDIR)/demo $(OUTDIR)/benchmark

CFLAGS =
CFLAGS += -Ilib/

CFLAGS += -fPIC
CFLAGS += -pthread
CFLAGS += -Wall
CFLAGS += -Wextra
CFLAGS += -Wno-unused-parameter

CFLAGS += -Wno-pointer-sign
CFLAGS += -Wno-implicit-function-declaration
CFLAGS += -Wno-format-zero-length
CFLAGS += -Wno-incompatible-pointer-types
CFLAGS += -Wno-parentheses
CFLAGS += -Wno-sign-compare
CFLAGS += -Wno-discarded-qualifiers
CFLAGS += -Wno-unused-variable


CFLAGS += -m64
CFLAGS += -O3
CFLAGS += -fno-omit-frame-pointer

# Multi Thread
LDFLAGS = -pthread -lrt

all: d $(TARGETS) 

# Compile: create object files from C source files.
define COMPILE_C_TEMPLATE
$(OBJDIR)/$(notdir $(basename $(1))).o : $(1) $(BUILDONCHANGE)
	@echo "==== Building [$$<]"
	@echo Compiling [$$<] to [$$@]
	@echo 
	$(CC) $$(CFLAGS) -c $$< -o $$@
	@echo " "
endef
$(foreach src, $(SRC), $(eval $(call COMPILE_C_TEMPLATE, $(src))))

outs/demo : $(COMMON_OBJS) objs/demo.o
	$(CC) $^ -o $@
	@echo 

outs/benchmark : $(COMMON_OBJS) objs/benchmark.o
	$(CC) $^ -o $@
	@echo 

d:
	@if [ -d "objs" ]; then : ; else mkdir objs;  fi
	@if [ -d "outs" ]; then : ; else mkdir outs;  fi

cs:
	find . -name "*.[chxsS]" -print > cscope.files
	cscope -b -q -k
c:
	$(RM) -f $(OBJS) $(TARGETS) cscope.*
