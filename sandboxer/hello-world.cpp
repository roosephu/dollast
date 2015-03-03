#include <iostream>
using namespace std;

int main() {
  int A, B;
  for (int i = 1; i <= 100000000; ++i)
    A += 1;
  cin >> A >> B;
  cout << A + B << endl;
  return 0;
}
