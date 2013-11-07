World = require "../support/worlds"
module.exports = ->
    @world = World.get()

    @After (done)=>
        @world.visit('about:blank').then(done)

    process.on 'exit', ->
        @world?.destroy()
        console.log 'Destroying world'
