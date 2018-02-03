export default {
  langSuffix: {
    c: '.c',
    cpp: '.cpp',
    java: '.java'
  },
  compileFmt: {
    cpp: (src, dst) => `g++ ${src} -o ${dst} -DONLINE_JUDGE`
  },
  solListOpts: {
    page: 1,
    limit: 10
  },
  probListOpts: {
    page: 1,
    limit: 2
  },
  user: {
    _id: {
      $min: 3,
      $max: 15
    },
    password: {
      $min: 8,
      $max: 16
    }
  },
  problem: {
    title: {
      $min: 2,
      $max: 60
    }
  },
  permit: {
    group: {
      $min: 2,
      $max: 20
    }
  },
  languages: ['cpp', 'java']
}
