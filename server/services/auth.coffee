express = require 'express'
passport = require 'passport'
ensureLogin = require 'connect-ensure-login'
jwt = require 'jsonwebtoken'
_ = require 'lodash'
Promise = require 'bluebird'
ExtractJwt = require('passport-jwt').ExtractJwt
BasicStrategy = require('passport-http').BasicStrategy

Config = require '../config'
JwtStrategy = require '../utils/jwt-strategy'

module.exports = new class JWTAuth

  getJWTReadParams: ->
    jwtFromRequest: ExtractJwt.fromAuthHeader()
    secretOrKey: Config.jwt.secret
    issuer: Config.jwt.issuer
    audience: Config.jwt.audience
    algorithms: ['HS256']

  getJWTWriteParams: ->
    issuer: Config.jwt.issuer
    audience: Config.jwt.audience
    algorithm: 'HS256'

  generateToken: (payload) =>
    new Promise (resolve, reject) =>
      jwt.sign payload, Config.jwt.secret, @getJWTWriteParams(), (err, token) ->
        resolve token

  attachTo: (app) =>

    passport.use 'jwt', new JwtStrategy @getJWTReadParams(), (payload, cb) ->
      User = app.locals.sequelize.models.User

      query =
        where:
          id: payload.userId

      User.findOne(query)
        .then (result) ->
          if (result)
            cb null, _.extend({}, payload, { data: result.toJSON() })
          else
            cb null, null
        .catch (err) ->
          cb err

    passport.use 'super-admin', new BasicStrategy (userId, password, done) ->
      if userId isnt Config.basicAuth.username or password isnt Config.basicAuth.password
        return done null, false
      else
        return done null, isSuperAdmin: true

    passport.serializeUser (jwtPayload, cb) ->
      cb null, id: jwtPayload.userId

    passport.deserializeUser (id, cb) ->
      cb null,
        id: id

    app.use passport.initialize()
    app.use passport.authenticate 'jwt', session: false

  authSuperAdmin: ->
    passport.authenticate 'super-admin', session: false

  requireAuth: ->
    return (req, res, next) ->
      if not req.isAuthenticated or not req.isAuthenticated()
        res.status(401).end()
      else
        next()
