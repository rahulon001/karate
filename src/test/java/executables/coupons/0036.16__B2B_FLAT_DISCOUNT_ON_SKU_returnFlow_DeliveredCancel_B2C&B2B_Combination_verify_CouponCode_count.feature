Feature: B2B_FLAT_DISCOUNT_ON_SKU MarkRedemptionFlow __0036.1

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * def firstCall = read('support.feature@activate_coupons')
    * def apiComponents = envConfig
    * def schemaAndValidation = envSchema
    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])
    * header Content-Type = 'application/json'
    * header x-client-type = "mpos"
    * def redeem_flags = "false"
    * def headerJson = {}
    * set headerJson.multi_redeem-enabled = redeem_flags
    * set headerJson.Content-Type = 'application/json'
    * set headerJson.x-client-type = 'mpos'
    * def masid = apiComponents['CMS_masid']
    * def b2c_discount_coupon_redemption = callonce read("0041__B2C_flat_discount_on_SKU_mark_redeem_flow_discountType.feature")
  
    # redemption count
    * def redeem_quantity_811153212223 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811153212223+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_count_811153212223 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811153212223+ "\'))")
   
    * def sku_price = apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.16"].price
    * def bill_amount = apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption__0036.16"].billAmount
    * def sku_data_1 = apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.16"].skuData1
    * print "****SKUDATA****",sku_data_1
    * def result = callonce read("B2C_B2B_CouponCodeGeneration.feature@B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_combination_B2C&B2B") {requestHeader: #(headerJson) , skuPrice: #(sku_price), billAmount: #(bill_amount), skuData: #(sku_data_1)}

    * def skuID = get result.response.skuCoupons[*].skuId
    * def skuID_index_811153212223 = skuID.indexOf("811153212223")
    * def skuID_index_1009977754 = skuID.indexOf("1009977754")

    * assert result.response["skuCoupons"][skuID_index_811153212223]["coupons"].length == 1
    * assert result.response["skuCoupons"][skuID_index_1009977754]["coupons"].length == 1


    * def sku_price = apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.16"].price
    * def bill_amount = apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption__0036.16"].billAmount
    * def sku_data_2 = apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.16"].skuData2
    * def result = callonce read("B2C_B2B_CouponCodeGeneration.feature@B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_combination_B2C&B2B") {requestHeader: #(headerJson) , skuPrice: #(sku_price), billAmount: #(bill_amount), skuData: #(sku_data_2)}

    * def skuID = get result.response.skuCoupons[*].skuId
    * def skuID_index_811153212223 = skuID.indexOf("811153212223")
    * def skuID_index_1009977754 = skuID.indexOf("1009977754")

    * assert result.response["skuCoupons"][skuID_index_811153212223]["coupons"].length == 3
    * assert result.response["skuCoupons"][skuID_index_1009977754]["coupons"].length == 1

    * def couponCode1 = result.response["skuCoupons"][skuID_index_811153212223]["coupons"][0]["couponCode"]
    * def couponCode2 = result.response["skuCoupons"][skuID_index_811153212223]["coupons"][1]["couponCode"]
    * def couponCode3 = result.response["skuCoupons"][skuID_index_811153212223]["coupons"][2]["couponCode"]
    * def couponCode4 = result.response["skuCoupons"][skuID_index_1009977754]["coupons"][0]["couponCode"]

    * def hold_time = db.readRows("SELECT CONFIG_VALUE FROM configuration WHERE CONFIG_NAME=\'get_eligible_hold_duration\'")
    * def hold_time = parseInt(hold_time[0].CONFIG_VALUE)/60
    * def update_hold_ts = db.updateRow("update fc_merchant_coupons set hold_ts=(systimestamp - numtodsinterval(\'"+hold_time+"\','MINUTE')) where merchant_coupon_code in (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode3+ "\',\'" +couponCode4+ "\')")

    * def activate1 = callonce firstCall

    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode3+ "\',\'" +couponCode4+ "\')")
    * print coupon_code_status

    * def sku_price = apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.16"].price
    * def bill_amount = apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption__0036.16"].billAmount
    * def sku_data_3 = apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.16"].skuData3
    * def result = callonce read("B2C_B2B_CouponCodeGeneration.feature@B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_combination_B2C&B2B") {requestHeader: #(headerJson) , skuPrice: #(sku_price), billAmount: #(bill_amount), skuData: #(sku_data_3)}

    * def skuID = get result.response.skuCoupons[*].skuId
    * def skuID_index_811153212223 = skuID.indexOf("811153212223")
    * def skuID_index_1009977754 = skuID.indexOf("1009977754")

    * assert result.response["skuCoupons"][skuID_index_811153212223]["coupons"].length == 2
    * assert result.response["skuCoupons"][skuID_index_1009977754]["coupons"].length == 1

    * match each result.response.skuCoupons[*].coupons[0].couponQty == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.16"].couponQty

    * def couponCode1 = result.response["skuCoupons"][skuID_index_811153212223]["coupons"][0]["couponCode"]
    * def couponCode2 = result.response["skuCoupons"][skuID_index_811153212223]["coupons"][1]["couponCode"]
    * def couponCode3 = result.response["skuCoupons"][skuID_index_1009977754]["coupons"][0]["couponCode"]

    * match each  result.response.skuCoupons[*].coupons[*]."discountType" == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.16"].discountType

    * assert result.response["skuCoupons"][skuID_index_811153212223]["quantity"]  == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.16"].quantity_811153212223
    * assert result.response["skuCoupons"][skuID_index_1009977754]["quantity"]  == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.16"].quantity_1009977754

    * assert result.response["skuCoupons"][skuID_index_811153212223]["coupons"][0].discount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.16"].discount_811153212223
    * assert result.response["skuCoupons"][skuID_index_811153212223]["coupons"][1].discount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.16"].discount_811153212223
    * assert result.response["skuCoupons"][skuID_index_1009977754]["coupons"][0].discount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.16"].discount_1009977754

    * assert result.response["skuCoupons"][skuID_index_811153212223]["price"] == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.16"].price

    *  def transactionID =
    """
      function(){ return java.lang.System.currentTimeMillis() }
    """
    * def transaction_id = callonce transactionID


  Scenario: B2B_FLAT_DISCOUNT_ON_SKU checkout Mark Redemption Flow __0036
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode3+ "\')")
    * print coupon_code_status
     * def schema = schemaAndValidation["hold_FC_merchant_coupon"]
    * match each coupon_code_status == schema

    * def redeem_quantity_811153212223_c = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811153212223+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_count_811153212223_c = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811153212223+ "\'))")

    # redemption count
    * match parseInt(redeem_quantity_811153212223_c[0].QUANTITY) == parseInt(redeem_quantity_811153212223[0].QUANTITY + 2)
     * match parseInt(redeem_count_811153212223_c[0].REDEEM_COUNT) == parseInt(redeem_count_811153212223[0].REDEEM_COUNT + 2)

  Scenario: B2B_FLAT_DISCOUNT_ON_SKU checkout Mark Redemption Flow __0036.
  * header override_flag = redeem_flags
    * def body =
    """
      {
      "masId": "#(masid)",
      "billAmount": #(apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption__0036.16"].billAmount),
      "transactionId": "#(transaction_id)",
      "couponCodes":[#(couponCode1), #(couponCode2), #(couponCode3)],
      "skuData": #(apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption__0036.16"].skuData)
      }
    """

    Given path '/coupons/v1/coupons/merchant/fc/checkout'
    And request body
    When method post
    Then status 200

    * def coupon_code = get response.data[*].coupon
    * assert response.discountAmount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.16"].discountAmount
    * assert response.newBillAmount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.16"].newBillAmount

    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode3+ "\')")
    * print coupon_code_status
     * def schema = schemaAndValidation["checkout_FC_merchant_coupon"]
    And match each coupon_code_status == schema

  Scenario: B2B_FLAT_DISCOUNT_ON_SKU delivered Mark Redemption Flow __0036.
    * header x-client-type = "hybris"
    * def body  =
    """
    {
      "couponCodes":[#(couponCode1), #(couponCode2), #(couponCode3)],
      "coupons" : [],
      "masId": "#(masid)",
     }
    """
    Given path '/coupons/v1/coupons/merchant/fc/delivered'
    And request body
    When method post
    Then status 200
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode3+ "\')")
    * print coupon_code_status

    * def update_delivered_TS = db.updateRow("UPDATE FC_MERCHANT_COUPONS SET DELIVERED_TS = CURRENT_TIMESTAMP - 20 WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode3+ "\')")
    * def schema = schemaAndValidation["delivered_FC_merchant_coupon"]
    * match each coupon_code_status == schema

  Scenario: B2B_FLAT_DISCOUNT_ON_SKU delayed cancel partial return flow __0036.1
     # redemption count
    * def redeem_quantity_811153212223 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811153212223+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_count_811153212223 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811153212223+ "\'))")

    * def body  =
    """
    {
      "couponCodes":[#(couponCode1), #(couponCode2), #(couponCode3)],
      "coupons" : [],
      "masId": "#(masid)",
     }
    """
    Given path '/coupons/v1/coupons/merchant/fc/delayed-cancel'
    And request body
    When method post
    Then status 200
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\')")
    * print coupon_code_status
    * def schema = schemaAndValidation["cancelled_FC_merchant_coupon"]
    And match each coupon_code_status == schema
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode3+ "\')")
    * print coupon_code_status
    * def schema = schemaAndValidation["active_FC_merchant_coupon"]
    And match each coupon_code_status == schema

    * def redeem_quantity_811153212223_r = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811153212223+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_count_811153212223_r = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811153212223+ "\'))")

    # redemption count
    * match parseInt(redeem_quantity_811153212223_r[0].QUANTITY) == parseInt(redeem_quantity_811153212223[0].QUANTITY -2 )
    * match parseInt(redeem_count_811153212223_r[0].REDEEM_COUNT) == parseInt(redeem_count_811153212223[0].REDEEM_COUNT -2)



  Scenario: B2B_FLAT_DISCOUNT_ON_SKU checkout of cancelled coupons in partial return flow __0036.1
    * def body =
    """
      {
      "masId": "#(masid)",
      "billAmount": #(apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption__0036.16"].billAmount),
      "transactionId": "#(transaction_id)",
      "couponCodes":[#(couponCode1), #(couponCode2)],
      "skuData": #(apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption__0036.16"].skuData)
      }
    """
    Given path '/coupons/v1/coupons/merchant/fc/checkout'
    And request body
    When method post
    Then status 400
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\')")
    * print coupon_code_status
    * match each coupon_code_status == schemaAndValidation["cancelled_FC_merchant_coupon"]

  Scenario: Switching off the features __0036.1.
    * def call_configuration_table = callonce read('support.feature@switch_off_features')