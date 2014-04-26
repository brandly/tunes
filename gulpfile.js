var
gulp = require('gulp'),
coffee = require('gulp-coffee'),
concat = require('gulp-concat');

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

gulp.task('build', ['copy:config', 'scripts'], function () {
  console.log('hell0');
});

gulp.task('default', ['build'], function () {
  gulp.watch(['src/**'], ['build']);
});
