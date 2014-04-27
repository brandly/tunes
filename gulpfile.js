var
gulp = require('gulp'),
config = require('./package'),
coffee = require('gulp-coffee'),
concat = require('gulp-concat'),
shell = require('gulp-shell');

gulp.task('coffee:tunes', function () {
  return gulp.src('src/tunes/**/*.coffee')
    .pipe(coffee())
    .pipe(gulp.dest('build/tunes/'));
});

gulp.task('coffee:server', function () {
  return gulp.src('src/server/**/*.coffee')
    .pipe(coffee())
    .pipe(gulp.dest('build/server/'));
});

gulp.task('scripts', ['coffee:tunes', 'coffee:server']);

gulp.task('copy:config', function () {
  return gulp.src('src/config.json')
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

gulp.task('build', ['copy:config', 'scripts']);

gulp.task('default', ['build'], function () {
  gulp.watch(['src/**'], ['build']);
});
