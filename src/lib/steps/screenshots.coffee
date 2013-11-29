Q = require 'q'
should = require "should"
GM = require 'gm'
GMCompare = Q.denodeify GM.compare
Path = require 'path'

process.env.THRESHOLD = process.env.THRESHOLD || 0.02

module.exports = ->
    require('qcumber')(@)

    ###
    Take a snapshot of the page, and compare it to a known reference image. The
    path is in brackets, and is relative to the root of the execution
    environment (next to the package.json, when run through grunt-cucumber).

    @global {float} process.env.THRESHOLD percentage map to statistically match
        images by, default is 0.2 (valid between 0.0 and 1.0).
    ###
    @Then /page should look like \[([^\]]+)\]/, (path)->
        compare = (image)->
            GMCompare(path, image, process.env.THRESHOLD)
            .spread (isEqual, equality, raw)->
                isEqual.should.equal true, "GM reports images unequal, threshold = #{process.env.THRESHOLD}"

        fail = (err)->
            # TODO probably not console.log.
            #console.log 'Comparing screenshots failed', err
            throw err

        @world.screenshot()
        .then compare, fail
