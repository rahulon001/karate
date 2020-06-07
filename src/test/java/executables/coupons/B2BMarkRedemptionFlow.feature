@ignore
Feature: Perform B2B mark redemption flow

  Background:
    * url baseUrl
    * header Content-Type = 'application/json'
    * header x-client-type = "mpos"
    * def apiComponents = read('../helperFiles/files/apiComponents.json')
    * def result = callonce read("B2CredemptionFlow_DiscountType.feature@B2CredemptionFlow_discountType")
    * def result = callonce read("B2C_B2B_CouponCodeGeneration.feature@B2B_cart_redemption")
    * def couponCode1 = result.response["skuCoupons"][0]["coupons"][0]["couponCode"]
    * def couponCode2 = result.response["skuCoupons"][1]["coupons"][0]["couponCode"]
    * def couponCode3 = result.response["skuCoupons"][2]["coupons"][0]["couponCode"]
    * def couponCode4 = result.response["skuCoupons"][3]["coupons"][0]["couponCode"]
    * def couponCode5 = result.response["skuCoupons"][4]["coupons"][0]["couponCode"]
    *  def transactionID =
    """
      function(){ return java.lang.System.currentTimeMillis() }
    """
    * def transaction_id = callonce transactionID
    * def masid = apiComponents['parameterValues']['masid']

  Scenario Outline: get B2B coupons B2BMarkRedemptionFlow.
    * def body =
    """
    {
    "sku": "<skuid>",
    "start" : 0,
    "end" : 1000
    }
    """

    Given path '/coupons/v1/coupons/merchant/'+masid+'/fc/coupons'
    And request body
    When method post
    Then status 200

    Examples:
      |skuid|
      |10099666767689|
      |1000059234|
      |1009966699|
      |100918099898|
      |1009977754|
      |100997773434|

  Scenario: merchant checkout B2BMarkRedemptionFlow.
    * def skuid = apiComponents['parameterValues']['B2BMarkRedemptionFlow']['skuid']
    * def skuQty = apiComponents['parameterValues']['B2BMarkRedemptionFlow']['skuQty']
    * def skuPrice = apiComponents['parameterValues']['B2BMarkRedemptionFlow']['skuPrice']
    * def skuid1 = apiComponents['parameterValues']['B2BMarkRedemptionFlow']['skuid1']
    * def skuQty1 = apiComponents['parameterValues']['B2BMarkRedemptionFlow']['skuQty1']
    * def skuPrice1 = apiComponents['parameterValues']['B2BMarkRedemptionFlow']['skuPrice1']
    * def skuid2 = apiComponents['parameterValues']['B2BMarkRedemptionFlow']['skuid2']
    * def skuQty2 = apiComponents['parameterValues']['B2BMarkRedemptionFlow']['skuQty2']
    * def skuPrice2 = apiComponents['parameterValues']['B2BMarkRedemptionFlow']['skuPrice2']
    * def skuid3 = apiComponents['parameterValues']['B2BMarkRedemptionFlow']['skuid3']
    * def skuQty3 = apiComponents['parameterValues']['B2BMarkRedemptionFlow']['skuQty3']
    * def skuPrice3 = apiComponents['parameterValues']['B2BMarkRedemptionFlow']['skuPrice3']
    * def skuid4 = apiComponents['parameterValues']['B2BMarkRedemptionFlow']['skuid4']
    * def skuQty4 = apiComponents['parameterValues']['B2BMarkRedemptionFlow']['skuQty4']
    * def skuPrice4 = apiComponents['parameterValues']['B2BMarkRedemptionFlow']['skuPrice4']
    * def discountAmount = apiComponents['parameterValues']['B2BMarkRedemptionFlow']['discountAmount']
    * def newBillAmount = apiComponents['parameterValues']['B2BMarkRedemptionFlow']['newBillAmount']
    * def body =
    """
    {
      "masId": "#(masid)",
      "billAmount": 1000,
      "transactionId": "#(transaction_id)",
      "couponCodes": [#(couponCode1), #(couponCode2), #(couponCode3), #(couponCode4), #(couponCode5)],

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
      }
    ]
  }
    """
    Given path '/coupons/v1/coupons/merchant/fc/checkout'
    And request body
    When method post
    Then status 200
    And match response["discountAmount"] == discountAmount
    And match response["newBillAmount"] == newBillAmount

   Scenario: B2B deliver B2BMarkRedemptionFlow.
    * def body  =
    """
    {
      "couponCodes":[#(couponCode1), #(couponCode2), #(couponCode3), #(couponCode4), #(couponCode5)],
      "masId": "#(masid)",
      "transactionId": "#(transaction_id)"
     }

    """
    Given path '/coupons/v1/coupons/merchant/fc/delivered'
    And request body
    When method post
    Then status 200

  Scenario: merchant mark redeem B2BMarkRedemptionFlow.
    * def body  =
    """
    {
    }
    """
    Given path '/coupons/v1/coupons/merchant/fc/mark-redeemed'
    And request body
    When method post
    Then status 200
