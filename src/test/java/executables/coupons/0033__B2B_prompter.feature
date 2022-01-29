Feature: B2B_prompter __0033

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * def apiComponents = envConfig
    * def schemaAndValidation = envSchema
    * def redeem_flags = "false"
    * def headerJson = {}
    * set headerJson.multi_redeem-enabled = redeem_flags
    * set headerJson.Content-Type = 'application/json'
    * set headerJson.x-client-type = 'mpos'
    * def schema = schemaAndValidation["prompter"]

  Scenario: B2B_SKU_AT_FIXED_PRICE prompter verification __0033.
    * def result = call read("B2C_B2B_CouponCodeGeneration.feature@B2B_SKU_AT_FIXED_PRICE_coupon_redemption") {requestHeader: #(headerJson) , skuPrice: 11.4, billAmount: #(apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption__0025"].billAmount )}
    * def b2b_prompter1 = result.response.prompter
    * print "B2B_SKU_AT_FIXED_PRICE_prompter", b2b_prompter1
    * match each b2b_prompter1 == schema

  Scenario: B2B_PERCENT_DISCOUNT prompter verification __0033.
    * def result = call read("B2C_B2B_CouponCodeGeneration.feature@B2B_PERCENT_DISCOUNT_coupon_redemption") {requestHeader: #(headerJson), skuPrice: 12.3, billAmount : 3400}
    * def b2b_prompter2 = result.response.prompter
    * print "B2B_PERCENT_DISCOUNT_prompter", b2b_prompter2
    * match each b2b_prompter2 == schema

  Scenario: Switching off the features __0033.
    * def call_configuration_table = callonce read('support.feature@switch_off_features')
    * def call_configuration_table_b2b = callonce read('support.feature@switch_off_features_b2b')