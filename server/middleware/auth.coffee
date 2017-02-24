
_ = require 'lodash'
compose = require 'composable-middleware'

{Auth} = require '../services'
{APIError} = require '../utils'

module.exports = new class AuthMiddleware

  isSuperAdmin: Auth.authSuperAdmin

  isLoggedIn: Auth.requireAuth

  isUser: =>
    return compose()
      .use @isLoggedIn()
      .use (req, res, next) ->
        if not req.user.userId
          return next new APIError.Unauthorized 'must be logged in user'
        else
          return next()

  isAdmin: =>
    return compose()
      .use @isLoggedIn()
      .use (req, res, next) ->
        if not req.user.adminId
          return next new APIError.Unauthorized 'must be logged in admin'
        else
          return next()
          
  isMe: =>
    return compose()
      .use @isLoggedIn()
      .use (req, res, next) ->
        if req.user.userId != parseInt(req.params.userId)
          return next new APIError.Unauthorized 'you cannot perform this action'
        else
          return next()