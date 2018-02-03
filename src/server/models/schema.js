import { typeDef as problemTypeDef, resolvers as problemResolvers } from './Problems'
import { typeDef as roundTypeDef, resolvers as roundResolvers } from './Rounds'
import { typeDef as userTypeDef, resolvers as userResolvers } from './Users'
import { typeDef as submissionTypeDef, resolvers as submissionResolvers } from './Submissions'
import { GraphQLUpload } from 'apollo-upload-server'
import { makeExecutableSchema } from 'graphql-tools'
import { merge } from 'lodash'
import { Types } from 'mongoose'
import { debug } from 'debug'

const log = debug('dollast:core:schema')

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
      return new Types.ObjectId()
    }
  }
}

export default makeExecutableSchema({
  typeDefs: [
    schemaDef,
    problemTypeDef,
    userTypeDef,
    submissionTypeDef,
    roundTypeDef
  ],
  resolvers: merge(...[
    rootResolvers,
    problemResolvers,
    userResolvers,
    submissionResolvers,
    roundResolvers,
    { Upload: GraphQLUpload }
  ])
})
