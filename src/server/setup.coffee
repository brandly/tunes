bodyParser = require 'body-parser'

module.exports = (app) ->
  # app.use express.logger('dev')
  app.use bodyParser()
