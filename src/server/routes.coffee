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
    tunes.pause()
    res.send 'paused'

  app.post '/next', (req, res) ->
    tunes.next()
    res.send 'next'

  app.post '/prev', (req, res) ->
    tunes.prev().then ->
      res.send 'prev'

  # could pass index of last search results
  app.post '/add', (req, res) ->
    res.send tunes.add(req.body.i)

  # add files, directories
  # app.post '/import', (req, res) ->

