debug = require('debug')('yuno:app')

{APIError} = require '../utils'

ErrorResponse = new class ErrorResponse

  send: (err, req, res) =>
    res.format
      "application/json": @json err, req, res
      "text/plain": @plain err, req, res
      "text/html": @html err, req, res
      default: @plain err, req, res

  json: (err, req, res) =>
    res.json
      error: err.message
      stack: err.stack if @dev
      stackArray: err.stack.split "\n" if @dev

  plain: (err, req, res) =>
    message = "#{err.name}: #{err.message}"
    message = err.stack if @dev
    res.setHeader 'Content-Type', 'text/plain'
    res.end message

  html: (err, req, res) =>
    stack = (err.stack or '').split('\n').slice(1)
    stack = stack.map (v) -> "<li>#{v}</li>"
    stack = stack.join ''

    html = """
      <html>
        <head>
          <meta charset='utf-8'>
          <title>{error}</title>
        </head>
        <body>
          <div id="wrapper">
            <h1>Oops. There's been an error</h1>
            <h2><em>{statusCode}</em> {error}</h2>
            <ul id="stacktrace">{stack}</ul>
          </div>
        </body>
      </html>
    """

    html = html
      .replace '{stack}', if @dev then stack else ''
      .replace '{title}', "#{err.name}: #{err.message}"
      .replace '{statusCode}', res.statusCode
      .replace /\{error\}/g, @escapeHTML err.toString().replace /\n/g, '<br/>'

    res.setHeader 'Content-Type', 'text/html; charset=utf-8'
    res.end html

  escapeHTML: (html) ->
    String html
      .replace /&(?!\w+;)/g, '&amp;'
      .replace /</g, '&lt;'
      .replace />/g, '&gt;'
      .replace /"/g, '&quot;'

module.exports = (err, req, res, next) ->
  type = req.headers.accept

  res.statusCode = err.status if err.status
  res.statusCode = 500 if res.statusCode < 400

  if err instanceof APIError
    debug err.stack if res.statusCode >= 500
    return ErrorResponse.json err, req, res
  else if not res._header
    debug err.stack
    return ErrorResponse.send err, req, res
