require! {
  'bluebird': Promise
  'co'
}

fs = Promise.promisify-all require 'fs'

fs.
