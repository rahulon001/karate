Feature:B2B Coupon track history __0049

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * def apiComponents = envConfig
    * def headerJson = {}
    * def login = callonce read('support.feature@login')
    * set headerJson.Cookie = $login.responseHeaders['Set-Cookie'][0]
    * set headerJson.X-Anti-Forgery = $login.responseHeaders['x-anti-forgery'][0]
    * set headerJson.Content-Type = 'application/json'
    * def masid = apiComponents['CMS_masid']

    *  def transactionID =
    """
      function(){ return java.lang.System.currentTimeMillis() }
    """
    * def transaction_id = callonce transactionID
    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])

  Scenario Outline: track history of Old data.
    Given path '/coupons/v1/coupons/track-history/<offerType>/'+ <entity_data>
    And headers headerJson
    When method GET
    Then status 200
    * print "<============>", response
    * def schema =
      """
          {
          "offerType": <offerType>,
          "jobType": #string,
          "offerId": #string,
          "updatedAt": #string,
          "updatedBy": #string,
          "metadata": #string
          }
      """
    And match each response.offerHistory[*] == schema

    Examples:
      |offerType     |entity_data|
      |b2b-coupon    |apiComponents['tracking_B2B_COUPON'] |
      |b2c-coupon    |apiComponents['tracking_B2C_COUPON']    |
      |voucher       |apiComponents['tracking_VOUCHER']    |
      |merchant-group|apiComponents['tracking_MERCHANT_GROUP']|
      |promotion     |apiComponents['tracking_PROMOTION']   |
      |b2b-campaign  |apiComponents['tracking_B2B_CAMPAIGN'] |
      |b2b-campaign  |apiComponents['tracking_B2B_CAMPAIGN'] |


  Scenario Outline: track history of Old data negative.
    Given path '/coupons/v1/coupons/track-history/<offerType>/'+ <entity_data>
    And headers headerJson
    When method GET
    Then status 400

    Examples:
      |offerType     |entity_data|
      |b2b-campaign1  |apiComponents['tracking_B2B_CAMPAIGN'] |