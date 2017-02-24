Promise = require 'bluebird'
_ = require 'lodash'

{APIError, NoReject} = require '../../utils'

module.exports = new class ListsCtrl

  create: (req, res) ->
    List = req.db.models.List
    List.create req.body

  read: (req, res) ->
    List = req.db.models.List
    options =
      where:
        id: req.params.listId
      include: [{
        model: req.db.models.Todo
        as: 'todos'
      }]
    List.findOne options

  update: (req, res) ->
    List = req.db.models.List
    List.findById req.params.listId
      .then (list) ->
        list.name = req.body.name
        list.save()

  addTodo: (req, res) ->
    Todo = req.db.models.Todo
    req.body.list_id = req.params.listId
    Todo.create req.body

  updateTodo: (req, res) ->
    Todo = req.db.models.Todo
    Todo.findById req.params.todoId
      .then (todo) ->
        todo.name = req.body.name if req.body.name
        todo.completed = req.body.completed
        todo.save()

  deleteTodo: (req, res) ->
    Todo = req.db.models.Todo
    options =
      where:
        id: req.params.todoId
    Todo.destroy options
      .then (status) ->
        if status == 1
          Promise.resolve()
        else
          Promise.reject()
