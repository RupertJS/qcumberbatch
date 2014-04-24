Path = require 'path'
module.exports = (grunt)->
    require('grunt-recurse')(grunt, __dirname)
    grunt.NpmTasks = 'grunt-release'

    [
        ['.', 'src', 'features']
    ]
    .map((dir)->Path.join.apply null, dir)
    .map(grunt.grunt)


    grunt.initConfig grunt.Config
    grunt.loadNpmTasks task for task in grunt.NpmTasks

    grunt.registerTask 'serve', ->
        http = require('http').createServer()
        http.on 'request', (req, res)->
            res.writeHead(200, { 'Content-Type': 'text/html'})
            res.write '''<html>
                <head><title>qcumberbatch</title></head>
                <body></body>
                </html>
            '''
            res.end()
        http.listen 3000

    grunt.loadTasks 'src/tasks'

    grunt.registerTask 'test', ['serve', 'integration']
    grunt.registerTask 'default', ['test', 'documentation']
