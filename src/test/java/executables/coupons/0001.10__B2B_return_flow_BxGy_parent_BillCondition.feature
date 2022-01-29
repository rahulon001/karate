Feature: BxGy B2B mark redeem flow parent __0001.10

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
    * def b2c_coupon_redemption = callonce read("0001.6__B2C_BxGy_parent_mark_redeem_flow_discountType_BillCondition_Satisfied.feature@bxgy_parent_BillCondition")
    * json result = callonce read("B2C_B2B_CouponCodeGeneration.feature@B2B_BxGy_parent_cart_redemption_BillCondition") {requestHeader: #(headerJson)}
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

  Scenario: B2B coupon code checkout __0001.10
    * header override_flag = redeem_flags
    * def body =
    """
        {
          "masId": "#(masid)",
          "billAmount": #(apiComponents["B2B_BxGy_parent_discountType__0001.10"].billAmount),
          "transactionId": "#(transaction_id)",
          "couponCodes": [#(couponCode1)],
          "skuData": #(apiComponents["B2B_BxGy_parent_discountType__0001.10"].skuData)
        }
    """
    Given path '/coupons/v1/coupons/merchant/fc/checkout'
    And request body
    When method post
    Then status 200
    And match response.discountAmount == apiComponents["B2B_BxGy_parent_responseData__0001.10"].discountAmount
    And match response.newBillAmount == apiComponents["B2B_BxGy_parent_responseData__0001.10"].newBillAmount
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\')")
    * print "<====== coupon_code_status ======>", coupon_code_status
    * def schema = schemaAndValidation["checkout_FC_merchant_coupon"]

    And match each coupon_code_status == schema

  Scenario: B2B coupon code deliver __0001.10.
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

  Scenario: B2B coupon code delayed cancel __0001.10.
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
