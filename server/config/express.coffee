path = require 'path'
express = require 'express'
bodyParser = require 'body-parser'
compression = require 'compression'
cors = require 'cors'

Config = require './index'
{Auth} = require '../services'

module.exports = (app) ->

  app.use cors()
  app.use compression()

  app.use bodyParser.urlencoded extended: true
  app.use bodyParser.json()

  Auth.attachTo app
