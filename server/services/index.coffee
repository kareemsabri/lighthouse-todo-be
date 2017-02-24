
requireDirectory = require 'require-directory'
_ = require 'lodash'

options =
  recurse: false
  rename: (name) -> _.upperFirst name

module.exports = requireDirectory module, options
