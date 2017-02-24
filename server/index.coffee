debug = require('debug')('todo:app')
express = require 'express'

Config = require './config'

module.exports = class App

  start: =>
    @app = express()
    require("./config/init") @app

    baseUrl = Config.baseUrl
    port = Config.port
    env = Config.env
    
    @app.listen port, ->
      debug "Server listening on #{baseUrl}; env=#{env}"
