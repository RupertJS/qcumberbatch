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
        ###
        Here through CB are a variety of regexes to pull out from the code

        ```
        Navigate the browser to a given URL.
        \#\#\#
        @When /browse(?:s)? to "([^"]*)"/, (url)->
        ```
        ###

        # Then ending ### in a comment
        Comment = '\\s+###\\n'
        # Group but ignore the @ possibilities.
        WGT = '(?:When|Given|Then)'
        # Whitespace before the @
        WS = "\\n?\\s*\\n?"
        # The step definition itself.
        StepMatch = "@(#{WGT}.*->).*"

        CommentBlocks = ///
            (?:
                #{Comment}
                (.*\n)
                #{Comment}
            )? # Possibly missing the comment; keep the text.
            #{WS}
            #{StepMatch} # The actual step regex and fn params.
        ///gm
        CB = (block)->
            CommentBlocks.lastIndex = 0 # The Regex is /g, so reset.
            CommentBlocks.exec block

        fileShortName = (filename)->
            filename.match(///src/lib/steps/(.*).coffee$///)[1]

        defaults =
            fileExpand: 'src/lib/steps/**/*'
            dir: Path.join '.', 'docs'
        defaults.target = Path.join defaults.dir, 'docs.json'

        -> # The actual task function
            projectDocs = {}
            files = grunt.file.expand defaults.fileExpand

            ###
            Look through a file, building a two-deep array of all step defns,
            each with two entries for comment and defn. Put the files with steps
            directly in to the projectDocs.
            ###
            grep = (filename)->
                contents = grunt.file.read filename

                grunt.verbose.write "Looking for docs in #{filename}... "

                blocks = contents.match CommentBlocks
                projectDocs[fileShortName(filename)] =
                    blocks?.map (block)->
                        block = CB block
                        block = [
                            block[1]?.trim() || "(No Docs)",
                            block[2].trim()
                        ]

                grunt.verbose.ok()

            # Populate the projectDocs.
            files.forEach grep

            # Save docs to disk
            grunt.log.write "Saving docs JSON in #{defaults.target}... "
            docsJson = JSON.stringify projectDocs, null, 4
            grunt.file.write defaults.target, docsJson
            grunt.log.ok()

    grunt.registerTask 'test', ['serve', 'integration']
    grunt.registerTask 'default', ['test', 'documentation']
