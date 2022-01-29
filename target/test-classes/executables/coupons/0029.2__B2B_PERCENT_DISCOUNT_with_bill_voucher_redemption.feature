
Feature: B2B_PERCENT_DISCOUNT Bill_voucher mark redeem flow __0029.2

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
    * def redeem_quantity_711143212226 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212226+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_711143212227 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212227+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_711143212228 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212228+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_count_711143212226 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212226+ "\'))")
    * def redeem_count_711143212228 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212228+ "\'))")
    * def redeem_count_711143212227 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212227+ "\'))")

    * def sku_price = apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029"].price
    * def bill_amount = apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption__0029"].billAmount
    * def result = callonce read("B2C_B2B_CouponCodeGeneration.feature@B2B_PERCENT_DISCOUNT_coupon_redemption") {requestHeader: #(headerJson) , skuPrice: #(sku_price), billAmount: #(bill_amount)}

    * def skuID = get result.response.skuCoupons[*].skuId
    * def skuID_index_711143212226 = skuID.indexOf("711143212226")
    * def skuID_index_711143212228 = skuID.indexOf("711143212228")
    * def skuID_index_711143212227 = skuID.indexOf("711143212227")

    * def couponCode1 = result.response["skuCoupons"][skuID_index_711143212226]["coupons"][0]["couponCode"]
    * def couponCode2 = result.response["skuCoupons"][skuID_index_711143212226]["coupons"][1]["couponCode"]
    * def couponCode3 = result.response["skuCoupons"][skuID_index_711143212228]["coupons"][0]["couponCode"]
    * def couponCode4 = result.response["skuCoupons"][skuID_index_711143212227]["coupons"][0]["couponCode"]
    * def couponCode5 = result.response["skuCoupons"][skuID_index_711143212227]["coupons"][1]["couponCode"]
    * def couponCode6 = result.response["skuCoupons"][skuID_index_711143212227]["coupons"][2]["couponCode"]
    * def couponCode_bill_voucher = result.response.billVouchers[0].redeemCode

    * def discount_bill_voucher = result.response.billVouchers[0].discount

    * def couponQuantity1 = result.response["skuCoupons"][skuID_index_711143212226]["coupons"][0]["couponQty"]
    * def couponQuantity2 = result.response["skuCoupons"][skuID_index_711143212228]["coupons"][0]["couponQty"]
    * def couponQuantity3 = result.response["skuCoupons"][skuID_index_711143212227]["coupons"][0]["couponQty"]


    *  def transactionID =
    """
      function(){ return java.lang.System.currentTimeMillis() }
    """
    * def transaction_id = callonce transactionID


  Scenario: B2B_PERCENT_DISCOUNT checkout mark redeem flow __0029.2
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode3+ "\',\'" +couponCode4+ "\',\'" +couponCode5+ "\',\'" +couponCode6+ "\')")
    * print coupon_code_status
    * def b2b_coupons = db.readRows("SELECT * FROM B2B_COUPON WHERE ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[2]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[3]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[4]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupons
    * def conditional_coupon_derived_from = b2b_coupons[0].CONDITIONAL_COUPON_ID
    * def b2b_conditional_coupons = db.readRows("SELECT * FROM B2B_COUPON WHERE DERIVED_FROM IN (\'" +conditional_coupon_derived_from+ "\')")
    * print b2b_conditional_coupons
    * def b2b_coupon_redemption = db.readRows("SELECT * FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[2]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[3]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[4]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupon_redemption
    * def schema = schemaAndValidation["hold_FC_merchant_coupon"]
    * match each coupon_code_status == schema

    * def redeem_quantity_711143212226_c = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212226+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_711143212227_c = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212227+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_711143212228_c = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212228+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_count_711143212226_c = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212226+ "\'))")
    * def redeem_count_711143212228_c = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212228+ "\'))")
    * def redeem_count_711143212227_c = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212227+ "\'))")

    # redemption count
    * match parseInt(redeem_quantity_711143212226_c[0].QUANTITY) == parseInt(redeem_quantity_711143212226[0].QUANTITY + 2)
    * match parseInt(redeem_quantity_711143212227_c[0].QUANTITY) == parseInt(redeem_quantity_711143212227[0].QUANTITY + 3)
    * match parseInt(redeem_quantity_711143212228_c[0].QUANTITY) == parseInt(redeem_quantity_711143212228[0].QUANTITY + 1)
    * match parseInt(redeem_count_711143212226_c[0].REDEEM_COUNT) == parseInt(redeem_count_711143212226[0].REDEEM_COUNT + 2)
    * match parseInt(redeem_count_711143212227_c[0].REDEEM_COUNT) == parseInt(redeem_count_711143212227[0].REDEEM_COUNT + 3)
    * match parseInt(redeem_count_711143212228_c[0].REDEEM_COUNT) == parseInt(redeem_count_711143212228[0].REDEEM_COUNT + 1)

  Scenario: B2B_PERCENT_DISCOUNT checkout mark redeem flow __0029.2
    * header override_flag = redeem_flags

    # recreation of skuData of the request body
    * def sku_data = apiComponents.B2B_PERCENT_DISCOUNT_coupon_redemption__0029.skuData

    * eval if (!sku_data[0].coupons) sku_data[0].coupons = {"couponCode": couponCode1,"quantity" : couponQuantity1}
    * set sku_data[0].coupons = [{"couponCode": #(couponCode1), "quantity" : #(couponQuantity1)}, {"couponCode": #(couponCode2), "quantity" : #(couponQuantity1)}]

    * eval if (!sku_data[1].coupons) sku_data[1].coupons = {"couponCode": couponCode3, "quantity" : couponQuantity2}
    * set sku_data[1].coupons = [{"couponCode": #(couponCode3), "quantity" : #(couponQuantity2)}]

    * eval if (!sku_data[2].coupons) sku_data[2].coupons = {"couponCode": couponCode4, "quantity" : couponQuantity3}
    * set sku_data[2].coupons = [{"couponCode": #(couponCode4), "quantity" : #(couponQuantity3)}, {"couponCode": #(couponCode5), "quantity" : #(couponQuantity3)}, {"couponCode": #(couponCode6), "quantity" : #(couponQuantity3)}]

    * def body =
    """
      {
      "masId": "#(masid)",
      "billAmount": #(apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption__0029"].billAmount),
      "transactionId": "#(transaction_id)",
      "couponCodes":[#(couponCode1), #(couponCode2), #(couponCode3), #(couponCode4), #(couponCode5), #(couponCode6),#(couponCode_bill_voucher)],
      "skuData": #(sku_data)
      }
    """
    Given path '/coupons/v1/coupons/merchant/fc/checkout'
    And request body
    When method post
    Then status 200
    * match each response.data[*].discountType == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029"].discountType
    # validation of discount for SKUs + vouchers .
    * assert response.discountAmount.toFixed(2) == (apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029"].discountAmount + discount_bill_voucher).toFixed(2)
    * assert response.newBillAmount.toFixed(2) == (apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029"].newBillAmount - discount_bill_voucher).toFixed(2)

  Scenario: B2B_PERCENT_DISCOUNT deliver mark redeem flow __0029.2
    * header x-client-type = "hybris"
    * def body  =
    """
    {
      "couponCodes":[#(couponCode1), #(couponCode2), #(couponCode3), #(couponCode4), #(couponCode5), #(couponCode6),#(couponCode_bill_voucher)],
      "coupons" : [{
                      "couponCode": #(couponCode1),
                      "quantity" : #(couponQuantity1)
                  },
                  {
                      "couponCode": #(couponCode2),
                      "quantity" : #(couponQuantity1)
                  },
                  {
                      "couponCode": #(couponCode3),
                      "quantity" : #(couponQuantity2)
                  },
                  {
                      "couponCode": #(couponCode4),
                      "quantity" : #(couponQuantity3)
                  },
                  {
                      "couponCode": #(couponCode5),
                      "quantity" : #(couponQuantity3)
                  },
                  {
                      "couponCode": #(couponCode6),
                      "quantity" : #(couponQuantity3)
                  }],
      "masId": "#(masid)",
     }
    """
    Given path '/coupons/v1/coupons/merchant/fc/delivered'
    And request body
    When method post
    Then status 200

    * def update_DELIVERED_TS = db.updateRow("UPDATE FC_MERCHANT_COUPONS SET DELIVERED_TS = CURRENT_TIMESTAMP - 20 WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode3+ "\',\'" +couponCode4+ "\',\'" +couponCode5+ "\',\'" +couponCode6+ "\')")
    * def update_voucher_DELIVERED_TS = db.updateRow("UPDATE VOUCHER_REDEMPTION SET DELIVERED_TS = CURRENT_TIMESTAMP - 20 WHERE REDEEM_CODE IN (\'" +couponCode_bill_voucher+ "\')")

    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode3+ "\',\'" +couponCode4+ "\',\'" +couponCode5+ "\',\'" +couponCode6+ "\',\'" +couponCode_bill_voucher+ "\')")
    * def schema = schemaAndValidation["delivered_FC_merchant_coupon"]
    * match each coupon_code_status == schema
    * print coupon_code_status

  Scenario: B2B_PERCENT_DISCOUNT mark redeem flow __0029.2
    * def body  =
    """
    {

    }
    """
    Given path '/coupons/v1/coupons/merchant/fc/mark-redeemed'
    And request body
    When method post
    Then status 200

    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode3+ "\',\'" +couponCode4+ "\',\'" +couponCode5+ "\',\'" +couponCode6+ "\',\'" +couponCode_bill_voucher+ "\')")
    * print coupon_code_status
    * def schema = schemaAndValidation["redeemed_FC_merchant_coupon"]
    * match each coupon_code_status == schema

  Scenario: Switching off the features __0029.2.
    * def call_configuration_table = callonce read('support.feature@switch_off_features')
    * def call_configuration_table_b2b = callonce read('support.feature@switch_off_features_b2b')