.globl _start
_start:
lui a0,0x10000
mv sp,a0
jal main
hang: j hang
