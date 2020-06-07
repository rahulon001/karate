@ignore
Feature: Get coupon categories

  Background:
    * url baseUrl
    * header Content-Type = 'application/json'

  @getCouponCategories
  Scenario: Get coupons
    Given path '/coupons/v1/coupons/categories'
    And header x-loginid = '8369353463'
    And param version = "v5"
    And param client = "myjio"
    When method get
    Then status 200