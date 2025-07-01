#include <iostream>
#include <stdint.h>
#include <string.h>


void TRANSP(int8_t *input, int8_t *index, int8_t *output){
    int vl;
    int temp=32;
    __asm__ volatile("vsetvli %0, %1, e8, m1, ta, ma":"=r"(vl):"r"(temp));
    __asm__ volatile("vle8.v v1,(%0)"::"r"(input));
    __asm__ volatile("vle8.v v2,(%0)"::"r"(index));
    __asm__ volatile("vrgather.vv v3,v1,v2");
    __asm__ volatile("vse8.v v3,(%0)"::"r"(output));
}

int8_t input[32]__attribute__((aligned(256)));
int8_t input_1[32]__attribute__((aligned(256)));;
int8_t index_arr[32]__attribute__((aligned(256)));;
int8_t output[32]__attribute__((aligned(256)));;
int8_t output_1[32]__attribute__((aligned(256)));;
int8_t temp[32];

int main(int argc, char* argv[]) {

    for(int8_t i=0;i<32;i++){
        input[i]=i+5;
        input_1[i]=32+i+5;
    }

    for(int i=0;i<4;i++){
        for(int j=0;j<8;j++){
            if(j<4){
                index_arr[i*8+j]=i+8*j;
            }
            else{
                index_arr[i*8+j]=i+8*(j-4)+4;
            }
        }
    }


    TRANSP(input,index_arr,output);
    TRANSP(input_1,index_arr,output_1);

    for(int8_t i=0;i<32;i++){
        temp[i]=output[i];
    }

    for(int i=0;i<4;i++){
        for(int j=4;j<8;j++){
            output[i*8+j]=output_1[i*8+(j-4)];
            output_1[i*8+(j-4)]=temp[i*8+j];
        }
    }

    return 0;
}