Feature: Central coupon datable API

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * json result = callonce read("B2C_B2B_CouponCodeGeneration.feature@B2C_cart_redemption")
    * def couponCode1 = result.response["skuCoupons"][0]["coupons"][0]["couponCode"]

  Scenario: CCD API
    Given path '/coupons/v1/coupons/cc'
    And param couponIds = couponCode1
    When method get
    Then status 200
    * def coupon = $response
    * def schema =
    """
      {
      "mobileNumber":"#string"
      }
    """
    Then match coupon == schema
