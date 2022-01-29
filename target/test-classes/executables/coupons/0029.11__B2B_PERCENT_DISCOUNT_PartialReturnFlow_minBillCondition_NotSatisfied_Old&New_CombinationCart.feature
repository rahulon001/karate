Feature: B2B_PERCENT_DISCOUNT partial return flow __0029.6

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * def call_configuration_table_mbv = callonce read('support.feature@switch_on_features_mbv')
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
    * def redeem_quantity_711143212226 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212226+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_711143212227 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212227+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_711143212228 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212228+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_count_711143212226 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212226+ "\'))")
    * def redeem_count_711143212228 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212228+ "\'))")
    * def redeem_count_711143212227 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212227+ "\'))")
    * def redeem_quantity_7111432122126 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +7111432122126+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_7111432122127 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +7111432122127+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_7111432122128 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +7111432122128+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_count_7111432122126 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +7111432122126+ "\'))")
    * def redeem_count_7111432122128 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +7111432122128+ "\'))")
    * def redeem_count_7111432122127 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +7111432122127+ "\'))")

    * def sku_price = apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].price
    * def bill_amount = apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].billAmount_mbv
    * def result = callonce read("B2C_B2B_CouponCodeGeneration.feature@B2B_PERCENT_DISCOUNT_coupon_redemption_combination") {requestHeader: #(headerJson) , skuPrice: #(sku_price), billAmount: #(bill_amount)}

    * def skuID = get result.response.skuCoupons[*].skuId
    * def skuID_index_711143212226 = skuID.indexOf("711143212226")
#    * def skuID_index_711143212228 = skuID.indexOf("711143212228")
    * def skuID_index_711143212227 = skuID.indexOf("711143212227")
    * match skuID.indexOf("711143212228") == -1
    * def skuID_index_7111432122126 = skuID.indexOf("7111432122126")
    * def skuID_index_7111432122127 = skuID.indexOf("7111432122127")
    * def skuID_index_7111432122128 = skuID.indexOf("7111432122128")
    * def skuID_index_711143212229 = skuID.indexOf("711143212229")
    * def skuID_index_711143212230 = skuID.indexOf("711143212230")

    * match each result.response.skuCoupons[*].coupons[0].couponQty == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].couponQty

    * def couponCode1 = result.response["skuCoupons"][skuID_index_711143212226]["coupons"][0]["couponCode"]
    * def couponCode2 = result.response["skuCoupons"][skuID_index_711143212226]["coupons"][1]["couponCode"]
#    * def couponCode3 = result.response["skuCoupons"][skuID_index_711143212228]["coupons"][0]["couponCode"]
    * def couponCode4 = result.response["skuCoupons"][skuID_index_711143212227]["coupons"][0]["couponCode"]
    * def couponCode5 = result.response["skuCoupons"][skuID_index_711143212227]["coupons"][1]["couponCode"]
    * def couponCode6 = result.response["skuCoupons"][skuID_index_711143212227]["coupons"][2]["couponCode"]
    * def couponCode7 = result.response["skuCoupons"][skuID_index_7111432122126]["coupons"][0]["couponCode"]
    * def couponCode8 = result.response["skuCoupons"][skuID_index_7111432122126]["coupons"][1]["couponCode"]
    * def couponCode9 = result.response["skuCoupons"][skuID_index_7111432122128]["coupons"][0]["couponCode"]
    * def couponCode10 = result.response["skuCoupons"][skuID_index_7111432122127]["coupons"][0]["couponCode"]
    * def couponCode11 = result.response["skuCoupons"][skuID_index_7111432122127]["coupons"][1]["couponCode"]
    * def couponCode12 = result.response["skuCoupons"][skuID_index_7111432122127]["coupons"][2]["couponCode"]
    * def couponCode13 = result.response["skuCoupons"][skuID_index_711143212229]["coupons"][0]["couponCode"]
    * def couponCode14 = result.response["skuCoupons"][skuID_index_711143212229]["coupons"][1]["couponCode"]
    * def couponCode15 = result.response["skuCoupons"][skuID_index_711143212230]["coupons"][0]["couponCode"]
    * def couponCode16 = result.response["skuCoupons"][skuID_index_711143212230]["coupons"][1]["couponCode"]

    * assert result.response["skuCoupons"][skuID_index_711143212226]["coupons"][0]["discountType"] == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discountType
    * assert result.response["skuCoupons"][skuID_index_711143212226]["coupons"][1]["discountType"] == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discountType
