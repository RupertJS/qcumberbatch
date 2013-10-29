Path = require 'path'
module.exports = (grunt)->
    require('grunt-recurse')(grunt, __dirname)

    [
        ['.', 'src', 'features']
    ]
    .map((dir)->Path.join.apply null, dir)
    .map(grunt.grunt)

    grunt.initConfig grunt.Config
    grunt.loadNpmTasks task for task in grunt.NpmTasks

    grunt.registerTask 'test', ['integration']
    grunt.registerTask 'default', ['test']
