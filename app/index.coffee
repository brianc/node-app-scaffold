express = require "express"

app = express()

app.configure ->
  app.set("port", app.get("port") || process.argv[2] || 3000)

app.get "/", (req, res) ->
  res.send "hello world"

app.get "/engine.io/*", ->
  #no-op - this is handled in socket server

module.exports = app
