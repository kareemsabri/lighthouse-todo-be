'use strict';

if (process.env.NODE_ENV === 'development') {
  require('dotenv').load();
}

const _ = require('lodash');
const url = require('url');

try {
  const dbUrl = url.parse(process.env.DATABASE_URL);

  const CREDENTIALS = dbUrl.auth ? dbUrl.auth.split(':') : [null, null];
  const DATABASE = dbUrl.pathname.substr(1);
  const HOST = dbUrl.host.split(':').shift();
  const ENGINE = dbUrl.protocol.replace(':', '');

  let config = {
    username:       CREDENTIALS.shift(),
    password:       CREDENTIALS.shift(),
    database:       DATABASE,
    host:           HOST,
    dialect:        ENGINE,
  };

  if(process.env.DATABASE_SSL === 'true') {
    config = _.extend(config, {
      ssl:            true,
      dialectOptions: {
        ssl: true
      }
    });
  }

  module.exports = config;

} catch(e) {
  throw new Error('Failed to parse database credentials from env ' + e);
}
