World = require "../support/worlds"
module.exports = (config)->
    @world = World.get(config)

    @After (done)=>
        @world.visit('about:blank').then(done)

    @registerHandler 'AfterFeatures', (event, done)=>
        @world?.destroy().then(done)
