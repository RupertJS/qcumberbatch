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

    grunt.registerTask 'documentation', do ->
        Comment = '\\s+###\\n'
        WGT = '(?:When|Given|Then)'
        WS = "\\n?\\s*\\n?"
        StepMatch = "@(#{WGT}.*->).*"

        CommentBlocks = ///
            (?:\s+([^\n]*)\n
            #{Comment})? #{WS}
            (#{StepMatch})
        ///g
        CB = (block)->
            CommentBlocks.lastIndex = 0
            CommentBlocks.exec block

        fileShortName = (filename)->
            filename.match(///src/lib/steps/(.*).coffee$///)[1]

        defaults =
            fileExpand: 'src/lib/steps/**/*'
            dir: Path.join '.', 'docs'
        defaults.target = Path.join defaults.dir, 'docs.json'

        ->
            files = grunt.file.expand defaults.fileExpand
            projectDocs = {}

            grep = (filename)->
                contents = grunt.file.read filename
                blocks = contents.match CommentBlocks

                projectDocs[fileShortName(filename)] =
                blocks?.map (block)->
                    block = CB block
                    block = [block[1] || "(No Docs)", block[3]]

            files.forEach grep

            docsJson = JSON.stringify projectDocs, null, 4
            grunt.verbose.ok docsJson

            grunt.log.write "Saving docs JSON in #{defaults.target}... "
            grunt.file.write defaults.target, docsJson
            grunt.log.ok()

    grunt.registerTask 'test', ['serve', 'integration']
    grunt.registerTask 'default', ['test', 'documentation']
