@ignore
Feature: create merchant group

  Background:
    * url baseUrl
    * def login = callonce read('loginToCMS.feature')
    * def xAntiForgery = $login.responseHeaders['x-anti-forgery'][0]
    * header Cookie = $login.responseHeaders['Set-Cookie'][0]
    * header Content-Type = 'application/json'
    * def apiComponents = read('../helperFiles/files/apiComponents.json')
    * def groupName = function(){ return java.lang.System.currentTimeMillis() }

  @merchantGroup
  Scenario: create cms merchant group
    * def merchantBranch = callonce read("merchantBranch.feature@merchantBranch")
    * set apiComponents['apiBody']['data_merchant_group']['name'] = "merchant_group"+ groupName()
    * print apiComponents['apiBody']['data_merchant_group']

    Given path '/v1/cms/merchant-group/'
    And  request apiComponents['apiBody']['data_merchant_group']
    And header x-anti-forgery = xAntiForgery
    When method post
    Then status 200

  @MASmerchantGroup1
  Scenario Outline: create MAS merchant group 1
    * def name = "MAS_merchant_group"+ groupName()
    * def body =
    """
    {
      "name": "#(name)",
      "auto_refresh": "<auto_refresh>",

      "rules": [
        {
          "merchant_property": "<merchant_property>",
          "property_value": [
            "<property_value>"
          ]
        }
      ],
      "userGroup": 42
    }
    """

    Given path '/v1/cms/mgdef'
    And request body
    And header x-anti-forgery = xAntiForgery
    When method post
    Then status 200

    Examples:
    |merchant_property|property_value|auto_refresh|
    |Payment Type     |501           |1           |
    |Payment Type     |501           |0           |
    |Payment Type     |601           |1           |
    |State            |HR            |1           |
    |State            |MH            |0           |
    |State            |KA            |1           |
    |Merchant Category|5511          |1           |
    |Merchant Category|5231          |0           |
    |City             |Bangalore     |1           |
    |Pin              |560034        |0           |

  @MASmerchantGroup2
  Scenario Outline: create MAS merchant group 2
    * def name = "MAS_merchant_group"+ groupName()
    * def body =
    """
    {
      "name": "#(name)",
      "auto_refresh": "<auto_refresh>",

      "rules": [
        {
          "merchant_property": "<merchant_property>",
          "property_value": [
            "<property_value1>","<property_value2>"
          ]
        }
      ],
      "userGroup": 42
    }
    """

    Given path '/v1/cms/mgdef'
    And request body
    And header x-anti-forgery = xAntiForgery
    When method post
    Then status 200

    Examples:
      |merchant_property|property_value1|property_value2|auto_refresh|
      |City             |Bangalore      |Mumbai         |1           |
      |City             |Kolkata        |Mumbai         |0           |
      |Pin              |560034         |400701         |1           |



  Scenario: merchant count in mas merchant group


  Scenario: cms logout
    Given path '/v1/cms/logout'
    And header x-anti-forgery = xAntiForgery
    When method get
    Then status 204