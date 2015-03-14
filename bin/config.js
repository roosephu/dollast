// Generated by LiveScript 1.3.1
var path, ref$, out$ = typeof exports != 'undefined' && exports || this;
path = require('path');
ref$ = out$;
ref$.mode = "debug";
ref$.concurrency = 3;
ref$.sandboxer = path.resolve('./utils/sandboxer/sandboxer');
ref$.keys = ['drdrd'];
ref$.dataDir = path.resolve("./data");
ref$.judgerDir = path.resolve("./utils/judgers");
ref$.imageDir = 'public/image';
ref$.langSuffix = {
  'c': '.c',
  'cpp': '.cpp',
  'java': '.java'
};
ref$.compileFmt = {
  'cpp': function(src, dst){
    return "g++ " + src + " -o " + dst;
  }
};
ref$['default'] = {
  theme: "dollast",
  priv: {}
};
ref$.bcryptCost = 10;
ref$.secret = 'drdrdrd';
ref$.solListOpts = {
  skip: 0,
  limit: 10
};
ref$.probListOpts = {
  skip: 0,
  limit: 2
};