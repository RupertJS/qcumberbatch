Q = require 'q'
should = require "should"

module.exports = ->
    require('qcumber')(@)

    @Given /(?:has|have) (?:his|her|a|my) browser open$/, -> true

    @Given /(?:on|go(?:es)? to|visits?) the (?:site|landing page)(?: directly)?/, ->
        @world.visit(process.env.APP_ROOT || "http://localhost:3000/")

    ###
    Navigate the browser to a given URL.
    ###
    @When /browses to "([^"]*)" url/, (url)->
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


    ###
    Check for existance of a string in the title
    ###
    @Then /should see "([^"]*)" in the title$/, (what) ->
        @world.title()
        .then (text)->
            text.indexOf(what).should.be.greaterThan -1,
                "'#{what}' expected in title"

    ###
    Check for existance of a string in a selector
    ###
    @Then /should see "([^"]*)" in (?:the )"([^"]*)"$/, (what, where) ->
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
