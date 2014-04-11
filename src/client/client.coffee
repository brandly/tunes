
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

switch command
  when 'search'
    request.get {url: searchUrl(argv._), json: true}, (e, r, files) ->
      for file, i in files
        console.log "[#{i}] #{file}"

  when 'status'
    request.get "#{base}/status", (e, r, body) ->
      console.log 'STATUS', body
  else
    console.log 'whatttt', command