#    * assert result.response["skuCoupons"][skuID_index_711143212228]["coupons"][0]["discountType"] == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discountType
    * assert result.response["skuCoupons"][skuID_index_711143212227]["coupons"][0]["discountType"] == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discountType
    * assert result.response["skuCoupons"][skuID_index_711143212227]["coupons"][1]["discountType"] == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discountType
    * assert result.response["skuCoupons"][skuID_index_711143212227]["coupons"][2]["discountType"] == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discountType
    * assert result.response["skuCoupons"][skuID_index_7111432122126]["coupons"][0]["discountType"] == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discountType
    * assert result.response["skuCoupons"][skuID_index_7111432122126]["coupons"][1]["discountType"] == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discountType
    * assert result.response["skuCoupons"][skuID_index_7111432122128]["coupons"][0]["discountType"] == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discountType
    * assert result.response["skuCoupons"][skuID_index_7111432122127]["coupons"][0]["discountType"] == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discountType
    * assert result.response["skuCoupons"][skuID_index_7111432122127]["coupons"][1]["discountType"] == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discountType
    * assert result.response["skuCoupons"][skuID_index_7111432122127]["coupons"][2]["discountType"] == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discountType

    * assert result.response["skuCoupons"][skuID_index_711143212226]["quantity"]  == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].quantity_711143212226
    * assert result.response["skuCoupons"][skuID_index_711143212227]["quantity"]  == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].quantity_711143212227
#    * assert result.response["skuCoupons"][skuID_index_711143212228]["quantity"]  == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].quantity_711143212228
    * assert result.response["skuCoupons"][skuID_index_7111432122126]["quantity"]  == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].quantity_7111432122126
    * assert result.response["skuCoupons"][skuID_index_7111432122127]["quantity"]  == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].quantity_7111432122127
    * assert result.response["skuCoupons"][skuID_index_7111432122128]["quantity"]  == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].quantity_7111432122128

    * assert result.response["skuCoupons"][skuID_index_711143212226]["coupons"][0].discount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discount_711143212226
    * assert result.response["skuCoupons"][skuID_index_711143212226]["coupons"][1].discount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discount_711143212226
