require! {
  "../core"
  "co"
  "util"
}

src = '''
#include <iostream>
using namespace std;

int main() {
  int A, B;
  for (; ;)
    ;
  cin >> A >> B;
  cout << A + B << endl;
  return 0;
}
'''
lang = 'C++'

core.compile lang, src .then (val) ->
  console.log "val: #{util.inspect val}"
.catch (err) ->
  console.log err
