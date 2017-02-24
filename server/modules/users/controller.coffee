_ = require 'lodash'

UserSvc = require './service'
{APIError, NoReject} = require '../../utils'

module.exports = new class UsersCtrl

  list: (req, res) ->
    User = req.db.models.User
    User.findAll()

  register: (req, res) ->
    service = new UserSvc req
    service.validateEmailRegistration req.body
      .then (values) ->
        service.createEmailUser values

  login: (req, res) ->
    service = new UserSvc req
    email = req.body.email
    password = req.body.password
    service.performEmailLogin email, password

  getLists: (req, res) ->
    List = req.db.models.List
    options =
      where:
        user_id: req.params.userId
      include: [{
        model: req.db.models.Todo
        as: 'todos'
      }]
    List.findAll options