#    * assert result.response["skuCoupons"][skuID_index_711143212228]["coupons"][0].discount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discount_711143212228
    * assert result.response["skuCoupons"][skuID_index_711143212227]["coupons"][0].discount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discount_711143212227
    * assert result.response["skuCoupons"][skuID_index_711143212227]["coupons"][1].discount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discount_711143212227
    * assert result.response["skuCoupons"][skuID_index_711143212227]["coupons"][2].discount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discount_711143212227
    * assert result.response["skuCoupons"][skuID_index_7111432122126]["coupons"][0].discount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discount_7111432122126
    * assert result.response["skuCoupons"][skuID_index_7111432122126]["coupons"][1].discount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discount_7111432122126
    * assert result.response["skuCoupons"][skuID_index_7111432122128]["coupons"][0].discount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discount_7111432122128
    * assert result.response["skuCoupons"][skuID_index_7111432122127]["coupons"][0].discount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discount_7111432122127
    * assert result.response["skuCoupons"][skuID_index_7111432122127]["coupons"][1].discount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discount_7111432122127
    * assert result.response["skuCoupons"][skuID_index_7111432122127]["coupons"][2].discount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discount_7111432122127

    * assert result.response["skuCoupons"][skuID_index_711143212226]["price"] == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].price

    *  def transactionID =
    """
      function(){ return java.lang.System.currentTimeMillis() }
    """
    * def transaction_id = callonce transactionID

    * def b2b_coupon_711143212226 = db.readRows("SELECT MINIMUM_BILL_VALUE,VENDOR_CONTRIBUTION FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212226+ "\')")
    * def b2b_coupon_711143212227 = db.readRows("SELECT MINIMUM_BILL_VALUE,VENDOR_CONTRIBUTION FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212227+ "\')")
  #  * def b2b_coupon_711143212228 = db.readRows("SELECT MINIMUM_BILL_VALUE,VENDOR_CONTRIBUTION FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212228+ "\')")
    * def fc_711143212226 = db.readRows("SELECT MINIMUM_BILL_VALUE,VENDOR_CONTRIBUTION FROM FC_MERCHANT_COUPONS  WHERE merchant_coupon_code IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\')")
    * def fc_711143212227 = db.readRows("SELECT MINIMUM_BILL_VALUE,VENDOR_CONTRIBUTION FROM FC_MERCHANT_COUPONS  WHERE merchant_coupon_code IN (\'" +couponCode4+ "\',\'" +couponCode5+ "\',\'" +couponCode6+ "\')")
  #  * def fc_711143212228 = db.readRows("SELECT MINIMUM_BILL_VALUE,VENDOR_CONTRIBUTION FROM FC_MERCHANT_COUPONS  WHERE merchant_coupon_code IN (\'" +couponCode3+ "\'')")

    * match each fc_711143212226 == b2b_coupon_711143212226[0]
    * match each fc_711143212227 == b2b_coupon_711143212227[0]
    #* match each fc_711143212228 == b2b_coupon_711143212228[0]

  Scenario: B2B_PERCENT_DISCOUNT hold status verification __0029.6
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode4+ "\',\'" +couponCode5+ "\',\'" +couponCode6+ "\',\'" +couponCode7+ "\',\'" +couponCode8+ "\',\'" +couponCode9+ "\',\'" +couponCode10+ "\',\'" +couponCode11+ "\',\'" +couponCode12+ "\',\'" +couponCode13+ "\',\'" +couponCode14+ "\',\'" +couponCode15+ "\',\'" +couponCode16+ "\')")
    * print coupon_code_status
    * def b2b_coupons = db.readRows("SELECT * FROM B2B_COUPON WHERE ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[2]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[3]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[4]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupons
    * def b2b_coupon_redemption = db.readRows("SELECT * FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[2]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[3]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[4]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupon_redemption
    * def schema = schemaAndValidation["hold_FC_merchant_coupon"]
    * match each coupon_code_status == schema

    * def redeem_quantity_711143212226_c = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212226+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_711143212227_c = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212227+ "\')) and masid=\'" +masid+ "\'")
 #   * def redeem_quantity_711143212228_c = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212228+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_7111432122126_c = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +7111432122126+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_7111432122127_c = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +7111432122127+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_7111432122128_c = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +7111432122128+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_count_7111432122126_c = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +7111432122126+ "\'))")
    * def redeem_count_7111432122128_c = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +7111432122128+ "\'))")
    * def redeem_count_7111432122127_c = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +7111432122127+ "\'))")
    * def redeem_count_711143212226_c = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212226+ "\'))")
 #   * def redeem_count_711143212228_c = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212228+ "\'))")
    * def redeem_count_711143212227_c = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212227+ "\'))")

    # redemption count
    * match parseInt(redeem_quantity_711143212226_c[0].QUANTITY) == parseInt(redeem_quantity_711143212226[0].QUANTITY + 2)
    * match parseInt(redeem_quantity_711143212227_c[0].QUANTITY) == parseInt(redeem_quantity_711143212227[0].QUANTITY + 3)
 #   * match parseInt(redeem_quantity_711143212228_c[0].QUANTITY) == parseInt(redeem_quantity_711143212228[0].QUANTITY + 1)
    * match parseInt(redeem_count_711143212226_c[0].REDEEM_COUNT) == parseInt(redeem_count_711143212226[0].REDEEM_COUNT + 2)
    * match parseInt(redeem_count_711143212227_c[0].REDEEM_COUNT) == parseInt(redeem_count_711143212227[0].REDEEM_COUNT + 3)
 #   * match parseInt(redeem_count_711143212228_c[0].REDEEM_COUNT) == parseInt(redeem_count_711143212228[0].REDEEM_COUNT + 1)
    * match parseInt(redeem_quantity_7111432122126_c[0].QUANTITY) == parseInt(redeem_quantity_7111432122126[0].QUANTITY + 2)
    * match parseInt(redeem_quantity_7111432122127_c[0].QUANTITY) == parseInt(redeem_quantity_7111432122127[0].QUANTITY + 3)
    * match parseInt(redeem_quantity_7111432122128_c[0].QUANTITY) == parseInt(redeem_quantity_7111432122128[0].QUANTITY + 1)
    * match parseInt(redeem_count_7111432122126_c[0].REDEEM_COUNT) == parseInt(redeem_count_7111432122126[0].REDEEM_COUNT + 2)
    * match parseInt(redeem_count_7111432122127_c[0].REDEEM_COUNT) == parseInt(redeem_count_7111432122127[0].REDEEM_COUNT + 3)
    * match parseInt(redeem_count_7111432122128_c[0].REDEEM_COUNT) == parseInt(redeem_count_7111432122128[0].REDEEM_COUNT + 1)

  Scenario: B2B_PERCENT_DISCOUNT checkout partial return flow __0029.6
    * header override_flag = redeem_flags
    * def body =
    """
      {
      "masId": "#(masid)",
      "billAmount": #(apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].billAmount_mbv),
      "transactionId": "#(transaction_id)",
      "couponCodes":[#(couponCode1), #(couponCode2), #(couponCode4), #(couponCode5), #(couponCode6),#(couponCode7), #(couponCode8), #(couponCode9), #(couponCode10), #(couponCode11), #(couponCode12), #(couponCode13), #(couponCode14), #(couponCode15), #(couponCode16)],
      "skuData": #(apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption__0029.10"].skuData)
      }
    """

    Given path '/coupons/v1/coupons/merchant/fc/checkout'
    And request body
    When method post
    Then status 200

    * def coupon_code = get response.data[*].coupon
    * assert response.discountAmount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discountAmount_mbv_c
    * assert response.newBillAmount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].newBillAmount_mbv_c
    * match each response.data[*].discountType == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discountType
    * match each response.data[*].quantity == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].quantity
    * assert response.data[coupon_code.indexOf(couponCode1)].discount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discount_711143212226
    * assert response.data[coupon_code.indexOf(couponCode2)].discount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discount_711143212226
