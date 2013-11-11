Q = require 'q'
should = require "should"
GM = require 'gm'
Compare = Q.denodeify GM.compare
Path = require 'path'

module.exports = ->
    require('qcumber')(@)
    @Then /page should look like \[([^\]]+)\]/, (path)->
        compare = (image)->
            Compare(path, image)
            .spread (isEqual, equality, raw)->
                isEqual.should.be.true

        fail = (err)->
            console.log 'Comparing screenshots failed', err
            throw err

        @world.screenshot()
        .then compare, fail
