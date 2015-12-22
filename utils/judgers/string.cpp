#include "testlib.h"
#include <string>
using namespace std;

int main(int argc, char **argv) {
  registerTestlibCmd(argc, argv);

  string a = ans.readString();
  string b = ouf.readString();

  if (a != b)
    quitf(_wa, "0 Answer does not match. \"%s\" vs \"%s\".", a.c_str(), b.c_str());
  quitf(_ok, "1 OK");

  return 0;
}
