World = require "./worlds/webdriver"
world = null
module.exports =
    get: (config)->
        if not world? or world.isDestroyed()
            world = new World(config)
        return world
