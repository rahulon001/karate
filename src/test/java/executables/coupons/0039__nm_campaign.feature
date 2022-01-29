@bxgy_parent
Feature: BxGy parent mark redeem flow __0039

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
   # * header x-client-type = "mpos"
    * def apiComponents = envConfig
    * def headerJson = {}
    * def login = call read('support.feature@login')
    * set headerJson.Cookie = $login.responseHeaders['Set-Cookie'][0]
    * set headerJson.X-Anti-Forgery = $login.responseHeaders['x-anti-forgery'][0]
    * set headerJson.Content-Type = 'application/json'

 #   * def DBUtils = Java.type('executables.utils.DBUtils')
#    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])
  #  * def helperMethods = Java.type('executables.utils.HelperMethods')
  #  * json result = callonce read("B2C_B2B_CouponCodeGeneration.feature@B2C_BxGy_combined_cart_verification")

  Scenario: Add NM campaign__0039
    * def body =
    """
      {
        "campaignCategory": 1,
        "startDate": "09-Jul-2021 03:02",
        "endDate": "31-Aug-2029 23:59",
        "b2bCouponIds": [
          81,
          82
        ],
        "validityPeriod": 5,
        "cities": [
          " Ghansoli"
        ],
        "pincodes": [
          "110001"
        ],
        "states": [
          "MH"
        ],
        "includeCity": true,
        "includePin": true,
        "includeState": true
      }

    """

    Given url  baseUrl+'/coupons/v1/coupons/new-merchant-campaign/'
    And request body
    And headers headerJson
    When method post
    Then status 200

  Scenario: Add NM campaign__0039- end date/time < start date/time. Negative case
    * def body =
    """
      {
        "campaignCategory": 1,
        "startDate": "09-Jul-2021 03:02",
        "endDate": "08-Jul-2021 03:00",
        "b2bCouponIds": [
          81,
          82
        ],
        "validityPeriod": 5,
        "cities": [
          " Ghansoli"
        ],
        "pincodes": [
          "110001"
        ],
        "states": [
          "MH"
        ],
        "includeCity": true,
        "includePin": true,
        "includeState": true
      }

    """

    Given url  baseUrl+'/coupons/v1/coupons/new-merchant-campaign/'
    And request body
    And headers headerJson
    When method post
    Then status 400

  Scenario: Add NM campaign__0039- end date/time,start date/time as 00 00.
    * def body =
    """
      {
        "campaignCategory": 1,
        "startDate": "09-Jul-2021 00:12",
        "endDate": "31-Aug-2029 21:00",
        "b2bCouponIds": [
          81,
          82
        ],
        "validityPeriod": 5,
        "cities": [
          " Ghansoli"
        ],
        "pincodes": [
          "110001"
        ],
        "states": [
          "MH"
        ],
        "includeCity": true,
        "includePin": true,
        "includeState": true
      }

    """

    Given url  baseUrl+'/coupons/v1/coupons/new-merchant-campaign/'
    And request body
    And headers headerJson
    When method post
    Then status 200

  Scenario: edit NM campaign__0039
    Given url  baseUrl+ '/coupons/v1/coupons/new-merchant-campaign/'
    And params {page: 1, page-size: 10}
    And headers headerJson
    When method get
    Then status 200
    * def id =  response.campaigns[0].id

    * def body =
    """
      {
        "startDate": "09-Jul-2021 03:02",
        "endDate": "31-Aug-2021 23:59",
        "validityPeriod": 1,
        "cities": [
        " Ghansoli"
        ],
        "pincodes": [
          "110001"
        ],
        "states": [
          "AD"
        ]
      }
    """
    Given url  baseUrl+ '/coupons/v1/coupons/new-merchant-campaign/'+id
    And request body
    And headers headerJson
    When method put
    Then status 200

  Scenario: List NM campaign__0039
    Given url  baseUrl+ '/coupons/v1/coupons/new-merchant-campaign/'
    And params {page: 1, page-size: 10}
    And headers headerJson
    When method get
    Then status 200

  Scenario Outline: Download NM campaign__0039
    Given url  baseUrl+'/coupons/v1/coupons/new-merchant-campaign/'
    And params {page: 1, page-size: 10}
    And headers headerJson
    When method get
    Then status 200
    * def id =  response.campaigns[0].id
    * print "<============== file_description ==============>", "<scenario>"
    Given url  baseUrl+<path>
   And headers headerJson
    When method get
    * print "---------DOWNLOAD---",response
    Then match responseStatus == <Status>


    Examples:
      |path                                                              |   Status    | scenario             |
      |'/coupons/v1/coupons/new-merchant-campaign/download/'+id          |  200        |  Valid nm campaign   |
      |'/coupons/v1/coupons/new-merchant-campaign/download/'             |  404        | null nm campaign     |
      | '/coupons/v1/coupons/new-merchant-campaign/download/&'           |  400        |  junk                |

  Scenario Outline: View NM campaign__0039
    Given url  baseUrl+ '/coupons/v1/coupons/new-merchant-campaign/'
    And params {page: 1, page-size: 10}
    And headers headerJson
    When method get
    Then status 200
    * def id =  response.campaigns[0].id
    * print "<============== file_description ==============>", "<scenario>"
    Given url  baseUrl+<path>
    And headers headerJson
    When method get
    Then match responseStatus == <Status>

    Examples:
      |path                                                     |   Status    | scenario             |
      |'/coupons/v1/coupons/new-merchant-campaign/'+id          |  200        |  Valid nm campaign   |
      |'/coupons/v1/coupons/new-merchant-campaign/'             |  200        | null nm campaign     |
      | '/coupons/v1/coupons/new-merchant-campaign/&'           |  400        |  junk                |