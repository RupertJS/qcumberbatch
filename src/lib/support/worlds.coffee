World = require "./worlds/webdriver"

world = null

module.exports =
    get: (capabilities) ->
        if !world or world.isDestroyed()
            world = new World(capabilities)
        return world
