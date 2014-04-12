# tunes

```shell
$ npm install
```

### server

```shell
$ coffee src/server/server.coffee
```

### client

```shell
# create a list called 'turnt'
$ coffee src/client/client.coffee list turnt
> ++ turnt

# search for mp3's on your computer
$ coffee src/client/client.coffee search flockaveli
> [0] Wacka Flocka Flame - Bustin' at 'Em
> [1] Wacka Flocka Flame - Hard in da Paint
> ...

# add track to turnt
$ coffee src/client/client.coffee add -i 1
> + Wacka Flocka Flame - Hard in da Paint

# play track from turnt
$ coffee src/client/client.coffee play -i 0
> > Wacka Flocka Flame - Hard in da Paint

# pause it
$ coffee src/client/client.coffee pause
> || Wacka Flocka Flame - Hard in da Paint

# make a different list...
$ coffee src/client/client.coffee list chill
> ++ chill
```
