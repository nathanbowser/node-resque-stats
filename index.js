var redis = require('redis')
  , db = redis.createClient()
  , fs = require('fs')
  , script = fs.readFileSync(__dirname + '/stats.lua')

// TODO Improve
db.eval(script, 0, function (err, result) {
  var stats = JSON.parse(result)
  console.log(stats)
  process.exit(0)
})
