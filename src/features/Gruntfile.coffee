module.exports = (grunt)->
    grunt.Config =
        cucumberjs:
            qcumberbatch:
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
                format: 'pretty'

                project: require('../../package').name
                build: require('../../package').version + '-next'
                matrix:
                    "Windows XP 1024x768": [
                        'Firefox 31.0'
                    ]
                    "OSX Mavericks 1920x1080": [
                        'Safari 7.0'
                        'Chrome 36.0'
                    ]
                    "android landscape": [
                        'Google Nexus 7'
                    ]

    grunt.NpmTasks = [
        'grunt-cucumber'
        'grunt-selenium-launcher'
    ]

    process.env.CONFIG = JSON.stringify {
        browserstack: true
        'os' : 'Windows',
        'os_version' : '7',
        'browser' : 'IE',
        'browser_version' : '8.0',
        'resolution' : '1024x768'
    }

    grunt.registerTask 'integration', [
        # 'selenium-launch'
        'cucumberjs:qcumberbatch'
    ]

    grunt.registerTask 'failing', [
        # 'selenium-launch'
        'cucumberjs:failing'
    ]
