#include "fmt/core.h"
#include <range/v3/view.hpp>
#include "fibo.h"
#include <cxxopts.hpp>

namespace view = ranges::views;

#ifdef _WIN32
#define EXPORT __declspec(dllexport)
#else
#define EXPORT
#endif

extern "C" EXPORT int fib(int x)
{
  int a = 0, b = 1;
  for (int it : view::repeat(0) | view::take(x))
  {
    (void)it;
    int tmp = a;
    a += b;
    b = tmp;
  }
  return a;
}
extern "C" EXPORT int runner(int x)
{
  cxxopts::Options options("fibo", "Print the fibonacci sequence up to a value 'n'");
  options.add_options()("n,value", "The value to print to", cxxopts::value<int>()->default_value("10"));
  for (int x : view::iota(1) | view::take(x))
  {
    fmt::print("fib({}) = {}\n", x, fib(x));
  }
  return 0;
}