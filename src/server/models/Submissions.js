import { Schema } from 'mongoose'
import { debug } from 'debug'
import { conn, Models } from '../connectors'

const atomResultSchema = new Schema({
  time: Number,
  space: Number,
  message: String,
  score: Number,
  status: String,
  inf: String,
  ans: String,
  weight: Number
})

const schema = new Schema({
  date: { type: Date, default: Date.now },
  code: String,
  language: String,
  problem: { type: Schema.Types.ObjectId, ref: 'problem' },
  user: { type: String, ref: 'user' },
  round: { type: Schema.Types.ObjectId, ref: 'round' },
  summary: {
    time: Number,
    space: Number,
    message: String,
    score: Number,
    status: String,
    input: String,
    output: String,
    weight: Number
  },
  results: [atomResultSchema]
})

const log = debug('dollast:sol')

export const Model = conn.model('submission', schema)

const typeDef = `
  type SubmissionSummary {
    time: Float
    space: Float
    message: String
    score: Float
    status: String
    input: String
    output: String
    weight: Float
  }

  type Submission {
    _id: String
    code: String
    language: String
    problem: Problem
    user: User
    round: Round
    summary: SubmissionSummary
  }

  extend type Query {
    submission(_id: String): Submission
    submissions: [Submission]
  }

  extend type Mutation {
    submit(
      code: String
      language: String
      problem: String
      round: String
    ): Submission
  }
`

const resolvers = {
  Submission: {
    async problem (s) {
      return Models.Problems.findById(s.problem).exec()
    },

    async user (s) {
      return Models.Users.findById(s.user).exec()
    },

    async round (s) {
      return Models.Rounds.findById(s.round).exec()
    },

    summary (s) {
      return s.summary
    }
  },

  Query: {
    async submission (root, { _id }) {
      return Model.findById(_id).exec()
    },

    submissions (root, args) {
      return Model.find().exec()
    }
  },

  Mutation: {
    async submit (root, submission, ctx) {
      if (!ctx.session.user) {
        throw new Error('not logged in')
      }
      submission.user = ctx.session.user
      const doc = new Model(submission)
      await doc.save()
      return doc
    }
  }
}

export {
  typeDef,
  resolvers
}
