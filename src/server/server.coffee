
express = require 'express'
setup = require './start/setup.coffee'
route = require './start/routes.coffee'

app = express()

setup app
route app

port = process.env.PORT or 8888
app.listen port
console.log "App started in #{app.get "env"} mode on port #{port}"
