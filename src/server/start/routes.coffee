tunes = require '../tunes/tunes.coffee'

module.exports = (app) ->
  app.get '/search', (req, res) ->
    tunes.search(req.query.q).then (results) ->
      res.send results
    , (e) ->
      res.send e

  app.get '/status', (req, res) ->
    res.send tunes.status()

  app.post '/play', (req, res) ->
    if req.body.i?
      tunes.playByIndex(req.body.i).then (file) ->
        res.send file
    else
      res.send tunes.resume()

  app.post '/pause', (req, res) ->
    res.send tunes.pause()

  app.post '/next', (req, res) ->
    tunes.next().then (file) ->
      res.send file

  app.post '/prev', (req, res) ->
    tunes.prev().then (file) ->
      res.send file

  app.post '/add', (req, res) ->
    tunes.add(req.body.i).then (track) ->
      res.send track

  app.post '/remove', (req, res) ->
    tunes.remove(req.body.i).then (track) ->
      res.send track

  app.get '/list', (req, res) ->
    tunes.getList().then (list) ->
      res.send list

  app.post '/list', (req, res) ->
    tunes.list(req.body.name).then (list) ->
      res.send list

  app.get '/artists', (req, res) ->
    tunes.artists().then (artists) ->
      res.send artists

  # add files, directories
  # app.post '/import', (req, res) ->

