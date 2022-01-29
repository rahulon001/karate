@ignore
Feature: create merchant

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * def login = call read('support.feature@login')
    * def headerJson = {}
    * set headerJson.Cookie = $login.responseHeaders['Set-Cookie'][0]
    * set headerJson.X-Anti-Forgery = $login.responseHeaders['x-anti-forgery'][0]
    * set headerJson.Content-Type = 'multipart/form-data'
    * def apiComponents = envConfig
    * def masID = function(){ return java.lang.System.currentTimeMillis() }

  @merchantCreation
  Scenario: create merchant
    * set apiComponents['data_add_merchants']['masId'] = masID()
    * set apiComponents['data_add_merchants']['name'] = "merchant "+ masID()
    * print apiComponents['data_add_merchants']
    Given path '/v1/cms/admin/merchants'
    And multipart file image = apiComponents['file_add_merchants']
    And multipart fields myMessage = apiComponents['data_add_merchants']
    And headers headerJson
    When method post
    Then status 200


  @ignore
  Scenario: cms logout
    * def logout = callonce read('support.feature@logout') {requestHeader: #(headerJson)}
