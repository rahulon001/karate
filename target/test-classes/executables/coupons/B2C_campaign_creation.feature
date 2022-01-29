@ignore
Feature: create campaigns

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * def login = callonce read('support.feature@login')
    * def headerJson = {}
    * set headerJson.Cookie = $login.responseHeaders['Set-Cookie'][0]
    * set headerJson.X-Anti-Forgery = $login.responseHeaders['x-anti-forgery'][0]
    * set headerJson.Content-Type = 'application/json'
    * def apiComponents = envConfig
#    * def couponCreation1 = callonce read("couponCreation.feature@couponCreationone")
#    * def couponCreation2 = callonce read("couponCreation.feature@couponCreationtwo")
#    * def couponCreation3 = callonce read("couponCreation.feature@couponCreationthree")
#    * def couponId1 = couponCreation1.response["id"]
#    * def couponId2 = couponCreation2.response["id"]
#    * def couponId3 = couponCreation3.response["id"]

  @campaignCreationOneCoupon
  Scenario: campaign creation
    * def body = 
    """
    {
      "name": "Automation_campaign",
      "startTime": "2019-12-09 00:00:00",
      "endTime": "2029-12-31 23:59:59",
      "lineItems": [
        {
          "coupons": ['263549',
                      '263550',
                      '263551',
                      '263552',
                      '263553',
                      '263554',
                      '263555',
                      '263556',
                      '263557',
                      '263558',
                      '263559',
                      '263560',
                      '263561'
                      ],
          "segment": {
            "op": "and",
            "segments": [
              {
                "op": "all",
                "segments": []
              }
            ]
          }
        }
      ],
      "userGroup": 42
    }
    """
    Given url baseUrl+ "/v1/cms/coupon-campaign/"
    And request body
    And headers headerJson
    When method post
    Then status 200

  @campaignCreationTwoCoupons
  Scenario: campaign creation
    * def body =
    """
    {
      "name": "Automation_campaign",
      "startTime": "2019-12-09 00:00:00",
      "endTime": "2023-12-31 23:59:59",
      "lineItems": [
        {
          "coupons": [#(couponId2),#(couponId3)],
          "segment": {
            "op": "and",
            "segments": [
              {
                "op": "all",
                "segments": []
              }
            ]
          }
        }
      ],
      "userGroup": 42
    }
    """
    Given url baseUrl+"/v1/cms/coupon-campaign/"
    And request body
    And headers headerJson
    When method post
    Then status 200

  @campaignCreation_Multiple
  Scenario: Multiple campaign creation
    * def body =
    """
        {
            "name": "Automation_campaign",
            "startTime": "2019-12-09 00:00:00",
            "endTime": "2023-12-31 23:59:59",
            "lineItems": [
              {
                "coupons": [
                  #(couponId1),
                  #(couponId2)
                ],
                "segment": {
                  "op": "and",
                  "segments": [
                    "3328"
                  ]
                }
              },
              {
                "coupons": [
                  #(couponId3)
                ],
                "segment": {
                  "op": "and",
                  "segments": [
                    "3259"
                  ]
                }
              }
            ],
            "userGroup": 42
          }
    """

    Given url baseUrl+ "/v1/cms/coupon-campaign/"
    And request body
    And headers headerJson
    When method post
    Then status 200

  @logout
  Scenario: cms logout
    * def logout = callonce read('support.feature@logout') {requestHeader: #(headerJson)}



