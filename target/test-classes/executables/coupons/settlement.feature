Feature: Merchant Settlement
  Background:
    * url baseUrl
    * call read('support.feature@common_functions')

  Scenario Outline: Merchant settlement
    Given path '/coupons/v1/coupons/merchantId-settlement'
    * param masId = '<masId>'
    * param startDate = '10-06-2020'
    * param endDate = '10-07-2021'
    * param couponType = '<couponType>'
    When method GET
    Then status 200
    And match response.OutStanding[0].masId == '<masId>'

    Examples:
    |masId            |couponType|
    |100001000073658|discount  |

  Scenario Outline: Merchant settlement Report
    Given path '/coupons/v1/coupons/merchant-settlement-report'
    * param masId = '<masId>'
    * param storeId = '<storeId>'
    * param tId = '<tId>'
    * param startDate = '<startDate>'
    * param endDate = '<endDate>'
    * param couponType = '<couponType>'
    When method GET
    Then status 200
    And match response.OutStanding[0].masId == '<masId>'

    Examples:
    |masId          |storeId        |tId      |startDate|endDate   |couponType|
    |100001000073658|100001000073658|xyzklj199|10-06-202|10-07-2021|discount  |
    