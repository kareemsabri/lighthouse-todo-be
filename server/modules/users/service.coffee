_ = require 'lodash'
request = require 'request-promise'
Promise = require 'bluebird'

{APIError} = require '../../utils'

Config = require '../../config'

{Auth, Password} = require '../../services'

module.exports = class UsersAPIService

  constructor: (@req) ->

  validateEmailRegistration: (values) =>
    if not values.email or not values.password
      throw new APIError.BadRequest 'email and password required'

    query =
      where:
        email: values.email.trim()

    User = @req.db.models.User
    User.findOne query
      .then (user) ->
        if user
          throw new APIError.Conflict 'email is already registered'
        else
          return values

  createEmailUser: (values) =>
    password = Password.encrypt values.password, Config.password.salt
    values.password_hash = password.hash
    values.email = values.email.trim()
    delete values.password

    User = @req.db.models.User
    User.create values

  performEmailLogin: (email, password) =>
    query =
      where:
        email: email

    User = @req.db.models.User
    User.findOne query
      .then (user) ->
        if not user then throw new APIError.Unauthorized 'login incorrect'
        password = Password.encrypt password, Config.password.salt
        if password.hash isnt user.password_hash
          throw new APIError.Unauthorized 'login incorrect'
        return user
