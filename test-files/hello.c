#include <stdio.h>
#include <string.h>

typedef struct {
  float fl;
  char k;
} S;

void foo (int a, S s) {
  int b = a + 1;
  printf ("%d\n", b);
  printf ("%f, %c\n", s.fl, s.k);
}

int main(int argc, char *argv[])
{
  if (!strcmp(argv[0], "hello")) {
    S s = {1.0, 'a'};
    foo(0, s);
    printf("Hello World\n");
  } else {
    S s = {1.2, 'b'};
    foo(100, s);
    printf("No hello\n");
  }
  return 0;
}
