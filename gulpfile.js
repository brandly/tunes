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

gulp.task('coffee:app', function () {
  return gulp.src('src/app/scripts/**/*.coffee')
    .pipe(coffee())
    .pipe(concat('app.js'))
    .pipe(gulp.dest('build/'));
});

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
