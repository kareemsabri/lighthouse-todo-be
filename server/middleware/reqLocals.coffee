


module.exports = (app) ->

  return (req, res, next) ->
    req.db = app.locals.sequelize
    next()
