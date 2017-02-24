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

  options =
    tableName: "lists"
    underscored: true

  List = sequelize.define 'List', schema, options
