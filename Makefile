CC := g++ # This is the main compiler
# CC := clang --analyze # and comment out the linker last line for sanity
SRCDIR := src
BUILDDIR := build
TARGETDIR := bin
TARGET := $(TARGETDIR)/ModularMadnessAssignment

# Google Test directory
GTEST_DIR := lib/googletest

SRCEXT := cpp
SOURCES := $(shell find $(SRCDIR) -type f -name *.$(SRCEXT))
OBJECTS := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SOURCES:.$(SRCEXT)=.o))
CFLAGS := -g -std=c++11# -Wall
LIB := -pthread
INC := -I include

$(TARGET): $(OBJECTS)
	@mkdir -p $(TARGETDIR)
	@echo " Linking..."
	@echo " $(CC) $^ -o $(TARGET) $(LIB)"; $(CC) $^ -o $(TARGET) $(LIB)

$(BUILDDIR)/%.o: $(SRCDIR)/%.$(SRCEXT)
	@mkdir -p $(BUILDDIR)
	@echo " $(CC) $(CFLAGS) $(INC) -c -o $@ $<"; $(CC) $(CFLAGS) $(INC) -c -o $@ $<

clean:
	@echo " Cleaning...";
	@echo " $(RM) -r $(BUILDDIR) $(TARGET)"; $(RM) -r $(BUILDDIR) $(TARGET)

# Google Test
gtest:
	@mkdir -p $(BUILDDIR)
	$(CC) -isystem ${GTEST_DIR}/include -I${GTEST_DIR} \
		-pthread -c ${GTEST_DIR}/src/gtest-all.cc -o $(BUILDDIR)/gtest-all.o
	ar -rv $(BUILDDIR)/libgtest.a ${BUILDDIR}/gtest-all.o

# Unit Tests
tests: gtest
	$(CC) $(CFLAGS) -isystem ${GTEST_DIR}/include test/tests.cpp ${BUILDDIR}/libgtest.a $(INC) $(LIB) $(filter-out build/main.o, $(OBJECTS)) -o bin/tests

.PHONY: clean
