module.exports = (grunt)->
    grunt.Config =
        cucumber:
            qcumberbatch:
                files:
                    src: ['src/features/integration/*']
                options:
                    tags: ['~@ShouldFail', '~@ImageComparison']
            failing:
                files:
                    src: ['src/features/integration/*']
                options:
                    tags: '@ShouldFail'
            images:
                files:
                    src: ['src/features/integration/*']
                options:
                    tags: '@ImageComparison'

            browserstack:
                files:
                    src: ['src/features/integration/*']
                options:
                    tags: '~@ShouldFail'
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

            options:
                steps: 'src/features/integration/steps'
                format: 'pretty'

                project: require('../../package').name
                build: require('../../package').version + '-next'
                matrix:
                    "local": [
                        "chrome"
                        "firefox"
                    ]

    # grunt.NpmTasks = [
    #     'grunt-cucumber'
    #     'grunt-selenium-launcher'
    # ]

    grunt.registerTask 'integration', [
        # 'selenium-launch'
        'cucumber:qcumberbatch'
    ]

    grunt.registerTask 'failing', [
        # 'selenium-launch'
        'cucumber:failing'
    ]
