
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
  "#{base}/search?q=#{encodeURIComponent q.join(' ')}"

get = (url, holla) ->
  request.get {url, json: true}, holla

display = (pre, file) ->
  id3 {file: file, type: id3.OPEN_LOCAL}, (err, tags) ->
    throw err if err
    console.log "#{pre} #{tags.v2.artist} - #{tags.v2.title}"

switch command
  when 'search'
    get searchUrl(argv._), (e, r, files) ->
      throw e if e

      for file, i in files
        display "[#{i}]", file

  when 'status'
    get "#{base}/status", (e, r, body) ->
      throw e if e

      if body.nowPlaying?
        display '#np', body.nowPlaying
      else
        console.log 'nothing playing'

  when 'add'
    request.post
      url: "#{base}/add"
      json: true
      body:
        i: argv.i
    , (e, r, file) ->
      throw e if e
      display '+', file

  when 'play'
    request.post
      url: "#{base}/play"
      json: true
      body:
        i: argv.i
    , (e, r, file) ->
      throw e if e
      display '>', file

  when 'pause'
    request.post
      url: "#{base}/pause"
      json: true
    , (e, r, file) ->
      throw e if e
      display '||', file

  when 'next'
    request.post
      url: "#{base}/next"
      json: true
    , (e, r, file) ->
      throw e if e
      display '>>', file

  when 'prev'
    request.post
      url: "#{base}/prev"
      json: true
    , (e, r, file) ->
      throw e if e
      display '<<', file

  else
    console.log 'whatttt u talkin bout', command
