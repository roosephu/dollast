import { Schema } from 'mongoose'
import { debug } from 'debug'
import { conn, Models } from './connectors'
import { judge } from '../core'

const testCaseResultSchema = new Schema({
  time: Number,
  space: Number,
  message: String,
  score: Number,
  input: String,
  answer: String,
  weight: Number
})

const submissionSchema = new Schema({
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
    status: String
  },
  results: [testCaseResultSchema]
})

const log = debug('dollast:sol')

export const Model = conn.model('Submission', submissionSchema)

const typeDef = `
  type SubmissionSummary {
    time: Float
    space: Float
    message: String
    score: Float
    status: String
  }

  type TestCaseResult {
    time: Float
    space: Float
    message: String
    score: Float
    input: String
    answer: String
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
    results: [TestCaseResult]
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
    rejudgeSubmission(_id: String): Submission
  }
`

async function rejudge (doc) {
  const problem = await Models.Problems.findById(doc.problem).exec()
  const { language, code } = doc
  const { timeLimit, spaceLimit, stackLimit, outputLimit, judger, dataset } = problem

  judge(language, code, { timeLimit, spaceLimit, stackLimit, outputLimit, judger, dataset }, doc)
}

const resolvers = {
  Submission: {
    async problem (s) {
      if (s.problem === undefined) {
        return undefined
      }
      // log({ s, problems: Models.Problems })
      return Models.Problems.findById(s.problem).exec()
    },

    async user (s) {
      if (s.user === undefined) {
        return undefined
      }
      return Models.Users.findById(s.user).exec()
    },

    async round (s) {
      if (s.round === undefined) {
        return undefined
      }
      return Models.Rounds.findById(s.round).exec()
    }
  },

  Query: {
    async submission (root, { _id }) {
      return Model.findById(_id).exec()
    },

    async submissions (root, args) {
      return Model.find().exec()
    }
  },

  Mutation: {
    async submit (root, submission, ctx) {
      if (!ctx.session.user) {
        throw new Error('not logged in')
      }
      const doc = new Model(submission)
      doc.user = ctx.session.user
      doc.summary = {
        status: 'running',
        score: 0
      }
      await doc.save()

      rejudge(doc)
      return doc
    },

    async rejudgeSubmission (root, { _id }, ctx) {
      const doc = await Model.findById(_id).exec()
      doc.summary = {
        status: 'running',
        score: 0
      }
      await doc.save()

      rejudge(doc)
      return doc
    }
  }
}

export {
  typeDef,
  resolvers
}
