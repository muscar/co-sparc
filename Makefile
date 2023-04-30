AS=sparc64-linux-gnu-as
LD=sparc64-linux-gnu-ld

all: co.o
	$(LD) -o co co.o

co.o: co.s
	$(AS) -Av9a -64 -no-undeclared-regs -relax -g -o co.o co.s

clean:
	rm -f co.o co
