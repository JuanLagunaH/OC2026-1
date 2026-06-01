build:
	gcc -m32 -c Main.c -o Main.o
	nasm -f elf p10.asm -o p10.o
	gcc -m32 p10.o Main.o -no-pie -z noexecstack -o ../../bin/practica10.exe

run:
	./../../bin/practica10.exe

clean:
	rm -f *.o ../../bin/practica10.exe