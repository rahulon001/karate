Feature: B2B_FLAT_DISCOUNT_ON_SKU MarkRedemptionFlow __0036.6

  Background:
    * url baseUrl
#    * call read('support.feature@common_functions')
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
    * def redeem_quantity_811143212221 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212221+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_811143212222 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212222+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_8111432122121 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +8111432122121+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_8111432122123 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +8111432122123+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_8111432122122 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +8111432122122+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_811143212219 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212219+ "\')) and masid=\'" +masid+ "\'")
#    * def redeem_quantity_811143212220 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212220+ "\')) and masid=\'" +masid+ "\'")

    * def redeem_count_8111432122121 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +8111432122121+ "\'))")
    * def redeem_count_8111432122123 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +8111432122123+ "\'))")
    * def redeem_count_8111432122122 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +8111432122122+ "\'))")
    * def redeem_count_811143212221 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212221+ "\'))")
    * def redeem_count_811143212222 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212222+ "\'))")
    * def redeem_count_811143212219 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212219+ "\'))")
#    * def redeem_count_811143212220 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212220+ "\'))")

    * def sku_price = apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].price
    * def bill_amount = apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].billAmount_mbv
    * def result = callonce read("B2C_B2B_CouponCodeGeneration.feature@B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_combination") {requestHeader: #(headerJson) , skuPrice: #(sku_price), billAmount: #(bill_amount)}

    * def skuID = get result.response.skuCoupons[*].skuId
    * def skuID_index_811143212219 = skuID.indexOf("811143212219")
    * match skuID.indexOf("811143212220") == -1
    * def skuID_index_811143212221 = skuID.indexOf("811143212221")
    * def skuID_index_811143212222 = skuID.indexOf("811143212222")
#    * def skuID_index_811143212223 = skuID.indexOf("811143212223")

    * match skuID.indexOf("811143212223") == -1

    * def skuID_index_8111432122121 = skuID.indexOf("8111432122121")
    * def skuID_index_8111432122122 = skuID.indexOf("8111432122122")
    * def skuID_index_8111432122123 = skuID.indexOf("8111432122123")


    * match each result.response.skuCoupons[*].coupons[0].couponQty == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].couponQty

    * def couponCode1 = result.response["skuCoupons"][skuID_index_811143212221]["coupons"][0]["couponCode"]
    * def couponCode2 = result.response["skuCoupons"][skuID_index_811143212222]["coupons"][0]["couponCode"]
    * def couponCode3 = result.response["skuCoupons"][skuID_index_811143212222]["coupons"][1]["couponCode"]
#    * def couponCode4 = result.response["skuCoupons"][skuID_index_811143212223]["coupons"][0]["couponCode"]
#    * def couponCode5 = result.response["skuCoupons"][skuID_index_811143212223]["coupons"][1]["couponCode"]
#    * def couponCode6 = result.response["skuCoupons"][skuID_index_811143212223]["coupons"][2]["couponCode"]
    * def couponCode7 = result.response["skuCoupons"][skuID_index_8111432122121]["coupons"][0]["couponCode"]
    * def couponCode8 = result.response["skuCoupons"][skuID_index_8111432122122]["coupons"][0]["couponCode"]
    * def couponCode9 = result.response["skuCoupons"][skuID_index_8111432122122]["coupons"][1]["couponCode"]
    * def couponCode10 = result.response["skuCoupons"][skuID_index_8111432122123]["coupons"][0]["couponCode"]
    * def couponCode11 = result.response["skuCoupons"][skuID_index_8111432122123]["coupons"][1]["couponCode"]
    * def couponCode12 = result.response["skuCoupons"][skuID_index_8111432122123]["coupons"][2]["couponCode"]
    * def couponCode13 = result.response["skuCoupons"][skuID_index_811143212219]["coupons"][0]["couponCode"]
    * def couponCode14 = result.response["skuCoupons"][skuID_index_811143212219]["coupons"][1]["couponCode"]
#    * def couponCode15 = result.response["skuCoupons"][skuID_index_811143212220]["coupons"][0]["couponCode"]
#    * def couponCode16 = result.response["skuCoupons"][skuID_index_811143212220]["coupons"][1]["couponCode"]

    * assert result.response["skuCoupons"][skuID_index_811143212221]["coupons"][0]["discountType"] == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discountType
    * assert result.response["skuCoupons"][skuID_index_811143212222]["coupons"][0]["discountType"] == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discountType
    * assert result.response["skuCoupons"][skuID_index_811143212222]["coupons"][1]["discountType"] == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discountType
