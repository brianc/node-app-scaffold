socket = eio("ws://localhost:3000")

socket.on "open", ->
  console.log "socket opened"
  socket.on "message", (msg) ->
    console.log "message '%s'", msg
  socket.on "close", ->
    console.log "socket closed"
