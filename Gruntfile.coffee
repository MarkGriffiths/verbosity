module.exports = (grunt) ->
	require('load-grunt-tasks') grunt

	# Project configuration.
	grunt.initConfig
		pkg: grunt.file.readJSON 'package.json'
		coffee:
			compile:
				options:
					bare: yes
				files: [
					expand: yes
					cwd: 'src/'
					src: ['*.coffee']
					dest: ''
					ext: '.js'
				,
					expand: yes
					cwd: 'src/lib'
					src: ['*.coffee']
					dest: 'lib'
					ext: '.js'
				]
		standard:
			options:
				format: yes
				lint: yes
			src: ['{,lib/}*.js']
		replace:
			shims:
				src: ['index.js', 'lib/**/*.js']
				overwrite: true
				replacements: [
					from: /,\n\s*indexOf.*\n/
					to: '\nvar indexOf = [].indexOf\n'
				]
		version:
			default:
				options:
					prefix: "verbosity [(]v"
				src: ['src/**/*.coffee', 'test/**/*.coffee']
			readme:
				options:
					prefix: "verbosity v"
				src: ['README.md']
		bump:
			options:
				updateConfigs: ['pkg']
				commitFiles: ['-a']
				pushTo: 'origin'
				prereleaseName: 'alpha'
				commitMessage: 'Snapshot v%VERSION%'
				tagMessage: 'Snapshot v%VERSION%'
				gitDescribeOptions: '--tags --always --dirty=-d'
				commit: yes
				createTag: no
				push: no
		shell:
			publish:
				command: 'npm publish'


	grunt.registerTask 'default', ['bump-only:prerelease', 'version', 'coffee:compile', 'replace', 'force:standard']
	grunt.registerTask 'commit',  ['default', 'bump-commit']
	grunt.registerTask 'push',    ['default', 'release', 'bump-commit']
	grunt.registerTask 'patch',   ['bump-only:prepatch', 'version', 'coffee:compile', 'replace', 'force:standard', 'bump-commit']
	grunt.registerTask 'minor',   ['bump-only:preminor', 'version', 'coffee:compile', 'replace', 'force:standard', 'bump-commit']
	grunt.registerTask 'major',   ['bump-only:premajor', 'version', 'coffee:compile', 'replace', 'force:standard', 'bump-commit']
	grunt.registerTask 'final',   ['bump-only', 'version', 'coffee:compile', 'release:final', 'replace', 'force:standard', 'bump-commit']
	grunt.registerTask 'publish', ['shell:publish']
	grunt.registerTask 'shipit',  ['final', 'publish']

	grunt.registerTask 'release', 'Construct commit/release logic and messaging.', (phase = 'push') ->
		pkg = grunt.config 'pkg'
		prName = grunt.config 'bump.options.prereleaseName'

		switch phase
			when 'push'
				grunt.config 'bump.options.push', true
				commitMessage = "Snapshot v#{pkg.version}"
			when 'final'
				commitMessage = "Release v#{pkg.version}"
				grunt.config 'bump.options.tagMessage', commitMessage
				grunt.config 'bump.options.push', true
				grunt.config 'bump.options.createTag', true

		grunt.config 'bump.options.commitMessage', commitMessage
		grunt.log.writeln "#{phase}, #{commitMessage}"
