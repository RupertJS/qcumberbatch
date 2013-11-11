Q = require 'q'
temp = require 'temp'
fs = require 'fs'
temp.track()

open = Q.denodeify temp.open
write = Q.denodeify fs.writeFile
close = Q.denodeify fs.close

save = (data)->
    info = null
    open('screenshot')
    .then (inf)->
        info = inf
    .then ->
        write info.path, data
    .then ->
        close info.fd
    .then ->
        info.path
    .fail ->
        console.log 'Saving {inf.path} failed', arguments

module.exports = ->
    Q(@driver.takeScreenshot())
    .then (image)->
        imageBuffer = new Buffer(image, 'base64');
        save(imageBuffer)
