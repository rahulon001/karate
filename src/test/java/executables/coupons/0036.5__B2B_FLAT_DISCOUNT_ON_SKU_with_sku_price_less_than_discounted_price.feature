Feature: B2B_FLAT_DISCOUNT_ON_SKU checkout cancel flow __0036.5

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
    * def redeem_quantity_811143212221 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212221+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_811143212223 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212223+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_811143212222 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212222+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_count_811143212221 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212221+ "\'))")
    * def redeem_count_811143212223 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212223+ "\'))")
    * def redeem_count_811143212222 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212222+ "\'))")

    * def sku_price = apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].less_price
    * def bill_amount = apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption__0036"].billAmount
    * def result = callonce read("B2C_B2B_CouponCodeGeneration.feature@B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption") {requestHeader: #(headerJson) , skuPrice: #(sku_price), billAmount: #(bill_amount)}

    * def skuID = get result.response.skuCoupons[*].skuId
    * def skuID_index_811143212221 = skuID.indexOf("811143212221")
    * def skuID_index_811143212222 = skuID.indexOf("811143212222")
    * def skuID_index_811143212223 = skuID.indexOf("811143212223")

    * match each result.response.skuCoupons[*].coupons[0].couponQty == apiComponents.B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.couponQty

    * def couponCode1 = result.response["skuCoupons"][skuID_index_811143212221]["coupons"][0]["couponCode"]

    * def couponCode2 = result.response["skuCoupons"][skuID_index_811143212222]["coupons"][0]["couponCode"]
    * def couponCode3 = result.response["skuCoupons"][skuID_index_811143212222]["coupons"][1]["couponCode"]

    * def couponCode4 = result.response["skuCoupons"][skuID_index_811143212223]["coupons"][0]["couponCode"]
    * def couponCode5 = result.response["skuCoupons"][skuID_index_811143212223]["coupons"][1]["couponCode"]
    * def couponCode6 = result.response["skuCoupons"][skuID_index_811143212223]["coupons"][2]["couponCode"]

    * assert result.response["skuCoupons"][skuID_index_811143212221]["coupons"][0]["discountType"] == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].discountType
    * assert result.response["skuCoupons"][skuID_index_811143212222]["coupons"][0]["discountType"] == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].discountType
    * assert result.response["skuCoupons"][skuID_index_811143212222]["coupons"][1]["discountType"] == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].discountType
    * assert result.response["skuCoupons"][skuID_index_811143212223]["coupons"][0]["discountType"] == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].discountType
    * assert result.response["skuCoupons"][skuID_index_811143212223]["coupons"][1]["discountType"] == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].discountType
    * assert result.response["skuCoupons"][skuID_index_811143212223]["coupons"][2]["discountType"] == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].discountType

    * assert result.response["skuCoupons"][skuID_index_811143212221]["quantity"]  == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].quantity_811143212221
    * assert result.response["skuCoupons"][skuID_index_811143212222]["quantity"]  == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].quantity_811143212222
    * assert result.response["skuCoupons"][skuID_index_811143212223]["quantity"]  == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].quantity_811143212223

    * assert result.response["skuCoupons"][skuID_index_811143212221]["coupons"][0].discount.toFixed(2) == (result.response.skuCoupons[skuID_index_811143212221].coupons[0].quantity * result.response.skuCoupons[skuID_index_811143212221].price - 0.01).toFixed(2)
    * assert result.response["skuCoupons"][skuID_index_811143212222]["coupons"][0].discount.toFixed(2) == (result.response.skuCoupons[skuID_index_811143212222].coupons[0].quantity * result.response.skuCoupons[skuID_index_811143212222].price - 0.01).toFixed(2)
    * assert result.response["skuCoupons"][skuID_index_811143212222]["coupons"][1].discount.toFixed(2) == (result.response.skuCoupons[skuID_index_811143212222].coupons[1].quantity * result.response.skuCoupons[skuID_index_811143212222].price - 0.01).toFixed(2)
    * assert result.response["skuCoupons"][skuID_index_811143212223]["coupons"][0].discount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].discount_811143212223
    * assert result.response["skuCoupons"][skuID_index_811143212223]["coupons"][1].discount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].discount_811143212223
    * assert result.response["skuCoupons"][skuID_index_811143212223]["coupons"][2].discount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].discount_811143212223

    * assert result.response["skuCoupons"][skuID_index_811143212221]["price"] == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].less_price

    *  def transactionID =
    """
      function(){ return java.lang.System.currentTimeMillis() }
    """
    * def transaction_id = callonce transactionID


  Scenario: B2B_FLAT_DISCOUNT_ON_SKU checkout checkoutCancel flow __0036.5
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode3+ "\',\'" +couponCode4+ "\',\'" +couponCode5+ "\',\'" +couponCode6+ "\')")
    * print coupon_code_status
    * def b2b_coupons = db.readRows("SELECT * FROM B2B_COUPON WHERE ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[2]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[3]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[4]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupons
    * def b2b_coupon_redemption = db.readRows("SELECT * FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[2]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[3]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[4]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupon_redemption
    * def schema = schemaAndValidation["hold_FC_merchant_coupon"]
    * match each coupon_code_status == schema

    * def redeem_quantity_811143212221_c = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212221+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_811143212223_c = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212223+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_811143212222_c = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212222+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_count_811143212221_c = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212221+ "\'))")
    * def redeem_count_811143212223_c = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212223+ "\'))")
    * def redeem_count_811143212222_c = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212222+ "\'))")

    # redemption count
    * match parseInt(redeem_quantity_811143212221_c[0].QUANTITY) == parseInt(redeem_quantity_811143212221[0].QUANTITY + 1)
    * match parseInt(redeem_quantity_811143212223_c[0].QUANTITY) == parseInt(redeem_quantity_811143212223[0].QUANTITY + 3)
    * match parseInt(redeem_quantity_811143212222_c[0].QUANTITY) == parseInt(redeem_quantity_811143212222[0].QUANTITY + 2)
    * match parseInt(redeem_count_811143212221_c[0].REDEEM_COUNT) == parseInt(redeem_count_811143212221[0].REDEEM_COUNT + 1)
    * match parseInt(redeem_count_811143212223_c[0].REDEEM_COUNT) == parseInt(redeem_count_811143212223[0].REDEEM_COUNT + 3)
    * match parseInt(redeem_count_811143212222_c[0].REDEEM_COUNT) == parseInt(redeem_count_811143212222[0].REDEEM_COUNT + 2)

  Scenario: B2B_FLAT_DISCOUNT_ON_SKU checkout checkoutCancel flow __0036.5
    * header override_flag = redeem_flags
    * def body =
    """
      {
      "masId": "#(masid)",
      "billAmount": #(apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption__0036"].billAmount),
      "transactionId": "#(transaction_id)",
      "couponCodes":[#(couponCode1),#(couponCode2), #(couponCode3), #(couponCode4), #(couponCode5), #(couponCode6)],
      "skuData": #(apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption__0036"].skuData)
      }
    """
  * set body.skuData[*].skuPrice = apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].less_price
    Given path '/coupons/v1/coupons/merchant/fc/checkout'
    And request body
    When method post
    Then status 200
    * def coupon_code = get response.data[*].coupon
    * match response.discountAmount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].discountAmount_lessPrice
    * match response.newBillAmount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].newBillAmount_lessPrice
    * match each response.data[*].discountType == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].discountType
    * match each response.data[*].quantity == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].quantity
    * match response.data[coupon_code.indexOf(couponCode1)].discount.toFixed(2) == (result.response.skuCoupons[skuID_index_811143212221].coupons[0].quantity * result.response.skuCoupons[skuID_index_811143212221].price - (0.01 * result.response.skuCoupons[skuID_index_811143212221].quantity)).toFixed(2)
    * match response.data[coupon_code.indexOf(couponCode2)].discount.toFixed(2) == (result.response.skuCoupons[skuID_index_811143212222].coupons[0].quantity * result.response.skuCoupons[skuID_index_811143212222].price - 0.01).toFixed(2)
    * match response.data[coupon_code.indexOf(couponCode3)].discount.toFixed(2) == (result.response.skuCoupons[skuID_index_811143212222].coupons[1].quantity * result.response.skuCoupons[skuID_index_811143212222].price - 0.01).toFixed(2)
    * match response.data[coupon_code.indexOf(couponCode4)].discount.toFixed(2) == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].discount_811143212223.toFixed(2)
    * match response.data[coupon_code.indexOf(couponCode5)].discount.toFixed(2) == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].discount_811143212223.toFixed(2)
    * match response.data[coupon_code.indexOf(couponCode6)].discount.toFixed(2) == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].discount_811143212223.toFixed(2)

    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode3+ "\',\'" +couponCode4+ "\',\'" +couponCode5+ "\',\'" +couponCode6+ "\')")
    * print coupon_code_status
    * def b2b_coupons = db.readRows("SELECT * FROM B2B_COUPON WHERE ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[2]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[3]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[4]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupons
    * def b2b_coupon_redemption = db.readRows("SELECT * FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[2]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[3]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[4]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupon_redemption
    * def schema = schemaAndValidation["checkout_FC_merchant_coupon"]
    And match each coupon_code_status == schema


  Scenario: B2B_FLAT_DISCOUNT_ON_SKU delayed cancel checkoutCancel flow __0036.5
    # redemption count
    * def redeem_quantity_811143212221 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212221+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_811143212223 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212223+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_811143212222 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212222+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_count_811143212221 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212221+ "\'))")
    * def redeem_count_811143212223 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212223+ "\'))")
    * def redeem_count_811143212222 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212222+ "\'))")

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

    * def redeem_quantity_811143212221_r = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212221+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_811143212223_r = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212223+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_811143212222_r = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212222+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_count_811143212221_r = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212221+ "\'))")
    * def redeem_count_811143212223_r = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212223+ "\'))")
    * def redeem_count_811143212222_r = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212222+ "\'))")

    # redemption count
    * match parseInt(redeem_quantity_811143212221_r[0].QUANTITY) == parseInt(redeem_quantity_811143212221[0].QUANTITY -1 )
    * match parseInt(redeem_quantity_811143212223_r[0].QUANTITY) == parseInt(redeem_quantity_811143212223[0].QUANTITY - 3)
    * match parseInt(redeem_quantity_811143212222_r[0].QUANTITY) == parseInt(redeem_quantity_811143212222[0].QUANTITY - 2)
    * match parseInt(redeem_count_811143212221_r[0].REDEEM_COUNT) == parseInt(redeem_count_811143212221[0].REDEEM_COUNT -1)
    * match parseInt(redeem_count_811143212223_r[0].REDEEM_COUNT) == parseInt(redeem_count_811143212223[0].REDEEM_COUNT - 3)
    * match parseInt(redeem_count_811143212222_r[0].REDEEM_COUNT) == parseInt(redeem_count_811143212222[0].REDEEM_COUNT - 2)

  Scenario: Switching off the features __0036.5.
    * def call_configuration_table = callonce read('support.feature@switch_off_features')