sequelize = require 'sequelize'
_ = require 'lodash'

module.exports = (sequelize, DataTypes) ->

  schema =
    id:
      type: DataTypes.INTEGER
      autoIncrement: true
      primaryKey: true
    name:
      type: DataTypes.STRING
      allowNull: false
    completed:
      type: DataTypes.BOOLEAN
      allowNull: false
      defaultValue: false

  options =
    tableName: "todos"
    underscored: true

  Todo = sequelize.define 'Todo', schema, options
