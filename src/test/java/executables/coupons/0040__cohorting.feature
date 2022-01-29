Feature: Cohorting __0040

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * header x-client-type = "mpos"
    * def apiComponents = envConfig
    * def headerJson = {}
    * def login = call read('support.feature@login')
    * set headerJson.Cookie = $login.responseHeaders['Set-Cookie'][0]
    * set headerJson.X-Anti-Forgery = $login.responseHeaders['x-anti-forgery'][0]
    * set headerJson.Content-Type = 'application/json'
    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])
    * def helperMethods = Java.type('executables.utils.HelperMethods')
    * def mas_merchant_group = apiComponents.masMerchantGroup
    * def cms_merchant_group = apiComponents.cmsMerchantGroup

  Scenario Outline: Downloading merchant  __0040.
    * def body =
    """
      {"merchantGroupIds":"<masID>"}
    """
    Given path '/v1/cms/merchant-group/merchants/download'
    And request body
    And headers headerJson
    When method post
    Then status 200
    * print response
    * csv response_new = response
  #  * print "***********NEW***********",response_new
    * match response_new[0] ==
    """
        {
        "MERCHANT_GROUP_ID": "#string",
        "NAME": "#string",
        "MAS_GROUP": "#string",
        "TOTAL_MERCHANTS": "#string",
        "MERCHANT_IDS": "##string",
        "MAS_IDS": "##string",
        "GROUP_RULES": "##string",
        "EXCLUDED_MERCHANTS": "##string"
        }
    """

    Examples:
    |masID|
    |581  |
    |67   |

