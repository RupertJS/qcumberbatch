Q = require 'q'
should = require "should"

module.exports = ->
    require('qcumber')(@)

    # _defineStep = @defineStep
    # qStep = (regex, cb)->
    #     _defineStep.call @, regex, (args..., done)->
    #         console.log "Matched step: #{regex}"
    #         console.log args.join ' : '
    #         cb.apply(@, arguments)
    # @Given = @When = @Then = @defineStep = qStep

    ###
    Default Given task, simply confirms the world setup was completed.
    ###
    @Given /(?:has|have) (?:his|her|a|my) browser open/, -> true

    ###
    Direct the browser to the SuT, either process.env.APP_ROOT or
    `http://localhost:3000`.
    ###
    @Given /(?:on|go(?:es)? to|visits?) the (?:site|landing page)(?: directly)?/, ->
        @world.visit(process.env.APP_ROOT || "http://localhost:3000/")

    ###
    Force the browser to adopt a certen width and height.
    ###
    @Given /resized to \((\d+)x(\d+)\)/, (width, height)->
        width = parseInt(width)
        height = parseInt(height)
        @world.resize(width, height)

    ###
    Navigate the browser to a given URL.
    ###
    @When /browse(?:s)? to "([^"]*)"/, (url)->
        @world.visit(url)

    ###
    Navigate the browser away from the current page.
    ###
    @When /leaves the page/, ->
        @world.visit('about:blank')

    ###
    Send some value to an input, without triggering further processing.
    ###
    @When /types "([^"]+)" into (?:the|a) "([^"]+)" (?:box|input|field)/, (value, field)->
        @world.fill(field, value)

    ###
    Send some value to an input, and submit its form.
    ###
    @When /enters "([^"]+)" into (?:the|a) "([^"]+)" (?:box|input|field)/, (value, field)->
        @world.fill(field, value, true)

    ###
    Send many values to one input, submitting its form each time.
    ###
    @When /enters into (?:the|a) "([^"]+)" (?:box|input|field)/, (field, lines)->
        Q.all([@world.fill(field, line, true) for line in lines.split '\n'])


    @Then /window should be \((\d+)x(\d+)\)/, (width, height)->
        @world.getWindowSize().then (size)->
            size.width.should.equal parseInt width
            size.height.should.equal parseInt height

    ###
    Check for existance of a string in the title
    ###
    @Then /should see "([^"]*)" in the title/, (what) ->
        @world.title()
        .then (text)->
            text.indexOf(what).should.be.greaterThan -1,
               "'#{what}' expected in title (#{text})"

    ###
    Check for existance of a string in a selector
    ###
    @Then /should see "([^"]*)" in (?:the )"([^"]*)"/, (what, where) ->
        @world.text(where)
        .then (text)->
            text.indexOf(what).should.be.greaterThan -1,
                "'#{what}' expected in '#{where}'"

    ###
    Check for reasonable placeholder value
    ###
    @Then /invited to enter a(?:n)? "([^"]*)" in the "([^"]*)" (?:box|input|field)/, (value, where)->
        @world.placeholder("input[type=text].#{where}")
        .then (placeholder)->
            placeholder.should.match ///#{value}///,
                "placeholder for #{where} should be inviting."

    ###
    Check for content somewhere in the body.
    ###
    @Then /page shows "([^"]+)"/, (content)->
        @world.text("body")
        .then (text)->
            text.should.match ///#{content}///,
                "body must have '#{content}'"

    ###
    Ensure lack of content in the body.
    ###
    @Then /page does not show "([^"]+)"/, (content)->
        @world.text("body")
        .then (text)->
            text.should.not.match ///#{content}///,
                "body must not have #{content}"