#    * assert response.data[coupon_code.indexOf(couponCode3)].discount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discount_711143212228
    * assert response.data[coupon_code.indexOf(couponCode4)].discount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discount_711143212227
    * assert response.data[coupon_code.indexOf(couponCode5)].discount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discount_711143212227
    * assert response.data[coupon_code.indexOf(couponCode6)].discount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discount_711143212227
    * assert response.data[coupon_code.indexOf(couponCode7)].discount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discount_7111432122126
    * assert response.data[coupon_code.indexOf(couponCode8)].discount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discount_7111432122126
    * assert response.data[coupon_code.indexOf(couponCode9)].discount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discount_7111432122128
    * assert response.data[coupon_code.indexOf(couponCode10)].discount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discount_7111432122127
    * assert response.data[coupon_code.indexOf(couponCode11)].discount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discount_7111432122127
    * assert response.data[coupon_code.indexOf(couponCode12)].discount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.10"].discount_7111432122127

    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode4+ "\',\'" +couponCode5+ "\',\'" +couponCode6+ "\',\'" +couponCode7+ "\',\'" +couponCode8+ "\',\'" +couponCode9+ "\',\'" +couponCode10+ "\',\'" +couponCode11+ "\',\'" +couponCode12+ "\',\'" +couponCode13+ "\',\'" +couponCode14+ "\',\'" +couponCode15+ "\',\'" +couponCode16+ "\')")
    * print coupon_code_status
    * def b2b_coupons = db.readRows("SELECT * FROM B2B_COUPON WHERE ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[2]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[3]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[4]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupons
    * def b2b_coupon_redemption = db.readRows("SELECT * FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[2]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[3]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[4]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupon_redemption
    * def schema = schemaAndValidation["checkout_FC_merchant_coupon"]
    And match each coupon_code_status == schema

  Scenario: B2B_PERCENT_DISCOUNT delivered partial return flow __0029.6

    * header x-client-type = "hybris"
    * def body  =
    """
    {
      "couponCodes":[#(couponCode1), #(couponCode2), #(couponCode4), #(couponCode5), #(couponCode6),#(couponCode7), #(couponCode8), #(couponCode9), #(couponCode10), #(couponCode11), #(couponCode12), #(couponCode13), #(couponCode14), #(couponCode15), #(couponCode16)],
      "coupons" : [],
      "masId": "#(masid)",
     }
    """
    Given path '/coupons/v1/coupons/merchant/fc/delivered'
    And request body
    When method post
    Then status 200
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode4+ "\',\'" +couponCode5+ "\',\'" +couponCode6+ "\',\'" +couponCode7+ "\',\'" +couponCode8+ "\',\'" +couponCode9+ "\',\'" +couponCode10+ "\',\'" +couponCode11+ "\',\'" +couponCode12+ "\',\'" +couponCode13+ "\',\'" +couponCode14+ "\',\'" +couponCode15+ "\',\'" +couponCode16+ "\')")
    * print coupon_code_status

    * def b2b_coupons = db.readRows("SELECT * FROM B2B_COUPON WHERE ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[2]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[3]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[4]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupons

    * def b2b_coupon_redemption = db.readRows("SELECT * FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[2]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[3]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[4]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupon_redemption

    * def update_delivered_TS = db.updateRow("UPDATE FC_MERCHANT_COUPONS SET DELIVERED_TS = CURRENT_TIMESTAMP - 20 WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode4+ "\',\'" +couponCode5+ "\',\'" +couponCode6+ "\',\'" +couponCode10+ "\',\'" +couponCode11+ "\',\'" +couponCode12+ "\',\'" +couponCode13+ "\',\'" +couponCode14+ "\',\'" +couponCode15+ "\',\'" +couponCode16+ "\')")
    * def schema = schemaAndValidation["delivered_FC_merchant_coupon"]
    * match each coupon_code_status == schema

  Scenario: B2B_PERCENT_DISCOUNT delayed cancel partial return flow __0029.6
     # redemption count
    * def redeem_quantity_711143212226 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212226+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_711143212227 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212227+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_711143212228 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212228+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_count_711143212226 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212226+ "\'))")
    * def redeem_count_711143212228 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212228+ "\'))")
    * def redeem_count_711143212227 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212227+ "\'))")
    * def redeem_quantity_7111432122126 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +7111432122126+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_7111432122127 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +7111432122127+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_7111432122128 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +7111432122128+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_count_7111432122126 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +7111432122126+ "\'))")
    * def redeem_count_7111432122128 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +7111432122128+ "\'))")
    * def redeem_count_7111432122127 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +7111432122127+ "\'))")

    * def body  =
    """
    {
      "couponCodes":[#(couponCode1), #(couponCode2),#(couponCode7), #(couponCode8)],
      "coupons" : [],
      "masId": "#(masid)",
     }
    """
    Given path '/coupons/v1/coupons/merchant/fc/delayed-cancel'
    And request body
    When method post
    Then status 200
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode7+ "\',\'" +couponCode8+ "\')")
    * print coupon_code_status

    * def coupon_code_uncancelled_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode4+ "\',\'" +couponCode5+ "\',\'" +couponCode6+ "\',\'" +couponCode10+ "\',\'" +couponCode11+ "\',\'" +couponCode12+ "\',\'" +couponCode13+ "\',\'" +couponCode14+ "\',\'" +couponCode15+ "\',\'" +couponCode16+ "\')")
    * def schema = schemaAndValidation["cancelled_FC_merchant_coupon"]
    And match each coupon_code_status == schema

