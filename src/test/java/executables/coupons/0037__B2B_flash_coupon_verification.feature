Feature: B2B flash coupon verification  __0037

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * def apiComponents = envConfig
    * def schemaAndValidation = envSchema
    * header Content-Type = 'application/json'
    * header x-client-type = "mpos"
    * def redeem_flags = "false"
    * def headerJson = {}
    * set headerJson.multi_redeem-enabled = redeem_flags
    * set headerJson.Content-Type = 'application/json'
    * set headerJson.x-client-type = 'mpos'

    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])

    * def masid = apiComponents['CMS_masid']

    *  def transactionID =
    """
      function(){ return java.lang.System.currentTimeMillis() }
    """
    * def transaction_id = callonce transactionID

  Scenario: B2B_FLAT_DISCOUNT_ON_SKU verify when flash coupon is expired Flow __0037.
    # cleaning the data as per SKU
    * def d1 = db.updateRow("UPDATE FC_MERCHANT_COUPONS SET STATUS = 'cancelled' WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON WHERE SKU_ID IN (\'" +1634204203873+ "\'))")
    # updating the valid_to time stamp
    * def d2 = db.updateRow("UPDATE B2B_COUPON SET VALID_TO = (systimestamp - numtodsinterval(30,'MINUTE')) WHERE SKU_ID IN (\'" +1634204203873+ "\')")

    * def result = call read("B2C_B2B_CouponCodeGeneration.feature@B2B_FLAT_DISCOUNT_ON_SKU_flash_coupon_verification") {requestHeader: #(headerJson)}
    * print result.response
    * match result.response.skuCoupons == []


  Scenario: B2B_FLAT_DISCOUNT_ON_SKU verify when flash coupon is active Flow __0037.
    # cleaning the data as per SKU
    * def d1 = db.updateRow("UPDATE FC_MERCHANT_COUPONS SET STATUS = 'cancelled' WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON WHERE SKU_ID IN (\'" +1634204203873+ "\'))")
    # updating the valid_to time stamp
    * def d2 = db.updateRow("UPDATE B2B_COUPON SET VALID_TO = (systimestamp + numtodsinterval(30,'MINUTE')) WHERE SKU_ID IN (\'" +1634204203873+ "\')")

    * def result = call read("B2C_B2B_CouponCodeGeneration.feature@B2B_FLAT_DISCOUNT_ON_SKU_flash_coupon_verification") {requestHeader: #(headerJson)}
    * def couponCode1 = result.response["skuCoupons"][0]["coupons"][0]["couponCode"]
    * def couponCode2 = result.response["skuCoupons"][0]["coupons"][1]["couponCode"]
    * print result.response
    * match result.response.skuCoupons != []
    * def b2b_coupon = db.readRows("SELECT to_char(valid_from, 'dd-mm-yy HH24:MI'),to_char(valid_to, 'dd-mm-yy HH24:MI') FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +1634204203873+ "\') and merchant_group is not null")
    * def fc_merchant_coupons_1 = db.readRows("SELECT to_char(valid_from, 'dd-mm-yy HH24:MI'),to_char(valid_to, 'dd-mm-yy HH24:MI') from FC_MERCHANT_COUPONS where merchant_coupon_code IN (\'" +couponCode1+ "\')")
    * def fc_merchant_coupons_2 = db.readRows("SELECT to_char(valid_from, 'dd-mm-yy HH24:MI'),to_char(valid_to, 'dd-mm-yy HH24:MI') from FC_MERCHANT_COUPONS where merchant_coupon_code IN (\'" +couponCode2+ "\')")
    * match b2b_coupon == fc_merchant_coupons_1
    * match b2b_coupon == fc_merchant_coupons_2


  Scenario Outline:  verify flash coupon in replacement API Flow __0037.

    * def body =
      """
          {
          "start" : 0,
          "end" : 1000,
          "sku": <skuid>
          }
      """
    Given path '/coupons/v1/coupons/merchant/'+masid+'/fc/coupons'
    And request body
    When method post
    Then status 200
    * print response
    * match each response.skus ==
    """
    {
      "id": "#string",
      "skuName": "#string",
      "totalDiscount": "#number",
      "earliestExpiryDate": "#number",
      "totalCouponCodes": "#number",
      "categories": "#[]",
      "coupons": "#[]"
       }
    """

    Examples:
      |skuid|
      |"1634204203873"|

