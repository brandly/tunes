# music sources

## search

make a file called `search.coffee`, and export a single method
```coffee
exports.search = (query, count) ->
```

this method should return a promise. that promise should resolve with an array. that array should hold tracks in the form:

```coffee
track =
  title: 'Two Doves'
  artist: 'Dirty Projectors'
  album: 'Bitte Orca'
  file: 'spotify:track:5ncCNLYgisW876X9dOetyK'
```

`file` is whatever allows the source to go fetch and play that track.

## track

make a file called `track.coffee`, and exports a single method
```coffee
exports.track = (file) ->
```

this method should return a promise. that promise should resolve with a track in the form:

```coffee
track =
  title: 'Two Doves'
  artist: 'Dirty Projectors'
  album: 'Bitte Orca'
  file: 'spotify:track:5ncCNLYgisW876X9dOetyK'
  stream: ->
```

where `stream` is a function that returns a stream that can then be decoded and played.
