module.exports =
    steps: (config = process.env.CONFIG)->
        debugger
        if typeof config is 'string'
            try
                _config = JSON.parse config
                config = _config
            catch e
                console.warn 'Cannot parse string config.'
                console.warn e

        require('./steps/world').call(@, config)
        require('./steps/browsing').call(@)
        require('./steps/screenshots').call(@)
