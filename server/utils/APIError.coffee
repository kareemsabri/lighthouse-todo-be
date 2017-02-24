HTTPStatus = require './HTTPStatus'

class APIError extends Error
  constructor: (@status, @message) ->
    @name = 'APIError'
    @stack = (new Error()).stack

Object.keys(HTTPStatus).map (method) ->
  return unless 400 <= HTTPStatus[method] < 600

  APIError[method] = class extends APIError
    constructor: (message) ->
      super HTTPStatus[method], message

module.exports = APIError
