@conditional_coupon_mark_redeem_MAS @conditionalCoupon
Feature: Perform B2B_conditional_coupon mark redemption flow for MAS merchant group.

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
    * def result = callonce read("B2C_B2B_CouponCodeGeneration.feature@B2B_conditional_coupon_redemption_MAS_merchant")  {requestHeader: #(headerJson)}

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
    * def masid = apiComponents['MAS_masId']
    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])

  Scenario: merchant checkout B2BMarkRedemptionFlow.
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\')")
    * print coupon_code_status
    * def schema = schemaAndValidation["hold_FC_merchant_coupon"]
    And match each coupon_code_status == schema

  Scenario: merchant checkout B2BMarkRedemptionFlow.
    * def discountAmount = apiComponents['discountAmount_multi_redeem']
    * def newBillAmount = apiComponents['newBillAmount_multi_redeem']
    * header override_flag = redeem_flags
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
#    And match response["discountAmount"] == discountAmount
#    And match response["newBillAmount"] == newBillAmount
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\')")
    * print coupon_code_status
    * def b2b_coupons = db.readRows("SELECT * FROM B2B_COUPON WHERE ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupons
    * def b2b_coupon_redemption = db.readRows("SELECT * FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupon_redemption
    * def b2b_conditional_coupons = db.readRows("SELECT * FROM B2B_COUPON WHERE DERIVED_FROM IN (\'" +apiComponents["conditional_coupon_MAS_derived_from"]+ "\')")
    * print b2b_conditional_coupons
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
    * def b2b_conditional_coupons = db.readRows("SELECT * FROM B2B_COUPON WHERE DERIVED_FROM IN (\'" +apiComponents["conditional_coupon_derived_from"]+ "\')")
    * print b2b_conditional_coupons
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