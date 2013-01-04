http = require "http"

logged = require "logged"
logged.on "log", (e) ->
  console.log e.message

log = require("logged")(__filename)

log.debug "loading app"
app = require "#{__dirname}"
server = http.createServer app

log.debug "loading socket serve"
sockets = require "#{__dirname}/sockets"
sockets(server)

build = require app.path("app/build")
build app, (err) ->
  throw err if err?
  server.listen app.get("port"), ->
    log.info "listening on #{app.get('port')}"