#    * assert result.response["skuCoupons"][skuID_index_811143212223]["coupons"][0]["discountType"] == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discountType
#    * assert result.response["skuCoupons"][skuID_index_811143212223]["coupons"][1]["discountType"] == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discountType
#    * assert result.response["skuCoupons"][skuID_index_811143212223]["coupons"][2]["discountType"] == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discountType

    * assert result.response["skuCoupons"][skuID_index_8111432122121]["coupons"][0]["discountType"] == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discountType
    * assert result.response["skuCoupons"][skuID_index_8111432122122]["coupons"][0]["discountType"] == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discountType
    * assert result.response["skuCoupons"][skuID_index_8111432122122]["coupons"][1]["discountType"] == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discountType
    * assert result.response["skuCoupons"][skuID_index_8111432122123]["coupons"][0]["discountType"] == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discountType
    * assert result.response["skuCoupons"][skuID_index_8111432122123]["coupons"][1]["discountType"] == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discountType
    * assert result.response["skuCoupons"][skuID_index_8111432122123]["coupons"][2]["discountType"] == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discountType
    * assert result.response["skuCoupons"][skuID_index_811143212219]["coupons"][0]["discountType"] == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discountType
    * assert result.response["skuCoupons"][skuID_index_811143212219]["coupons"][1]["discountType"] == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discountType
#    * assert result.response["skuCoupons"][skuID_index_811143212220]["coupons"][0]["discountType"] == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discountType
#    * assert result.response["skuCoupons"][skuID_index_811143212220]["coupons"][1]["discountType"] == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discountType


    * assert result.response["skuCoupons"][skuID_index_811143212221]["quantity"]  == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].quantity_811143212221
    * assert result.response["skuCoupons"][skuID_index_811143212222]["quantity"]  == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].quantity_811143212222
#    * assert result.response["skuCoupons"][skuID_index_811143212223]["quantity"]  == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].quantity_811143212223
    * assert result.response["skuCoupons"][skuID_index_8111432122121]["quantity"]  == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].quantity_8111432122121
    * assert result.response["skuCoupons"][skuID_index_8111432122122]["quantity"]  == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].quantity_8111432122122
    * assert result.response["skuCoupons"][skuID_index_8111432122123]["quantity"]  == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].quantity_8111432122123


    * assert result.response["skuCoupons"][skuID_index_811143212221]["coupons"][0].discount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discount_811143212221
    * assert result.response["skuCoupons"][skuID_index_811143212222]["coupons"][0].discount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discount_811143212222
    * assert result.response["skuCoupons"][skuID_index_811143212222]["coupons"][1].discount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discount_811143212222
