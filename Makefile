AS=sparc64-linux-gnu-as
LD=sparc64-linux-gnu-ld
CPP=cpp

all: co.o
	$(LD) -o co co.o

co.o: co.s
	$(CPP) co.s | $(AS) -Av9a -64 -no-undeclared-regs -relax -g -o co.o --

clean:
	rm -f co.o co
