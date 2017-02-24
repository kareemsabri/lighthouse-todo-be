express = require 'express'

module.exports = ->

  router = express.Router()

  router.use '/users', require('../modules/users/router')()
  router.use '/lists', require('../modules/lists/router')()

  return router
