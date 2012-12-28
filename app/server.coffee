http = require "http"

logged = require "logged"
logged.on "log", (e) ->
  console.log e.message

log = require("logged")(__filename)

log.debug "requiring app"

app = require "#{__dirname}"
sockets = require "#{__dirname}/sockets"

server = http.createServer app
sockets(server)

server.listen app.get("port"), ->
  log.info "listening on #{app.get('port')}"
