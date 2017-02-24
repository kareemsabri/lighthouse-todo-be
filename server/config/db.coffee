fs = require 'fs'
path = require 'path'
pg = require('pg')
Sequelize = require 'sequelize'
urlParse = require 'parse-database-url'

Config = require './index'

module.exports = (app) ->
  #https://github.com/sequelize/sequelize/issues/2383
  pg.defaults.parseInt8 = true
  conn = urlParse Config.dbUrl

  sequelize = new Sequelize conn.database, conn.user, conn.password,
    dialect: conn.driver
    host: conn.host
    port: conn.port
    ssl: true
    timezone: '+00:00'
    logging: undefined
    native: true

  modelsDir = path.join __dirname, "..", "models"
  modelFiles = fs.readdirSync(modelsDir).map (modelFile) ->
    name: path.basename modelFile, path.extname(modelFile)
    fileName: path.basename modelFile
    fullPath: path.join modelsDir, modelFile

  modelFiles.forEach (modelFile) ->
    if /^[A-Z]/.test modelFile.fileName
      sequelize.import modelFile.fullPath

  require("./db_associations") sequelize
  require("./db_sync") sequelize

  app.locals.sequelize = sequelize
