test.o:main.cc Makefile lscript bootstrap.s
	clang++ --target=riscv32 -march=rv32imv -mabi=ilp32 -O3 -mllvm -riscv-v-register-bit-width-lmul=1 -mllvm --riscv-v-vector-bits-min=256 -T lscript bootstrap.s main.cc -o test.o -nostdlib
	llvm-objdump -d test.o>test.dmp
	riscv64-unknown-elf-elf2hex --bit-width 512 --input test.o --output out.hex

clean:
	rm *.o *.dmp *.hex
