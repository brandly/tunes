
express = require 'express'
setup = require './start/setup.coffee'
route = require './start/routes.coffee'
config = require '../config'

app = express()

setup app
route app

port = config.port
app.listen port
console.log "App started in #{app.get "env"} mode on port #{port}"
