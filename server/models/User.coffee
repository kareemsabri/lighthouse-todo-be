sequelize = require 'sequelize'
_ = require 'lodash'

module.exports = (sequelize, DataTypes) ->

  schema =
    id:
      type: DataTypes.INTEGER
      autoIncrement: true
      primaryKey: true
    first_name:
      type: DataTypes.STRING
      allowNull: true
    last_name:
      type: DataTypes.STRING
      allowNull: true
    email:
      type: DataTypes.STRING
      allowNull: false
      validate:
        isEmail: true
    password_hash:
      type: DataTypes.STRING
      allowNull: true
    profile_image_url:
      type: DataTypes.STRING(2056)
      allowNull: true
      validate:
        isUrl: true
      
  options =
    tableName: "users"
    underscored: true
    instanceMethods:
      toJSON: (token) ->
        json = _.omit this.get(), ['password_hash']
        json.token = token if token
        return json

  User = sequelize.define 'User', schema, options
