path = require 'path'


env = process.env.NODE_ENV
live = process.env.NODE_ENV is 'production'
protocol = process.env.PROTOCOL or 'http'
hostname = process.env.HOSTNAME or 'localhost'
port = process.env.PORT or 3020

dbUrl = process.env.DATABASE_URL

baseUrl = do ->
  if live
    return "#{protocol}://#{hostname}"
  else
    return "#{protocol}://#{hostname}:#{port}"

servePath = path.join __dirname, '..', '..', 'public'

basicAuth =
  username: process.env.BASIC_AUTH_USER
  password: process.env.BASIC_AUTH_PASS

jwt =
  secret: process.env.JWT_SECRET or 'opentablepoi'
  issuer: process.env.JWT_ISSUER or hostname
  audience: process.env.JWT_AUDIENCE or "#{hostname}/users"

password =
  salt: process.env.PASSWORD_SALT

module.exports = {
  baseUrl
  basicAuth
  dbUrl
  env
  hostname
  jwt
  live
  password
  port
  protocol
  servePath
}
