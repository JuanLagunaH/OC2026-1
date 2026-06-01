build:
	gcc -m32 -c Main.c -o Main.o
	nasm -f elf p9.asm -o p9.o
	gcc -m32 p9.o Main.o -no-pie -z noexecstack -o ../../bin/practica9.exe

run:
	./../../bin/practica9.exe

clean:
	rm -f *.o ../../bin/practica9.exe