webdriver = require "selenium-webdriver"

CucumberCLI = require '../node_modules/cucumber-js/lib/cucumber/cli'

buildArgv (capabilities, options)->
    argv = ['node', 'node_modules/.bin/cucumber-js']

    argv = argv.concat(files) if options.files?.length
    argv = argv.concat(['-r', options.steps]) if options.steps?.length
    argv = argv.concat(['-t', options.tags]) if options.tags?.length
    argv = argv.concat(['-f', options.format]) if options.format?.length

module.exports = (grunt)->
    getCapabilites = (capability, options)
        if typeof capability is 'string'
            webdriver.Capabilities[capability]()
        else
            grunt.util._.extend {}, capability, options.browserstack

    grunt.registerMultiTask 'qcumberbatch', ->
        defaults =
            hub: 'http://localhost:4444/wd/hub'
        options = @options defaults

        matrix = options.matrix
        process.env.SELENIUM_HUB = options.hub

        done = @async()
        tests = matrix.length
        passed = true
        matrix.forEach (capability)->
            capabilities = getCapabilites capability, options
            grunt.verbose.writeflags capabilities, "Running capabilities:"

            argv = buildArgv capabilities

            finish = (succeeded)->
                passed = passed and succeeded
                if --tests is 0 then done passed

            CucumberCLI(argv).run (succeeded)->
                # exit after waiting for all pending output
                if process.stdout.write ""
                    # no buffer left, exit now:
                    finish succeeded
                else
                    # write() returned false
                    # kernel buffer is not yet empty
                    process.stdout.on 'drain', ->
                        # the kernel buffer is now empty
                        finish succeeded
