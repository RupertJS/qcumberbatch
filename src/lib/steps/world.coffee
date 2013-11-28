World = require "../support/worlds"
module.exports = ->
    @world = World.get()

    @After (done)=>
        @world.visit('about:blank').then(done)

    @registerHandler 'AfterFeatures', (event, done)=>
        @world?.destroy().then(done)
