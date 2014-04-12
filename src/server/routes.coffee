tunes = require './tunes.coffee'

module.exports = (app) ->
  app.get '/search', (req, res) ->
    tunes.search(req.query.q).then (results) ->
      res.send results
    , (e) ->
      res.send e

  app.get '/status', (req, res) ->
    res.send tunes.status()

  app.post '/play', (req, res) ->
    res.send tunes.play(req.body.i)

  app.post '/pause', (req, res) ->
    res.send tunes.pause()

  app.post '/next', (req, res) ->
    res.send tunes.next()

  app.post '/prev', (req, res) ->
    res.send tunes.prev()

  # could pass index of last search results
  app.post '/add', (req, res) ->
    res.send tunes.add(req.body.i)

  app.get '/list', (req, res) ->
    res.send tunes.getList()

  app.post '/list', (req, res) ->
    res.send tunes.list(req.body.name)

  # add files, directories
  # app.post '/import', (req, res) ->

