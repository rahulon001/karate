Feature: Get applicable coupons in Jiokart as per SKU

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * header Content-Type = 'application/json'
    * def apiComponents = envConfig

    Scenario: Get applicable coupon via post request as per SKU.
      * def body =
      """
      {
        "billAmount": 1000,
        "skuData": [
          {
            "skuId": "1000059291",
            "skuQty": 3,
            "skuPrice": 10.4
          },
          {
            "skuId": "100005923491",
            "skuQty": 2,
            "skuPrice": 10.5
          },
          {
            "skuId": "100996669991",
            "skuQty": 2,
            "skuPrice": 10.5
          },
          {
            "skuId": "10091809989891",
            "skuQty": 2,
            "skuPrice": 9
          },
          {
            "skuId": "100997775491",
            "skuQty": 1,
            "skuPrice": 11
          },
          {
            "skuId": "10099777343491",
            "skuQty": 6,
            "skuPrice": 10.5
          }
        ]
      }
      """
      Given path "/coupons/v1/coupons/mastercode/coupons"
      And header x-client-type = 'RJIL_JioKart'
      And request body
      When method post
      Then status 200

