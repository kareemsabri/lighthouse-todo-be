express = require 'express'

mw = require '../../middleware'
lists = require './controller'

{isUser, isAdmin, isMe} = mw.auth

module.exports = ->

  router = express.Router()

  router.route "/"
    .post mw.wrap(lists.create)

  router.route "/:listId"
    .get mw.wrap(lists.read)
    .patch mw.wrap(lists.update)

  router.route "/:listId/todos"
    .post mw.wrap(lists.addTodo)

  router.route "/:listId/todos/:todoId"
    .patch isMe(), mw.wrap(lists.updateTodo)
    .delete isMe(), mw.wrap(lists.deleteTodo)

  return router