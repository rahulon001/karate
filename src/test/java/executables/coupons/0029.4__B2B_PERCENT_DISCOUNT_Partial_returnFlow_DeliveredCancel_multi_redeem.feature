Feature: B2B_PERCENT_DISCOUNT partial return flow multi redeem __0029.4

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * def apiComponents = envConfig
    * def schemaAndValidation = envSchema
    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])
    * header Content-Type = 'application/json'
    * header x-client-type = "mpos"
    * def redeem_flags = "true"
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

    * def sku_data = apiComponents.B2B_PERCENT_DISCOUNT_coupon_redemption__0029.skuData

    * def sku_price = apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029"].price
    * def bill_amount = apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption__0029"].billAmount

    * def result = callonce read("B2C_B2B_CouponCodeGeneration.feature@B2B_PERCENT_DISCOUNT_coupon_redemption") {requestHeader: #(headerJson) , skuPrice: #(sku_price), billAmount: #(bill_amount)}

    * def skuID = get result.response.skuCoupons[*].skuId
    * def skuID_index_711143212226 = skuID.indexOf("711143212226")
    * print "skuID_index_711143212226>", skuID_index_711143212226
    * def skuID_index_711143212228 = skuID.indexOf("711143212228")
    * print "skuID_index_711143212228>", skuID_index_711143212228
    * def skuID_index_711143212227 = skuID.indexOf("711143212227")
    * print "skuID_index_711143212227>", skuID_index_711143212227

    * def couponCode1 = result.response["skuCoupons"][skuID_index_711143212226]["coupons"][0]["couponCode"]
    * print "couponCode1>", couponCode1
    * def couponCode2 = result.response["skuCoupons"][skuID_index_711143212228]["coupons"][0]["couponCode"]
    * print "couponCode2>", couponCode2
    * def couponCode3 = result.response["skuCoupons"][skuID_index_711143212227]["coupons"][0]["couponCode"]
    * print "couponCode3>", couponCode3

    * assert result.response["skuCoupons"][skuID_index_711143212226]["coupons"][0]["couponQty"] == apiComponents.B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.couponQty_mr_711143212226
    * assert result.response["skuCoupons"][skuID_index_711143212228]["coupons"][0]["couponQty"] == apiComponents.B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.couponQty_mr_711143212228
    * assert result.response["skuCoupons"][skuID_index_711143212227]["coupons"][0]["couponQty"] == apiComponents.B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.couponQty_mr_711143212227

    * def couponCode1 = result.response["skuCoupons"][skuID_index_711143212226]["coupons"][0]["couponCode"]
    * def couponQuantity1 = result.response["skuCoupons"][skuID_index_711143212226]["coupons"][0]["couponQty"]
    * def couponCode2 = result.response["skuCoupons"][skuID_index_711143212228]["coupons"][0]["couponCode"]
    * def couponQuantity2 = result.response["skuCoupons"][skuID_index_711143212228]["coupons"][0]["couponQty"]
    * def couponCode3 = result.response["skuCoupons"][skuID_index_711143212227]["coupons"][0]["couponCode"]
    * def couponQuantity3 = result.response["skuCoupons"][skuID_index_711143212227]["coupons"][0]["couponQty"]

    * assert result.response["skuCoupons"][skuID_index_711143212226]["coupons"][0]["discountType"] == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029"].discountType
    * assert result.response["skuCoupons"][skuID_index_711143212228]["coupons"][0]["discountType"] == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029"].discountType
    * assert result.response["skuCoupons"][skuID_index_711143212227]["coupons"][0]["discountType"] == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029"].discountType

    * assert result.response["skuCoupons"][skuID_index_711143212226]["quantity"]  == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029"].quantity_711143212226
    * assert result.response["skuCoupons"][skuID_index_711143212228]["quantity"]  == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029"].quantity_711143212228
    * assert result.response["skuCoupons"][skuID_index_711143212227]["quantity"]  == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029"].quantity_711143212227

    * assert result.response["skuCoupons"][skuID_index_711143212226]["coupons"][0].discount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029"].discount_mr_711143212226
    * assert result.response["skuCoupons"][skuID_index_711143212228]["coupons"][0].discount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029"].discount_mr_711143212228
    * assert result.response["skuCoupons"][skuID_index_711143212227]["coupons"][0].discount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029"].discount_mr_711143212227

    * assert result.response["skuCoupons"][skuID_index_711143212226]["coupons"][0].quantity == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029"].sku_quantity_per_unit_mr_711143212226
    * assert result.response["skuCoupons"][skuID_index_711143212228]["coupons"][0].quantity == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029"].sku_quantity_per_unit_mr_711143212228
    * assert result.response["skuCoupons"][skuID_index_711143212227]["coupons"][0].quantity == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029"].sku_quantity_per_unit_mr_711143212227

    * assert result.response["skuCoupons"][skuID_index_711143212226]["price"] == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029"].price

    *  def transactionID =
    """
      function(){ return java.lang.System.currentTimeMillis() }
    """
    * def transaction_id = callonce transactionID


  Scenario: B2B_PERCENT_DISCOUNT checkout partial return flow multi redeem __0029.4
    * def coupon_id_711143212226 = db.readRows("SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212226+ "\')")
    * def coupon_id_711143212228 = db.readRows("SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212228+ "\')")
    * def coupon_id_711143212227 = db.readRows("SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212227+ "\')")

    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE B2B_COUPON_ID IN (\'" +coupon_id_711143212226[0].ID+ "\',\'" +coupon_id_711143212228[0].ID+ "\',\'" +coupon_id_711143212227[0].ID+ "\') and status='hold'")
    * print coupon_code_status
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

  Scenario: B2B_PERCENT_DISCOUNT checkout partial return flow multi redeem __0029.4.
    * header override_flag = redeem_flags

    # recreation of skuData of the request body
    * eval if (!sku_data[0].coupons) sku_data[0].coupons = {"couponCode": couponCode1,"quantity" : couponQuantity1}
    * set sku_data[0].coupons = [{"couponCode": #(couponCode1), "quantity" : #(couponQuantity1)}]

    * eval if (!sku_data[1].coupons) sku_data[1].coupons = {"couponCode": couponCode3,"quantity" : couponQuantity3}
    * set sku_data[1].coupons = [{"couponCode": #(couponCode3), "quantity" : #(couponQuantity3)}]

    * eval if (!sku_data[2].coupons) sku_data[2].coupons = {"couponCode": couponCode2,"quantity" : couponQuantity2}
    * set sku_data[2].coupons = [{"couponCode": #(couponCode2), "quantity" : #(couponQuantity2)}]

    * def body =
    """
      {
      "masId": "#(masid)",
      "billAmount": #(apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption__0029"].billAmount),
      "transactionId": "#(transaction_id)",
      "couponCodes":[#(couponCode1), #(couponCode2), #(couponCode3)],
      "skuData": #(sku_data)
      }
    """

    Given path '/coupons/v1/coupons/merchant/fc/checkout'
    And request body
    When method post
    Then status 200

    * def COUPONCODE_status = db.readRows("SELECT * FROM B2BCOUPONMAPPING WHERE COUPONCODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode3+ "\')")
    * print COUPONCODE_status

    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (SELECT CONSTITUENTCOUPONCODE FROM B2BCOUPONMAPPING WHERE COUPONCODE in (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode3+ "\'))")
    * print coupon_code_status

    * def b2b_coupons = db.readRows("SELECT * FROM B2B_COUPON WHERE ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[2]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupons

    * def b2b_coupon_redemption = db.readRows("SELECT * FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[3]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupon_redemption

    * def schema = schemaAndValidation["checkout_FC_merchant_coupon"]
    * match each coupon_code_status == schema

    * def coupon_code = get response.data[*].coupon
    * assert response.discountAmount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029"].discountAmount
    * assert response.newBillAmount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029"].newBillAmount
    * match each response.data[*].discountType == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029"].discountType

    * assert response.data[coupon_code.indexOf(couponCode1)].discount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029"].discount_mr_711143212226
    * assert response.data[coupon_code.indexOf(couponCode2)].discount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029"].discount_mr_711143212228
    * assert response.data[coupon_code.indexOf(couponCode3)].discount == apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029"].discount_mr_711143212227

    * assert response.data[coupon_code.indexOf(couponCode1)].discountCoupon.toString == apiComponents.B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.couponQty_mr_711143212226.toString
    * assert response.data[coupon_code.indexOf(couponCode2)].discountCoupon.toString == apiComponents.B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.couponQty_mr_711143212228.toString
    * assert response.data[coupon_code.indexOf(couponCode3)].discountCoupon.toString == apiComponents.B2B_PERCENT_DISCOUNT_coupon_redemption_responseData__0029.couponQty_mr_711143212227.toString

  Scenario: B2B_PERCENT_DISCOUNT delivered partial return flow multi redeem __0029.4
    * header x-client-type = "hybris"
    * def body  =
    """
    {
      "couponCodes":[#(couponCode1), #(couponCode2), #(couponCode3)],
       "coupons" : [{
                      "couponCode": #(couponCode1),
                      "quantity" : #(couponQuantity1)
                  },
                  {
                      "couponCode": #(couponCode2),
                      "quantity" : #(couponQuantity2)
                  },
                  {
                      "couponCode": #(couponCode3),
                      "quantity" : #(couponQuantity3)
                  }],
      "masId": "#(masid)",
     }
    """
    Given path '/coupons/v1/coupons/merchant/fc/delivered'
    And request body
    When method post
    Then status 200

    * def COUPONCODE_status = db.readRows("SELECT * FROM B2BCOUPONMAPPING WHERE COUPONCODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode3+ "\')")
    * print COUPONCODE_status

    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (SELECT CONSTITUENTCOUPONCODE FROM B2BCOUPONMAPPING WHERE COUPONCODE in (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode3+ "\'))")
    * print coupon_code_status

    * def b2b_coupons = db.readRows("SELECT * FROM B2B_COUPON WHERE ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[3]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupons

    * def b2b_coupon_redemption = db.readRows("SELECT * FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (\'" +coupon_code_status[0]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[1]["B2B_COUPON_ID"]+ "\',\'" +coupon_code_status[3]["B2B_COUPON_ID"]+ "\')")
    * print b2b_coupon_redemption

    * def schema = schemaAndValidation["delivered_FC_merchant_coupon"]
    * match each coupon_code_status == schema

  Scenario: B2B_PERCENT_DISCOUNT delayed cancel partial return flow multi redeem __0029.4
     # redemption count
    * def redeem_quantity_711143212226 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212226+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_711143212227 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212227+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_711143212228 = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212228+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_count_711143212226 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212226+ "\'))")
    * def redeem_count_711143212228 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212228+ "\'))")
    * def redeem_count_711143212227 = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212227+ "\'))")

    * def body  =
    """
    {
      "couponCodes":[#(couponCode1), #(couponCode2)],
      "coupons" : [{
                      "couponCode": #(couponCode1),
                      "quantity" : #(couponQuantity1)
                  },
                  {
                      "couponCode": #(couponCode2),
                      "quantity" : #(couponQuantity2)
                  }],
      "masId": "#(masid)",
     }
    """
    Given path '/coupons/v1/coupons/merchant/fc/delayed-cancel'
    And request body
    When method post
    Then status 200

    * def COUPONCODE_status = db.readRows("SELECT * FROM B2BCOUPONMAPPING WHERE COUPONCODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\')")
    * print COUPONCODE_status

    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (SELECT CONSTITUENTCOUPONCODE FROM B2BCOUPONMAPPING WHERE COUPONCODE in (\'" +couponCode1+ "\',\'" +couponCode2+ "\'))")
    * print coupon_code_status

    * def update_delivered_TS = db.updateRow("UPDATE FC_MERCHANT_COUPONS SET DELIVERED_TS = CURRENT_TIMESTAMP - 20 WHERE MERCHANT_COUPON_CODE IN (SELECT CONSTITUENTCOUPONCODE FROM B2BCOUPONMAPPING WHERE COUPONCODE in (\'" +couponCode3+ "\'))")

    * def schema = schemaAndValidation["cancelled_FC_merchant_coupon"]
    * match each coupon_code_status == schema

    #  redemption count after return in  B2B_COUPON_REDEMPTION & B2B_COUPON
    * def redeem_quantity_711143212226_r = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212226+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_711143212227_r = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212227+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_quantity_711143212228_r = db.readRows("SELECT QUANTITY FROM B2B_COUPON_REDEMPTION WHERE B2B_COUPON_ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212228+ "\')) and masid=\'" +masid+ "\'")
    * def redeem_count_711143212226_r = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212226+ "\'))")
    * def redeem_count_711143212227_r = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212227+ "\'))")
    * def redeem_count_711143212228_r = db.readRows("SELECT REDEEM_COUNT FROM B2B_COUPON WHERE ID IN (SELECT ID FROM B2B_COUPON bbc WHERE SKU_ID IN (\'" +711143212228+ "\'))")

      # redemption count
    * match parseInt(redeem_quantity_711143212226_r[0].QUANTITY) == parseInt(redeem_quantity_711143212226[0].QUANTITY - 2)
    * match parseInt(redeem_quantity_711143212227_r[0].QUANTITY) == parseInt(redeem_quantity_711143212227[0].QUANTITY)
    * match parseInt(redeem_quantity_711143212228_r[0].QUANTITY) == parseInt(redeem_quantity_711143212228[0].QUANTITY - 1)

    * match parseInt(redeem_count_711143212226_r[0].REDEEM_COUNT) == parseInt(redeem_count_711143212226[0].REDEEM_COUNT - 2)
    * match parseInt(redeem_count_711143212227_r[0].REDEEM_COUNT) == parseInt(redeem_count_711143212227[0].REDEEM_COUNT)
    * match parseInt(redeem_count_711143212228_r[0].REDEEM_COUNT) == parseInt(redeem_count_711143212228[0].REDEEM_COUNT - 1)

  Scenario: B2B_PERCENT_DISCOUNT redeem partial return flow multi redeem __0029.4
    * def body  =
    """
    {
    }
    """
    Given path '/coupons/v1/coupons/merchant/fc/mark-redeemed'
    And request body
    When method post
    Then status 200

    * def COUPONCODE_status = db.readRows("SELECT * FROM B2BCOUPONMAPPING WHERE COUPONCODE IN (\'" +couponCode3+ "\')")
    * print COUPONCODE_status

    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (SELECT CONSTITUENTCOUPONCODE FROM B2BCOUPONMAPPING WHERE COUPONCODE in (\'" +couponCode3+ "\'))")
    * print coupon_code_status

    * match each coupon_code_status == schemaAndValidation["redeemed_FC_merchant_coupon"]

  Scenario: B2B_PERCENT_DISCOUNT checkout of cancelled coupons in partial return flow multi redeem __0029.4
    * def body =
    """
      {
      "masId": "#(masid)",
      "billAmount": #(apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption__0029"].billAmount),
      "transactionId": "#(transaction_id)",
      "couponCodes":[#(couponCode1), #(couponCode2)],
      "skuData": [
          {
            "skuId": "#(sku_data[0].skuId)",
            "skuQty": #(sku_data[0].skuQty),
            "skuPrice": #(sku_data[0].skuPrice),
            "articleId" : "lol",
            "coupons" : [{
                "couponCode": #(couponCode1),
                "quantity" : #(couponQuantity1)
            }],
          },
          {
            "skuId": "#(sku_data[3].skuId)",
            "skuQty":  #(sku_data[3].skuQty),
            "skuPrice": #(sku_data[3].skuPrice),
            "articleId" : "lol",
            "coupons" : [{
                "couponCode": #(couponCode2),
                "quantity" : #(couponQuantity2)
            }],
          }
        ]
      }
    """
    Given path '/coupons/v1/coupons/merchant/fc/checkout'
    And request body
    When method post
    Then status 400

    * def COUPONCODE_status = db.readRows("SELECT * FROM B2BCOUPONMAPPING WHERE COUPONCODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\')")
    * print COUPONCODE_status

    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (SELECT CONSTITUENTCOUPONCODE FROM B2BCOUPONMAPPING WHERE COUPONCODE in (\'" +couponCode1+ "\',\'" +couponCode2+ "\'))")
    * print coupon_code_status

    * match each coupon_code_status == schemaAndValidation["cancelled_FC_merchant_coupon"]

  Scenario: Switching off the features __0029.4.
    * def call_configuration_table = callonce read('support.feature@switch_off_features')
    * def call_configuration_table_b2b = callonce read('support.feature@switch_off_features_b2b')