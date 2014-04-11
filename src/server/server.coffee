
express = require 'express'
setup = require './setup.coffee'
route = require './routes.coffee'

app = express()

setup app
route app

port = process.env.PORT or 8888
app.listen port
console.log "App started in #{app.get "env"} mode on port #{port}"
