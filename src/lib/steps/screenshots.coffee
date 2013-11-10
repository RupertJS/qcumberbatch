Q = require 'q'
should = require "should"

module.exports = ->
    require('qcumber')(@)
    @Then /page should look like \[([^\]]+)\]/, (path)->
        @world.screenshot()
        .then (image)->
            console.log path, image
