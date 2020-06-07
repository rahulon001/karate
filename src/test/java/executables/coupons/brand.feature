@ignore
Feature: create brands.

  Background:
    * url baseUrl
    * def login = callonce read('loginToCMS.feature')
    * def xAntiForgery = $login.responseHeaders['x-anti-forgery'][0]
    * header Cookie = $login.responseHeaders['Set-Cookie'][0]
    * header Content-Type = 'multipart/form-data'
    * def ExternalId = function(){ return java.lang.System.currentTimeMillis() }
    * def apiComponents = read('../helperFiles/files/apiComponents.json')

  Scenario: create brand
    * set apiComponents['apiBody']['data_create_brand']['name'] = ExternalId() + " Automated"
    * set apiComponents['apiBody']['data_create_brand']['desc'] = "Brand created for ExternalId(): "+ ExternalId()
    * set apiComponents['apiBody']['data_create_brand']['ExternalId'] = ExternalId()
    * print apiComponents['apiBody']['data_add_merchants']
    * print apiComponents['apiBody']['file_add_merchants']

    Given path '/v1/cms/brands/'
    And multipart file image = apiComponents['apiBody']['file_create_brand']
    And multipart fields myMessage = apiComponents['apiBody']['data_create_brand']
    And header x-anti-forgery = xAntiForgery
    When method post
    Then status 200

  Scenario: cms logout
    Given path '/v1/cms/logout'
    And header x-anti-forgery = xAntiForgery
    When method get
    Then status 204