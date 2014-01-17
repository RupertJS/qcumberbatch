module.exports = (grunt)->
    features = ['src/features/integration/**/*.feature']

    grunt.Config =
        qcumberbatch:
            options:
                steps: 'src/features/integration/steps'
                tags: '~@ShouldFail'
                browserstack:
                    'browserstack.user' : process.env.BS_USER
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
                hub: "http://hub.browserstack.com/wd/hub"

            local:
                files:
                    src: features
                options:
                    hub: 'http://localhost:4444/wd/hub'
                    matrix: ['firefox']

            browserstack:
                files:
                    src: features

            failing:
                files:
                    src: features
                options:
                    tags: '@ShouldFail'

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
