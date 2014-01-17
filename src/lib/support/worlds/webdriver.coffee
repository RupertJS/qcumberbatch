Q = require "q"
should = require "should"
webdriver = require "selenium-webdriver"
By = webdriver.By

_destroyed = false
module.exports = class World
    ###
    Create a new world, assuming firefox capabilities.

    @param {string} browser property name from the `webdriver.Capabilities`
        list.
    ###
    constructor: (capabilities = {browserName: "firefox"})->
        @driver = new webdriver.Builder().
            usingServer(process.env.SELENIUM_HUB).
            withCapabilities(capabilities).build()

        @driver.manage().timeouts().setScriptTimeout(10000)

    ###
    Provide a URL for the browser to load.

    @param {string} url to visit in the driven browser.
    @return {deferred} resolved when page loads, or rejected when the
        page has an error precenting loading.
    ###
    visit: (url)->
        Q @driver.get(url)

    ###
    Force the browser to reload the current base.
    @return {promise} resolved when page loads, or rejected when the
        page has an error precenting loading.
    ###
    reload: ->
        Q @driver.reload()

    ###
    Change the size of the browser window.

    @param {int} width in pixels of the browser window.
    @param {int} height in pixels of the browser window.
    @return {promise} resolved when resize is complete.
    ###
    resize: (width, height)->
        Q @driver.manage().window().setSize(width, height)

    ###
    Return a promise resolved with an object containing the width and height
    of the window's current size.

    @return {promise}
    ###
    getWindowSize: ->
        Q @driver.manage().window().getSize()

    ###
    Load the screenshot module.
    ###
    screenshot: require './screenshot'

    ###
    Return a webelement wrapper for the given CSS.

    @param {string} selector (CSS) to look up.
    @return {webdriver}
    ###
    find: (selector)->
        @driver.findElement By.css selector

    ###
    Self-contained task to check for presence of an id (without selector).

    @param {string} id, with no leading.
    @returns {deferred} resolved with true when element is present, or throws
        `error '"id" not on page'` when id isn't present.
    ###
    exists: (id)->
        Q(@driver.findElements(By.id(id)))
        .then (elements)->
            throw new Error("'#{id}' not on page") unless elements.length > 0
            true

    ###
    Get the text of an element.

    @param {string} where selector to return all text children.
    @returns {promise} resolved with concatanated text.
    ###
    text: (where)->
        Q @find(where).getText()

    ###
    Get the title of the page.

    @return {promise} resolved with the string title of the page.
    ###
    title: ->
        Q @driver.getTitle()

    ###
    Get the value of the placeholder attribute of an element.

    @param {string} where selector of element to get the placeholder value.
    @return {promise} resolved with text of placeholder, or null if no
        placeholder was set.
    ###
    placeholder: (where)->
        Q @find(where).getAttribute 'placeholder'

    ###
    Provide input values to form elements.

    @param {string} what name of the form element to fill.
    @param {string} value text to send to the form.
    @param {boolean=} submit the form, default false.
    @return {promise} resolved when the input has been filled, or when the form
        sumbit has completed when `submit == true`.
    ###
    fill: (what, value, submit = false)->
        input = @driver.findElement(By.name(what))
        deferred = input.sendKeys(value)
        input.submit()  if submit
        Q deferred

    ###
    Return an object with the dimensions of the element, and the dimensions of
    the window.

    @param {string} element selector for element whose dimension is needed.
    @return {promise} resolved with an object of the form
        `{window: {width, height}, element: {width, height, left, top}}`.

    ###
    coords: (elem)->
        Q.all([
            @find('html').getSize()
            @find( elem ).getLocation()
            @find( elem ).getSize()
        ]).spread (window, location, size)->
            coords =
                window:
                    width: window.width
                    height: window.height
                element:
                    width: size.width
                    height: size.height
                    left: location.x
                    top: location.y

    ###
    Trigger a mouse click on an element.

    @param {string} what selector for element to be clicked.
    @return {promise} resolved when the element click has completed.
    ###
    click: (what)->
        Q @find(what).click()

    ###
    Destroy the curent browser session.
    ###
    destroy: ->
        _destroyed = true
        @driver.quit()

    ###
    Check if the session is no longer active.

    @return {boolean} true if browsing session has been destroyed.
    ###
    isDestroyed: -> _destroyed
