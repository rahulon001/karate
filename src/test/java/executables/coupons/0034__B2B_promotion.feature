@ignore
Feature: B2B_promotion __0034

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

  Scenario: B2B_SKU_AT_FIXED_PRICE promotion verification __0034.

    * def result = call read("B2C_B2B_CouponCodeGeneration.feature@B2B_SKU_AT_FIXED_PRICE_coupon_redemption") {requestHeader: #(headerJson) , skuPrice: 11.4, billAmount: #(apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption__0025"].billAmount)}
    * print result

     #promotion applied schema validation
    * def schema_promotionsApplied = schemaAndValidation.promotion.promotionsApplied[0]
    * print ">>>>>schema_promotionsApplied<<<<<", schema_promotionsApplied

    * def b2b_promotion_applied = result.response.promotionsApplied[0]
    * print "<<<<b2b_promotion_applied>>>>", b2b_promotion_applied
    * match b2b_promotion_applied == schema_promotionsApplied

    #promotion metadata schema validation
    * def schema_promotionMetaData = schemaAndValidation.promotion.promotionMetaData.AutomationPromo2
    * print ">>>>>schema_promotionMetaData<<<<<", schema_promotionMetaData

    * def promotion_metaData = result.response.promotionMetaData.AutomationPromo2
    * print "<<<<promotion_metaData>>>>", promotion_metaData
    * match promotion_metaData == schema_promotionMetaData

  Scenario: B2B_PERCENT_DISCOUNT prompter verification __0034.

    * def result = call read("B2C_B2B_CouponCodeGeneration.feature@B2B_PERCENT_DISCOUNT_coupon_redemption") {requestHeader: #(headerJson), skuPrice: 12.6, billAmount: 2333}

    #promotion applied schema validation
    * print ">>>>>schema_promotionsApplied<<<<<", schemaAndValidation.promotion.promotionsApplied[0]
    * def schema_promotionsApplied = schemaAndValidation.promotion.promotionsApplied[0]
    * print ">>>>>schema_promotionsApplied<<<<<", schema_promotionsApplied

    * print "<<<<b2b_promotion_applied>>>>", result.response.promotionsApplied[0]
    * def b2b_promotion_applied = result.response.promotionsApplied[0]
    * print "<<<<b2b_promotion_applied>>>>", b2b_promotion_applied

    * match b2b_promotion_applied == schema_promotionsApplied

    #promotion metadata schema validation
    * print ">>>>>schema_promotionMetaData<<<<<", schemaAndValidation.promotion.promotionMetaData
    * def schema_promotionMetaData = schemaAndValidation.promotion.promotionMetaData
    * print ">>>>>schema_promotionMetaData<<<<<", schema_promotionMetaData.AutomationPromo2

    * print "<<<<promotion_metaData>>>>", result.response.promotionMetaData.AutomationPromo1
    * def promotion_metaData = result.response.promotionMetaData.AutomationPromo1
    * print "<<<<promotion_metaData>>>>", promotion_metaData

    * match promotion_metaData == schema_promotionMetaData.AutomationPromo2

  Scenario: Switching off the features __0034.
    * def call_configuration_table = callonce read('support.feature@switch_off_features')
    * def call_configuration_table_b2b = callonce read('support.feature@switch_off_features_b2b')