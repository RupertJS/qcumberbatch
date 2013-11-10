Q = require "q"
should = require "should"
webdriver = require "selenium-webdriver"
By = webdriver.By

_destroyed = false
module.exports = class World
    constructor: (browser="firefox")->
        @driver = new webdriver.Builder().
            usingServer(process.env.SELENIUM_HUB).
            withCapabilities(webdriver.Capabilities[browser]()).build()

        @driver.manage().timeouts().setScriptTimeout(10000)

    visit: (url)->
        Q @driver.get(url)

    reload: ->
        Q @driver.reload()

    resize: (width, height)->
        Q @driver.manage().window().setSize(width, height)

    getWindowSize: ->
        Q @driver.manage().window().getSize()

    find: (selector)->
        @driver.findElement By.css selector

    exists: (id)->
        Q(@driver.findElements(By.id(id)))
        .then (elements)->
            throw new Error("'#{id}' not on page") unless elements.length > 0
            true

    text: (where)->
        Q @find(where).getText()

    title: ->
        Q @driver.getTitle()

    placeholder: (where)->
        Q @find(where).getAttribute 'placeholder'

    fill: (what, value, submit = false)->
        input = @driver.findElement(By.name(what))
        deferred = input.sendKeys(value)
        input.submit()  if submit
        Q deferred

    coords: (elem)->
        Q.all([
            @find('html').getSize()
            @find( elem ).getLocation()
            @find( elem ).getSize()
        ]).spread (window, location, size)->
            coords =
                window: window
                element:
                    width: size.width
                    left: location.x

    click: (what)->
        Q @find(what).click()

    destroy: ->
        _destroyed = true
        @driver.quit()

    isDestroyed: -> _destroyed
