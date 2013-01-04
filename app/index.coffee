log = require("logged") __filename
express = require "express"

build = require "#{__dirname}/build"

app = express()
app.use express.favicon()
app.use express.cookieParser('lkasjdlfkajsdf')

app.get "/engine.io/*", ->
  #no-op - this is handled in socket server

app.configure ->
  app.path = (part) -> "#{__dirname}/../#{part}"
  app.set("port", app.get("port") || process.argv[2] || 3000)
  app.engine "jade", require("jade").__express
  app.use(express.static(app.path "/.build"))
  app.use (req, res, next) ->
    log.warn "not found: #{req.method} #{req.url}"
    next()

app.configure "development", ->
  #build on non-static route match
  app.all "*", (req, res, next) ->
    build app, next

app.get "/", (req, res, next) ->
  log.debug "rendering index.jade"
  app.render "index.jade", (err, html) ->
    return next err if err?
    res.send html

module.exports = app
