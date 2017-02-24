path = require 'path'

ApiRouter = require './router-api-v1'
WebhooksRouter = require './router-webhooks-v1'
{reqLocals, errorHandler} = require '../middleware'

module.exports = (app) ->

  app.get '/', (req, res) ->
    res.sendFile path.join(__dirname, '..', '..', 'docs', 'api.html')

  app.use '/api/v1', reqLocals(app), ApiRouter()
  app.use '/webhooks/v1', reqLocals(app), WebhooksRouter()
  app.use errorHandler
