import Mongoose from 'mongoose'
import { debug } from 'debug'

Mongoose.Promose = global.Promise

export const conn = Mongoose.createConnection('mongodb://localhost/dollast')

const Problems = require('./models/Problems')
const Rounds = require('./models/Rounds')
const Users = require('./models/Users')
// const Submissions = require('./models/Submissions')

export const Models = {
  Problems: Problems.Model,
  Rounds: Rounds.Model,
  Users: Users.Model
  // Submissions: Submissions.Model
}

Rounds.init()
