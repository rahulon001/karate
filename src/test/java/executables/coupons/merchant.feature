@ignore
Feature: create merchant

  Background:
    * url baseUrl
    * def login = callonce read('loginToCMS.feature')
    * def xAntiForgery = $login.responseHeaders['x-anti-forgery'][0]
    * header Cookie = $login.responseHeaders['Set-Cookie'][0]
    * header Content-Type = 'multipart/form-data'
    * def apiComponents = read("../helperFiles/files/apiComponents.json")
    * def masID = function(){ return java.lang.System.currentTimeMillis() }

  @merchantCreation
  Scenario: create merchant
    * set apiComponents['apiBody']['data_add_merchants']['masId'] = masID()
    * set apiComponents['apiBody']['data_add_merchants']['name'] = "merchant "+ masID()
    * print apiComponents['apiBody']['data_add_merchants']

    Given path '/v1/cms/admin/merchants'
    And multipart file image = apiComponents['apiBody']['file_add_merchants']
    And multipart fields myMessage = apiComponents['apiBody']['data_add_merchants']
    And header x-anti-forgery = xAntiForgery
    When method post
    Then status 200

  Scenario: cms logout
    Given path '/v1/cms/logout'
    And header x-anti-forgery = xAntiForgery
    When method get
    Then status 204