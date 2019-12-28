TARGET = game
TEST_TARGET = check

LIBS = -lm -DREENTRANT -std=c11 -Lcecs/ -lcecs
TEST_LIBS = $(LIBS) `pkg-config --libs check`

CC = gcc
CFLAGS = -g -Wall -Isrc/

.PHONY: default all clean cecs FORCE output
.PRECIOUS: $(TARGET) $(TEST_TARGET)

default: all
all: $(TARGET) $(TEST_TARGET)

#OBJECTS = $(patsubst src/%.c, src/%.o, $(wildcard src/**/*.c))
ALL_OBJECTS = $(patsubst src/%.c, src/%.o, $(wildcard src/*.c))
OBJECTS = $(filter-out src/main.o, $(ALL_OBJECTS))
HEADERS = $(wildcard src/*.h) $(wildcard src/**/*.h)
SRCS = $(wildcard src/*.c) $(wildcard src/**/*.c)

TEST_OBJECTS = $(patsubst tests/%.c, tests/%.o, $(wildcard tests/*.c))
TEST_HEADERS = $(wildcard tests/*.h) $(wildcard tests/**/*.h)
TEST_SRCS = $(wildcard tests/*.c) $(wildcard tests/**/*.c)

cecs:
	$(MAKE) -C cecs 

$(TARGET): cecs $(ALL_OBJECTS)
	@echo "========== Building $(TARGET) =========="
	$(CC) $(CFLAGS) $(ALL_OBJECTS) $(LIBS) -o $@

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

clean:
	rm -f src/*.o
	rm -f tests/*.o
	rm -f $(TARGET)
	rm -f $(TEST_TARGET)

output:
	@echo "==== $(TARGET) ===="
	@echo "sources: $(SRCS)"
	@echo "headers: $(HEADERS)"
	@echo "objects: $(ALL_OBJECTS)"
	@echo "==== $(TEST_TARGET) ===="
	@echo "sources: $(TEST_SRCS)"
	@echo "headers: $(TEST_HEADERS)"
	@echo "objects: $(TEST_OBJECTS)"

FORCE:
