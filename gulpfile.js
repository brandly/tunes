var
gulp = require('gulp'),
config = require('./package'),
coffee = require('gulp-coffee'),
es = require('event-stream'),
concat = require('gulp-concat'),
shell = require('gulp-shell'),
uglify = require('gulp-uglify');

gulp.task('coffee:tunes', function () {
  return gulp.src('src/tunes/**/*.coffee')
    .pipe(coffee())
    .pipe(gulp.dest('build/tunes/'));
});

// combine js libs with coffee src
function createScriptsTask (scripts) {
  return function () {
    var
    libs = gulp.src(scripts.js),

    compiled = gulp.src(scripts.coffee)
                   .pipe(concat('null'))
                   .pipe(coffee({ join: true }));

    return es.merge(libs, compiled)
             .pipe(concat(scripts.dest))
             .pipe(uglify())
             .pipe(gulp.dest('build/'));
  }
}

gulp.task('coffee:app', createScriptsTask({
  js: [
    'bower_components/angular/angular.js',
    'bower_components/lodash/dist/lodash.js',
    'src/app/scripts/lib/*.js'
  ],
  coffee: 'src/app/scripts/**/*.coffee',
  dest: 'app.js'
}))

gulp.task('scripts', ['coffee:tunes', 'coffee:app']);

gulp.task('copy:config', function () {
  return gulp.src('src/config.json')
    .pipe(gulp.dest('build/'));
});

gulp.task('copy:index', function () {
  return gulp.src('src/app/index.html')
    .pipe(gulp.dest('build/'));
});

var
modulesNeedRebuilding = [
  'mmmagic',
  'lame',
  'speaker'
],
targetNodewebkitVersion = config.dependencies.nodewebkit.match(/\d+\.\d+\.\d+/),
rebuildCommand = 'nw-gyp rebuild --target=' + targetNodewebkitVersion;

function rebuildTaskName(module) {
  return 'rebuid:' + module;
}

modulesNeedRebuilding.forEach(function (module) {
  gulp.task(rebuildTaskName(module), shell.task([
    'cd node_modules/' + module + ' && ' + rebuildCommand
  ]));
});

var rebuildSubtasks = modulesNeedRebuilding.map(rebuildTaskName);

gulp.task('rebuild:modules', rebuildSubtasks);

gulp.task('build', ['copy:config', 'copy:index', 'scripts']);

gulp.task('default', ['build'], function () {
  gulp.watch(['src/**'], ['build']);
});
