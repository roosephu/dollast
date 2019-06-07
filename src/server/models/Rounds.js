import { Schema } from 'mongoose'
import { conn, Models, nextRandomIndex } from './connectors'
import { GraphQLDateTime } from 'graphql-iso-date'
import status from '../status'
import { debug } from 'debug'
import moment from 'moment'

const log = debug('dollast:Rounds')

const roundSchema = new Schema({
  index: Number,
  date: { type: Date, default: Date.now },
  title: String,
  beginTime: { type: Date, default: Date.now },
  endTime: { type: Date, default: Date.now },
  problems: [{ type: Schema.Types.ObjectId, ref: 'Problem' }]
})
roundSchema.index({ index: 1 })

export const Model = conn.model('Round', roundSchema)

const typeDef = `
  scalar DateTime

  type Round {
    _id: ID!
    index: Int
    title: String
    beginTime: DateTime
    endTime: DateTime

    problems: [Problem]
    board: [Submission]
  }

  extend type Query {
    rounds: [Round]
    round(_id: ID!): Round
    defaultRoundId: String
  }

  extend type Mutation {
    updateRound(
      _id: ID!
      title: String
      beginTime: DateTime
      endTime: DateTime
    ): Round
  }
`

const resolvers = {
  Round: {
    async board ({ _id }) {
      const round = await Model.findById(_id).lean().exec()
      if (!round) return new Error('no such round')
      if (moment().isBefore(round.beginTime)) return new Error('wait until started')

      const submissionIds = await Models.Submissions.aggregate([
        { $match: { round: _id, date: { $gte: round.beginTime, $lte: round.endTime } } },
        { $sort: { problem: 1, user: 1, date: -1 } },
        { $group: { _id: { problem: '$problem', user: '$user' }, submissionId: { $first: '$id' } } }
      ]).exec()

      return Models.Submissions.find({ _id: { $in: submissionIds.map(x => x.submissionId) } }).exec()
    },

    async problems ({ _id }) {
      return Models.Problems.find({ round: _id }).lean().exec()
    }
  },

  DateTime: GraphQLDateTime,

  Query: {
    async rounds () {
      return Model.find().lean().exec()
    },

    async round (root, { _id }) {
      return Model.findById(_id).lean().exec()
    },

    defaultRoundId () {
      return status.defaultRoundId
    }
  },

  Mutation: {
    async updateRound (root, round) {
      const { _id } = round

      let doc = null
      if (_id) {
        doc = await Models.Rounds.find({ _id }).limit().exec()
      } else {
        doc = new Model(round)
      }

      if (!doc) round.index = await nextRandomIndex(Model)
      await Model.update({ _id }, round, { upsert: true }).exec()

      return Model.findById(_id).lean().exec()
    }
  }
}

export async function init () {
  if ((await Model.find().count().exec()) === 0) {
    var defaultRuond = new Model({
      title: 'Default',
      beginTime: new Date(0),
      endTime: new Date(1e14)
    })
    await defaultRuond.save()
  }
}

export {
    typeDef,
    resolvers
}
