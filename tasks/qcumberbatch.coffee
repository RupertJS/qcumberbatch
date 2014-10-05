Q = require 'q'
cucumber = require 'cucumber'

module.exports = (grunt)->
    grunt.registerMultiTask 'cucumber',
        'Run cucumberjs tests across local and browserstack',
        ->
            done = @async()

            options = @options()
            steps = options.steps or ''
            delete options.steps
            tags = options.tags or ''
            delete options.tags
            format = options.format or ''
            delete options.format

            files = @filesSrc or []

            argv = ['node', 'node_modules/.bin/cucumber-js']
            argv = argv.concat files unless files.length is 0
            argv = argv.concat ['-r', steps] if steps.length > 0
            argv = argv.concat ['-t', tags] if tags.length > 0
            argv = argv.concat ['-f', format] if format.length > 0

            grunt.verbose.writeln 'Command line ready'
            grunt.verbose.writeln argv

            grunt.verbose.writeln 'Preparing matrix..'
            capabilityList = getCapabilityList(options.matrix)
            grunt.verbose.writeln "#{capabilityList.length} capabilities..."

            runAll argv, capabilityList, done, options.failHard

    runAll = (argv, capabilityList, done, failHard = no)->
        allPassed = yes
        next = (succeeded)->
            unless succeeded
                if failHard is yes
                    return done false
                else
                    allPassed = no
            if capability = capabilityList.pop()
                runCucumber argv, capability, next
            else
                done allPassed
        next(yes)

    runCucumber = (argv, capabilities, callback)->
        platform = "#{capabilities.browser} on on #{capabilities.os}"
        grunt.log.writeln "Running tests for #{platform}..."
        process.env.CONFIG = JSON.stringify capabilities
        cucumber.Cli(argv).run (succeeded)->
            # Clear the current configuration
            process.env.CONFIG = ''
            delete process.env.CONFIG

            grunt.verbose.writeln "Finished #{platform}, succeeded #{succeeded}"

            exitFunction = -> callback(succeeded)

            # no buffer left, exit now:
            return exitFunction() if process.stdout.write ""

            # exit after waiting for all pending output
            process.stdout.on 'drain', exitFunction # kernel buffer is now empty

    getCapabilityList = (matrix)->
        capabilityList = []
        for os, browsers of matrix
            [_1, os, os_version, resolution] = os.match ///
            ^
            (Windows|OSX|ios|android|local)\s*
            (
                XP|7|8|8.1|
                Lion|Snow Leopard|Mountain Lion|Mavericks|Yosemite
            )?
            \s*
            ([0-9]{3,4}x[0-9]{3,4}|landscape|portrait)?
            $
            ///
            os = 'OS X' if os is 'OSX'
            for browser in browsers
                [_2, browser, browser_version] = browser.match ///
                ^
                ([a-zA-Z]+)\s?
                (.*)?
                $
                ///
                if os in ['Windows', 'OS X']
                    capabilityList.push {
                        browserstack: true
                        browser, browser_version
                        os, os_version
                        resolution
                    }
                else if os is 'local'
                    capabilityList.push { os, browser }
                else
                    platform = switch os
                        when 'android' then 'ANDROID'
                        when 'ios' then 'MAC'
                    capabilityList.push {
                        browserstack: true
                        platform,
                        browserName: os
                        device: _2
                        orientation: resolution or 'portrait'
                    }

        capabilityList
