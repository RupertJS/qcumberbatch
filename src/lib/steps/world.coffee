World = require "../support/worlds"


# process.env.SELENIUM_HUB = 'http://hub.browserstack.com/wd/hub'
capabilities =
  'browserName' : 'firefox'
  'browserstack.user' : 'joecranemessina'
  'browserstack.key' : process.env.BS_ACCESS_KEY
  'browserstack.tunnel' : 'true' # This was the secret!

capabilities = null

module.exports = ->
    @world = World.get(capabilities)

    @After (done)=>
        @world.visit('about:blank').then(done)

    @registerHandler 'AfterFeatures', (event, done)=>
        @world?.destroy().then(done)
