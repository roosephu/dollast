import { Schema, Types } from 'mongoose'
import { conn } from '../connectors'
import { GraphQLDateTime } from 'graphql-iso-date'
import status from '../status'

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
