@ignore
Feature: Perform B2B mark redemption multi-redeem flow with vouchers

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * def apiComponents = envConfig
    * def schemaAndValidation = envSchema
    * header Content-Type = 'application/json'
    * header x-client-type = "mpos"
    * def headerJson = {}
    * def redeem_flags = "true"
    * set headerJson.multi_redeem-enabled = redeem_flags
    * set headerJson.Content-Type = 'application/json'
    * set headerJson.x-client-type = 'mpos'
    * def result = callonce read("B2C_B2B_CouponCodeGeneration.feature@B2B_coupon_redemption") {requestHeader: #(headerJson)}
    * def couponCode1 = result.response["skuCoupons"][0]["coupons"][0]["couponCode"]
    * def couponCode2 = result.response["skuCoupons"][1]["coupons"][0]["couponCode"]
    * def couponCode3 = result.response["skuCoupons"][2]["coupons"][0]["couponCode"]
    * def couponCode4 = result.response["skuCoupons"][3]["coupons"][0]["couponCode"]
    * def couponCode5 = result.response["skuCoupons"][4]["coupons"][0]["couponCode"]
    * def VoucherCode1 = result.response["billVouchers"][0]["redeemCode"]
    * def skuId1 = result.response["skuCoupons"][0]["skuId"]
    * def skuId2 = result.response["skuCoupons"][1]["skuId"]
    * def skuId3 = result.response["skuCoupons"][2]["skuId"]
    * def skuId4 = result.response["skuCoupons"][3]["skuId"]
    * def skuId5 = result.response["skuCoupons"][4]["skuId"]
    * def couponQuantity1 = result.response["skuCoupons"][0]["coupons"][0]["couponQty"]
    * def couponQuantity2 = result.response["skuCoupons"][1]["coupons"][0]["couponQty"]
    * def couponQuantity3 = result.response["skuCoupons"][2]["coupons"][0]["couponQty"]
    * def couponQuantity4 = result.response["skuCoupons"][3]["coupons"][0]["couponQty"]
    * def couponQuantity5 = result.response["skuCoupons"][4]["coupons"][0]["couponQty"]
    * def skuQty1 = result.response["skuCoupons"][0]["quantity"]
    * def skuQty2 = result.response["skuCoupons"][1]["quantity"]
    * def skuQty3 = result.response["skuCoupons"][2]["quantity"]
    * def skuQty4 = result.response["skuCoupons"][3]["quantity"]
    * def skuQty5 = result.response["skuCoupons"][4]["quantity"]
    * def skuPrice1 = result.response["skuCoupons"][0]["price"]
    * def skuPrice2 = result.response["skuCoupons"][1]["price"]
    * def skuPrice3 = result.response["skuCoupons"][2]["price"]
    * def skuPrice4 = result.response["skuCoupons"][3]["price"]
    * def skuPrice5 = result.response["skuCoupons"][4]["price"]
    *  def transactionID =
    """
      function(){ return java.lang.System.currentTimeMillis() }
    """
    * def transaction_id = callonce transactionID
    * def masid = apiComponents['CMS_masid']
    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])


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
          "couponCodes":[#(couponCode1), #(couponCode2), #(couponCode3), #(couponCode4), #(couponCode5), #(VoucherCode1)],
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
          },
            {
            "skuId": "#(skuId3)",
            "skuQty": #(skuQty3),
            "skuPrice": #(skuPrice3),
            "articleId" : "lol",
            "coupons" : [{
                "couponCode": #(couponCode3),
                "quantity" : #(couponQuantity3)
            }],
          },
          {
            "skuId": "#(skuId4)",
            "skuQty":  #(skuQty4),
            "skuPrice": #(skuPrice4),
            "articleId" : "lol",
            "coupons" : [{
                "couponCode": #(couponCode4),
                "quantity" : #(couponQuantity4)
            }],
          },
           {
            "skuId": "#(skuId5)",
            "skuQty":  #(skuQty5),
            "skuPrice": #(skuPrice5),
            "articleId" : "lol",
            "coupons" : [{
                "couponCode": #(couponCode5),
                "quantity" : #(couponQuantity5)
            }],
          }
        ]
      }
    """
    Given path '/coupons/v1/coupons/merchant/fc/checkout'
    And request body
    When method post
    Then status 200

    * def COUPONCODE_status = db.readRows("SELECT * FROM B2BCOUPONMAPPING WHERE COUPONCODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode3+ "\',\'" +couponCode4+ "\',\'" +couponCode5+ "\',\'" +VoucherCode1+ "\')")
    * print COUPONCODE_status

    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (SELECT CONSTITUENTCOUPONCODE FROM B2BCOUPONMAPPING WHERE COUPONCODE in (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode3+ "\',\'" +couponCode4+ "\',\'" +couponCode5+ "\',\'" +VoucherCode1+ "\'))")
    * print coupon_code_status

    * def b2b_coupons = db.readRows("SELECT * FROM B2B_COUPON WHERE ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[2]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[3]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[4]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupons

    * def b2b_coupon_redemption = db.readRows("SELECT * FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[2]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[3]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[4]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupon_redemption

    * def schema = schemaAndValidation["checkout_FC_merchant_coupon"]
    * match each coupon_code_status == schema

  Scenario: B2B deliver B2BMarkRedemptionFlow.
    * header x-client-type = "hybris"
    * def body  =
    """
    {
      "couponCodes":[#(couponCode1), #(couponCode2), #(couponCode3), #(couponCode4), #(couponCode5), #(VoucherCode1)],
      "coupons" : [{
                      "couponCode": #(couponCode1),
                      "quantity" : #(couponQuantity1)
                  },
                  {
                      "couponCode": #(couponCode2),
                      "quantity" : #(couponQuantity2)
                  },
                  {
                      "couponCode": #(couponCode3),
                      "quantity" : #(couponQuantity3)
                  },
                  {
                      "couponCode": #(couponCode4),
                      "quantity" : #(couponQuantity4)
                  },
                  {
                      "couponCode": #(couponCode5),
                      "quantity" : #(couponQuantity5)
                  }],
      "masId": "#(masid)",
     }
    """
    Given path '/coupons/v1/coupons/merchant/fc/delivered'
    And request body
    When method post
    Then status 200

    * def COUPONCODE_status = db.readRows("SELECT * FROM B2BCOUPONMAPPING WHERE COUPONCODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode3+ "\',\'" +couponCode4+ "\',\'" +couponCode5+ "\',\'" +VoucherCode1+ "\')")
    * print COUPONCODE_status

    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (SELECT CONSTITUENTCOUPONCODE FROM B2BCOUPONMAPPING WHERE COUPONCODE in (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode3+ "\',\'" +couponCode4+ "\',\'" +couponCode5+ "\',\'" +VoucherCode1+ "\'))")
    * print coupon_code_status

    * def b2b_coupons = db.readRows("SELECT * FROM B2B_COUPON WHERE ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[2]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[3]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[4]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupons

    * def b2b_coupon_redemption = db.readRows("SELECT * FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[2]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[3]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[4]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupon_redemption

    * def schema = schemaAndValidation["delivered_FC_merchant_coupon"]
    * match each coupon_code_status == schema

    * def update_return_upto = db.updateRow("UPDATE FC_MERCHANT_COUPONS SET DELIVERED_TS = CURRENT_TIMESTAMP - 20 WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode3+ "\',\'" +couponCode5+ "\')")
    * def update_voucher_deliverTS = db.updateRow("UPDATE VOUCHER_REDEMPTION SET DELIVERED_TS = CURRENT_TIMESTAMP - 20 WHERE REDEEM_CODE IN (\'" +VoucherCode1+ "\')")


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
