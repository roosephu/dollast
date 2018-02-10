import { Schema } from 'mongoose'
import { conn, Models, nextRandomIndex } from './connectors'
import { GraphQLDateTime } from 'graphql-iso-date'
import status from '../status'
import { debug } from 'debug'

const log = debug('dollast:Rounds')

const roundSchema = new Schema({
  index: Number,
  date: { type: Date, default: Date.now },
  title: String,
  beginTime: { type: Date, default: Date.now },
  endTime: { type: Date, default: Date.now },
  problems: [{ type: Schema.Types.ObjectId, ref: 'Problem' }]
})

export const Model = conn.model('Round', roundSchema)

const typeDef = `
  scalar DateTime

  type Round {
    _id: ID!
    index: Int
    title: String
    beginTime: DateTime
    endTime: DateTime
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
      if (!round) {
        return new Error('no such round')
      }

      const submissions = await Models.Submissions.aggregate([{
        $match: {
          round: _id,
          date: {
            $gte: round.beginTime,
            $lte: round.endTime
          }
        }
      }, {
        $sort: {
          problem: 1,
          user: 1,
          date: -1
        }
      }, {
        $group: {
          _id: {
            problem: '$problem',
            user: '$user'
          },
          score: {
            $first: '$summary.score'
          },
          solution: {
            $first: '$id'
          }
        }
      }]).exec()
      log({ submissions })

      return submissions
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

      if (!round.index) round.index = await nextRandomIndex(Model)

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
