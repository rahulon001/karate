Feature: b2b campaign category

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * def login = callonce read('support.feature@login')
    * def headerJson = {}
    * set headerJson.Cookie = $login.responseHeaders['Set-Cookie'][0]
    * set headerJson.X-Anti-Forgery = $login.responseHeaders['x-anti-forgery'][0]
    * set headerJson.Content-Type = 'application/json'
    * def apiComponents = envConfig
    * def schemaAndValidation = envSchema
    * def helperMethods = Java.type('executables.utils.HelperMethods')
    * def campaign_Category_ID = helperMethods.getRandomString(10)

  Scenario: Get all B2B categories
    Given path "/v1/b2b-campaign-category"
    And headers headerJson
    And params {page:1, page-size:"10"}
    When method get
    Then status 200

  Scenario: Create new B2B categories
    * set headerJson.Content-Type = 'multipart/form-data'
    Given path "/v1/b2b-campaign-category"
    And headers headerJson
    And multipart field name = 'Automation' + campaign_Category_ID
    When method post
    Then status 200

  Scenario: update new B2B categories
    * def cc = apiComponents['campaignCategoryToUpdate']
    * set headerJson.Content-Type = 'multipart/form-data'
    Given path "/v1/b2b-campaign-category/"+cc
    And headers headerJson
    And multipart field name = 'Automation' + campaign_Category_ID
    When method put
    Then status 200

  Scenario: Download all B2B categories
    Given path "/v1/b2b-campaign-category/downloadAllCsv"
    And headers headerJson
    When method get
    Then status 200
