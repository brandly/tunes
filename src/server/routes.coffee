tunes = require './tunes.coffee'

module.exports = (app) ->
  app.get '/search', (req, res) ->
    console.log 'SEARCHING', req.query
    tunes.search(req.query.q).then (results) ->
      console.log 'SENDING RESULTS'
      res.send results
    , (e) ->
      console.log 'SENDING ERROR'
      res.send e

  app.get '/status', (req, res) ->
    tunes.status().then (status) ->
      res.send status

  app.post '/play', (req, res) ->
    res.send tunes.play(req.query.i)

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
  # app.post '/add', (req, res) ->

  # add files, directories
  # app.post '/import', (req, res) ->

