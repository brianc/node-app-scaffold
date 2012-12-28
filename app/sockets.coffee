#takes in an instance of an http server
engine = require "engine.io"
log = require("logged")(__filename)

sockets = new engine.Server

sockets.on "connection", (socket) ->
  log.debug "new socket connection", id: socket.id
  socket.send "hi"

attach = (httpServer) ->
  log.debug "attaching socket server to http server"

  httpServer.on "upgrade", (req, socket, head) ->
    sockets.handleUpgrade req, socket, head

  httpServer.on "request", (req, res) ->
    if req.url.indexOf("/engine.io") is 0
      log.debug "handling socket request"
      sockets.handleRequest req, res

module.exports = attach
