JwtStrategy = require('passport-jwt').Strategy

module.exports = class JWTStrategy extends JwtStrategy

  authenticate: (req, options) ->

    self = this
    token = self._jwtFromRequest req

    if not token
      return self.pass()

    JwtStrategy.JwtVerifier token, self._secretOrKey, self._verifOpts, (jwt_err, payload) ->
      if jwt_err
        return self.fail jwt_err
      else
        verified = (err, user, info) ->
          if err
            return self.error err
          else if not user
            return self.fail info
          else
            property = req._passport.instance._userProperty or 'user'
            req[property] = user
            return self.success user, info

        try
          if self._passReqToCallback
            self._verify req, payload, verified
          else
            self._verify payload, verified
        catch ex
          self.error ex
