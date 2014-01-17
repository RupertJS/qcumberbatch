Path = require 'path'
spawn = require('child_process').spawn

module.exports = (grunt)->
    require('grunt-recurse')(grunt, __dirname)

    [
        ['.', 'src', 'features']
    ]
    .map((dir)->Path.join.apply null, dir)
    .map(grunt.grunt)

    # grunt.Config =
    grunt.Config =
        browserstackTunnel:
            options:
                accessKey: process.env.BS_ACCESS_KEY
            devel: {}


    grunt.registerTask 'serve', ->
        http = require('http').createServer()
        http.on 'request', (req, res)->
            grunt.verbose.writeln("Request received.")
            res.writeHead(200, { 'Content-Type': 'text/html'})
            res.write '''<html>
                <head><title>qcumberbatch</title></head>
                <body></body>
                </html>
            '''
            res.end()
        http.listen 3000

    grunt.loadTasks 'src/tasks'

    grunt.registerTask 'default', ['setup', 'integration', 'documentation']
    grunt.registerTask 'setup', [
        'serve',
        'browserstackTunnel:devel',
    ]
    grunt.finalize();
