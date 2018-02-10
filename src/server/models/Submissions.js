import { Schema } from 'mongoose'
// import { debug } from 'debug'
import { conn, Models } from './connectors'
import { judge } from '../core'
import * as _ from 'lodash'
import config from '../config'
import status from '../status'

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

// const log = debug('dollast:sol')

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
    _id: ID!
    code: String
    language: String
    problem: Problem
    user: User
    round: Round
    summary: SubmissionSummary
    results: [TestCaseResult]
  }

  extend type Query {
    submission(_id: ID!): Submission
    submissions(
      user: String
      problem: String
      round: String
      maxScore: Float
      minScore: Float
      language: String
      page: Int
    ): [Submission]
  }

  extend type Mutation {
    submit(
      code: String
      language: String
      problem: String
    ): Submission
    rejudgeSubmission(submissionId: ID, problemId: ID, contestId: ID): Submission
  }
`

async function rejudge (doc) {
  const problem = await Models.Problems.findById(doc.problem).exec()
  const { language, code } = doc
  const config = _.pick(problem, ['timeLimit', 'spaceLimit', 'stackLimit', 'outputLimit', 'judger', 'dataset'])

  judge(language, code, config, doc)
}

const resolvers = {
  Submission: {
    async problem (root) {
      return Models.Problems.findById(root.problem).lean().exec()
    },

    async user (root) {
      return Models.Users.findById(root.user).lean().exec()
    },

    async round (root) {
      return Models.Rounds.findById(root.round).lean().exec()
    }
  },

  Query: {
    async submission (root, { _id }) {
      return Models.Submissions.findById(_id).lean().exec()
    },

    async submissions (root, args) {
      let { user, problem, round, maxScore, minScore, language, page } = args
      round = round || status.defaultRoundId

      let query = Models.Submissions
        .find(_.pickBy({ user, problem, round, language }))
        .sort('-date')
        .limit(config.limit)
        .lean()
      if (maxScore) query = query.and({ 'summary.score': { $lte: maxScore } })
      if (minScore) query = query.and({ 'summary.score': { $gte: minScore } })
      if (page) query = query.skip((page - 1) * config.limit)

      return query.exec()
    }
  },

  Mutation: {
    async submit (root, submission, ctx) {
      if (!ctx.session.user) return new Error('logged in to submit')
      const problemDoc = await Models.findById(submission.problem).lean().exec()
      if (!problemDoc) return new Error('no such problem')
      submission.round = problemDoc.round

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

    async rejudgeSubmission (root, { submissionId }, ctx) {
      const doc = await Models.Submissions.findById(submissionId).exec()
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
