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
include CMakeFiles/exec_simple.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/exec_simple.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/exec_simple.dir/flags.make

CMakeFiles/exec_simple.dir/src/exec_simple.c.o: CMakeFiles/exec_simple.dir/flags.make
CMakeFiles/exec_simple.dir/src/exec_simple.c.o: ../src/exec_simple.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/tonyfu/riscv/ucore-Tutorial/user/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object CMakeFiles/exec_simple.dir/src/exec_simple.c.o"
	riscv64-linux-musl-gcc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/exec_simple.dir/src/exec_simple.c.o   -c /home/tonyfu/riscv/ucore-Tutorial/user/src/exec_simple.c

CMakeFiles/exec_simple.dir/src/exec_simple.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/exec_simple.dir/src/exec_simple.c.i"
	riscv64-linux-musl-gcc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/tonyfu/riscv/ucore-Tutorial/user/src/exec_simple.c > CMakeFiles/exec_simple.dir/src/exec_simple.c.i

CMakeFiles/exec_simple.dir/src/exec_simple.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/exec_simple.dir/src/exec_simple.c.s"
	riscv64-linux-musl-gcc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/tonyfu/riscv/ucore-Tutorial/user/src/exec_simple.c -o CMakeFiles/exec_simple.dir/src/exec_simple.c.s

CMakeFiles/exec_simple.dir/src/exec_simple.c.o.requires:

.PHONY : CMakeFiles/exec_simple.dir/src/exec_simple.c.o.requires

CMakeFiles/exec_simple.dir/src/exec_simple.c.o.provides: CMakeFiles/exec_simple.dir/src/exec_simple.c.o.requires
	$(MAKE) -f CMakeFiles/exec_simple.dir/build.make CMakeFiles/exec_simple.dir/src/exec_simple.c.o.provides.build
.PHONY : CMakeFiles/exec_simple.dir/src/exec_simple.c.o.provides

CMakeFiles/exec_simple.dir/src/exec_simple.c.o.provides.build: CMakeFiles/exec_simple.dir/src/exec_simple.c.o


# Object files for target exec_simple
exec_simple_OBJECTS = \
"CMakeFiles/exec_simple.dir/src/exec_simple.c.o"

# External object files for target exec_simple
exec_simple_EXTERNAL_OBJECTS =

riscv64/exec_simple: CMakeFiles/exec_simple.dir/src/exec_simple.c.o
riscv64/exec_simple: CMakeFiles/exec_simple.dir/build.make
riscv64/exec_simple: libulib.a
riscv64/exec_simple: CMakeFiles/exec_simple.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/tonyfu/riscv/ucore-Tutorial/user/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C executable riscv64/exec_simple"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/exec_simple.dir/link.txt --verbose=$(VERBOSE)
	mkdir -p asm
	riscv64-linux-musl-objdump -d -S /home/tonyfu/riscv/ucore-Tutorial/user/build/riscv64/exec_simple > asm/exec_simple.asm
	mkdir -p target
	riscv64-linux-musl-objcopy -O binary /home/tonyfu/riscv/ucore-Tutorial/user/build/riscv64/exec_simple target/exec_simple.bin

# Rule to build all files generated by this target.
CMakeFiles/exec_simple.dir/build: riscv64/exec_simple

.PHONY : CMakeFiles/exec_simple.dir/build

CMakeFiles/exec_simple.dir/requires: CMakeFiles/exec_simple.dir/src/exec_simple.c.o.requires

.PHONY : CMakeFiles/exec_simple.dir/requires

CMakeFiles/exec_simple.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/exec_simple.dir/cmake_clean.cmake
.PHONY : CMakeFiles/exec_simple.dir/clean

CMakeFiles/exec_simple.dir/depend:
	cd /home/tonyfu/riscv/ucore-Tutorial/user/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/tonyfu/riscv/ucore-Tutorial/user /home/tonyfu/riscv/ucore-Tutorial/user /home/tonyfu/riscv/ucore-Tutorial/user/build /home/tonyfu/riscv/ucore-Tutorial/user/build /home/tonyfu/riscv/ucore-Tutorial/user/build/CMakeFiles/exec_simple.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/exec_simple.dir/depend

