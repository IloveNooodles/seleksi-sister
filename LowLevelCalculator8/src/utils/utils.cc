#include "../include/utils.h"

int absolute(int x)
{
  int mask = x >> 31;
  return (x ^ mask) - mask;
}

int addition(int x, int y)
{
addition:
  int keep = (x & y) << 1;
  x ^= y;
  y = keep;

  if (y != 0)
    goto addition;

  return x;
}

int substraction(int x, int y)
{
  return addition(x, addition(~y, 1));
}
/*
x * y = (x * 2) * (y/2)
if y even do nothing
if y odd + x
*/
int multiplication(int x, int y)
{
  int res = 0;
  int sign = 1;
  if ((x < 0) ^ (y < 0))
    sign = -1;
  x = absolute(x);
  y = absolute(y);

mult:
  if (y & 1)
    res = addition(res, x);

  x <<= 1;
  y >>= 1;

  if (y != 0)
    goto mult;

  return sign > 0 ? res : -res;
}
/*
9 / 3
int cur = 1;
if(cur * y > x) cur = 0 x - cur * y
*/
int division(int x, int y)
{
  int res = 0;
  int sign = 1;
  if ((x < 0) ^ (y < 0))
    sign = -1;
  x = absolute(x);
  y = absolute(y);
div:
  x = substraction(x, y);
  res = addition(res, 1);

  if (x >= y)
    goto div;

  return sign > 0 ? res : -res;
}

int power(int x, int y)
{
  int res = 1;
power:
  res = multiplication(res, x);
  y = substraction(y, 1);

  if (y > 0)
    goto power;
  return res;
}