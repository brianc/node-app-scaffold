express = require "express"

build = require "#{__dirname}/build"

app = express()
app.get "/engine.io/*", ->
  #no-op - this is handled in socket server

app.configure ->
  app.path = (part) -> "#{__dirname}/../#{part}"
  app.set("port", app.get("port") || process.argv[2] || 3000)
  app.engine "jade", require("jade").__express


app.configure "development", ->
  app.use (req, res, next) ->
    build app, next
  
app.use(express.static(app.path "/.build"))

app.get "/", (req, res, next) ->
  app.render "index.jade", (err, html) ->
    return next err if err?
    res.send html

module.exports = app
