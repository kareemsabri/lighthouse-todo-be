express = require 'express'

mw = require '../../middleware'
users = require './controller'

{isUser, isAdmin, isMe} = mw.auth

module.exports = ->

  router = express.Router()

  router.route "/"
    .get mw.wrap(users.list)
    .post mw.wrap(users.register)

  router.route "/tokens"
    .post mw.wrap(users.login)

  router.route "/:userId"
    .get isUser(), mw.wrap(users.getUser)
    .patch isMe(), mw.wrap(users.updateUser)

  router.route "/:userId/lists"
    .get mw.wrap(users.getLists)

  return router