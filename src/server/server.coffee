
express = require 'express'
setup = require './start/setup'
route = require './start/routes'
config = require '../config'

app = express()

setup app
route app

port = config.port
app.listen port
console.log "App started in #{app.get "env"} mode on port #{port}"
