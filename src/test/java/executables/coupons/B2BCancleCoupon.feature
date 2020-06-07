@ignore
Feature: Perform B2B redemption cancel coupon flow

  Background:
    * url baseUrl
    * header Content-Type = 'application/json'
    * header x-client-type = "mpos"
    * def result = callonce read("B2CredemptionFlow_DiscountType.feature@B2CredemptionFlow_discountType")
    * def result = callonce read("B2C_B2B_CouponCodeGeneration.feature@B2B_cart_redemption")
    * def couponCode1 = result.response["skuCoupons"][0]["coupons"][0]["couponCode"]
    * print "<<<<<<<<<<<<<<<<", couponCode1
    * def apiComponents = read('../helperFiles/files/apiComponents.json')
    * def masid = apiComponents['parameterValues']['masid']

  Scenario: get B2B coupons B2BCancleCoupon.
    * def skuid = apiComponents['parameterValues']['B2BCancelCoupon']['skuid']
    * def body =
    """
    {
    "sku": "#(skuid)",
    "start" : 0,
    "end" : 1000
    }
    """

    Given path '/coupons/v1/coupons/merchant/'+masid+'/fc/coupons'
    And request body
    When method post
    Then status 200

  Scenario: merchant checkout B2BCancleCoupon.
    * def skuid = apiComponents['parameterValues']['B2BCancelCoupon']['skuid']
    * def skuid1 = apiComponents['parameterValues']['B2BCancelCoupon']['skuid1']
    * def skuQty = apiComponents['parameterValues']['B2BCancelCoupon']['skuQty']
    * def skuQty1 = apiComponents['parameterValues']['B2BCancelCoupon']['skuQty1']
    * def skuPrice = apiComponents['parameterValues']['B2BCancelCoupon']['skuPrice']
    * def skuPrice1 = apiComponents['parameterValues']['B2BCancelCoupon']['skuPrice1']
    * def body =
    """
    {
      "masId": "#(masid)",
      "billAmount": 1000,
      "couponCodes": [#(couponCode1)],

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
      }
    ]
  }
    """
    Given path '/coupons/v1/coupons/merchant/fc/checkout'
    And request body
    When method post
    Then status 200


  Scenario: merchant redeem B2BCancleCoupon.
    * def body  =
    """
    {
      "masId": "#(masid)",
      "couponCodes":[#(couponCode1)]
    }
    """
    Given path '/coupons/v1/coupons/merchant/fc/delayed-cancel'
    And request body
    When method post
    Then status 200
