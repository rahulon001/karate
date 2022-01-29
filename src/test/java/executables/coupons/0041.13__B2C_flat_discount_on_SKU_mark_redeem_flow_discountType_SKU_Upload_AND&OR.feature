Feature: B2C flat discount on SKU return flow discount type__0041.1

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * header Content-Type = 'application/json'
    * header x-client-type = "mpos"
    * def apiComponents = envConfig
    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])
    * def helperMethods = Java.type('executables.utils.HelperMethods')
    * def sku_data1 = apiComponents["B2C_flat_discount_on_SKU_discountType_responseData__0041.12"].skuData1
    * json result = callonce read("B2C_B2B_CouponCodeGeneration.feature@B2C_flat_discount_SKU_Upload"){requestHeader: #(headerJson) , skuData: #(sku_data1)}
    * match result.response["skuCoupons"] == []
    * def sku_data2 = apiComponents["B2C_flat_discount_on_SKU_discountType_responseData__0041.12"].skuData2
    * json result = callonce read("B2C_B2B_CouponCodeGeneration.feature@B2C_flat_discount_SKU_Upload"){requestHeader: #(headerJson) , skuData: #(sku_data2)}
    * match result.response["skuCoupons"] == []
    * def sku_data3 = apiComponents["B2C_flat_discount_on_SKU_discountType_responseData__0041.12"].skuData3
    * json result = callonce read("B2C_B2B_CouponCodeGeneration.feature@B2C_flat_discount_SKU_Upload"){requestHeader: #(headerJson) , skuData: #(sku_data3)}

    * def skuID = get result.response.skuCoupons[*].skuId
    * def skuID_index_1009977755 = skuID.indexOf("1009977755")
    * def skuID_index_1009977757 = skuID.indexOf("1009977757")
    * def skuID_index_1009977758 = skuID.indexOf("1009977758")

    * def couponCode1 = result.response["skuCoupons"][skuID_index_1009977755]["coupons"][0]["couponCode"]
    * def couponId1 = result.response["skuCoupons"][skuID_index_1009977755]["coupons"][0]["couponId"]
    * def couponCode2 = result.response["skuCoupons"][skuID_index_1009977757]["coupons"][0]["couponCode"]
    * def couponId2 = result.response["skuCoupons"][skuID_index_1009977757]["coupons"][0]["couponId"]
    * def couponCode3 = result.response["skuCoupons"][skuID_index_1009977758]["coupons"][0]["couponCode"]
    * def couponId3 = result.response["skuCoupons"][skuID_index_1009977758]["coupons"][0]["couponId"]

    * match couponCode1 == couponCode2
    * match couponCode2 == couponCode3
    * match couponCode3 == couponCode1

    * def discount1 = result.response["skuCoupons"][skuID_index_1009977755]["coupons"][0]["discount"]
    * def discount1 = result.response["skuCoupons"][skuID_index_1009977757]["coupons"][0]["discount"]
    * def discount1 = result.response["skuCoupons"][skuID_index_1009977758]["coupons"][0]["discount"]

    * def skuId1 = result.response["skuCoupons"][skuID_index_1009977755]["skuId"]
    * def skuId1 = result.response["skuCoupons"][skuID_index_1009977757]["skuId"]
    * def skuId1 = result.response["skuCoupons"][skuID_index_1009977758]["skuId"]

    * def quantity1 = result.response["skuCoupons"][skuID_index_1009977755]["quantity"]
    * def quantity1 = result.response["skuCoupons"][skuID_index_1009977757]["quantity"]
    * def quantity1 = result.response["skuCoupons"][skuID_index_1009977758]["quantity"]

    * def price1 = result.response["skuCoupons"][skuID_index_1009977755]["price"]
    * def price1 = result.response["skuCoupons"][skuID_index_1009977757]["price"]
    * def price1 = result.response["skuCoupons"][skuID_index_1009977758]["price"]

    * def appliedQuantity1 = result.response["skuCoupons"][0]["coupons"][0]["appliedQuantity"]

    *  def transactionID =
    """
    function(){ return java.lang.System.currentTimeMillis() }
    """
    * def transaction_id = callonce transactionID
    * def masid = apiComponents['CMS_masid']


  Scenario: merchant verify b2c flat discount on SKU __0041.1.
    * def body =
    """
      {
        "masId": "#(masid)",
        "storeId": "#(masid)",
        "transactionId": "#(transaction_id)",
        "tId": "xyzklj199",
        "billAmount": #(apiComponents["B2C_flat_discount_on_SKU_discountType__0041.12"].billAmount),
        "couponCodes": "#(couponCode1)",
        "skuData": #(apiComponents["B2C_flat_discount_on_SKU_discountType__0041.12"].skuData)
      }
    """
    Given path '/coupons/v1/coupons/merchant-verify'
    And request body
    When method post
    Then status 200
    * match response.data[0].discountType == apiComponents["B2C_flat_discount_on_SKU_discountType_responseData__0041.12"].discountType1
    * match response.data[0].discount == apiComponents["B2C_flat_discount_on_SKU_discountType_responseData__0041.12"].discount1
    * match response.discountedItems[0].skuId == apiComponents["B2C_flat_discount_on_SKU_discountType_responseData__0041.12"].discountedItems_skuId1
    * match response.discountedItems[1].skuId == apiComponents["B2C_flat_discount_on_SKU_discountType_responseData__0041.12"].discountedItems_skuId2
    * match response.discountedItems[2].skuId == apiComponents["B2C_flat_discount_on_SKU_discountType_responseData__0041.12"].discountedItems_skuId3
    * match response.newBillAmount == apiComponents["B2C_flat_discount_on_SKU_discountType_responseData__0041.12"].newBillAmount
    * def coupon_code_status = db.readRows("SELECT STATUS, BATCH_ID, ACCEPT_TS, DELIVERED_TS , RETURN_UPTO FROM CLOSED_LOOP_REDEMPTION WHERE COUPON_CODE =\'"+couponCode1+"\'")
    * match coupon_code_status == []

  Scenario: merchant checkout b2c flat discount on SKU __0041.12.1.
    * def body =
    """
      {
        "masId": "#(masid)",
        "storeId": "#(masid)",
        "transactionId": "#(transaction_id)",
        "tId": "xyzklj199",
        "billAmount": #(apiComponents["B2C_flat_discount_on_SKU_discountType__0041.12"].billAmount),
        "couponCodes": "#(couponCode1)",
        "skuData": #(apiComponents["B2C_flat_discount_on_SKU_discountType__0041.12"].skuData)
      }
    """
    Given path '/coupons/v1/coupons/merchant/checkout'
    And request body
    When method post
    Then status 200
    * match response.data[0].discountType == apiComponents["B2C_flat_discount_on_SKU_discountType_responseData__0041.12"].discountType1
    * match response.data[0].discount == apiComponents["B2C_flat_discount_on_SKU_discountType_responseData__0041.12"].discount1
    * match response.discountedItems[0].skuId == apiComponents["B2C_flat_discount_on_SKU_discountType_responseData__0041.12"].discountedItems_skuId1
    * match response.discountedItems[1].skuId == apiComponents["B2C_flat_discount_on_SKU_discountType_responseData__0041.12"].discountedItems_skuId2
    * match response.discountedItems[2].skuId == apiComponents["B2C_flat_discount_on_SKU_discountType_responseData__0041.12"].discountedItems_skuId3
    * match response.newBillAmount == apiComponents["B2C_flat_discount_on_SKU_discountType_responseData__0041.12"].newBillAmount

    * def coupon_code_status = db.readRows("SELECT STATUS, BATCH_ID, ACCEPT_TS, DELIVERED_TS , RETURN_UPTO FROM CLOSED_LOOP_REDEMPTION WHERE COUPON_CODE =\'"+couponCode1+"\'")
    * def schema =
    """
      {
        "STATUS": "processing",
        "BATCH_ID": null,
        "ACCEPT_TS": null,
        "DELIVERED_TS": null,
        "RETURN_UPTO": null
      }
    """

    And match each coupon_code_status == schema

  Scenario: merchant accept-order b2c flat discount on SKU __0041.12.
         #Redeem count before accept
    * def redeem_count = db.readRows("SELECT REDEEM_COUNT FROM coupon where ID IN (\'" +couponId1+ "\')")
    * def count = db.readRows("SELECT COUNT FROM merchant_redemption_count where coupon IN (\'" +couponId1+ "\') and merchant=\'" +masid+ "\'")


    * def body  =
    """
    {
      "couponCodes":[#(couponCode1)],
      "masId": "#(masid)",
      "storeId": "#(masid)",
      "transactionId": "#(transaction_id)",
      "tId": "xyzklj199"
    }
    """
    Given path '/coupons/v1/coupons/merchant/accept-order'
    And request body
    When method post
    Then status 200
    * def coupon_code_status = db.readRows("SELECT STATUS, BATCH_ID, ACCEPT_TS, DELIVERED_TS , RETURN_UPTO FROM CLOSED_LOOP_REDEMPTION WHERE COUPON_CODE IN (\'" +couponCode1+ "\')")
    * def schema =
    """
      {
        "STATUS": "accepted",
        "BATCH_ID": null,
        "ACCEPT_TS": '#? isValidDate(_)',
        "DELIVERED_TS": null,
        "RETURN_UPTO": null
      }
    """

    And match each coupon_code_status == schema
#Redeem count After checkout & accept
    * def redeem_count_a = db.readRows("SELECT REDEEM_COUNT FROM coupon where ID IN (\'" +couponId1+ "\')")
    * def count_a = db.readRows("SELECT COUNT FROM merchant_redemption_count where coupon IN (\'" +couponId1+ "\') and merchant=\'" +masid+ "\'")


    #Validate redemption count
    * match parseInt(redeem_count_a[0].REDEEM_COUNT) == parseInt(redeem_count[0].REDEEM_COUNT + appliedQuantity1)
    * match parseInt(count_a[0].COUNT) == parseInt(count[0].COUNT + appliedQuantity1)


  Scenario: merchant delivered-order b2c flat discount on SKU __0041.12.1.
    * def body =
    """
    {
      "couponCodes":[#(couponCode1)],
      "masId": "#(masid)",
      "storeId": "#(masid)",
      "transactionId": "#(transaction_id)",
      "tId": "xyzklj199"
    }
    """
    Given path '/coupons/v1/coupons/merchant/delivered'
    And request body
    When method post
    Then status 200
    * def coupon_code_status = db.readRows("SELECT STATUS, BATCH_ID, ACCEPT_TS, DELIVERED_TS , RETURN_UPTO FROM CLOSED_LOOP_REDEMPTION WHERE COUPON_CODE IN (\'" +couponCode1+ "\')")
    * def schema =
    """
      {
        "STATUS": "delivered",
        "BATCH_ID": null,
        "ACCEPT_TS": '#? isValidDate(_)',
        "DELIVERED_TS": '#? isValidDate(_)',
        "RETURN_UPTO": '#? isValidDate(_)'
      }
    """
    And match each coupon_code_status == schema

    * def update_return_upto = db.updateRow("UPDATE CLOSED_LOOP_REDEMPTION SET RETURN_UPTO = CURRENT_TIMESTAMP - 20 WHERE COUPON_CODE IN (\'" +couponCode1+ "\')")


  Scenario: merchant mark redeem b2c B2C flat discount on SKU_0041
    * def body  =
    """
    {

    }
    """
    Given path '/coupons/v1/coupons/merchant/mark-redeemed'
    And request body
    When method post
    Then status 200
    And assert response.result.merchants[0].couponCodes != []
