
crypto = require 'crypto'

module.exports = new class PasswordService

  encrypt: (password, salt) ->
    if not salt
      salt = crypto.randomBytes(16).toString 'base64'

    saltBuf = new Buffer salt, 'base64'
    hash = crypto.pbkdf2Sync(password, saltBuf, 10000, 64).toString 'base64'

    salt: salt
    hash: hash
