#@ignore @B2CmarkredemptionFlow
Feature: Perform B2C mark redemption flow for discount type coupons.

  Background:
    * def ArrayList = Java.type('java.util.ArrayList')
    * def Collections = Java.type('java.util.Collections')
    * url baseUrl
    * header Content-Type = 'application/json'
    * header x-client-type = "mpos"
    * def apiComponents = read('../helperFiles/files/apiComponents.json')
    * def helperMethods = Java.type('executables.utils.HelperMethods')
    * json result = callonce read("B2C_B2B_CouponCodeGeneration.feature@B2C_cart_redemption")
    * def couponCode1 = result.response["skuCoupons"][0]["coupons"][0]["couponCode"]
    * def couponCode2 = result.response["skuCoupons"][1]["coupons"][0]["couponCode"]
    * def couponCode3 = result.response["skuCoupons"][2]["coupons"][0]["couponCode"]
    * def couponCode4 = result.response["skuCoupons"][3]["coupons"][0]["couponCode"]
    * def couponCode5 = result.response["skuCoupons"][4]["coupons"][0]["couponCode"]
    * def couponId1 = result.response["skuCoupons"][0]["coupons"][0]["couponId"]
    * def couponId2 = result.response["skuCoupons"][1]["coupons"][0]["couponId"]
    * def couponId3 = result.response["skuCoupons"][2]["coupons"][0]["couponId"]
    * def couponId4 = result.response["skuCoupons"][3]["coupons"][0]["couponId"]
    * def couponId5 = result.response["skuCoupons"][4]["coupons"][0]["couponId"]
    * def Codes = [#(couponCode1),#(couponCode2),#(couponCode3),#(couponCode4),#(couponCode5)]
    * def Ids = [#(couponId1),#(couponId2),#(couponId3),#(couponId4),#(couponId5)]
    * def map = helperMethods.MapIt(Codes,Ids)
    *  def transactionID =
    """
    function(){ return java.lang.System.currentTimeMillis() }
    """
    * def transaction_id = callonce transactionID
    * def masid = apiComponents['parameterValues']['masid']
    * def skuid = apiComponents['parameterValues']['B2CMarkRedeemFlow_discountType']['skuid']
    * def skuQty = apiComponents['parameterValues']['B2CMarkRedeemFlow_discountType']['skuQty']
    * def skuPrice = apiComponents['parameterValues']['B2CMarkRedeemFlow_discountType']['skuPrice']
    * def skuid1 = apiComponents['parameterValues']['B2CMarkRedeemFlow_discountType']['skuid1']
    * def skuQty1 = apiComponents['parameterValues']['B2CMarkRedeemFlow_discountType']['skuQty1']
    * def skuPrice1 = apiComponents['parameterValues']['B2CMarkRedeemFlow_discountType']['skuPrice1']
    * def skuid2 = apiComponents['parameterValues']['B2CMarkRedeemFlow_discountType']['skuid2']
    * def skuQty2 = apiComponents['parameterValues']['B2CMarkRedeemFlow_discountType']['skuQty2']
    * def skuPrice2 = apiComponents['parameterValues']['B2CMarkRedeemFlow_discountType']['skuPrice2']
    * def skuid3 = apiComponents['parameterValues']['B2CMarkRedeemFlow_discountType']['skuid3']
    * def skuQty3 = apiComponents['parameterValues']['B2CMarkRedeemFlow_discountType']['skuQty3']
    * def skuPrice3 = apiComponents['parameterValues']['B2CMarkRedeemFlow_discountType']['skuPrice3']
    * def skuid4 = apiComponents['parameterValues']['B2CMarkRedeemFlow_discountType']['skuid4']
    * def skuQty4 = apiComponents['parameterValues']['B2CMarkRedeemFlow_discountType']['skuQty4']
    * def skuPrice4 = apiComponents['parameterValues']['B2CMarkRedeemFlow_discountType']['skuPrice4']
    * def skuid5 = apiComponents['parameterValues']['B2CMarkRedeemFlow_discountType']['skuid5']
    * def skuQty5 = apiComponents['parameterValues']['B2CMarkRedeemFlow_discountType']['skuQty5']
    * def skuPrice5 = apiComponents['parameterValues']['B2CMarkRedeemFlow_discountType']['skuPrice5']
    * def discountAmount = apiComponents['parameterValues']['B2CMarkRedeemFlow_discountType']['discountAmount']
    * def newBillAmount = apiComponents['parameterValues']['B2CMarkRedeemFlow_discountType']['newBillAmount']

  Scenario Outline: merchant verify B2CMarkRedeemFlow_discountType.
    * def body =
    """
    {
      "masId": "#(masid)",
      "storeId": "#(masid)",
      "transactionId": "#(transaction_id)",
      "tId": "xyzklj199",
      "billAmount": 1000,
      "couponCodes": <codes>,
      "skuData": [
      {
        "skuId": "#(skuid)",
        "skuQty": #(skuQty),
        "skuPrice": #(skuPrice)
      },
      {
        "skuId": "#(skuid1)",
        "skuQty":  #(skuQty1),
        "skuPrice": #(skuPrice1)
      },
        {
        "skuId": "#(skuid2)",
        "skuQty": #(skuQty2),
        "skuPrice": #(skuPrice2)
      },
      {
        "skuId": "#(skuid3)",
        "skuQty":  #(skuQty3),
        "skuPrice": #(skuPrice3)
      },
       {
        "skuId": "#(skuid4)",
        "skuQty":  #(skuQty4),
        "skuPrice": #(skuPrice4)
      },
      {
        "skuId": "#(skuid5)",
        "skuQty":  #(skuQty5),
        "skuPrice": #(skuPrice5)
      }
      ]
    }
    """
    Given path '/coupons/v1/coupons/merchant-verify'
    And request body
    When method post
    Then status 200
    * match response["data"][0]["couponId"] == <couponId>
    * match response["data"][0]["discountType"] == <discountType>
    * match response["data"][0]["discount"] == <discount>
    * match response["data"][0]["settlementAmount"] == <settlementAmount>
    * match response["discountedItems"][0]["skuId"] == <freeSku>
    * match response["discountedItems"][0]["skuPrice"] == <skuDiscountPrice>
    * match response["discountedItems"][0]["skuQty"] == <skuQty_response>
    * match response["newBillAmount"] == <newBillAmount>


    Examples:
      | codes               | discountType                   | settlementAmount | newBillAmount | couponId | skuDiscountPrice | freeSku          | discount | skuQty_response |
      | #(map.get("10545")) | "FREE_SKU_WITH_SKU"            | 0.0              | 982.0         | 10545    | 0.0              | "100918099898"   | 18.0     | 2               |
      | #(map.get("10546")) | "FLAT_DISCOUNT_WITH_SKU"       | 0.0              | 997.0         | 10546    | 8.0              | "1009977754"     | 3.0      | 1               |
      | #(map.get("9655"))  | "SAMPLE_TYPE_DISCOUNT"         | 1.04             | 989.6         | 9655     | 0.0              | "10099666767689" | 10.4     | 1               |
      | #(map.get("9947"))  | "PERCENTAGE_DISCOUNT_WITH_SKU" | 0.0              | 999.055       | 9947     | 9.555            | "1000059234"     | 0.945    | 1               |
      | #(map.get("10547")) | "FREE_SKU_WITH_SKU"            | 0.0              | 979.0         | 10547    | 0.0              | "100997773434"   | 21.0     | 2               |


  Scenario Outline: merchant checkout B2CMarkRedeemFlow_discountType.
    * def body =
    """
    {
      "masId": "#(masid)",
      "storeId": "#(masid)",
      "transactionId": "#(transaction_id)",
      "tId": "xyzklj199",
      "billAmount": 1000,
      "couponCodes": <codes>,
      "skuData": [
      {
        "skuId": "#(skuid)",
        "skuQty": #(skuQty),
        "skuPrice": #(skuPrice)
      },
      {
        "skuId": "#(skuid1)",
        "skuQty":  #(skuQty1),
        "skuPrice": #(skuPrice1)
      },
        {
        "skuId": "#(skuid2)",
        "skuQty": #(skuQty2),
        "skuPrice": #(skuPrice2)
      },
      {
        "skuId": "#(skuid3)",
        "skuQty":  #(skuQty3),
        "skuPrice": #(skuPrice3)
      },
       {
        "skuId": "#(skuid4)",
        "skuQty":  #(skuQty4),
        "skuPrice": #(skuPrice4)
      },
      {
        "skuId": "#(skuid5)",
        "skuQty":  #(skuQty5),
        "skuPrice": #(skuPrice5)
      }
      ]
    }
    """
    Given path '/coupons/v1/coupons/merchant/checkout'
    And request body
    When method post
    Then status 200
    * match response["data"][0]["couponId"] == <couponId>
    * match response["data"][0]["discountType"] == <discountType>
    * match response["data"][0]["discount"] == <discount>
    * match response["data"][0]["settlementAmount"] == <settlementAmount>
    * match response["discountedItems"][0]["skuId"] == <freeSku>
    * match response["discountedItems"][0]["skuPrice"] == <skuDiscountPrice>
    * match response["discountedItems"][0]["skuQty"] == <skuQty_response>
    * match response["newBillAmount"] == <newBillAmount>


    Examples:
      | codes               | discountType                   | settlementAmount | newBillAmount | couponId | skuDiscountPrice | freeSku          | discount | skuQty_response |
      | #(map.get("10545")) | "FREE_SKU_WITH_SKU"            | 0.0              | 982.0         | 10545    | 0.0              | "100918099898"   | 18.0     | 2               |
      | #(map.get("10546")) | "FLAT_DISCOUNT_WITH_SKU"       | 0.0              | 997.0         | 10546    | 8.0              | "1009977754"     | 3.0      | 1               |
      | #(map.get("9655"))  | "SAMPLE_TYPE_DISCOUNT"         | 1.04             | 989.6         | 9655     | 0.0              | "10099666767689" | 10.4     | 1               |
      | #(map.get("9947"))  | "PERCENTAGE_DISCOUNT_WITH_SKU" | 0.0              | 999.055       | 9947     | 9.555            | "1000059234"     | 0.945    | 1               |
      | #(map.get("10547")) | "FREE_SKU_WITH_SKU"            | 0.0              | 979.0         | 10547    | 0.0              | "100997773434"   | 21.0     | 2               |


  Scenario: merchant accept-order B2CMarkRedeemFlow_discountType.
    * def body  =
    """
    {
      "couponCodes":[#(couponCode1), #(couponCode2), #(couponCode3), #(couponCode4), #(couponCode5)],
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


  Scenario: merchant delivered-order B2CMarkRedeemFlow_discountType.
    * def body =
    """
    {
      "couponCodes":[#(couponCode1), #(couponCode2), #(couponCode3), #(couponCode4), #(couponCode5)],
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

  Scenario: merchant mark redeem B2CMarkRedeemFlow_discountType.
    * def body  =
    """
    {

    }
    """
    Given path '/coupons/v1/coupons/merchant/mark-redeemed'
    And request body
    When method post
    Then status 200
