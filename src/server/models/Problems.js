import { Schema } from 'mongoose'
import { conn, Models } from '../connectors'
import { debug } from 'debug'
import { upload, genDataPairs } from '../core'

const log = debug('dollast:models:Problems')

const testCaseSchema = new Schema({
  input: String,
  answer: String,
  weight: Number
})

const problemSchema = new Schema({
    // outlook
  description: String,
  title: String,
  inputFormat: String,
  outputFormat: String,
  sampleInput: String,
  sampleOutput: String,

    // config
  date: { type: Date, default: Date.now },
  round: { type: Schema.Types.ObjectId, ref: 'Round' },
  timeLimit: Number,
  spaceLimit: Number,
  stackLimit: Number,
  outputLimit: Number,
  judger: String,

  dataset: [testCaseSchema]
})

export const Model = conn.model('Problem', problemSchema)

const typeDef = `
  type TestCase {
    input: String
    answer: String
    weight: Float
  }

  type Problem {
    _id: String
    description: String
    title: String
    inputFormat: String
    outputFormat: String
    sampleInput: String
    sampleOutput: String
    round: Round
    timeLimit: Float
    spaceLimit: Float
    stackLimit: Float
    outputLimit: Float
    judger: String
    dataset: [TestCase]
  }

  extend type Query {
    problem(_id: String): Problem
    problems(round: String): [Problem]
  }

  extend type Mutation {
    updateProblem(
      _id: String!
      description: String
      title: String
      inputFormat: String
      outputFormat: String
      sampleInput: String
      sampleOutput: String
      round: String
      timeLimit: Float
      spaceLimit: Float
      stackLimit: Float
      outputLimit: Float
      judger: String
    ): Problem

    uploadData(_id: String, file: Upload): [TestCase]
  }
`

function prepare (o) {
  if (o != null) {
    o._id = o._id.toString()
  }
  return o
}

const resolvers = {
  Problem: {
    async round (p) {
      return Models.Rounds.findById(p.round).exec()
    }
  },

  TestCase: {

  },

  Query: {
    async problem (root, {_id}) {
      return prepare(await Model.findById(_id).exec())
    },

    async problems (root, args) {
      return (await Model.find(args).exec()).map(prepare)
    }
  },

  Mutation: {
    async updateProblem (root, problem) {
      const { _id } = problem
      await Model.update({ _id }, problem, { upsert: true }).exec()
      return Model.findById(_id).exec()
    },

    async uploadData (root, { _id, file }) {
      await upload(_id, await file[0])
      const dataset = await genDataPairs(_id)
      await Model.update({ _id }, { dataset }, { upsert: true }).exec()
      return dataset
    }
  }
}

export {
    typeDef,
    resolvers
}
