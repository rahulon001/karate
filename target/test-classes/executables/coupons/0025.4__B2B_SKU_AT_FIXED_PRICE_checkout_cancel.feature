Feature: B2B_SKU_AT_FIXED_PRICE checkout cancel flow __0025.4

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
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
      # redemption count
    * def redeem_quantity_811143212226 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212226+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_811143212227 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212227+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_811143212228 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212228+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_count_811143212226 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212226+ "\'))")
    * def redeem_count_811143212227 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212227+ "\'))")
    * def redeem_count_811143212228 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212228+ "\'))")

    * def sku_price = apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption_responseData__0025"].price
    * def bill_amount = apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption__0025"].billAmount
    * def result = callonce read("B2C_B2B_CouponCodeGeneration.feature@B2B_SKU_AT_FIXED_PRICE_coupon_redemption") {requestHeader: #(headerJson) , skuPrice: #(sku_price), billAmount: #(bill_amount)}

    * def skuID = get result.response.skuCoupons[*].skuId
    * def skuID_index_811143212226 = skuID.indexOf("811143212226")
    * def skuID_index_811143212228 = skuID.indexOf("811143212228")
    * def skuID_index_811143212227 = skuID.indexOf("811143212227")

    * match each result.response.skuCoupons[*].coupons[0].couponQty == apiComponents.B2B_SKU_AT_FIXED_PRICE_coupon_redemption_responseData__0025.couponQty

    * def couponCode1 = result.response["skuCoupons"][skuID_index_811143212226]["coupons"][0]["couponCode"]
    * def couponCode2 = result.response["skuCoupons"][skuID_index_811143212226]["coupons"][1]["couponCode"]
    * def couponCode3 = result.response["skuCoupons"][skuID_index_811143212228]["coupons"][0]["couponCode"]
    * def couponCode4 = result.response["skuCoupons"][skuID_index_811143212227]["coupons"][0]["couponCode"]
    * def couponCode5 = result.response["skuCoupons"][skuID_index_811143212227]["coupons"][1]["couponCode"]
    * def couponCode6 = result.response["skuCoupons"][skuID_index_811143212227]["coupons"][2]["couponCode"]

    * assert result.response["skuCoupons"][skuID_index_811143212226]["coupons"][0]["discountType"] == apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption_responseData__0025"].discountType
    * assert result.response["skuCoupons"][skuID_index_811143212226]["coupons"][1]["discountType"] == apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption_responseData__0025"].discountType
    * assert result.response["skuCoupons"][skuID_index_811143212228]["coupons"][0]["discountType"] == apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption_responseData__0025"].discountType
    * assert result.response["skuCoupons"][skuID_index_811143212227]["coupons"][0]["discountType"] == apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption_responseData__0025"].discountType
    * assert result.response["skuCoupons"][skuID_index_811143212227]["coupons"][1]["discountType"] == apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption_responseData__0025"].discountType
    * assert result.response["skuCoupons"][skuID_index_811143212227]["coupons"][2]["discountType"] == apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption_responseData__0025"].discountType

    * assert result.response["skuCoupons"][skuID_index_811143212226]["quantity"]  == apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption_responseData__0025"].quantity_811143212226
    * assert result.response["skuCoupons"][skuID_index_811143212227]["quantity"]  == apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption_responseData__0025"].quantity_811143212227
    * assert result.response["skuCoupons"][skuID_index_811143212228]["quantity"]  == apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption_responseData__0025"].quantity_811143212228

    * assert result.response["skuCoupons"][skuID_index_811143212226]["coupons"][0].discount == apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption_responseData__0025"].discount_811143212226
    * assert result.response["skuCoupons"][skuID_index_811143212226]["coupons"][1].discount == apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption_responseData__0025"].discount_811143212226
    * assert result.response["skuCoupons"][skuID_index_811143212228]["coupons"][0].discount == apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption_responseData__0025"].discount_811143212228
    * assert result.response["skuCoupons"][skuID_index_811143212227]["coupons"][0].discount == apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption_responseData__0025"].discount_811143212227
    * assert result.response["skuCoupons"][skuID_index_811143212227]["coupons"][1].discount == apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption_responseData__0025"].discount_811143212227
    * assert result.response["skuCoupons"][skuID_index_811143212227]["coupons"][2].discount == apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption_responseData__0025"].discount_811143212227

    *  def transactionID =
    """
      function(){ return java.lang.System.currentTimeMillis() }
    """
    * def transaction_id = callonce transactionID


  Scenario: B2B_SKU_AT_FIXED_PRICE checkout checkoutCancel flow __0025.4
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode3+ "\',\'" +couponCode4+ "\',\'" +couponCode5+ "\',\'" +couponCode6+ "\')")
    * print coupon_code_status
    * def b2b_coupons = db.readRows("SELECT * FROM B2B_COUPON WHERE ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[2]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[3]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[4]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupons
    * def b2b_coupon_redemption = db.readRows("SELECT * FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[2]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[3]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[4]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupon_redemption
    * def schema = schemaAndValidation["hold_FC_merchant_coupon"]
    * match each coupon_code_status == schema

    * def redeem_quantity_811143212226_c = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212226+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_811143212227_c = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212227+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_811143212228_c = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212228+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_count_811143212226_c = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212226+ "\'))")
    * def redeem_count_811143212227_c = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212227+ "\'))")
    * def redeem_count_811143212228_c = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212228+ "\'))")

    # redemption count
    * match parseInt(redeem_quantity_811143212226_c[0].QUANTITY) == parseInt(redeem_quantity_811143212226[0].QUANTITY + 2)
    * match parseInt(redeem_quantity_811143212227_c[0].QUANTITY) == parseInt(redeem_quantity_811143212227[0].QUANTITY + 3)
    * match parseInt(redeem_quantity_811143212228_c[0].QUANTITY) == parseInt(redeem_quantity_811143212228[0].QUANTITY + 1)
    * match parseInt(redeem_count_811143212226_c[0].REDEEM_COUNT) == parseInt(redeem_count_811143212226[0].REDEEM_COUNT + 2)
    * match parseInt(redeem_count_811143212227_c[0].REDEEM_COUNT) == parseInt(redeem_count_811143212227[0].REDEEM_COUNT + 3)
    * match parseInt(redeem_count_811143212228_c[0].REDEEM_COUNT) == parseInt(redeem_count_811143212228[0].REDEEM_COUNT + 1)

  Scenario: B2B_SKU_AT_FIXED_PRICE checkout checkoutCancel flow __0025.4
    * header override_flag = redeem_flags
    * def body =
    """
      {
      "masId": "#(masid)",
      "billAmount": #(apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption__0025"].billAmount),
      "transactionId": "#(transaction_id)",
      "couponCodes":[#(couponCode1), #(couponCode2), #(couponCode3), #(couponCode4), #(couponCode5), #(couponCode6)],
      "skuData": #(apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption__0025"].skuData)
      }
    """

    Given path '/coupons/v1/coupons/merchant/fc/checkout'
    And request body
    When method post
    Then status 200

    * def coupon_code = get response.data[*].coupon
    * assert response.discountAmount == apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption_responseData__0025"].discountAmount
    * assert response.newBillAmount == apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption_responseData__0025"].newBillAmount
    * match each response.data[*].discountType == apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption_responseData__0025"].discountType
    * match each response.data[*].quantity == apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption_responseData__0025"].quantity
    * assert response.data[coupon_code.indexOf(couponCode1)].discount == apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption_responseData__0025"].discount_811143212226
    * assert response.data[coupon_code.indexOf(couponCode2)].discount == apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption_responseData__0025"].discount_811143212226
    * assert response.data[coupon_code.indexOf(couponCode3)].discount == apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption_responseData__0025"].discount_811143212228
    * assert response.data[coupon_code.indexOf(couponCode4)].discount == apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption_responseData__0025"].discount_811143212227
    * assert response.data[coupon_code.indexOf(couponCode5)].discount == apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption_responseData__0025"].discount_811143212227
    * assert response.data[coupon_code.indexOf(couponCode6)].discount == apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption_responseData__0025"].discount_811143212227

    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode3+ "\',\'" +couponCode4+ "\',\'" +couponCode5+ "\',\'" +couponCode6+ "\')")
    * print coupon_code_status
    * def b2b_coupons = db.readRows("SELECT * FROM B2B_COUPON WHERE ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[2]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[3]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[4]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupons
    * def b2b_coupon_redemption = db.readRows("SELECT * FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[2]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[3]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[4]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupon_redemption
    * def schema = schemaAndValidation["checkout_FC_merchant_coupon"]
    And match each coupon_code_status == schema

  Scenario: B2B_SKU_AT_FIXED_PRICE delayed cancel checkoutCancel flow __0025.4
    # redemption count
    * def redeem_quantity_811143212226 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212226+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_811143212227 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212227+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_811143212228 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212228+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_count_811143212226 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212226+ "\'))")
    * def redeem_count_811143212227 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212227+ "\'))")
    * def redeem_count_811143212228 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212228+ "\'))")

    * def body  =
    """
    {
      "couponCodes":[#(couponCode1), #(couponCode2), #(couponCode3), #(couponCode4), #(couponCode5), #(couponCode6)],
      "coupons" : [],
      "masId": "#(masid)",
     }
    """
    Given path '/coupons/v1/coupons/merchant/fc/delayed-cancel'
    And request body
    When method post
    Then status 200
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode3+ "\',\'" +couponCode4+ "\',\'" +couponCode5+ "\',\'" +couponCode6+ "\')")
    * print coupon_code_status
    And match each coupon_code_status == schemaAndValidation["cancelled_FC_merchant_coupon"]

    * def redeem_quantity_811143212226_r = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212226+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_811143212227_r = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212227+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_811143212228_r = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212228+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_count_811143212226_r = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212226+ "\'))")
    * def redeem_count_811143212227_r = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212227+ "\'))")
    * def redeem_count_811143212228_r = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212228+ "\'))")

    # redemption count
    * match parseInt(redeem_quantity_811143212226_r[0].QUANTITY) == parseInt(redeem_quantity_811143212226[0].QUANTITY - 2)
    * match parseInt(redeem_quantity_811143212227_r[0].QUANTITY) == parseInt(redeem_quantity_811143212227[0].QUANTITY - 3)
    * match parseInt(redeem_quantity_811143212228_r[0].QUANTITY) == parseInt(redeem_quantity_811143212228[0].QUANTITY - 1)

    * match parseInt(redeem_count_811143212226_r[0].REDEEM_COUNT) == parseInt(redeem_count_811143212226[0].REDEEM_COUNT - 2)
    * match parseInt(redeem_count_811143212227_r[0].REDEEM_COUNT) == parseInt(redeem_count_811143212227[0].REDEEM_COUNT - 3)
    * match parseInt(redeem_count_811143212228_r[0].REDEEM_COUNT) == parseInt(redeem_count_811143212228[0].REDEEM_COUNT - 1)


  Scenario: Switching off the features __0025.4.
    * def call_configuration_table = callonce read('support.feature@switch_off_features')
    * def call_configuration_table_b2b = callonce read('support.feature@switch_off_features_b2b')