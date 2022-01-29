Feature: Perform mark redeem for conditional coupon generated and redemption via b2b coupon.

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * def apiComponents = envConfig
    * def schemaAndValidation = envSchema
    * header Content-Type = 'application/json'
    * header x-client-type = "mpos"
    * def headerJson = {}
    * def redeem_flags = "false"
    * set headerJson.multi_redeem-enabled = redeem_flags
    * set headerJson.Content-Type = 'application/json'
    * set headerJson.x-client-type = 'mpos'
    * def result0 = callonce read("0036.8__B2B_FLAT_DISCOUNT_ON_SKU_MarkRedemptionFlow_generation_of_conditional_coupon.feature@conditional_coupon_mark_redeem_CMS")
    * def result = callonce read("B2C_B2B_CouponCodeGeneration.feature@B2B_conditional_coupon_redeeming_CMS") {requestHeader: #(headerJson)}
    * def couponCode1 = result.response["skuCoupons"][0]["coupons"][0]["couponCode"]
    * def skuId1 = result.response["skuCoupons"][0]["skuId"]
    * def couponQuantity1 = result.response["skuCoupons"][0]["coupons"][0]["couponQty"]
    * def skuQty1 = result.response["skuCoupons"][0]["quantity"]
    * def skuPrice1 = result.response["skuCoupons"][0]["price"]

    *  def transactionID =
    """
      function(){ return java.lang.System.currentTimeMillis() }
    """
    * def transaction_id = callonce transactionID
    * def masid = apiComponents['CMS_masid']
    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])

  Scenario: merchant checkout B2BMarkRedemptionFlow.
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\')")
    * print coupon_code_status
    * def schema = schemaAndValidation["hold_FC_merchant_coupon"]
    * match each coupon_code_status == schema

  Scenario: merchant checkout B2BMarkRedemptionFlow.
    * header override_flag = redeem_flags
    * def discountAmount = apiComponents['discountAmount_multi_redeem']
    * def newBillAmount = apiComponents['newBillAmount_multi_redeem']
    * def body =
    """
        {
          "masId": "#(masid)",
          "billAmount": 1000,
          "transactionId": "#(transaction_id)",
          "couponCodes":[#(couponCode1)],
          "skuData": [
          {
            "skuId": "#(skuId1)",
            "skuQty": #(skuQty1),
            "skuPrice": #(skuPrice1),
            "articleId" : "lol",
            "coupons" : [{
                "couponCode": #(couponCode1),
                "quantity" : #(couponQuantity1)
            }],
          }
        ]
      }
    """
    Given path '/coupons/v1/coupons/merchant/fc/checkout'
    And request body
    When method post
    Then status 200
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\')")
    * print coupon_code_status
    * def b2b_coupons = db.readRows("SELECT * FROM B2B_COUPON WHERE ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupons
    * def b2b_coupon_redemption = db.readRows("SELECT * FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupon_redemption
    * def schema = schemaAndValidation["checkout_FC_merchant_coupon"]
    And match each coupon_code_status == schema

  Scenario: B2B deliver B2BMarkRedemptionFlow.
    * header x-client-type = "hybris"
    * def body  =
    """
    {
      "couponCodes":[],
      "coupons" : [{
                      "couponCode": #(couponCode1),
                      "quantity" : #(couponQuantity1)
                  }],
      "masId": "#(masid)",
     }
    """
    Given path '/coupons/v1/coupons/merchant/fc/delivered'
    And request body
    When method post
    Then status 200
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\')")
    * print coupon_code_status
    * def b2b_coupons = db.readRows("SELECT * FROM B2B_COUPON WHERE ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupons
    * def b2b_coupon_redemption = db.readRows("SELECT * FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupon_redemption
    * def schema = schemaAndValidation["delivered_FC_merchant_coupon"]
    And match each coupon_code_status == schema
    * def update_return_upto = db.updateRow("UPDATE FC_MERCHANT_COUPONS SET DELIVERED_TS = CURRENT_TIMESTAMP - 20 WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\')")


  Scenario: merchant mark redeem B2BMarkRedemptionFlow.
    * def body  =
    """
    {
    }
    """
    Given path '/coupons/v1/coupons/merchant/fc/mark-redeemed'
    And request body
    When method post
    Then status 200

  Scenario: Switching off the features 2.
    * def call_configuration_table = callonce read('support.feature@switch_off_features')
