@ignore
Feature: create merchant branches

  Background:
    * url baseUrl
    * def mer_list = []
    * def login = callonce read('loginToCMS.feature')
    * def xAntiForgery = $login.responseHeaders['x-anti-forgery'][0]
    * def apiComponents = read('../helperFiles/files/apiComponents.json')
    * def merchantID_generator = callonce read(("merchant.feature@merchantCreation"))
    * header Cookie = $login.responseHeaders['Set-Cookie'][0]
    * header Content-Type = 'application/x-www-form-urlencoded'

  @merchantBranch
  Scenario Outline: create merchant branches
    * def responseBodyMerchantID = $merchantID_generator.response
    * set apiComponents['apiBody']['data_merchant_branch'][0]['merchant'] = responseBodyMerchantID
    * set apiComponents['apiBody']['data_merchant_branch'][1]['merchant'] = responseBodyMerchantID
    * print apiComponents['apiBody']['data_merchant_branch']
    Given path '/v1/cms/merchant/'+ <merchantId> +'/address'
    And form fields <body>
    And header x-anti-forgery = xAntiForgery
    When method post
    Then status 200

    Examples:
    |body                                               |merchantId            |
    |apiComponents['apiBody']['data_merchant_branch'][0]|responseBodyMerchantID|
    |apiComponents['apiBody']['data_merchant_branch'][1]|responseBodyMerchantID|


  Scenario: cms logout
    Given path '/v1/cms/logout'
    And header x-anti-forgery = xAntiForgery
    When method get
    Then status 204