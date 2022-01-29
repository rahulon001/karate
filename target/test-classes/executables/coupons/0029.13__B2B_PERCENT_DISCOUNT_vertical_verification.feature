Feature: B2B_PERCENT_DISCOUNT partial return flow __0029.1

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * def apiComponents = envConfig
    * def schemaAndValidation = envSchema
    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])
    * header Content-Type = 'application/json'
    * header x-client-type = "mpos"
    * def redeem_flags = "false"
    * def headerJson = {}
    * set headerJson.multi_redeem-enabled = redeem_flags
    * set headerJson.Content-Type = 'application/json'
    * set headerJson.x-client-type = 'mpos'

    * def call_configuration_table = callonce read('support.feature@switch_on_features')
    * def call_configuration_table = callonce read('support.feature@switch_on_features_b2b')
    * def call_configuration_table = callonce read('support.feature@switch_on_features_b2b_segment')


  Scenario Outline: B2B_PERCENT_DISCOUNT verify get eligible with verticals __0029.13.
    * def body = apiComponents["B2B_PERCENT_DISCOUNT_ON_SKU_coupon_redemption_vertical__0029.13"]
    * set body.segment = <verticals>
    * def result = call read("B2C_B2B_CouponCodeGeneration.feature@B2B_verticals_coupon_redemption") {requestHeader: #(headerJson) , skuPrice: 100, billAmount: 5000, api_body: #(body)}
    * def skuID = get result.response.skuCoupons[*].skuId
    * match skuID contains only <expected_Sku>

    Examples:
      |verticals|expected_Sku|
      |'horeca' |["711143212229","711143212228"]|
      |'KIRANA' |["711143212228","711143212230"]|
      |'All'    |["711143212228","711143212229","711143212230"]|

  Scenario: Switching off the features __0029.1.
    * def call_configuration_table = callonce read('support.feature@switch_off_features')
    * def call_configuration_table = callonce read('support.feature@switch_off_features_b2b')
    * def call_configuration_table = callonce read('support.feature@switch_off_features_b2b_segment')