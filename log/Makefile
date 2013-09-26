
MODULE := dlogmodule.o

all:
	dmd -c logger.d writer.d writers/console.d -of${MODULE}

.PHONY: clean

clean:
	rm *.o
