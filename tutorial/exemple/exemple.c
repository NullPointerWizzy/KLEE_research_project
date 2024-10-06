#include <stdio.h>
#include "/home/thomas/Application/klee/include/klee/klee.h"

int main() {
    int y;	
		klee_make_symbolic(&y,sizeof(y),"y");		
    int z = y * 2;
    if (z < 12){
      if(z%2==0){
        z=8;
      }else{
        z=6;
      }
      printf("yes");
    }
    else
      printf("OK");
}
