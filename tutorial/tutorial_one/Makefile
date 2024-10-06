CC = clang-14
CFLAGS = -Wall -Wextra -g -O0
CPPFLAGS = -I ../klee.git/include


all: sample-00.ll

sample-00.ll: sample-00.bc
	llvm-dis $^

sample-00.bc: sample-00.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -emit-llvm -c -o $@ $^

clean:
	@rm -f *~ *.ll *.bc

.PHONY:	all clean
