Q = require "q"
should = require "should"
webdriver = require "selenium-webdriver"
By = webdriver.By

LOCAL_HUB = 'http://localhost:4444/wd/hub'

_destroyed = false
module.exports = class World
    ###
    Create a new world, assuming firefox capabilities.

    @param {config} object of options.
    ###
    constructor: (config)->
        capabilities = @_buildCapabilities config

        builder = new webdriver.Builder()
        builder.usingServer(capabilities.hub) if capabilities.hub?
        builder.withCapabilities(capabilities)
        @driver = builder.build()

        # Set default timeout
        if @driver.manage?
            @driver.manage().timeouts().setScriptTimeout config.timeout or 10000

    _buildCapabilities: (config)->
        capabilities = config
        if config.browserstack
            try
                webdriver = require 'browserstack-webdriver'
            catch e
                console.error 'Asked for browserstack but could not load.'
            capabilities.hub = 'http://hub.browserstack.com/wd/hub'
            config['browserstack.user'] or= process.env.BROWSERSTACK_USER
            config['browserstack.key'] = process.env.BROWSERSTACK_KEY
            config['browserstack.local'] = yes
            config['acceptSllCerts'] = yes
            console.log '\n\nIMPORTANT\n\nPlease ensure local testing is ready.'
            console.log '\n'
            console.log "BrowserStackLocal #{config['browserstack.key']}" +
                " localhost,3000,0 -skipCheck &"
            # Set up the tunnel
            # BrowserStackLocal KEY
            # host1,port1,ssl_flag,host2,port2,ssl_flag -skipCheck
        else
            capabilities = webdriver.Capabilities[config.browser]()
            unless config.browser in ['chrome', 'firefox']
                capabilities.hub = process.env.SELENIUM_HUB or LOCAL_HUB

        capabilities

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
    Return a list of webelement wrappers for the given CSS.

    @param {string} selector (CSS) to look up.
    @return {webdriver}
    ###
    findAll: (selector)->
        @driver.findElements By.css selector

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
