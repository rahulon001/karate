Feature: B2B mark redeem flow from B2C percentage discount on sku __0042.3

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * header Content-Type = 'application/json'
    * header x-client-type = "mpos"
    * def apiComponents = envConfig
    * def schemaAndValidation = envSchema
    * def headerJson = {}
    * def redeem_flags = "false"
    * set headerJson.multi_redeem-enabled = redeem_flags
    * set headerJson.Content-Type = 'application/json'
    * set headerJson.x-client-type = 'mpos'
    * def b2c_discount_coupon_redemption = callonce read("0042.13__B2C_percentage_discount_on_SKU_markRedeem_multiredeem_SKU_Upload_OR.feature")
    * def result = callonce read("B2C_B2B_CouponCodeGeneration.feature@B2B_percentage_discount_on_SKU_redemption_SKU_Upload_OR") {requestHeader: #(headerJson)}
    * def couponCode1 = result.response["skuCoupons"][0]["coupons"][0]["couponCode"]
    * def sku1 = result.response["skuCoupons"][0]["skuId"]
    * def couponQuantity1 = result.response["skuCoupons"][0]["coupons"][0]["couponQty"]
    *  def transactionID =
    """
      function(){ return java.lang.System.currentTimeMillis() }
    """
    * def transaction_id = callonce transactionID
    * def masid = apiComponents['CMS_masid']
    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])

  Scenario: B2B coupon code geteligible __0042.3
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\')")
    * print "<====== coupon_code_status ======>", coupon_code_status
    * def schema = schemaAndValidation["hold_FC_merchant_coupon"]
    * match each coupon_code_status == schema

  Scenario: B2B coupon code checkout __0042.3
    * header override_flag = redeem_flags
    * def body =
    """
        {
          "masId": "#(masid)",
          "billAmount": #(apiComponents["B2B_percentage_discount_on_SKU_discountType__0042.14"].billAmount),
          "transactionId": "#(transaction_id)",
          "couponCodes": [#(couponCode1)],
          "skuData": #(apiComponents["B2B_percentage_discount_on_SKU_discountType__0042.14"].skuData)
        }
    """
    Given path '/coupons/v1/coupons/merchant/fc/checkout'
    And request body
    When method post
    Then status 200
    And match response.discountAmount == apiComponents["B2B_percentage_discount_on_SKU_discountType_responseData__0042.14"].discountAmount
    And match response.newBillAmount == apiComponents["B2B_percentage_discount_on_SKU_discountType_responseData__0042.14"].newBillAmount
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\')")
    * print "<====== coupon_code_status ======>", coupon_code_status
    * def schema = schemaAndValidation["checkout_FC_merchant_coupon"]

    And match each coupon_code_status == schema

   Scenario: B2B coupon code deliver __0042.3.
    * def body  =
    """
    {
      "couponCodes":[#(couponCode1)],
      "masId": "#(masid)",
      "transactionId": "#(transaction_id)"
     }

    """
    Given path '/coupons/v1/coupons/merchant/fc/delivered'
    And request body
    When method post
    Then status 200
     * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\')")
     * print coupon_code_status
     * def update_return_upto = db.updateRow("UPDATE FC_MERCHANT_COUPONS SET DELIVERED_TS = CURRENT_TIMESTAMP - 20 WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\')")
     * def schema = schemaAndValidation["delivered_FC_merchant_coupon"]

     And match each coupon_code_status == schema

  Scenario: B2B coupon code delayed cancel __0042.3.
    * def body  =
    """
    {
      "couponCodes":[#(couponCode1)],
      "coupons" : [{
                      "couponCode": #(couponCode1),
                      "quantity" : #(couponQuantity1)
                  }],
      "masId": "#(masid)",
     }
    """
    Given path '/coupons/v1/coupons/merchant/fc/delayed-cancel'
    And request body
    When method post
    Then status 200
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\')")
    * print coupon_code_status
    * def schema = schemaAndValidation["active_FC_merchant_coupon"]
