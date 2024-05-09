#ifndef FIBO_H
#define FIBO_H
#ifdef __cplusplus
extern "C"
{
#endif
#ifdef _WIN32
#define IMPORT __declspec(dllimport)
#else
#define IMPORT
#endif
    IMPORT int fib(int n);
    IMPORT int runner(int n);
#ifdef __cplusplus
}
#endif
#endif