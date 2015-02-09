var redis = require('redis')
  , fs = require('fs')
  , script = fs.readFileSync(__dirname + '/stats.lua')
  , defaults = {
    namespace: 'resque',
    host: '127.0.0.1',
    password: '',
    port: 6379,
    database: 0
  }

module.exports = function (opts, next) {
  if (!next) {
    next = opts
    opts = undefined
  }

  var options = opts || {}
    , db = null

  for (var i in defaults) {
    if (options[i] == null) {
      options[i] = defaults[i]
    }
  }

  if (!options.client) {
    db = redis.createClient(options.port, options.host, options.options)
    if (options.password) {
      try {
        db.auth(options.password)
      } catch (e) {}
    }
  } else {
    db = options.client
  }

  db.eval(script, 0, options.namespace + ':', function (err, result) {
    if (err) {
      return next(err)
    }
    try {
      var stats = JSON.parse(result)
      return next(null, stats)
    } catch (e) {
      return next(e)
    }
  })
}
