Feature: Flat discount on SKU B2B mark redeem flow __0041.2

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
    * def b2b_coupon_redemption = callonce read("0041__B2C_flat_discount_on_SKU_mark_redeem_flow_discountType.feature@B2C_flat_discount_on_SKU")
    * json result = callonce read("B2C_B2B_CouponCodeGeneration.feature@B2B_flat_discount_on_SKU_redemption") {requestHeader: #(headerJson)}
    * def couponCode1 = result.response["skuCoupons"][0]["coupons"][0]["couponCode"]
    * def sku1 = result.response["skuCoupons"][0]["skuId"]
    *  def transactionID =
    """
      function(){ return java.lang.System.currentTimeMillis() }
    """
    * def transaction_id = callonce transactionID
    * def masid = apiComponents['CMS_masid']
    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])

  Scenario: B2B coupon code geteligible __0041.2
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\')")
    * print "<====== coupon_code_status ======>", coupon_code_status
    * def schema = schemaAndValidation["hold_FC_merchant_coupon"]
    And match each coupon_code_status == schema

  Scenario: B2B coupon code release geteligible __0041.2
    * def hold_time = db.readRows("SELECT CONFIG_VALUE FROM configuration WHERE CONFIG_NAME=\'get_eligible_hold_duration\'")
    * def hold_time = parseInt(hold_time[0].CONFIG_VALUE)/60
    * def update_hold_ts = db.updateRow("update fc_merchant_coupons set hold_ts=(systimestamp - numtodsinterval(\'"+hold_time+"\','MINUTE')) where merchant_coupon_code in (\'" +couponCode1+ "\')")

   Given path '/coupons/v1/coupons/merchant/fc/resetGetEligibleTxn'
    And  request {}
   When method post
   Then status 200

   * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\')")
   * print "<====== coupon_code_status ======>", coupon_code_status
   * def schema = schemaAndValidation["active_FC_merchant_coupon"]
   * json result = call read("B2C_B2B_CouponCodeGeneration.feature@B2B_flat_discount_on_SKU_redemption") {requestHeader: #(headerJson)}
   * def couponCode1_new = result.response["skuCoupons"][0]["coupons"][0]["couponCode"]
   * def sku1 = result.response["skuCoupons"][0]["skuId"]
   * match couponCode1_new == couponCode1

    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\')")
    * print "<====== coupon_code_status ======>", coupon_code_status
    * def schema = schemaAndValidation["hold_FC_merchant_coupon"]
    * match each coupon_code_status == schema

  Scenario: B2B coupon code checkout __0041.2
    * header override_flag = redeem_flags
    * def body =
    """
        {
          "masId": "#(masid)",
          "billAmount": #(apiComponents["B2B_flat_discount_on_SKU_discountType__0041.2"].billAmount),
          "transactionId": "#(transaction_id)",
          "couponCodes": [#(couponCode1)],
          "skuData": #(apiComponents["B2B_flat_discount_on_SKU_discountType__0041.2"].skuData)
        }
    """
    Given path '/coupons/v1/coupons/merchant/fc/checkout'
    And request body
    When method post
    Then status 200
    And match response.discountAmount == apiComponents["B2B_flat_discount_on_SKU_discountType_responseData__0041.2"].discountAmount
    And match response.newBillAmount == apiComponents["B2B_flat_discount_on_SKU_discountType_responseData__0041.2"].newBillAmount
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\')")
    * print "<====== coupon_code_status ======>", coupon_code_status
    * def schema = schemaAndValidation["checkout_FC_merchant_coupon"]

    And match each coupon_code_status == schema

  Scenario: B2B coupon code deliver __0041.2.
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

  Scenario: B2B coupon code mark redeem __0041.2.
    * def body  =
    """
    {
    }
    """
    Given path '/coupons/v1/coupons/merchant/fc/mark-redeemed'
    And request body
    When method post
    Then status 200
    And assert response.codes != []
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\')")
    * print coupon_code_status
    * match each coupon_code_status == schemaAndValidation["redeemed_FC_merchant_coupon"]