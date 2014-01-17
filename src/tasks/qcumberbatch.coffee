webdriver = require "selenium-webdriver"
spawn = require('child_process').spawn

module.exports = (grunt)->
    buildArgv = (files, capabilities, options)->
        argv = ['./node_modules/cucumber/bin/cucumber.js']

        process.env.CAPABILITIES = JSON.stringify capabilities

        argv = argv.concat(files)
        argv = argv.concat(['-r', options.steps]) if options.steps?.length
        argv = argv.concat(['-t', options.tags]) if options.tags?.length
        argv = argv.concat(['-f', options.format]) if options.format?.length

        argv

    getCapabilites = (capability, options)->
        if typeof capability is 'string'
            # webdriver.Capabilities[capability]()
            {browserName: capability}
        else
            grunt.util._.extend {}, capability, options.browserstack

    cleanup = (result)-> (succeeded)->
        debugger
        finish = (succeeded)->
            result.passed = result.passed and succeeded
            if --result.tests is 0 then result.done result.passed

        # exit after waiting for all pending output
        if process.stdout.write ""
            # no buffer left, exit now:
            finish succeeded == 0
        else
            # write() returned false
            # kernel buffer is not yet empty
            process.stdout.on 'drain', ->
                # the kernel buffer is now empty
                finish succeeded == 0

    prepare = (options, capability)->
        capabilities = getCapabilites capability, options
        grunt.verbose.writeflags capabilities, "Running capabilities"

        files = options.files.map((file)->file.src.join(' ')).join(' ')
        argv = buildArgv grunt.file.expand(files), capabilities, options
        env = grunt.util._.extend {}, process.env

        grunt.verbose.writeln "argv$ ", argv.join(' ')
        grunt.verbose.writeflags env, "Environment"
        [argv, env]

    execute = (argv, env, result)->
        stdio = 'pipe'
        run = spawn('node', argv, {env, stdio})
        run.stdout.on 'data', (d)->grunt.log.write d
        run.stderr.on 'data', (d)->grunt.log.error d
        run.on 'close', cleanup(result)

    runCapability = (options, result)-> (capability)->
        [argv, env] = prepare options, capability
        execute argv, env, result

    grunt.registerMultiTask 'qcumberbatch', ->
        defaults =
            hub: process.env.SELENIUM_HUB
        options = @options defaults
        options.files = @files

        matrix = options.matrix
        process.env.SELENIUM_HUB = options.hub

        done = @async()
        tests = matrix.length
        passed = true

        result = {done, tests, passed}
        matrix.forEach runCapability(options, result)
