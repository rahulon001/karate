@ignore
Feature: Generate B2B and B2C coupon codes.

  Background:
    * url baseUrl
    * def apiComponents = read('../helperFiles/files/apiComponents.json')
    * header Content-Type = 'application/json'

  @B2C_cart_redemption
  Scenario: Perform B2C cart redemption discount type
    * header x-client-type = "myjio"
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request apiComponents['apiBody']['data_create_cart_B2C_mastercode']
    When method post
    Then status 200

  @B2C_cart_redemption_paymentType
  Scenario: Perform B2C cart redemption payment type
    * header x-client-type = "myjio"
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request apiComponents['apiBody']['data_create_cart_B2C_mastercode_paymentType']
    When method post
    Then status 200

  @B2B_cart_redemption
  Scenario: Perform B2B cart redemption
    * header x-client-type = "mpos"
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And request apiComponents['apiBody']['data_create_cart_B2B']
    When method post
    Then status 200