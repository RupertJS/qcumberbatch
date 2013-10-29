module.exports = (grunt)->
    grunt.Config =
        cucumberjs:
            qcumberbatch:
                files:
                    src: ['src/features/integration/*']
            options:
                steps: 'src/features/integration/steps'

    grunt.NpmTasks = [
        'grunt-cucumber'
        'grunt-selenium-launcher'
    ]

    grunt.registerTask 'integration', [
        'selenium-launch'
        'cucumberjs:qcumberbatch'
    ]
