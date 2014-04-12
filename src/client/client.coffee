
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

base = 'http://127.0.0.1:8888'
command = argv._.shift()

searchUrl = (q) ->
  "#{base}/search?q=#{encodeURIComponent q.join(' ')}"

get = (url, holla) ->
  request.get {url, json: true}, holla

switch command
  when 'search'
    get searchUrl(argv._), (e, r, files) ->
      throw e if e

      for file, i in files
        console.log "[#{i}] #{file}"

  when 'status'
    get "#{base}/status", (e, r, body) ->
      throw e if e

      if body.nowPlaying?
        console.log '#np', body.nowPlaying
      else
        console.log 'nothing playing'

  when 'add'
    request.post
      url: "#{base}/add"
      json: true
      body:
        i: argv.i
    , (e, r, body) ->
      throw e if e
      console.log 'ADDED', body

  when 'play'
    request.post
      url: "#{base}/play"
      json: true
      body:
        i: argv.i
    , (e, r, body) ->
      throw e if e
      console.log 'PLAYING', body

  when 'pause'
    request.post
      url: "#{base}/pause"
      json: true
    , (e, r, body) ->
      throw e if e
      console.log body

  when 'next'
    request.post
      url: "#{base}/next"
      json: true
    , (e, r, body) ->
      throw e if e
      console.log body

  when 'prev'
    request.post
      url: "#{base}/prev"
      json: true
    , (e, r, body) ->
      throw e if e
      console.log body

  else
    console.log 'whatttt u talkin bout', command