#    * assert result.response["skuCoupons"][skuID_index_811143212223]["coupons"][0].discount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discount_811143212223
#    * assert result.response["skuCoupons"][skuID_index_811143212223]["coupons"][1].discount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discount_811143212223
#    * assert result.response["skuCoupons"][skuID_index_811143212223]["coupons"][2].discount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discount_811143212223
    * assert result.response["skuCoupons"][skuID_index_8111432122121]["coupons"][0].discount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discount_8111432122121
    * assert result.response["skuCoupons"][skuID_index_8111432122122]["coupons"][0].discount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discount_8111432122122
    * assert result.response["skuCoupons"][skuID_index_8111432122122]["coupons"][1].discount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discount_8111432122122
   * assert result.response["skuCoupons"][skuID_index_8111432122123]["coupons"][0].discount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discount_8111432122123
   * assert result.response["skuCoupons"][skuID_index_8111432122123]["coupons"][1].discount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discount_8111432122123
   * assert result.response["skuCoupons"][skuID_index_8111432122123]["coupons"][2].discount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discount_8111432122123

    * assert result.response["skuCoupons"][skuID_index_811143212221]["price"] == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].price

    *  def transactionID =
    """
      function(){ return java.lang.System.currentTimeMillis() }
    """
    * def transaction_id = callonce transactionID


  Scenario: B2B_FLAT_DISCOUNT_ON_SKU verifying hold status __0036.12
    * def b2b_coupon_811143212221 = db.readRows("SELECT MINIMUM_BILL_VALUE,VENDOR_CONTRIBUTION FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212221+ "\')")
    * def b2b_coupon_811143212222 = db.readRows("SELECT MINIMUM_BILL_VALUE,VENDOR_CONTRIBUTION FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212222+ "\')")
  #  * def b2b_coupon_811143212223 = db.readRows("SELECT MINIMUM_BILL_VALUE,VENDOR_CONTRIBUTION FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212223+ "\')")
    * def fc_811143212221 = db.readRows("SELECT MINIMUM_BILL_VALUE,VENDOR_CONTRIBUTION FROM FC_MERCHANT_COUPONS  WHERE merchant_coupon_code IN (\'" +couponCode1+ "\')")
    * def fc_811143212222 = db.readRows("SELECT MINIMUM_BILL_VALUE,VENDOR_CONTRIBUTION FROM FC_MERCHANT_COUPONS  WHERE merchant_coupon_code IN (\'" +couponCode2+ "\',\'" +couponCode3+ "\')")
  #  * def fc_811143212223 = db.readRows("SELECT MINIMUM_BILL_VALUE,VENDOR_CONTRIBUTION FROM FC_MERCHANT_COUPONS  WHERE merchant_coupon_code IN (\'" +couponCode4+ "\',\'" +couponCode5+ "\',\'" +couponCode6+ "\')")

    * match each fc_811143212221 == b2b_coupon_811143212221[0]
    * match each fc_811143212222 == b2b_coupon_811143212222[0]
    #* match each fc_811143212223 == b2b_coupon_811143212223[0]

    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode3+ "\',\'" +couponCode7+ "\',\'" +couponCode8+ "\',\'" +couponCode9+ "\',\'" +couponCode10+ "\',\'" +couponCode11+ "\',\'" +couponCode12+ "\',\'" +couponCode13+ "\',\'" +couponCode14+ "\')")
    * print coupon_code_status
    * def b2b_coupons = db.readRows("SELECT * FROM B2B_COUPON WHERE ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[2]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupons
    * def b2b_coupon_redemption = db.readRows("SELECT * FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[2]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupon_redemption
    * def schema = schemaAndValidation["hold_FC_merchant_coupon"]
    * match each coupon_code_status == schema

    * def redeem_quantity_811143212221_c = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212221+ "\')) and masid=\'" +masid+ "\'")
 #   * def redeem_quantity_811143212223_c = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212223+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_811143212222_c = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212222+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_8111432122121_c = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +8111432122121+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_8111432122123_c = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +8111432122123+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_8111432122122_c = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +8111432122122+ "\')) and masid=\'" +masid+ "\'")


    * def redeem_count_811143212221_c = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212221+ "\'))")
 #   * def redeem_count_811143212223_c = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212223+ "\'))")
    * def redeem_count_811143212222_c = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212222+ "\'))")
    * def redeem_count_8111432122121_c = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +8111432122121+ "\'))")
    * def redeem_count_8111432122123_c = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +8111432122123+ "\'))")
    * def redeem_count_8111432122122_c = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +8111432122122+ "\'))")

    # redemption count
    * match parseInt(redeem_quantity_811143212221_c[0].QUANTITY) == parseInt(redeem_quantity_811143212221[0].QUANTITY + 1)
 #   * match parseInt(redeem_quantity_811143212223_c[0].QUANTITY) == parseInt(redeem_quantity_811143212223[0].QUANTITY + 3)
    * match parseInt(redeem_quantity_811143212222_c[0].QUANTITY) == parseInt(redeem_quantity_811143212222[0].QUANTITY + 2)
    * match parseInt(redeem_quantity_8111432122121_c[0].QUANTITY) == parseInt(redeem_quantity_8111432122121[0].QUANTITY + 1)
    * match parseInt(redeem_quantity_8111432122123_c[0].QUANTITY) == parseInt(redeem_quantity_8111432122123[0].QUANTITY + 3)
    * match parseInt(redeem_quantity_8111432122122_c[0].QUANTITY) == parseInt(redeem_quantity_8111432122122[0].QUANTITY + 2)
    * match parseInt(redeem_count_8111432122121_c[0].REDEEM_COUNT) == parseInt(redeem_count_8111432122121[0].REDEEM_COUNT + 1)
    * match parseInt(redeem_count_8111432122123_c[0].REDEEM_COUNT) == parseInt(redeem_count_8111432122123[0].REDEEM_COUNT + 3)
    * match parseInt(redeem_count_8111432122122_c[0].REDEEM_COUNT) == parseInt(redeem_count_8111432122122[0].REDEEM_COUNT + 2)
    * match parseInt(redeem_count_811143212221_c[0].REDEEM_COUNT) == parseInt(redeem_count_811143212221[0].REDEEM_COUNT + 1)
 #   * match parseInt(redeem_count_811143212223_c[0].REDEEM_COUNT) == parseInt(redeem_count_811143212223[0].REDEEM_COUNT + 3)
    * match parseInt(redeem_count_811143212222_c[0].REDEEM_COUNT) == parseInt(redeem_count_811143212222[0].REDEEM_COUNT + 2)

  Scenario: B2B_FLAT_DISCOUNT_ON_SKU checkout Mark Redemption Flow __0036.6.
     * header override_flag = redeem_flags
    * def body =
    """
      {
      "masId": "#(masid)",
      "billAmount": #(apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].billAmount_mbv),
      "transactionId": "#(transaction_id)",
      "couponCodes":[#(couponCode1), #(couponCode2), #(couponCode3),#(couponCode7), #(couponCode8), #(couponCode9), #(couponCode10), #(couponCode11), #(couponCode12), #(couponCode13),#(couponCode14)],
      "skuData": #(apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption__0036.12"].skuData)
      }
    """

    Given path '/coupons/v1/coupons/merchant/fc/checkout'
    And request body
    When method post
    Then status 200

    * def coupon_code = get response.data[*].coupon
    * assert response.discountAmount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discountAmount_mbv_c
    * assert response.newBillAmount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].newBillAmount_mbv_c
    * match each response.data[*].discountType == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discountType
    * match each response.data[*].quantity == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].quantity
    * assert response.data[coupon_code.indexOf(couponCode1)].discount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discount_811143212221
    * assert response.data[coupon_code.indexOf(couponCode2)].discount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discount_811143212222
    * assert response.data[coupon_code.indexOf(couponCode3)].discount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discount_811143212222