#  redemption count after return in  B2B_COUPON_REDEMPTION & B2B_COUPON
    * def redeem_quantity_711143212226_r = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212226+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_711143212227_r = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212227+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_711143212228_r = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212228+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_count_711143212226_r = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212226+ "\'))")
    * def redeem_count_711143212227_r = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212227+ "\'))")
    * def redeem_count_711143212228_r = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212228+ "\'))")
    * def redeem_quantity_7111432122126_r = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +7111432122126+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_7111432122127_r = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +7111432122127+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_7111432122128_r = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +7111432122128+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_count_7111432122126_r = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +7111432122126+ "\'))")
    * def redeem_count_7111432122128_r = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +7111432122128+ "\'))")
    * def redeem_count_7111432122127_r = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +7111432122127+ "\'))")

      # redemption count
    * match parseInt(redeem_quantity_711143212226_r[0].QUANTITY) == parseInt(redeem_quantity_711143212226[0].QUANTITY - 2)
    * match parseInt(redeem_quantity_711143212227_r[0].QUANTITY) == parseInt(redeem_quantity_711143212227[0].QUANTITY)
    * match parseInt(redeem_quantity_711143212228_r[0].QUANTITY) == parseInt(redeem_quantity_711143212228[0].QUANTITY)
    * match parseInt(redeem_count_711143212226_r[0].REDEEM_COUNT) == parseInt(redeem_count_711143212226[0].REDEEM_COUNT - 2)
    * match parseInt(redeem_count_711143212227_r[0].REDEEM_COUNT) == parseInt(redeem_count_711143212227[0].REDEEM_COUNT)
    * match parseInt(redeem_count_711143212228_r[0].REDEEM_COUNT) == parseInt(redeem_count_711143212228[0].REDEEM_COUNT)

    * match parseInt(redeem_quantity_7111432122126_r[0].QUANTITY) == parseInt(redeem_quantity_7111432122126[0].QUANTITY - 2)
    * match parseInt(redeem_quantity_7111432122127_r[0].QUANTITY) == parseInt(redeem_quantity_7111432122127[0].QUANTITY)
    * match parseInt(redeem_quantity_7111432122128_r[0].QUANTITY) == parseInt(redeem_quantity_7111432122128[0].QUANTITY)
    * match parseInt(redeem_count_7111432122126_r[0].REDEEM_COUNT) == parseInt(redeem_count_7111432122126[0].REDEEM_COUNT - 2)
    * match parseInt(redeem_count_7111432122127_r[0].REDEEM_COUNT) == parseInt(redeem_count_7111432122127[0].REDEEM_COUNT)
    * match parseInt(redeem_count_7111432122128_r[0].REDEEM_COUNT) == parseInt(redeem_count_7111432122128[0].REDEEM_COUNT)

  Scenario: B2B_PERCENT_DISCOUNT redeem partial return flow __0029.6
    * def body  =
    """
    {
    }
    """
    Given path '/coupons/v1/coupons/merchant/fc/mark-redeemed'
    And request body
    When method post
    Then status 200
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode4+ "\',\'" +couponCode5+ "\',\'" +couponCode6+ "\',\'" +couponCode10+ "\',\'" +couponCode11+ "\',\'" +couponCode12+ "\',\'" +couponCode13+ "\',\'" +couponCode14+ "\',\'" +couponCode15+ "\',\'" +couponCode16+ "\')")
    * print coupon_code_status
    And match each coupon_code_status == schemaAndValidation["redeemed_FC_merchant_coupon"]


  Scenario: B2B_PERCENT_DISCOUNT checkout of cancelled coupons in partial return flow __0029.6
    * def body =
    """
      {
      "masId": "#(masid)",
      "billAmount": #(apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption__0029.10"].billAmount),
      "transactionId": "#(transaction_id)",
      "couponCodes":[#(couponCode1), #(couponCode2),#(couponCode7), #(couponCode8)],
      "skuData": #(apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption__0029.10"].skuData)
      }
    """
    Given path '/coupons/v1/coupons/merchant/fc/checkout'
    And request body
    When method post
    Then status 400
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\')")
    * print coupon_code_status
    * match each coupon_code_status == schemaAndValidation["cancelled_FC_merchant_coupon"]

  Scenario: Switching off the features __0029.6.
    * def call_configuration_table = callonce read('support.feature@switch_off_features')
    * def call_configuration_table_b2b = callonce read('support.feature@switch_off_features_b2b')
    * def call_configuration_table_mbv = callonce read('support.feature@switch_off_features_mbv')