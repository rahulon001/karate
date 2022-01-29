Feature: Perform B2C FC merchant release

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * header Content-Type = 'application/json'
    * def apiComponents = envConfig
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
    * def masid = apiComponents['CMS_masid']
    * def skuid = apiComponents['FCBlock_merchantRelease']['skuid']
    * def skuQty = apiComponents['FCBlock_merchantRelease']['skuQty']
    * def skuPrice = apiComponents['FCBlock_merchantRelease']['skuPrice']
    * def skuid1 = apiComponents['FCBlock_merchantRelease']['skuid1']
    * def skuQty1 = apiComponents['FCBlock_merchantRelease']['skuQty1']
    * def skuPrice1 = apiComponents['FCBlock_merchantRelease']['skuPrice1']
    * def skuid2 = apiComponents['FCBlock_merchantRelease']['skuid2']
    * def skuQty2 = apiComponents['FCBlock_merchantRelease']['skuQty2']
    * def skuPrice2 = apiComponents['FCBlock_merchantRelease']['skuPrice2']
    * def skuid3 = apiComponents['FCBlock_merchantRelease']['skuid3']
    * def skuQty3 = apiComponents['FCBlock_merchantRelease']['skuQty3']
    * def skuPrice3 = apiComponents['FCBlock_merchantRelease']['skuPrice3']
    * def skuid4 = apiComponents['FCBlock_merchantRelease']['skuid4']
    * def skuQty4 = apiComponents['FCBlock_merchantRelease']['skuQty4']
    * def skuPrice4 = apiComponents['FCBlock_merchantRelease']['skuPrice4']
    * def skuid5 = apiComponents['FCBlock_merchantRelease']['skuid5']
    * def skuQty5 = apiComponents['FCBlock_merchantRelease']['skuQty5']
    * def skuPrice5 = apiComponents['FCBlock_merchantRelease']['skuPrice5']

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

  Scenario Outline: FC merchant release.
    * header x-client-type = "mpos"
    * def body  =
    """
        {
          "couponCodes": "<codes>",
          "transactionId": "#(transaction_id)",
          "masId": "100001000073658"
        }
    """
    Given path '/coupons/v1/coupons/merchant-release'
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