#    * assert response.data[coupon_code.indexOf(couponCode4)].discount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discount_811143212223
#    * assert response.data[coupon_code.indexOf(couponCode5)].discount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discount_811143212223
#    * assert response.data[coupon_code.indexOf(couponCode6)].discount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036.12"].discount_811143212223

    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode3+ "\',\'" +couponCode7+ "\',\'" +couponCode8+ "\',\'" +couponCode9+ "\',\'" +couponCode10+ "\',\'" +couponCode11+ "\',\'" +couponCode12+ "\')")
    * print coupon_code_status
    * def b2b_coupons = db.readRows("SELECT * FROM B2B_COUPON WHERE ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[2]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupons
    * def b2b_coupon_redemption = db.readRows("SELECT * FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[2]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupon_redemption
    * def schema = schemaAndValidation["checkout_FC_merchant_coupon"]
    And match each coupon_code_status == schema

  Scenario: B2B_FLAT_DISCOUNT_ON_SKU delivered Mark Redemption Flow __0036.6.
    * header x-client-type = "hybris"
    * def body  =
    """
    {
      "couponCodes":[#(couponCode1), #(couponCode2), #(couponCode3),#(couponCode7), #(couponCode8), #(couponCode9), #(couponCode10), #(couponCode11), #(couponCode12)],
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

    * def b2b_coupons = db.readRows("SELECT * FROM B2B_COUPON WHERE ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[2]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupons

    * def b2b_coupon_redemption = db.readRows("SELECT * FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[2]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupon_redemption

    * def update_delivered_TS = db.updateRow("UPDATE FC_MERCHANT_COUPONS SET DELIVERED_TS = CURRENT_TIMESTAMP - 20 WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode3+ "\',\'" +couponCode7+ "\',\'" +couponCode8+ "\',\'" +couponCode9+ "\',\'" +couponCode10+ "\',\'" +couponCode11+ "\',\'" +couponCode12+ "\')")
    * def schema = schemaAndValidation["delivered_FC_merchant_coupon"]
    * match each coupon_code_status == schema

  Scenario: B2B_FLAT_DISCOUNT_ON_SKU delayed cancel partial return flow __0036.6
      # redemption count
    * def redeem_quantity_811143212221 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212221+ "\')) and masid=\'" +masid+ "\'")
 #   * def redeem_quantity_811143212223 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212223+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_811143212222 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212222+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_count_811143212221 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212221+ "\'))")
 #   * def redeem_count_811143212223 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212223+ "\'))")
    * def redeem_count_811143212222 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212222+ "\'))")

    * def redeem_quantity_8111432122121 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +8111432122121+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_8111432122123 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +8111432122123+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_8111432122122 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +8111432122122+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_count_8111432122121 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +8111432122121+ "\'))")
    * def redeem_count_8111432122123 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +8111432122123+ "\'))")
    * def redeem_count_8111432122122 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +8111432122122+ "\'))")

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
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\')")
    * print coupon_code_status

    * def update_delivered_TS = db.updateRow("UPDATE FC_MERCHANT_COUPONS SET DELIVERED_TS = CURRENT_TIMESTAMP - 20 WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode3+ "\')")
    * def schema = schemaAndValidation["cancelled_FC_merchant_coupon"]
    And match each coupon_code_status == schema

    * def redeem_quantity_811143212221_r = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212221+ "\')) and masid=\'" +masid+ "\'")
 #   * def redeem_quantity_811143212223_r = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212223+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_811143212222_r = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212222+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_count_811143212221_r = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212221+ "\'))")
 #   * def redeem_count_811143212223_r = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212223+ "\'))")
    * def redeem_count_811143212222_r = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +811143212222+ "\'))")

    * def redeem_quantity_8111432122121_r = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +8111432122121+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_8111432122123_r = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +8111432122123+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_8111432122122_r = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +8111432122122+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_count_8111432122121_r = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +8111432122121+ "\'))")
    * def redeem_count_8111432122123_r = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +8111432122123+ "\'))")
    * def redeem_count_8111432122122_r = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +8111432122122+ "\'))")

    # redemption count
    * match parseInt(redeem_quantity_811143212221_r[0].QUANTITY) == parseInt(redeem_quantity_811143212221[0].QUANTITY -1 )
#    * match parseInt(redeem_quantity_811143212223_r[0].QUANTITY) == parseInt(redeem_quantity_811143212223[0].QUANTITY)
    * match parseInt(redeem_quantity_811143212222_r[0].QUANTITY) == parseInt(redeem_quantity_811143212222[0].QUANTITY - 1)
    * match parseInt(redeem_count_811143212221_r[0].REDEEM_COUNT) == parseInt(redeem_count_811143212221[0].REDEEM_COUNT -1)
 #   * match parseInt(redeem_count_811143212223_r[0].REDEEM_COUNT) == parseInt(redeem_count_811143212223[0].REDEEM_COUNT)
    * match parseInt(redeem_count_811143212222_r[0].REDEEM_COUNT) == parseInt(redeem_count_811143212222[0].REDEEM_COUNT - 1)

    * match parseInt(redeem_quantity_8111432122121_r[0].QUANTITY) == parseInt(redeem_quantity_8111432122121[0].QUANTITY -1 )
    * match parseInt(redeem_quantity_8111432122123_r[0].QUANTITY) == parseInt(redeem_quantity_8111432122123[0].QUANTITY)
    * match parseInt(redeem_quantity_8111432122122_r[0].QUANTITY) == parseInt(redeem_quantity_8111432122122[0].QUANTITY - 1)
    * match parseInt(redeem_count_8111432122121_r[0].REDEEM_COUNT) == parseInt(redeem_count_8111432122121[0].REDEEM_COUNT -1)
    * match parseInt(redeem_count_8111432122123_r[0].REDEEM_COUNT) == parseInt(redeem_count_8111432122123[0].REDEEM_COUNT)
    * match parseInt(redeem_count_8111432122122_r[0].REDEEM_COUNT) == parseInt(redeem_count_8111432122122[0].REDEEM_COUNT - 1)


  Scenario: B2B_FLAT_DISCOUNT_ON_SKU redeem partial return flow __0036.6
    * def body  =
    """
    {
    }
    """
    Given path '/coupons/v1/coupons/merchant/fc/mark-redeemed'
    And request body
    When method post
    Then status 200
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode3+ "\',\'" +couponCode9+ "\',\'" +couponCode10+ "\',\'" +couponCode11+ "\',\'" +couponCode12+ "\')")
    * print coupon_code_status
    And match each coupon_code_status == schemaAndValidation["redeemed_FC_merchant_coupon"]

  Scenario: B2B_FLAT_DISCOUNT_ON_SKU checkout of cancelled coupons in partial return flow __0036.6
    * def body =
    """
      {
      "masId": "#(masid)",
      "billAmount": #(apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption__0036.12"].billAmount),
      "transactionId": "#(transaction_id)",
      "couponCodes":[#(couponCode1), #(couponCode2),#(couponCode7), #(couponCode8)],
      "skuData": #(apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption__0036.12"].skuData)
      }
    """
    Given path '/coupons/v1/coupons/merchant/fc/checkout'
    And request body
    When method post
    Then status 400
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode7+ "\',\'" +couponCode8+ "\')")
    * print coupon_code_status
    * match each coupon_code_status == schemaAndValidation["cancelled_FC_merchant_coupon"]

  Scenario: Switching off the features __0036.6.
    * def call_configuration_table = callonce read('support.feature@switch_off_features')
    * def call_configuration_table_mbv = callonce read('support.feature@switch_off_features_mbv')