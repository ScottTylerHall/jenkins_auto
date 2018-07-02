hello: hello.o
	gcc -Wall -g -o hello hello.o

hello.o: hello.c
	gcc -c hello.c

run:
	./hello

clean:
	rm *.o