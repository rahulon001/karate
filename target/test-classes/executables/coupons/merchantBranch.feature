@ignore
Feature: create merchant branches

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * def mer_list = []
    * def login = callonce read('support.feature@login')
    * def headerJson = {}
    * set headerJson.Cookie = $login.responseHeaders['Set-Cookie'][0]
    * set headerJson.X-Anti-Forgery = $login.responseHeaders['x-anti-forgery'][0]
    * set headerJson.Content-Type = 'application/x-www-form-urlencoded'
    * def apiComponents = envConfig
    * def merchantID_generator = callonce read('merchant.feature@merchantCreation')

  @merchantBranch
  Scenario Outline: create merchant branches
    * def responseBodyMerchantID = $merchantID_generator.response
    * set apiComponents['data_merchant_branch'][0]['merchant'] = responseBodyMerchantID
    * set apiComponents['data_merchant_branch'][1]['merchant'] = responseBodyMerchantID
    * print apiComponents['data_merchant_branch']
    Given path '/v1/cms/merchant/'+ <merchantId> +'/address'
    And form fields <body>
    And headers headerJson
    When method post
    Then status 200

    Examples:
    |body                                               |merchantId            |
    |apiComponents['data_merchant_branch'][0]|responseBodyMerchantID|
    |apiComponents['data_merchant_branch'][1]|responseBodyMerchantID|

  @logout
  Scenario: cms logout
    * def logout = callonce read('support.feature@logout') {requestHeader: #(headerJson)}
