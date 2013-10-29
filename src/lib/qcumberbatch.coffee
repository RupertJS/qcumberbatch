module.exports =
    steps: ->
        require('./steps/world').call(@)
        require('./steps/browsing').call(@)
