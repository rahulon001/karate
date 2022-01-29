Feature: b2c percentage discount on sku discount type return flow multi redeem __0002.4

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * header Content-Type = 'application/json'
    * def apiComponents = envConfig
    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])
    * def helperMethods = Java.type('executables.utils.HelperMethods')
    * def sku_price = apiComponents["B2C_percentage_discount_on_SKU_discountType_mrpc_responseData__0042.4"].maxPrice
    * def body = apiComponents["B2C_percentage_discount_on_SKU_discountType_mrpc__0042.4"]
    * def bill_amount = apiComponents["B2C_percentage_discount_on_SKU_discountType_mrpc__0042.4"].billAmount
    * json result = callonce read("B2C_B2B_CouponCodeGeneration.feature@B2C_percentage_discount_on_SKU_mrpc") {skuPrice: #(sku_price), billAmount: #(bill_amount), body: #(body)}
    * def couponCode1 = result.response["skuCoupons"][0]["coupons"][0]["couponCode"]
    * def couponId1 = result.response["skuCoupons"][0]["coupons"][0]["couponId"]
    * def discount1 = result.response["skuCoupons"][0]["coupons"][0]["discount"]
    * def skuId1 = result.response["skuCoupons"][0]["skuId"]
    * def quantity1 = result.response["skuCoupons"][0]["quantity"]
    * def price1 = result.response["skuCoupons"][0]["price"]
    * def discountType = result.response["skuCoupons"][0]["coupons"][0]["discountType"]
    * def appliedQuantity1 = result.response["skuCoupons"][0]["coupons"][0]["appliedQuantity"]

     #get the coupon details  from DB and validate
    * def coupon_discount = db.readRows("SELECT DISCOUNT_PERCENTAGE_VALUE FROM coupon where ID IN (\'" +couponId1+ "\')")
    * def coupon_discount_max = db.readRows("SELECT DISCOUNT_MAX FROM coupon where ID IN (\'" +couponId1+ "\')")
    * def sku_qty = db.readRows("SELECT QUANTITY FROM SKU_CONDITION_DATA scd WHERE COUPON_CONDITION  IN (SELECT ID FROM COUPON_CONDITION WHERE COUPON in (\'" +couponId1+ "\'))")
    * def sku_id = db.readRows("SELECT SKU FROM SKU_CONDITION_DATA scd WHERE COUPON_CONDITION  IN (SELECT ID FROM COUPON_CONDITION WHERE COUPON in (\'" +couponId1+ "\'))")
    * def coupon_discount_type = db.readRows("SELECT DISCOUNT_TYPE FROM coupon where ID IN (\'" +couponId1+ "\')")

    * def coupon_discount_customer = coupon_discount_max[0].DISCOUNT_MAX * appliedQuantity1
    * print "************DSC***********", discount1.toFixed(2), (coupon_discount_customer * appliedQuantity1).toFixed(2)
    * assert discount1.toFixed(2) == coupon_discount_customer.toFixed(2)
    * assert skuId1 == sku_id[0].SKU
    * assert quantity1 == sku_qty[0].QUANTITY * appliedQuantity1
    * assert discountType == coupon_discount_type[0].DISCOUNT_TYPE
    * assert appliedQuantity1 == quantity1/sku_qty[0].QUANTITY

    #vendor funding details

    * def merchant_contribution = db.readRows("SELECT MERCHANT_CONTRIBUTION FROM vendor_funding_detail where COUPONID IN (\'" +couponId1+ "\')")
    * def brand_contribution = db.readRows("SELECT BRAND_CONTRIBUTION FROM vendor_funding_detail where COUPONID IN (\'" +couponId1+ "\')")
    * def reliance_contribution = db.readRows("SELECT RELIANCE_CONTRIBUTION FROM vendor_funding_detail where COUPONID IN (\'" +couponId1+ "\')")
    * def coupon_discount_merchant = (coupon_discount_customer/appliedQuantity1) * (brand_contribution[0].BRAND_CONTRIBUTION + reliance_contribution[0].RELIANCE_CONTRIBUTION)/100

    #Coupon qty used to check redeem count
    * def coupon_redeem = appliedQuantity1
    * print "**************REDEEMCOUNT***********",coupon_redeem

    *  def transactionID =
    """
    function(){ return java.lang.System.currentTimeMillis() }
    """
    * def transaction_id = callonce transactionID
    * def masid = apiComponents["CMS_masid"]


  Scenario: merchant verify b2c percentage discount on sku discount type __0002.4
    * header x-client-type = "mpos"
    * def body =
    """
    {
      "masId": "#(masid)",
      "storeId": "#(masid)",
      "transactionId": "#(transaction_id)",
      "tId": "xyzklj199",
      "billAmount": #(apiComponents["B2C_percentage_discount_on_SKU_discountType_mrpc__0042.4"].billAmount),
      "couponCodes": "#(couponCode1)",
      "couponsApplied": [
        {
            "code": "#(couponCode1)",
            "quantity": "#(appliedQuantity1)"
        }],
        "skuData": #(apiComponents["B2C_percentage_discount_on_SKU_discountType_mrpc__0042.4"].skuData)
    }
    """
    Given path '/coupons/v1/coupons/merchant-verify'
    And request body
    When method post
    Then status 200
    * match response.data[0].couponId == couponId1
    * match response.data[0].discountType == coupon_discount_type[0].DISCOUNT_TYPE
    * match response.data[0].discount == coupon_discount_customer
    * match response.discountedItems[0].skuId == sku_id[0].SKU
    * match response.discountedItems[0].skuPrice.toFixed(2) == ((price1 - coupon_discount_customer)/quantity1).toFixed(2)
    * match response.newBillAmount.toFixed(2) == (apiComponents["B2C_percentage_discount_on_SKU_discountType_mrpc__0042.4"].billAmount - coupon_discount_customer).toFixed(2)

    * def coupon_code_status = db.readRows("SELECT STATUS, BATCH_ID, ACCEPT_TS, DELIVERED_TS , RETURN_UPTO FROM CLOSED_LOOP_REDEMPTION WHERE COUPON_CODE =\'"+couponCode1+"\'")
    * match coupon_code_status == []

  Scenario: merchant checkout b2c b2c percentage discount on sku discount type __0002.4
    * header x-client-type = "mpos"
    * def body =
    """
    {
      "masId": "#(masid)",
      "storeId": "#(masid)",
      "transactionId": "#(transaction_id)",
      "tId": "xyzklj199",
      "billAmount": #(apiComponents["B2C_percentage_discount_on_SKU_discountType_mrpc__0042.4"].billAmount),
      "couponCodes": "#(couponCode1)",
      "couponsApplied": [
        {
            "code": "#(couponCode1)",
            "quantity": "#(appliedQuantity1)"
        }],
        "skuData": #(apiComponents["B2C_percentage_discount_on_SKU_discountType_mrpc__0042.4"].skuData)
    }
    """
    * set body.skuData[*].skuPrice = sku_price
    Given path '/coupons/v1/coupons/merchant/checkout'
    And request body
    When method post
    Then status 200
    * print response
    * match response.data[0].couponId == couponId1
    * match response.data[0].discountType == coupon_discount_type[0].DISCOUNT_TYPE
    * match response.data[0].discount == coupon_discount_customer
    * match response.discountedItems[0].skuId == sku_id[0].SKU
    * match response.discountedItems[0].skuPrice.toFixed(2) == ((price1 - coupon_discount_customer)/quantity1).toFixed(2)
    * match response.newBillAmount.toFixed(2) == (apiComponents["B2C_percentage_discount_on_SKU_discountType_mrpc__0042.4"].billAmount - coupon_discount_customer).toFixed(2)

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

    #Verify if corresponding B2B coupon created in fc_merchant_coupon_table and status is inactive
    * def masid_merchant = db.readRows("SELECT MASID FROM FC_MERCHANT_COUPONS where CUSTOMER_COUPON_CODE IN (\'" +couponCode1+ "\')")
    * def couponid_merchant = db.readRows("SELECT COUPON FROM FC_MERCHANT_COUPONS where CUSTOMER_COUPON_CODE IN (\'" +couponCode1+ "\')")
    * def discount_amount_merchant = db.readRows("SELECT DISCOUNT_AMOUNT FROM FC_MERCHANT_COUPONS where CUSTOMER_COUPON_CODE IN (\'" +couponCode1+ "\')")
    * def couponstatus_merchant = db.readRows("SELECT STATUS FROM FC_MERCHANT_COUPONS where CUSTOMER_COUPON_CODE IN (\'" +couponCode1+ "\')")

    * assert masid_merchant[0].MASID == masid
   #* assert couponid_merchant[0].COUPON == couponId1
    * assert couponstatus_merchant[0].STATUS == 'inactive'

    * assert masid_merchant[1].MASID == masid
    #* assert couponid_merchant[1].COUPON == couponId1
    * assert couponstatus_merchant[1].STATUS == 'inactive'



  Scenario: merchant accept-order b2c b2c percentage discount on sku discount type __0002.4
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
 #   * assert redeem_count_a[0].REDEEM_COUNT == redeem_count[0].REDEEM_COUNT + coupon_redeem


  Scenario: merchant delivered-order b2c b2c percentage discount on sku discount type __0002.4
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

  Scenario: merchant return-order b2c b2c percentage discount on sku discount type __0002.4
    * def discounted_billAmount = apiComponents["B2C_percentage_discount_on_SKU_discountType_mrpc__0042.4"].billAmount - coupon_discount_customer
    * header x-client-type = "mpos"
    * def body  =
    """
    {
      "masId": "#(masid)",
      "discountedBillAmount": #(discounted_billAmount),
      "couponCodesApplied":[#(couponCode1)],
      "originalCart": #(apiComponents["B2C_percentage_discount_on_SKU_discountType_mrpc__0042.4"].skuData),
      "returnedItems": #(apiComponents["B2C_percentage_discount_on_SKU_discountType_mrpc__0042.4"].skuData)
    }
    """
    * set body.originalCart[*].skuPrice = sku_price
    * set body.returnedItems[*].skuPrice = sku_price
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

  Scenario: merchant order-returned(cancel) b2c b2c percentage discount on sku discount type __0002.4
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
 #   * assert redeem_count_r[0].REDEEM_COUNT == redeem_count[0].REDEEM_COUNT - coupon_redeem


    * def couponstatus_merchant = db.readRows("SELECT STATUS FROM FC_MERCHANT_COUPONS where CUSTOMER_COUPON_CODE IN (\'" +couponCode1+ "\')")
    * match couponstatus_merchant == []
