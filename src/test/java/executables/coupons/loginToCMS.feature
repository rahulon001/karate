@ignore
Feature: cms login

  Background:
    * url baseUrl
    * header Content-Type = 'application/x-www-form-urlencoded'
    * configure ssl = true

  Scenario: login legacy
    Given path '/legacy/login'
    And form field username = 'super5'
    And form field password = 'foobar'
    When method post
    Then status 200
#    * def resHeaders = responseHeaders
#    * def xAntiForgery = resHeaders['x-anti-forgery'][0]
