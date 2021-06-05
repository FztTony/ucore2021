# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.10

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/tonyfu/riscv/ucore-Tutorial/user

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/tonyfu/riscv/ucore-Tutorial/user/build

# Include any dependencies generated for this target.
include CMakeFiles/pipetest.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/pipetest.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/pipetest.dir/flags.make

CMakeFiles/pipetest.dir/src/pipetest.c.o: CMakeFiles/pipetest.dir/flags.make
CMakeFiles/pipetest.dir/src/pipetest.c.o: ../src/pipetest.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/tonyfu/riscv/ucore-Tutorial/user/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object CMakeFiles/pipetest.dir/src/pipetest.c.o"
	riscv64-linux-musl-gcc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/pipetest.dir/src/pipetest.c.o   -c /home/tonyfu/riscv/ucore-Tutorial/user/src/pipetest.c

CMakeFiles/pipetest.dir/src/pipetest.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/pipetest.dir/src/pipetest.c.i"
	riscv64-linux-musl-gcc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/tonyfu/riscv/ucore-Tutorial/user/src/pipetest.c > CMakeFiles/pipetest.dir/src/pipetest.c.i

CMakeFiles/pipetest.dir/src/pipetest.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/pipetest.dir/src/pipetest.c.s"
	riscv64-linux-musl-gcc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/tonyfu/riscv/ucore-Tutorial/user/src/pipetest.c -o CMakeFiles/pipetest.dir/src/pipetest.c.s

CMakeFiles/pipetest.dir/src/pipetest.c.o.requires:

.PHONY : CMakeFiles/pipetest.dir/src/pipetest.c.o.requires

CMakeFiles/pipetest.dir/src/pipetest.c.o.provides: CMakeFiles/pipetest.dir/src/pipetest.c.o.requires
	$(MAKE) -f CMakeFiles/pipetest.dir/build.make CMakeFiles/pipetest.dir/src/pipetest.c.o.provides.build
.PHONY : CMakeFiles/pipetest.dir/src/pipetest.c.o.provides

CMakeFiles/pipetest.dir/src/pipetest.c.o.provides.build: CMakeFiles/pipetest.dir/src/pipetest.c.o


# Object files for target pipetest
pipetest_OBJECTS = \
"CMakeFiles/pipetest.dir/src/pipetest.c.o"

# External object files for target pipetest
pipetest_EXTERNAL_OBJECTS =

riscv64/pipetest: CMakeFiles/pipetest.dir/src/pipetest.c.o
riscv64/pipetest: CMakeFiles/pipetest.dir/build.make
riscv64/pipetest: libulib.a
riscv64/pipetest: CMakeFiles/pipetest.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/tonyfu/riscv/ucore-Tutorial/user/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C executable riscv64/pipetest"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/pipetest.dir/link.txt --verbose=$(VERBOSE)
	mkdir -p asm
	riscv64-linux-musl-objdump -d -S /home/tonyfu/riscv/ucore-Tutorial/user/build/riscv64/pipetest > asm/pipetest.asm
	mkdir -p target
	riscv64-linux-musl-objcopy -O binary /home/tonyfu/riscv/ucore-Tutorial/user/build/riscv64/pipetest target/pipetest.bin

# Rule to build all files generated by this target.
CMakeFiles/pipetest.dir/build: riscv64/pipetest

.PHONY : CMakeFiles/pipetest.dir/build

CMakeFiles/pipetest.dir/requires: CMakeFiles/pipetest.dir/src/pipetest.c.o.requires

.PHONY : CMakeFiles/pipetest.dir/requires

CMakeFiles/pipetest.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/pipetest.dir/cmake_clean.cmake
.PHONY : CMakeFiles/pipetest.dir/clean

CMakeFiles/pipetest.dir/depend:
	cd /home/tonyfu/riscv/ucore-Tutorial/user/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/tonyfu/riscv/ucore-Tutorial/user /home/tonyfu/riscv/ucore-Tutorial/user /home/tonyfu/riscv/ucore-Tutorial/user/build /home/tonyfu/riscv/ucore-Tutorial/user/build /home/tonyfu/riscv/ucore-Tutorial/user/build/CMakeFiles/pipetest.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/pipetest.dir/depend

