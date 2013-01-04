fs = require "fs"

Packit = require "packit"
log = require("logged") __filename
mkdirp = require "mkdirp"
async = require "async"
coffee = require "coffee-script"

module.exports = (app, cb) ->

  eiopath = require("path").dirname(require.resolve("engine.io-client"))

  packages =
    "index.js": [
      "#{eiopath}/engine.io.js"
      app.path "public/jquery.js"
      require.resolve "xo"
      app.path "app/client/index/boot.coffee"
      app.path "app/client/index/socket.coffee"
    ]

  packit = new Packit packages
  packit.use ".coffee", (text, cb) ->
    try
      cb null, coffee.compile text
    catch e
      return cb(e)

  staticDir = "#{__dirname}/../.build"

  mkdirp.sync staticDir

  names = Object.keys packages
  render = (name, cb) ->
    log.debug "packing #{name}"
    packit.get name, (err, text) ->
      return cb err if err?
      path = "#{staticDir}/#{name}"
      log.debug "writing #{path}"
      fs.writeFile path, text, "utf8", cb

  async.map names, render, cb
