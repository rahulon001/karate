@ignoreClientAPI
Feature: Access tokens for client facing applications

  Background:
    * url baseUrlApp
    * header Content-Type = 'application/x-www-form-urlencoded'

  Scenario: login to Application
    Given path '/jm/auth/oauth/v2/token'
    And header Authorization = "Basic bDd4eDNlODg3NDAzYjVlZDQwZTc4Y2E4ZWRlZjY1Yzg3NTg3OmM2NDU1NjhhOTI3NzQ1YTY5NmUwZTUyZTU4NzFiZTgz"
    And form field username = '7977558623'
    And form field password = 'Test@1357'
    And form field grant_type = 'password'
    When method post
    Then status 200
#    * def access_token_response = response
#    * print access_token_response["access_token"]
