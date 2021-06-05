ARCH ?= riscv64
MODE ?= release
CHAPTER ?=
app_dir = src
src_dir := build/$(ARCH)
bin_dir := build/bin
out_dir := target
cmake_build_args := -DARCH=$(ARCH) -DCHAPTER=$(CHAPTER)
ifeq ($(MODE), release)
cmake_build_args += -DCMAKE_BUILD_TYPE=Release
else ifeq ($(MODE), debug)
cmake_build_args += -DCMAKE_BUILD_TYPE=Debug
endif

OBJCOPY := $(ARCH)-linux-musl-objcopy
OBJDUMP := $(ARCH)-linux-musl-objdump
CP := cp
CH_TESTS :=  

CH2_TESTS := ch2_ ch2t_
CH3_TESTS_BASE := $(CH2_TESTS) ch3_0_ ch3t_
CH4_TESTS := ch2_ ch3_0_ ch4_
CH5_TESTS := $(CH4_TESTS) ch5_
CH6_TESTS := $(CH5_TESTS) ch6_
CH7_TESTS := $(CH6_TESTS) ch7_
CH8_TESTS := $(CH7_TESTS) ch8_

ifeq ($(CHAPTER), 2)
	CH_TESTS := $(CH2_TESTS)
else ifeq ($(CHAPTER), 2_bad)
	CH_TESTS := __ch2_bad_
else ifeq ($(CHAPTER), 3_0)
	CH_TESTS := $(CH3_TESTS_BASE)
else ifeq ($(CHAPTER), 3_1)
	CH_TESTS := ch3_1_
else ifeq ($(CHAPTER), 3_2)
	CH_TESTS := ch3_2_
else ifeq ($(CHAPTER), 4)
	CH_TESTS := $(CH4_TESTS)
else ifeq ($(CHAPTER), 4_only)
	CH_TESTS := ch4_
else ifeq ($(CHAPTER), 5)
	CH_TESTS := $(CH5_TESTS)
else ifeq ($(CHAPTER), 5_only)
	CH_TESTS := ch5_
else ifeq ($(CHAPTER), 6)
	CH_TESTS := $(CH6_TESTS)
else ifeq ($(CHAPTER), 6_only)
	CH_TESTS := ch6_
else ifeq ($(CHAPTER), 7)
	CH_TESTS := $(CH7_TESTS)
else ifeq ($(CHAPTER), 7_only)
	CH_TESTS := ch7_
else ifeq ($(CHAPTER), 8)
	CH_TESTS := $(CH8_TESTS)
else ifeq ($(CHAPTER), 8_only)
	CH_TESTS := ch8_
endif

binary:
	@mkdir -p build
	@cd build && cmake $(cmake_build_args) .. && make
	@mkdir -p asm
	@$(CP) build/asm/* asm

pre:
	@rm -rf $(out_dir)
	@mkdir -p $(out_dir)/bin/
	@mkdir -p $(out_dir)/elf/

all: binary pre
	@$(foreach t, $(CH_TESTS), cp $(bin_dir)/$(t)* $(out_dir)/bin/;)
	@$(foreach t, $(CH_TESTS), cp $(src_dir)/$(t)* $(out_dir)/elf/;)

clean:
	@rm -rf build target asm
