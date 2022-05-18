CC := gcc
CFLAGS := -m32 -g

OBJDIR := obj
BINDIR := bin
SRCDIR := src

_OBJ := int2str.o next_line.o strings_are_equal.o get_pilot.o telemetry.o main.o
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
