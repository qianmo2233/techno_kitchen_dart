import 'dart:math';

int calcRandom() {
  const int max = 1037933;
  int num2 = Random().nextInt(max) + 1;
  num2 *= 2069;
  num2 += 1024; // specialnum

  int num3 = 0;
  for (int i = 0; i < 32; i++) {
    num3 <<= 1;
    num3 += num2 % 2;
    num2 >>= 1;
  }

  return num3;
}