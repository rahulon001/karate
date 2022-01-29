@conditionalCoupon
Feature: Perform B2B cancel coupon multi-redeem flow

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
    * def result = callonce read("B2C_B2B_CouponCodeGeneration.feature@B2B_ConditionalCoupon_redemption_merchant") {requestHeader: #(headerJson)}
    * def couponCode1 = result.response["skuCoupons"][0]["coupons"][0]["couponCode"]
    * def couponCode2 = result.response["skuCoupons"][1]["coupons"][0]["couponCode"]
    * def skuId1 = result.response["skuCoupons"][0]["skuId"]
    * def skuId2 = result.response["skuCoupons"][1]["skuId"]
    * def couponQuantity1 = result.response["skuCoupons"][0]["coupons"][0]["couponQty"]
    * def couponQuantity2 = result.response["skuCoupons"][1]["coupons"][0]["couponQty"]
    * def skuQty1 = result.response["skuCoupons"][0]["quantity"]
    * def skuQty2 = result.response["skuCoupons"][1]["quantity"]
    * def skuPrice1 = result.response["skuCoupons"][0]["price"]
    * def skuPrice2 = result.response["skuCoupons"][1]["price"]
    *  def transactionID =
    """
      function(){ return java.lang.System.currentTimeMillis() }
    """
    * def transaction_id = callonce transactionID
    * def masid = apiComponents['CMS_masid']
    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])

  Scenario: merchant checkout B2BMarkRedemptionFlow.
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\')")
    * print coupon_code_status
    * def schema = schemaAndValidation["hold_FC_merchant_coupon"]
    * match each coupon_code_status == schema

  Scenario: merchant checkout B2BMarkRedemptionFlow.
    * def discountAmount = apiComponents['discountAmount_multi_redeem']
    * def newBillAmount = apiComponents['newBillAmount_multi_redeem']
    * header override_flag = redeem_flags
    * def body =
    """
        {
          "masId": "#(masid)",
          "billAmount": 5000,
          "transactionId": "#(transaction_id)",
          "couponCodes":[#(couponCode1), #(couponCode2)],
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
          },
          {
            "skuId": "#(skuId2)",
            "skuQty":  #(skuQty2),
            "skuPrice": #(skuPrice2),
            "articleId" : "lol",
            "coupons" : [{
                "couponCode": #(couponCode2),
                "quantity" : #(couponQuantity2)
            }],
          }
        ]
      }
    """
    Given path '/coupons/v1/coupons/merchant/fc/checkout'
    And request body
    When method post
    Then status 200
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\')")
    * print coupon_code_status
    * def b2b_coupons = db.readRows("SELECT * FROM B2B_COUPON WHERE ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupons
    * def b2b_conditional_coupons = db.readRows("SELECT * FROM B2B_COUPON WHERE DERIVED_FROM IN (SELECT CONDITIONAL_COUPON_ID FROM B2B_COUPON WHERE ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\'))")
    * print b2b_conditional_coupons
    * def b2b_coupon_redemption = db.readRows("SELECT * FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupon_redemption
    * def schema = schemaAndValidation["checkout_FC_merchant_coupon"]
    And match each coupon_code_status == schema


  Scenario: merchant redeem B2BCancleCoupon.
    * def body  =
    """
    {
      "couponCodes":[#(couponCode1), #(couponCode2)],
      "coupons" : [{
                      "couponCode": #(couponCode1),
                      "quantity" : #(couponQuantity1)
                  },
                  {
                      "couponCode": #(couponCode2),
                      "quantity" : #(couponQuantity2)
                  }],
      "masId": "#(masid)",
     }
    """
    Given path '/coupons/v1/coupons/merchant/fc/delayed-cancel'
    And request body
    When method post
    Then status 200
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\')")
    * print coupon_code_status
    * def b2b_coupons = db.readRows("SELECT * FROM B2B_COUPON WHERE ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupons
    * def b2b_coupon_redemption = db.readRows("SELECT * FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupon_redemption
    * def schema = schemaAndValidation["cancelled_FC_merchant_coupon"]
    And match each coupon_code_status == schema
