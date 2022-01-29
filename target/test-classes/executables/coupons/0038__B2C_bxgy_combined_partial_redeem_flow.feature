Feature: BxGy parent mark redeem flow __0038

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * header Content-Type = 'application/json'
    * header x-client-type = "mpos"
    * def apiComponents = envConfig
    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])
    * def helperMethods = Java.type('executables.utils.HelperMethods')
    * json result = callonce read("B2C_B2B_CouponCodeGeneration.feature@B2C_BxGy_combined_cart_verification")

    * def skuID = get result.response.skuCoupons[*].skuId
    * def skuID_index_873873773873 = skuID.indexOf("873873773873")
    * def skuID_index_873873773863 = skuID.indexOf("873873773863")
    * def skuID_index_163873773873 = skuID.indexOf("163873773873")
    * def skuID_index_263873773873 = skuID.indexOf("263873773873")
    * def skuID_index_773873773873 = skuID.indexOf("773873773873")

    * def couponCode1 = result.response["skuCoupons"][skuID_index_873873773873]["coupons"][0]["couponCode"]
    * def couponCode2 = result.response["skuCoupons"][skuID_index_873873773863]["coupons"][0]["couponCode"]
    * def couponCode3 = result.response["skuCoupons"][skuID_index_163873773873]["coupons"][0]["couponCode"]
    * def couponCode4 = result.response["skuCoupons"][skuID_index_263873773873]["coupons"][0]["couponCode"]
    * def couponCode5 = result.response["skuCoupons"][skuID_index_773873773873]["coupons"][0]["couponCode"]

    * def couponId1 = result.response["skuCoupons"][skuID_index_873873773873]["coupons"][0]["couponId"]
    * def couponId2 = result.response["skuCoupons"][skuID_index_873873773863]["coupons"][0]["couponId"]
    * def couponId3 = result.response["skuCoupons"][skuID_index_163873773873]["coupons"][0]["couponId"]
    * def couponId4 = result.response["skuCoupons"][skuID_index_263873773873]["coupons"][0]["couponId"]
    * def couponId5 = result.response["skuCoupons"][skuID_index_773873773873]["coupons"][0]["couponId"]

    * def discount1 = result.response["skuCoupons"][0]["coupons"][0]["discount"]
    * def free_sku1 = result.response["skuCoupons"][0]["coupons"][0]["freeSKU"][0]
    * def skuId1 = result.response["skuCoupons"][0]["skuId"]
    * def quantity1 = result.response["skuCoupons"][0]["quantity"]
    * def price1 = result.response["skuCoupons"][0]["price"]
    *  def transactionID =
    """
    function(){ return java.lang.System.currentTimeMillis() }
    """
    * def transaction_id = callonce transactionID
    * def masid = apiComponents['CMS_masid']

  Scenario Outline: merchant verify b2c BxGy parent __0038.
    * def body =
    """
      {
        "masId": "#(masid)",
        "storeId": "#(masid)",
        "transactionId": "#(transaction_id)",
        "tId": "xyzklj199",
        "billAmount": #(apiComponents["B2C_BxGy_combined_partial_return__0038"].billAmount),
        "couponCodes":  #(result.response["skuCoupons"][<coupon_codes_indexes>]["coupons"][0]["couponCode"]),
        "skuData": #(apiComponents["B2C_BxGy_combined_partial_return__0038"].skuData)
      }
    """
    Given path '/coupons/v1/coupons/merchant-verify'
    And request body
    When method post
    Then status 200

  Examples:
    |coupon_codes_indexes|
    |skuID.indexOf("873873773873")|
    |skuID.indexOf("873873773863")|
    |skuID.indexOf("163873773873")|
    |skuID.indexOf("263873773873")|
    |skuID.indexOf("773873773873")|

  Scenario Outline: merchant checkout b2c BxGy parent __0038.
    * def body =
    """
      {
        "masId": "#(masid)",
        "storeId": "#(masid)",
        "transactionId": "#(transaction_id)",
        "tId": "xyzklj199",
        "billAmount": #(apiComponents["B2C_BxGy_combined_partial_return__0038"].billAmount),
        "couponCodes":  #(result.response["skuCoupons"][<coupon_codes_indexes>]["coupons"][0]["couponCode"]),
        "skuData": #(apiComponents["B2C_BxGy_combined_partial_return__0038"].skuData)
      }
    """
    Given path '/coupons/v1/coupons/merchant/checkout'
    And request body
    When method post
    Then status 200

    Examples:
      |coupon_codes_indexes|
      |skuID.indexOf("873873773873")|
      |skuID.indexOf("873873773863")|
      |skuID.indexOf("163873773873")|
      |skuID.indexOf("263873773873")|
      |skuID.indexOf("773873773873")|

  Scenario: merchant accept-order b2c BxGy parent __0038.
    * def body  =
    """
    {
      "couponCodes":[#(couponCode1),#(couponCode2),#(couponCode3),#(couponCode4),#(couponCode5)],
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

  Scenario: merchant delivered-order b2c BxGy parent __0038.
    * def body =
    """
    {
      "couponCodes":[#(couponCode1),#(couponCode2),#(couponCode3),#(couponCode4),#(couponCode5)],
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
    * def update_return_upto = db.updateRow("UPDATE CLOSED_LOOP_REDEMPTION SET RETURN_UPTO = CURRENT_TIMESTAMP + 20 WHERE COUPON_CODE IN (\'" +couponCode1+ "\',\'" +couponCode2+ "\',\'" +couponCode3+ "\',\'" +couponCode4+ "\',\'" +couponCode5+ "\')")


  Scenario: merchant return-order b2c BxGy parent __0038.
    * header x-client-type = "mpos"
    * def returnedItems  =
    """
    [
        {
          "skuId": "873873773873",
          "skuQty": 3,
          "skuPrice": 11.4
        },
        {
          "skuId": "873873773874",
          "skuQty": 2,
          "skuPrice": 9.5
        },
        {
          "skuId": "773873773873",
          "skuQty": 4,
          "skuPrice": 11.4
        },
        {
          "skuId": "773873773874",
          "skuQty": 4,
          "skuPrice": 9.5
        },
        {
          "skuId": "163873773873",
          "skuQty": 8,
          "skuPrice": 111.4
        },
        {
          "skuId": "163873773874",
          "skuQty": 2,
          "skuPrice": 99.5
        },
        {
          "skuId": "263873773873",
          "skuQty": 8,
          "skuPrice": 111.4
        },
        {
          "skuId": "263873773874",
          "skuQty": 9,
          "skuPrice": 90.5
        }
      ]
    """

    * def body  =
    """
    {
      "masId": "#(masid)",
      "discountedBillAmount": #(apiComponents["B2C_BxGy_combined_partial_return_responseData__0038"].newBillAmount),
      "couponCodesApplied":[#(couponCode1),#(couponCode2),#(couponCode3),#(couponCode4),#(couponCode5)],
      "originalCart": #(apiComponents["B2C_BxGy_combined_partial_return__0038"].skuData),
      "returnedItems": #(returnedItems)
    }
    """
    Given path '/coupons/v1/coupons/merchant/return-order'
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

  Scenario: merchant order-returned b2c BxGy parent __0001.1.
    * header x-client-type = "mpos"
    * def body =
    """
    {
      "couponCodes":[#(couponCode2),#(couponCode3),#(couponCode4),#(couponCode5)],
      "masId": "#(masid)",
    }
    """
    Given path '/coupons/v1/coupons/merchant/cancel'
    And request body
    When method post
    Then status 200

    * def update_return_upto = db.updateRow("UPDATE CLOSED_LOOP_REDEMPTION SET RETURN_UPTO = CURRENT_TIMESTAMP - 20 WHERE COUPON_CODE IN (\'" +couponCode1+ "\')")

  Scenario: merchant mark redeem b2c BxGy parent __0038.
    * def body  =
    """
    {

    }
    """
    Given path '/coupons/v1/coupons/merchant/mark-redeemed'
    And request body
    When method post
    Then status 200
