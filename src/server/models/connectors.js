import { GraphQLUpload } from 'apollo-upload-server'
import { makeExecutableSchema } from 'graphql-tools'
import { merge } from 'lodash'
import { debug } from 'debug'
import Mongoose from 'mongoose'

const log = debug('dollast:connectors')

Mongoose.Promose = global.Promise

export const conn = Mongoose.createConnection('mongodb://localhost/dollast')

const Rounds = require('./Rounds')
const Users = require('./Users')
const Submissions = require('./Submissions')
const Problems = require('./Problems')

// log({ Problems, Rounds, Submissions, Users })

export const Models = {
  Problems: Problems.Model,
  Rounds: Rounds.Model,
  Users: Users.Model,
  Submissions: Submissions.Model
}

Rounds.init()

const schemaDef = `
  scalar Upload

  type Query {
    getObjectID: String
  }

  type Mutation {
    _: String
  }

  schema {
    query: Query
    mutation: Mutation
  }
`

const rootResolvers = {
  Query: {
    getObjectID () {
      return new Mongoose.Types.ObjectId()
    }
  },

  Upload: GraphQLUpload
}

export default makeExecutableSchema({
  typeDefs: [
    schemaDef,
    Problems.typeDef,
    Users.typeDef,
    Submissions.typeDef,
    Rounds.typeDef
  ],
  resolvers: merge(...[
    rootResolvers,
    Problems.resolvers,
    Users.resolvers,
    Submissions.resolvers,
    Rounds.resolvers
  ])
})
