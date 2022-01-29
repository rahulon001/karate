Feature: create merchant group

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * def login = callonce read('support.feature@login')
    * def headerJson = {}
    * set headerJson.Cookie = $login.responseHeaders['Set-Cookie'][0]
    * set headerJson.X-Anti-Forgery = $login.responseHeaders['x-anti-forgery'][0]
    * set headerJson.Content-Type = 'application/json'
    * def apiComponents = envConfig
    * def groupName = function(){ return java.lang.System.currentTimeMillis() }
    * def mas_merchant_group = apiComponents.masMerchantGroup
    * def cms_merchant_group = apiComponents.cmsMerchantGroup


  @merchantGroup
  Scenario: create cms merchant group
    * set apiComponents['data_merchant_group']['name'] = "merchant_group"+ groupName()

    Given url baseUrl+'/v1/cms/merchant-group/'
    And  request apiComponents['data_merchant_group']
    And headers headerJson
    When method post
    Then status 200

  @MASmerchantGroup1
  Scenario Outline: create MAS merchant group 1 <number>
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
    And headers headerJson
    When method post
    Then status 200

    Examples:
    |merchant_property|property_value|auto_refresh|number|
    |Payment Type     |501           |1           |1     |
    |Payment Type     |501           |0           |2     |
    |Payment Type     |601           |1           |3     |
    |State            |HR            |1           |4     |
    |State            |MH            |0           |5     |
    |State            |KA            |1           |6     |
    |Merchant Category|5511          |1           |7     |
    |Merchant Category|5231          |0           |8     |
    |City             |Bangalore     |1           |9     |
    |Pin              |560034        |0           |10    |

  @MASmerchantGroup2
  Scenario Outline: create MAS merchant group 2 <property_value1>
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
    And headers headerJson
    When method post
    Then status 200

    Examples:
      |merchant_property|property_value1|property_value2|auto_refresh|
      |City             |Bangalore      |Mumbai         |1           |
      |City             |Kolkata        |Mumbai         |0           |
      |Pin              |560034         |400701         |1           |


  @MASmerchantGroupView
  Scenario Outline: View MASMerchantGroup
    * print "<============== file_description ==============>", "<scenario>"
    Given <path_url> <path>
    And headers headerJson
    When method get
    Then status <status>

    Examples:
      |path                                     |status|scenario        |path_url|
      |'/v1/cms/mgdef/'+mas_merchant_group      | 200  |   valid mg     |path    |
      |baseUrl+'/v1/cms/mgdef/'                 | 404  |   null mg      |url     |
      |'/v1/cms/mgdef/&'                        | 400  |   junk mg      |path    |



  @MAS_merchant_count
  Scenario Outline: merchant count in mas merchant group
    Given path '/v1/cms/mg_count'
    * def body =
    """
       {
          "name": "test",
          "auto_refresh": "<auto_refresh>",
          "rules": [
            {
              "merchant_property": "<merchant_property>",
              "property_value": [
                "<property_value>"
              ]
            }
          ]
        }
    """
    And request body
    And headers headerJson
    When method post
    Then status 200
#    * match response["count"] == '#number'
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


  Scenario: Property Value
    Given path '/v1/cms/property_values'
    And headers headerJson
    When method get
    Then status 200

  Scenario: Property Value State
    Given path '/v1/cms/property_values/state'
    And headers headerJson
    And params {page: 1, page-size: 10}
    When method get
    Then status 200

  Scenario: Property Value City
    Given path '/v1/cms/property_values/city'
    And headers headerJson
    And params {page: 1, page-size: 10}
    When method get
    Then status 200

  Scenario: Property Value Pin
    Given path '/v1/cms/property_values/pin'
    And headers headerJson
    And params {page: 1, page-size: 10}
    When method get
    Then status 200

  Scenario Outline: create MAS merchant group-check duplicate group name not allowed <property_value1>
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
    And headers headerJson
    When method post
    Then status 200

    Given url  baseUrl+ '/v1/cms/merchant-group/'
    And headers headerJson
    And params {page: 1, page-size: 10}
    When method get
    Then status 200
    * match response.data[0].name == name
    * def id = response.data[0].id

    * url baseUrl
    Given path '/v1/cms/mgdef'
    And request body
    And headers headerJson
    When method post
    Then status 400
    * match response.message == "Group Name already exists"

    Given url  baseUrl+ '/v1/cms/merchant-group/'
    And headers headerJson
    And params {page: 1, page-size: 10}
    When method get
    Then status 200
    * match response.data[0].id == id

    Examples:
      |merchant_property|property_value1|property_value2|auto_refresh|
      |City             |Bangalore      |Mumbai         |1           |


  @ignore
  Scenario: cms logout
    * def logout = callonce read('support.feature@logout') {requestHeader: #(headerJson)}

