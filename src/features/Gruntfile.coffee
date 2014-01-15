module.exports = (grunt)->

    bs_hub = "http://bs.hub ... "
    local_hub = "http:// ... "

    grunt.Config =
        qcumberbatch:
            options:
                browserstack:
                    'browserstack.user' : process.env.BS_USER || 'joecranemessina'
                    'browserstack.key' : process.env.BS_ACCESS_KEY
                    'browserstack.tunnel' : 'true' # This was the secret!

                matrix: [
                    browser: 'firefox'
                    browser_version: '26.0'
                    os: 'Windows'
                    os_version : '7',
                ,
                    browser : 'IE',
                    browser_version : '9.0',
                    os : 'Windows',
                    os_version : '7',
                    resolution : '1024x768'
                ]
                hub: "http://bsHub"

            local:
                files:
                    src: ['src/features/integration/*']
                options:
                    tags: '~@ShouldFail'
                    hub: 'http://localHub'
                    matrix: ['firefox']

            browserstack:
                files:
                    src: ['src/features/integration/*']
                options:
                    tags: '~@ShouldFail'

            failing:
                files:
                    src: ['src/features/integration/*']
                options:
                    tags: '@ShouldFail'
            options:
                steps: 'src/features/integration/steps'

    grunt.NpmTasks = [
        'grunt-cucumber'
        'grunt-selenium-launcher'
    ]

    grunt.registerTask 'integration', [
        'selenium-launch'
        'qcumberbatch:local'
    ]

    grunt.registerTask 'regression', [
        'qcumberbatch:browserstack'
    ]

    grunt.registerTask 'failing', [
        'selenium-launch'
        'cucumberjs:failing'
    ]
