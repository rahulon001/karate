@ignore1
Feature: B2B flash coupon verification  __0037

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * def apiComponents = envConfig
    * def schemaAndValidation = envSchema
    * header Content-Type = 'application/json'
    * header x-client-type = "mpos"
    * def redeem_flags = "false"
    * def headerJson = {}
    * set headerJson.multi_redeem-enabled = redeem_flags
    * set headerJson.Content-Type = 'application/json'
    * set headerJson.x-client-type = 'mpos'

    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])

    * def masid = apiComponents['CMS_masid']

    *  def transactionID =
    """
      function(){ return java.lang.System.currentTimeMillis() }
    """
    * def transaction_id = callonce transactionID

  Scenario Outline:  Old and new coupons in replacement API Flow __0037 when b2b percent and fixed is off
    * def call_configuration_table_b2b = callonce read('support.feature@switch_off_features_b2b')
    * def body =
      """
          {
          "start" : 0,
          "end" : 1000,
          "sku": <skuid>
          }
      """
    Given path '/coupons/v1/coupons/merchant/'+masid+'/fc/coupons'
    And request body
    When method post
    Then status 200
    * print response
    * match <validations>
    * match each response.skus ==
    """
    {
      "id": "#string",
      "skuName": "#string",
      "totalDiscount": "#number",
      "earliestExpiryDate": "#number",
      "totalCouponCodes": "#number",
      "categories": "#[]",
      "coupons": "#[]"
       }
    """

    Examples:
      |skuid          |description                                            |validations                            |
      |"8111432122121"| Flat discount without records in b2b_discount_mapping |response.skus[0].id == "8111432122121" |
      |"811143212223"| Flat discount with records in b2b_discount_mapping     |response.skus[0].id == "811143212223"  |
      |"7111432122127"| % discount                                            |response.skus == []                    |
      |"711143212227" | % discount                                            |response.skus == []                    |
      |"8111432122127"| fixed discount                                        |response.skus == []                    |
      |"811143212227" | fixed discount                                         |response.skus == []                    |

  Scenario Outline:  Old and new coupons in replacement API Flow __0037 when b2b percent and fixed is on
    * def call_configuration_table_b2b = callonce read('support.feature@switch_on_features_b2b')
    * def body =
      """
          {
          "start" : 0,
          "end" : 1000,
          "sku": <skuid>
          }
      """
    Given path '/coupons/v1/coupons/merchant/'+masid+'/fc/coupons'
    And request body
    When method post
    Then status 200
    * print response
    * match <validations>
    * match each response.skus ==
    """
    {
      "id": "#string",
      "skuName": "#string",
      "totalDiscount": "#number",
      "earliestExpiryDate": "#number",
      "totalCouponCodes": "#number",
      "categories": "#[]",
      "coupons": "#[]"
       }
    """

    Examples:
      |skuid          |description                                            |validations                            |
      |"8111432122121"| Flat discount without records in b2b_discount_mapping |response.skus[0].id == "8111432122121" |
      |"811143212223"| Flat discount with records in b2b_discount_mapping     |response.skus[0].id == "811143212223"  |
      |"7111432122127"| % discount                                            |response.skus[0].id == "7111432122127"                    |
      |"711143212227" | % discount                                            |response.skus[0].id == "711143212227"                    |
      |"8111432122127"| fixed discount                                        |response.skus[0].id == "8111432122127"                   |
      |"811143212227" | fixed discount                                        |response.skus[0].id == "811143212227"                    |

  Scenario: Switching off the features __0043.1.
    * def call_configuration_table_b2b = callonce read('support.feature@switch_off_features_b2b')