Feature: Webdriver stack
    As a webdriver wrapper
    I want to exercise all default steps
    So that I know the library passes to selenium-webdriver correctly

    Scenario: Smoke
        Given I have my browser open
        When I go to the site
        Then I should see "qcumberbatch" in the title

    Scenario: Open Second
        Given I have my browser open

    Scenario: Open Third
        Given I have my browser open

    Scenario: Resize
        Given I have my browser open
        And it is resized to (1024x768)
        When I browse to "http://google.com"
        Then the window should be (1024x768)
