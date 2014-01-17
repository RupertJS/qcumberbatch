World = require "../support/worlds"

capabilities =
    if process.env.CAPABILITIES
        JSON.parse process.env.CAPABILITIES
    else
        { browserName: "firefox" }

module.exports = ->
    @world = World.get(capabilities)

    @After (done)=>
        @world.visit('about:blank').then(done)

    @registerHandler 'AfterFeatures', (event, done)=>
        @world?.destroy().then(done)
