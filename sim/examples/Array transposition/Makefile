transp.o:main.cpp Makefile lscript bootstrap.s
	riscv64-unknown-elf-g++ -march=rv32imv -mabi=ilp32 -O3 -nostdlib -T lscript bootstrap.s main.cpp -lc -o transp.o
	riscv64-unknown-elf-objdump -d transp.o > temp.dmp
	riscv64-unknown-elf-elf2hex --bit-width 512 --input transp.o --output testshex_transp.txt

clean:
	rm *.dmp *.o *.txt