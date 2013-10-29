World = require "./worlds/webdriver"
world = new World()
module.exports =
    get: ->
        if world.isDestroyed()
            world = new World()
        return world
