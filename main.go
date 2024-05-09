package main

/*
#cgo CFLAGS: -I./build/include
#cgo LDFLAGS: -L./build/lib -lfibo
#include <fibo.h>
*/

import "C"
import "fmt"

func main() {
	fmt.Println("From Go")
	fmt.Println(C.runner(10))
}
