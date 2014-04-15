# tunes

```shell
$ npm install -g coffee-script
$ npm install
```

### server

```shell
$ coffee src/server/server.coffee
```

### client

create a list called 'turnt'
```shell
$ coffee src/client/client.coffee list turnt
++ turnt
```

search for mp3's on your computer
```shell
$ coffee src/client/client.coffee search flockaveli
[0] Wacka Flocka Flame - Bustin' at 'Em
[1] Wacka Flocka Flame - Hard in da Paint
...
```

add track to turnt
```shell
$ coffee src/client/client.coffee add -i 1
+ Wacka Flocka Flame - Hard in da Paint
```

play track from turnt
```shell
$ coffee src/client/client.coffee play -i 0
> Wacka Flocka Flame - Hard in da Paint
```

pause it
```shell
$ coffee src/client/client.coffee pause
|| Wacka Flocka Flame - Hard in da Paint
```

make a different list...
```shell
$ coffee src/client/client.coffee list chill
++ chill
```

### config

this'll probably change, but you currently need to make your own `src/config.json`.

```json
{
  "port": 8888,
  "spotifyUsername": "coolguy69",
  "spotifyPassword": "hunter2"
}
```
