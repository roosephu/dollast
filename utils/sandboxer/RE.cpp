#include <iostream>
using namespace std;

int main() {
  int A, B;
  cin >> A >> B;
  cout << (A + B) / 0 << endl;
  cout << *(int *) 12345678 << endl;
  return 0;
}
