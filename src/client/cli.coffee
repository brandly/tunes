# tunes status
# tunes play -i 3
# tunes pause
# tunes next
# tunes prev
# tunes add -i
request = require 'request'
argv = require('minimist') process.argv.slice(2)
config = require '../config'

base = 'http://127.0.0.1:' + config.port
command = argv._.shift()

searchUrl = (q) ->
  "/search?q=#{encodeURIComponent q.join(' ')}"

get = (url, holla) ->
  request.get {url: "#{base}#{url}", json: true}, holla

post = (url, body, holla) ->
  options =
    url: "#{base}#{url}"
    json: true

  if typeof holla is 'function'
    options.body = body
  else
    holla = body

  request.post options, holla

display = (pre, track) ->
  console.log "#{pre} #{track.artist} - #{track.title}"

list = (files) ->
  for file, i in files
    display "[#{i}]", file

switch command
  when 'search'
    get searchUrl(argv._), (e, r, files) ->
      throw e if e
      list files

  when 'status'
    get '/status', (e, r, body) ->
      throw e if e

      if body.nowPlaying?
        display '#np', body.nowPlaying
      else
        console.log 'nothing playing'

  when 'add'
    post '/add', {i: argv.i}, (e, r, track) ->
      throw e if e
      display '+', track

  when 'remove'
    post '/remove', {i: argv.i}, (e, r, track) ->
      throw e if e
      display '-', track

  when 'play'
    post '/play', {i: argv.i}, (e, r, track) ->
      throw e if e
      display '>', track

  when 'pause'
    post '/pause', (e, r, track) ->
      throw e if e
      display '||', track

  when 'next'
    post '/next', (e, r, track) ->
      throw e if e
      display '>>', track

  when 'prev'
    post '/prev', (e, r, track) ->
      throw e if e
      display '<<', track

  when 'list'
    name = argv._.shift()
    if name?
      post '/list', {name}, (e, r, files) ->
        throw e if e
        console.log '++', name
        list files
    else if argv.a
      get '/list/names', (e, r, names) ->
        throw e if e
        console.log name for name in names
    else
      get '/list', (e, r, files) ->
        throw e if e
        list files

  when 'artists'
    get '/artists', (e, r, artists) ->
      throw e if e

      console.log artist for artist in artists

  when 'albums'
    get '/albums', (e, r, albums) ->
      throw e if e

      console.log album for album in albums

  else
    console.log 'whatttt u talkin bout', command
