Q = require 'q'
should = require "should"
GM = require 'gm'
Compare = Q.denodeify GM.compare
Path = require 'path'

process.env.THRESHOLD = process.env.THRESHOLD || 0.02

module.exports = ->
    require('qcumber')(@)
    @Then /page should look like \[([^\]]+)\]/, (path)->
        compare = (image)->
            Compare(path, image, process.env.THRESHOLD)
            .spread (isEqual, equality, raw)->
                isEqual.should.equal true, "GM reports images unequal, threshold = #{process.env.THRESHOLD}"

        fail = (err)->
            console.log 'Comparing screenshots failed', err
            throw err

        @world.screenshot()
        .then compare, fail
