import { Schema } from 'mongoose'
import { conn, Models } from './connectors'
import { GraphQLDateTime } from 'graphql-iso-date'
import status from '../status'
import { debug } from 'debug'
import { AssertionError } from 'assert'

const log = debug('dollast:Rounds')

const roundSchema = new Schema({
  date: { type: Date, default: Date.now },
  title: String,
  beginTime: { type: Date, default: Date.now },
  endTime: { type: Date, default: Date.now },
  problems: [{ type: Schema.Types.ObjectId, ref: 'Problem' }]
})

export const Model = conn.model('Round', roundSchema)

const typeDef = `
  scalar Date

  type Round {
    _id: String
    title: String
    beginTime: Date
    endTime: Date
    board: [Submission]
  }

  extend type Query {
    rounds: [Round]
    round(_id: String): Round
    defaultRoundId: String
  }

  extend type Mutation {
    updateRound(
      _id: String!
      title: String
      beginTime: Date
      endTime: Date
    ): Round
  }
`

const resolvers = {
  Round: {
    async board (r) {
      const round = await Model.findById(r._id).exec()
      if (!round) {
        throw new AssertionError('fals')
      }

      const submissions = await Models.Submissions.aggregate([{
        $match: {
          round: r._id,
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

  Date: GraphQLDateTime,

  Query: {
    async rounds () {
      return Model.find().exec()
    },

    async round (root, {_id}) {
      return Model.findById(_id).exec()
    },

    defaultRoundId () {
      return status.defaultRoundId
    }
  },

  Mutation: {
    async updateRound (root, args) {
      const { _id } = args
      await Model.update({ _id }, args, { upsert: true }).exec()
      return Model.findById(_id).exec()
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
