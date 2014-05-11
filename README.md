# tunes

```shell
$ npm install -g gulp
$ npm install
```

this'll probably change, but you currently need to make your own `src/config.json`.
```json
{
  "port": 8888,
  "spotifyUsername": "coolguy69",
  "spotifyPassword": "hunter2"
}
```

some modules need to be rebuilt to work with node-webkit i guess.
```shell
$ gulp rebuild:modules
```

then, go into `node_modules/spotify-web/node_modules/protobufjs/ProtoBuf.js`, and find the line that sets `Util.IS_NODE`. replace the comparison with `Util.IS_NODE = true`.

there's a bug in `nodewebkit` that'll hopefully be fixed soon, go into the local instance of `nodewebkit` and rename `package.json` to something else.

```
$ cd node_modules/nodewebkit/
$ mv package.json _package.json
$ cd ../../
```

build the app
```shell
$ gulp
```

and run it
```shell
$ npm start
```
