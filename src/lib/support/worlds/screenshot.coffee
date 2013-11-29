Q = require 'q'
temp = require 'temp'
fs = require 'fs'
temp.track()

# Wrap several node functions in Q
open = Q.denodeify temp.open
write = Q.denodeify fs.writeFile
close = Q.denodeify fs.close

# Given a buffer of data, write it to a temporary file, resolving with the path
# of the written file.
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
    # Get a PNG screenshot of th entire page from the browser
    Q(@driver.takeScreenshot())
    .then (image)->
        # Cast the date to an image buffer.
        imageBuffer = new Buffer(image, 'base64');
        # Save that, allowing the chain to continue further with the path of the
        # writted screen shot.
        save(imageBuffer)
