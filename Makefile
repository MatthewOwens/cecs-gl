TARGET = game
TEST_TARGET = check

LIBS = -lm -D_REENTRANT -std=c11 -Lcecs/ -lcecs -lGL -lGLEW -lSDL2 -lSDL2_image
TEST_LIBS = $(LIBS) `pkg-config --libs check`

CC = gcc
CFLAGS = -g -Wall -Isrc/

.PHONY: default all clean cecs FORCE output help
.PRECIOUS: $(TARGET) $(TEST_TARGET)

default: all

ALL_OBJECTS = $(patsubst src/%.c, src/%.o, $(wildcard src/*.c))
OBJECTS = $(filter-out src/main.o, $(ALL_OBJECTS))
HEADERS = $(wildcard src/*.h) $(wildcard src/**/*.h)
SRCS = $(wildcard src/*.c) $(wildcard src/**/*.c)

TEST_OBJECTS = $(patsubst tests/%.c, tests/%.o, $(wildcard tests/*.c))
TEST_HEADERS = $(wildcard tests/*.h) $(wildcard tests/**/*.h)
TEST_SRCS = $(wildcard tests/*.c) $(wildcard tests/**/*.c)

## all: builds the game, cecs submodule & tests
all: $(TARGET) $(TEST_TARGET)

## cecs: builds the cecs submodule
cecs:
	$(MAKE) -C cecs libcecs.a

## game: builds the game and cecs submodule
$(TARGET): cecs $(ALL_OBJECTS)
	@echo "========== Building $(TARGET) =========="
	$(CC) $(CFLAGS) $(ALL_OBJECTS) $(LIBS) -o $@

## check: builds and runs the tests.
##        requires that game .o files (except main) & cecs submodule are built
$(TEST_TARGET): cecs $(OBJECTS) $(TEST_OBJECTS) FORCE
	@echo "========== Building $(TEST_TARGET) =========="
	$(CC) $(TEST_CFLAGS) $(OBJECTS) $(TEST_OBJECTS) $(TEST_LIBS) -o $@
	@echo "========== RUNNING TESTS =========="
	./$(TEST_TARGET)
	@echo ""

src/%.o: src/%.c
	$(CC) $(CFLAGS) -c $^ -o $@

tests/%o: tests/%.c
	$(CC) $(TEST_CFLAGS) -c $^ -o $@

## clean: removes all .o files, binaries for game & cecs submodule
clean:
	rm -f src/*.o
	rm -f tests/*.o
	rm -f $(TARGET)
	rm -f $(TEST_TARGET)
	$(MAKE) -C cecs clean

## output: prints the variables used in the makefile & their values
output:
	@echo "==== $(TARGET) ===="
	@echo "sources: $(SRCS)"
	@echo "headers: $(HEADERS)"
	@echo "objects: $(ALL_OBJECTS)"
	@echo "==== $(TEST_TARGET) ===="
	@echo "sources: $(TEST_SRCS)"
	@echo "headers: $(TEST_HEADERS)"
	@echo "objects: $(TEST_OBJECTS)"

## help: prints this message
help: Makefile
	@sed -n 's/^##//p' $<

FORCE:
