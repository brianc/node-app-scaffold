omf = require "omf"
app = require "#{__dirname}/../app"
eio = require "engine.io-client"
sockets = require "#{__dirname}/../app/sockets"

logger = require("logged")
logger.on "log", (msg) ->
  #console.log msg.message

omf app, (app) ->
  app.get "/", (res) ->
    res.has.statusCode 200
    res.is.html()

  describe "engine.io", ->
    sockets(app.server)
    url = "ws://localhost:#{app.port}"

    before (done) ->
      @socket = eio url
      @socket.on "open", done

    it "gets initial data", (done) ->
      @socket.on "message", (msg) ->
        done()
