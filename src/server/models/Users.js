// import { debug } from 'debug'
import { Schema } from 'mongoose'
import { conn, Models } from './connectors'
import config from '../config'
import { compareSync, hashSync } from 'bcrypt'
import sanitizeHtml from 'sanitize-html'

// const log = debug('dollast:models:user')

const schema = new Schema({
  _id: { type: String, required: true, trim: true },
  password: String,
  description: String,
  email: String,
  rating: Number,
  date: { type: Date, default: Date.now }
})

export const Model = conn.model('User', schema)

const typeDef = `
  type User {
    _id: ID!
    email: String
    description: String
    date: DateTime
    rating: Float

    solvedProblems: [Problem]
  }

  extend type Query {
    user(_id: ID!): User
  }

  extend type Mutation {
    updateUser(
      _id: ID!,
      description: String,
      password: String,
      oldPassword: String,
      email: String
    ): User
    login(_id: ID!, password: String!): Boolean
  }
`

const resolvers = {
  User: {
    async solvedProblems ({ _id }) {
      if (!_id) return new Error('_id required')
      const query = Models.Submissions.aggregate([
        { $match: { user: _id, 'summary.score': 1 } },
        { $sort: { problem: 1 } },
        { $group: { _id: '$problem' } }
      ])

      const problemIds = await query.exec()
      return Models.Problems.find({ _id: { $in: problemIds.map(x => x._id) } }).exec()
    }
  },

  Query: {
    async user (root, { _id }) {
      return Model.findById(_id).exec()
    }
  },

  Mutation: {
    async updateUser (root, user, ctx) {
      const { _id } = user
      const doc = await Models.Users.findById(_id).lean().exec()
      if (!doc) { // create
      } else {
        if (doc.password && user.password && !compareSync(doc.password, user.oldPassword)) return new Error('password doesn\'t match')
      }

      if (user.password) user.password = hashSync(user.password, config.bcryptCost)
      if (user.description) user.description = sanitizeHtml(user.description)

      delete user.oldPassword

      await Model.update({ _id }, user, { upsert: true }).exec()
      return Model.findById(_id).exec()
    },

    async login (root, { _id, password }, ctx) {
      const user = await Model.findById(_id).exec()
      // log(ctx)
      // log(user)
      if (!user) return new Error('no such user')
      // if (!compareSync(password, user.password)) {
      if (!compareSync(password, user.password)) return new Error('wrong password')
      ctx.session.user = _id
      return true

      // const groups = ['Users']

      // const serverKey = config.serverAESKey
      // const serverPayload = JSON.stringify({
      //   _id,
      //   groups
      // })
      // const clientPayload = JSON.stringify({
      //   user: _id
      // })

      // const payload = {
      //   server: serverPayload,
      //   client: clientPayload
      // }

      // const token = sign(payload, config.jwtKey, { expiresIn: 60 * 60 * 24 })
      // const refresh = sign(payload, config.serverAESKey, { expiresIn: 60 * 60 * 24 * 30 })

      // return {
      //   token, refresh
      // }
    }
  }
}

export {
  typeDef,
  resolvers
}
