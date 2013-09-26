
MODULE := "../log/dlogmodule.o"
INCLUDE_PATH := "../"

all:
	dmd -I${INCLUDE_PATH} main.d ${MODULE}
	
.PHONY: clean run

clean:
	rm *.o main

run: all
	./main
