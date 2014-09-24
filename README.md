# qcumberbatch

> A variety of bridge steps between cucumberjs and webdriverjs.

The approach taken here I'm calling 'Selenium Mappings Model'. [Read about it!][mapmodel]

## Getting Started

This plugin requires Grunt `~0.4.0` for the

## Cucumber task
_Run this task with the `grunt cucumber` command._

Task targets, files and options may be specified according to the Grunt [Configuring tasks](http://gruntjs.com/configuring-tasks) guide.

### Options

#### `matrix`
Type: `Object`
Default: `{}`

Specify the list of OS and Browser versions to test. The keys of the object are strings specifying `"<os> [version] [resolution]"`. The values are an array of strings, each entry being one of "browser [version]".

Each of the properties' values are constrained by the Browserstack and Selenium Webdriver configuration and documentation. To run local tests, specify `local` for the OS, and no version or resolution. To run tests against browserstack, specify `OSX` or `Windows` for the OS, a Browserstack version for the os version (`XP`, `8.1`, `Mountain Lion`, `Mavericks`, etc). Locally, browsers can be anything loaded from `selenium-webdriver/Capabilities`. On Browserstack, specify an appropriate name and version. To test on a mobile device, set `os` as one of `android` or `ios`; set `resolution` to `landscape` or `portrait`; and put the entire device name in the browser array.

A complete example:

```coffeescript
matrix:
    "Windows 8.1 1280x1024": [
        'IE 11.0'
        'Chrome 36.0'
    ]
    "Windows XP 1024x768": [
        'Firefox 31.0'
    ]
    "OS X Mavericks 1920x1080": [
        'Safari 7.0'
        'Firefox 31.0'
        'Chrome 36.0'
    ]
    "ios portrait": [
        'iPad 4th Gen'
    ]
    "android landscape": [
        'Google Nexus 7'
    ]
```

#### `failHard`

Type: `boolean`
Default: `false`

If true, stop the grunt task after the first error in a selenium test. Otherwise, will run tests on the entire device matrix, and only fail after all tests have completed.

#### `tags`
#### `steps`
#### `format`

Type: `string`
Default: `""`

These have the same meanings as their cucumberjs CLI counterparts.

## Release History
**0.1.0** *2014-09-24* Matrix browser spec and Browserstack intertie.
**0.0.4** *2014-06-18* SELENIUM_BROWSER flag.
**0.0.3** *2014-04-24* Added `findAll` to world.
**0.0.2** *2013-11-29* Documentation release.
**0.0.1** *2013-10-30* Initial release; some basic steps, and screenshot handing.
