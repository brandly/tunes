
# parse inputs with like minimist or something
# make requests to some local endpoints

# tunes status
# tunes play -i 3
# tunes pause
# tunes next
# tunes prev
# tunes add -i
request = require 'request'
argv = require('minimist') process.argv.slice(2)
id3 = require 'id3js'

base = 'http://127.0.0.1:8888'
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

display = (pre, file) ->
  id3 {file: file, type: id3.OPEN_LOCAL}, (err, tags) ->
    throw err if err
    console.log "#{pre} #{tags.v2.artist} - #{tags.v2.title}"

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
    post '/add', {i: argv.i}, (e, r, file) ->
      throw e if e
      display '+', file

  when 'play'
    post '/play', {i: argv.i}, (e, r, file) ->
      throw e if e
      display '>', file

  when 'pause'
    post '/pause', (e, r, file) ->
      throw e if e
      display '||', file

  when 'next'
    post '/next', (e, r, file) ->
      throw e if e
      display '>>', file

  when 'prev'
    post '/prev', (e, r, file) ->
      throw e if e
      display '<<', file

  when 'list'
    name = argv._.shift()
    if name?
      post '/list', {name}, (e, r, body) ->
        throw e if e
        console.log '++', name
    else
      get '/list', (e, r, files) ->
        throw e if e
        list files

  else
    console.log 'whatttt u talkin bout', command
