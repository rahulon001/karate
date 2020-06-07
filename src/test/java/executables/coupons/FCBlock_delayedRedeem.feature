@ignore
Feature: Perform B2C FC block delayed redeem

  Background:
    * url baseUrl
    * header Content-Type = 'application/json'
    * def apiComponents = read('../helperFiles/files/apiComponents.json')
    * json result = callonce read("B2C_B2B_CouponCodeGeneration.feature@B2C_cart_redemption")
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
    * def skuid = apiComponents['parameterValues']['FCBlock_delayedRedeem']['skuid']
    * def skuQty = apiComponents['parameterValues']['FCBlock_delayedRedeem']['skuQty']
    * def skuPrice = apiComponents['parameterValues']['FCBlock_delayedRedeem']['skuPrice']
    * def skuid1 = apiComponents['parameterValues']['FCBlock_delayedRedeem']['skuid1']
    * def skuQty1 = apiComponents['parameterValues']['FCBlock_delayedRedeem']['skuQty1']
    * def skuPrice1 = apiComponents['parameterValues']['FCBlock_delayedRedeem']['skuPrice1']
    * def skuid2 = apiComponents['parameterValues']['FCBlock_delayedRedeem']['skuid2']
    * def skuQty2 = apiComponents['parameterValues']['FCBlock_delayedRedeem']['skuQty2']
    * def skuPrice2 = apiComponents['parameterValues']['FCBlock_delayedRedeem']['skuPrice2']
    * def skuid3 = apiComponents['parameterValues']['FCBlock_delayedRedeem']['skuid3']
    * def skuQty3 = apiComponents['parameterValues']['FCBlock_delayedRedeem']['skuQty3']
    * def skuPrice3 = apiComponents['parameterValues']['FCBlock_delayedRedeem']['skuPrice3']
    * def skuid4 = apiComponents['parameterValues']['FCBlock_delayedRedeem']['skuid4']
    * def skuQty4 = apiComponents['parameterValues']['FCBlock_delayedRedeem']['skuQty4']
    * def skuPrice4 = apiComponents['parameterValues']['FCBlock_delayedRedeem']['skuPrice4']
    * def skuid5 = apiComponents['parameterValues']['FCBlock_delayedRedeem']['skuid5']
    * def skuQty5 = apiComponents['parameterValues']['FCBlock_delayedRedeem']['skuQty5']
    * def skuPrice5 = apiComponents['parameterValues']['FCBlock_delayedRedeem']['skuPrice5']

  Scenario Outline: merchant verify for FC Block.
    * header x-client-type = "mpos"
    * def body =
    """
    {
      "masId": "#(masid)",
      "storeId": "#(masid)",
      "transactionId": "#(transaction_id)",
      "tId": "xyzklj199",
      "billAmount": 1000,
      "couponCodes": "<codes>",
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

    Examples:
      |codes|
      |#(couponCode1)|
      |#(couponCode2)|
      |#(couponCode3)|
      |#(couponCode4)|
      |#(couponCode5)|

  Scenario Outline: merchant checkout for FC block.
    * header x-client-type = "mpos"
    * def body =
    """
    {
      "masId": "#(masid)",
      "storeId": "#(masid)",
      "transactionId": "#(transaction_id)",
      "tId": "xyzklj199",
      "billAmount": 1000,
      "couponCodes": "<codes>",
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

    Examples:
      |codes|
      |#(couponCode1)|
      |#(couponCode2)|
      |#(couponCode3)|
      |#(couponCode4)|
      |#(couponCode5)|

  Scenario: FC block.
    * header x-client-type = "mpos"
    * def body  =
    """
        {
          "couponCodes" : [#(couponCode1), #(couponCode2), #(couponCode3), #(couponCode4), #(couponCode5)],
          "masId": "#(masid)",
          "storeId": "#(masid)",
          "tId": "xyzklj199",
        }
    """
    Given path '/coupons/v1/coupons/merchant-block'
    And request body
    When method post
    Then status 200

  Scenario: Delayed redeem.
    * header x-client-type = "mpos"
    * def body  =
    """
        {
          "couponCodes" : [#(couponCode1), #(couponCode2), #(couponCode3), #(couponCode4), #(couponCode5)],
          "transactionId": "#(transaction_id)",
          "masId": "#(masid)",
        }
    """
    Given path '/coupons/v1/coupons/merchant-delayed-redeem'
    And request body
    When method post
    Then status 200
#    * match response != {"message":"failure","code":71}

