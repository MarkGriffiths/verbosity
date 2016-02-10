###
Client Gulp File
###

gulp = require 'gulp'
cordial = require '@thebespokepixel/cordial'

gulp.task 'bump',                              cordial.version.build.inc
gulp.task 'reset',                             cordial.version.build.reset
gulp.task 'write',                             cordial.version.build.write

gulp.task 'coffee',        ['bump', 'write'],  cordial.compile.coffee ['src/**/*.coffee'], './'
gulp.task 'babel',         ['bump', 'write'],  cordial.compile.babel  ['src/**/*.js'],     './'

gulp.task 'babel-format',  ['bump', 'write'],  cordial.format.babel    'src/**/*.js',      './'
gulp.task 'coffee-format', ['bump', 'write'],  cordial.format.coffee   'src/**/*.coffee',  './'
gulp.task 'xo-format',     ['bump', 'write'],  cordial.format.xo       'src/**/*.js',      './'

gulp.task 'test',                              cordial.test.shortCircuit
# gulp.task 'vows',                            cordial.test.vows       ['test/*']
# gulp.task 'coffeeVows',                      cordial.test.coffeeVows ['test/*']
# gulp.task 'ava',                             cordial.test.ava        ['test/*']
# gulp.task 'xo',                              cordial.test.xo         ['test/*']

gulp.task 'commit',                            cordial.git.commitAll
gulp.task 'push',                              cordial.git.pushAll      'origin'
gulp.task 'backup',        ['push'],           cordial.git.pushAll      'backup'

gulp.task 'prerelease',    ['reset'], cordial.npm.version.set 'prerelease'
gulp.task 'publish',       ['test'],  cordial.npm.publish

gulp.task 'default',       ['bump']

gulp.task 'post-flow-release-start', ['reset'], cordial.flow.release.start
gulp.task 'post-flow-release-finish', ['publish', 'push']
gulp.task 'filter-flow-release-start-version', cordial.flow.release.versionFilter
gulp.task 'filter-flow-release-finish-tag-message', cordial.flow.release.tagFilter


