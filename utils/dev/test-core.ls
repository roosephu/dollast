require! {
  "debug"
  "co"
  "util"
  "bluebird"
  "co-limiter"
}

log = debug 'test-core'

src = '''
#include <iostream>
using namespace std;

int main() {
  int A, B;
  cin >> A >> B;
  cout << A + B << endl;
  return 0;
}
'''
lang = 'C++'

/*
core.compile lang, src .then (val) ->
  console.log "val: #{util.inspect val}"
.catch (err) ->
  console.log err
*/

task = [
  ->* return 1
  , (cb) -> return 2
  , (cb) -> return 3
]
