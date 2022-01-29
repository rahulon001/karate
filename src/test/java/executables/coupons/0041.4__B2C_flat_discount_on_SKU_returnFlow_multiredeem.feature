Feature: B2C flat discount on SKU return flow multi redeem __0041.4

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * header Content-Type = 'application/json'
    * def apiComponents = envConfig
    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])
    * def helperMethods = Java.type('executables.utils.HelperMethods')
    * def result = callonce read("B2C_B2B_CouponCodeGeneration.feature@B2C_flat_discount_on_SKU_mrpc")
    * def couponCode1 = result.response["skuCoupons"][0]["coupons"][0]["couponCode"]
    * def couponId1 = result.response["skuCoupons"][0]["coupons"][0]["couponId"]
    * def discount1 = result.response["skuCoupons"][0]["coupons"][0]["discount"]
    * def skuId1 = result.response["skuCoupons"][0]["skuId"]
    * def quantity1 = result.response["skuCoupons"][0]["quantity"]
    * def price1 = result.response["skuCoupons"][0]["price"]
    * def appliedQuantity1 = result.response["skuCoupons"][0]["coupons"][0]["appliedQuantity"]
    *  def transactionID =
    """
    function(){ return java.lang.System.currentTimeMillis() }
    """
    * def transaction_id = callonce transactionID
    * def masid = apiComponents['CMS_masid']

  Scenario: merchant verify b2c B2C flat discount on SKU __0041.4
    * header x-client-type = "mpos"
    * def body =
    """
    {
      "masId": "#(masid)",
      "storeId": "#(masid)",
      "transactionId": "#(transaction_id)",
      "tId": "xyzklj199",
      "billAmount": #(apiComponents["B2C_flat_discount_on_SKU_discountType_mrpc__0041.4"].billAmount),
      "couponCodes": "#(couponCode1)",
      "couponsApplied": [
        {
            "code": "#(couponCode1)",
            "quantity": "#(appliedQuantity1)"
        }],
        "skuData": #(apiComponents["B2C_flat_discount_on_SKU_discountType_mrpc__0041.4"].skuData)
    }
    """
    Given path '/coupons/v1/coupons/merchant-verify'
    And request body
    When method post
    Then status 200
    * match response.data[0].discountType == apiComponents["B2C_flat_discount_on_SKU_discountType_mrpc_responseData__0041.4"].discountType1
    * match response.data[0].discount == apiComponents["B2C_flat_discount_on_SKU_discountType_mrpc_responseData__0041.4"].discount1
    * match response.discountedItems[0].skuId == apiComponents["B2C_flat_discount_on_SKU_discountType_mrpc_responseData__0041.4"].skuId1
    * match response.newBillAmount == apiComponents["B2C_flat_discount_on_SKU_discountType_mrpc_responseData__0041.4"].newBillAmount

    * def coupon_code_status = db.readRows("SELECT STATUS, BATCH_ID, ACCEPT_TS, DELIVERED_TS , RETURN_UPTO FROM CLOSED_LOOP_REDEMPTION WHERE COUPON_CODE =\'"+couponCode1+"\'")
    * match coupon_code_status == []

  Scenario: merchant checkout b2c B2C flat discount on SKU __0041.4
    * header x-client-type = "mpos"
    * def body =
    """
    {
      "masId": "#(masid)",
      "storeId": "#(masid)",
      "transactionId": "#(transaction_id)",
      "tId": "xyzklj199",
      "billAmount": #(apiComponents["B2C_flat_discount_on_SKU_discountType_mrpc__0041.4"].billAmount),
      "couponCodes": "#(couponCode1)",
      "couponsApplied": [
        {
            "code": "#(couponCode1)",
            "quantity": "#(appliedQuantity1)"
        }],
        "skuData": #(apiComponents["B2C_flat_discount_on_SKU_discountType_mrpc__0041.4"].skuData)
    }
    """
    Given path '/coupons/v1/coupons/merchant/checkout'
    And request body
    When method post
    Then status 200
    * print response
    * match response.data[0].discountType == apiComponents["B2C_flat_discount_on_SKU_discountType_mrpc_responseData__0041.4"].discountType1
    * match response.data[0].discount == apiComponents["B2C_flat_discount_on_SKU_discountType_mrpc_responseData__0041.4"].discount1
    * match response.discountedItems[0].skuId == apiComponents["B2C_flat_discount_on_SKU_discountType_mrpc_responseData__0041.4"].skuId1
    * match response.newBillAmount == apiComponents["B2C_flat_discount_on_SKU_discountType_mrpc_responseData__0041.4"].newBillAmount

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

  Scenario: merchant accept-order b2c B2C flat discount on SKU __0041.4
  #Redeem count before accept
    * def redeem_count = db.readRows("SELECT REDEEM_COUNT FROM coupon where ID IN (\'" +couponId1+ "\')")

    * header x-client-type = "mpos"
    * def body  =
    """
    {
      "couponCodes":[#(couponCode1)],
      "couponsApplied": [
        {
            "code": "#(couponCode1)",
            "quantity": #(appliedQuantity1)
        }],
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

    #Validate redemption count
    * match parseInt(redeem_count_a[0].REDEEM_COUNT) == parseInt(redeem_count[0].REDEEM_COUNT + appliedQuantity1)


  Scenario: merchant delivered-order b2c B2C flat discount on SKU __0041.4
    * header x-client-type = "mpos"
    * def body  =
    """
    {
      "couponCodes":[#(couponCode1)],
      "couponsApplied": [
        {
            "code": "#(couponCode1)",
            "quantity": #(appliedQuantity1)
        }],
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

  Scenario: merchant return-order b2c B2C flat discount on SKU __0041.4
    * header x-client-type = "mpos"
    * def body  =
    """
    {
      "masId": "#(masid)",
      "discountedBillAmount": #(apiComponents["B2C_flat_discount_on_SKU_discountType_mrpc_responseData__0041.4"].newBillAmount),
      "couponCodesApplied":[#(couponCode1)],
      "originalCart": #(apiComponents["B2C_flat_discount_on_SKU_discountType_mrpc__0041.4"].skuData),
      "returnedItems": #(apiComponents["B2C_flat_discount_on_SKU_discountType_mrpc__0041.4"].skuData)
    }
    """
    Given path '/coupons/v1/coupons/merchant/return-order'
    And request body
    When method post
    Then status 200
    * print response
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

  Scenario: merchant order-returned(cancel) b2c B2C flat discount on SKU __0041.4
       #Redeem count before accept
    * def redeem_count = db.readRows("SELECT REDEEM_COUNT FROM coupon where ID IN (\'" +couponId1+ "\')")

    * header x-client-type = "mpos"
    * def body =
    """
    {
      "couponCodes":[#(couponCode1)],
      "couponsApplied": [
        {
            "code": "#(couponCode1)",
            "quantity": #(appliedQuantity1)
        }],
      "masId": "#(masid)",
    }
    """
    Given path '/coupons/v1/coupons/merchant/cancel'
    And request body
    When method post
    Then status 200
#    * call sleep 30
    * def coupon_code_status = db.readRows("SELECT STATUS, BATCH_ID, ACCEPT_TS, DELIVERED_TS , RETURN_UPTO FROM CLOSED_LOOP_REDEMPTION WHERE COUPON_CODE IN (\'" +couponCode1+ "\')")
    * def schema =
    """
      {
        "STATUS": "cancelled",
        "BATCH_ID": null,
        "ACCEPT_TS": '#? isValidDate(_)',
        "DELIVERED_TS": '#? isValidDate(_)',
        "RETURN_UPTO": '#? isValidDate(_)',
      }
    """
    And match each coupon_code_status == schema

       #Redeem count After checkout & accept
    * def redeem_count_r = db.readRows("SELECT REDEEM_COUNT FROM coupon where ID IN (\'" +couponId1+ "\')")

    #Validate redemption count
    * match parseInt(redeem_count_r[0].REDEEM_COUNT) == parseInt(redeem_count[0].REDEEM_COUNT - appliedQuantity1)
