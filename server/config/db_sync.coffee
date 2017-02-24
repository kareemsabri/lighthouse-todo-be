Promise = require 'bluebird'

module.exports = (sequelize) ->

  syncParams =
    force: false

  return sequelize.models.User.sync syncParams
    .then ->
      sequelize.models.List.sync syncParams
    .then ->
      sequelize.models.Todo.sync syncParams