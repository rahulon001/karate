Feature: NovelVox related APIs

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * header Content-Type = 'application/json'
    * header x-client-type = 'myjio'

  Scenario: GET novelVox Merchant Coupons
    Given path '/coupons/v1/coupons/merchantCoupons'
    And param masId = "100001000073658"
    And param startDate = "02-01-2018"
    And param endDate = "05-01-2019"
    When method get
    Then status 200
#    * def coupon = $response["result"]
    * def schema =
    """
      {
      "id": "#number",
      "title": "#string",
      "description":  "#string",
      "startDate":  "#string",
      "endDate":  "#string",
      "status":  "#string",
      "discountType":  "#string"
    }
    """
#    Then match coupon == '#[] schema'


  Scenario: GET novelVox Merchant Redemption
    Given path '/coupons/v1/coupons/merchantRedemptions'
    And param masId = "100001000073658"
    When method get
    Then status 200
#    * def coupon = $response["result"]
    * def schema =
    """
      {
      "coupon": "#number",
      "coupon_code": "#string",
      "discount_amount": "##string",
      "reedem_ts": "##string",
      "status": "#string",
      "settlemet_amount": "##string",
      "settlemet_status": "##string",
      "batch_id": "#string"
    }
    """
#    Then match coupon == '#[] schema'

  Scenario: GET novelVox redeem-status
    Given path '/coupons/v1/coupons/redeem-status'
    And param phone = "9945240311"
    When method get
    Then status 200
#    * def coupon = $response["result"]
    * def schema =
    """
      {
            "coupon": "#number",
            "title": "#string",
            "phone": "#string",
            "assignTime": "#number",
            "assigned": "#boolean"
      }
    """
#    Then match coupon == '#[] schema'

