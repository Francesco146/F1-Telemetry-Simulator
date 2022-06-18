CC := gcc
CFLAGS := -m32 -g

OBJDIR := obj
BINDIR := bin
SRCDIR := src

_OBJ := str2int.o process_line.o output_max_avg.o is_my_pilot.o int2str.o next_line.o are_strings_equal.o get_pilot.o telemetry.o main.o
OBJ := $(addprefix $(OBJDIR)/,$(_OBJ))

.PHONY: all clean

all: $(BINDIR)/telemetry

$(BINDIR)/telemetry: $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^

$(OBJDIR)/main.o: $(SRCDIR)/main.c
	$(CC) $(CFLAGS) -c -o $@ $<

$(OBJDIR)/%.o: $(SRCDIR)/%.s
	$(CC) $(CFLAGS) -c -o $@ $<

dirs:
	mkdir -p $(OBJDIR) $(BINDIR)

clean:
	rm -f $(OBJDIR)/*
	rm -f $(BINDIR)/*
