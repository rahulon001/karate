Feature: create campaigns

  Background:
    * url baseUrl
    * def login = callonce read('loginToCMS.feature')
    * def xAntiForgery = $login.responseHeaders['x-anti-forgery'][0]
    * header Cookie = $login.responseHeaders['Set-Cookie'][0]
    * def apiComponents = read('../helperFiles/files/apiComponents.json')
    * header Content-Type = 'application/json'
    * def couponCreation1 = callonce read("couponCreation.feature@couponCreationone")
    * def couponCreation2 = callonce read("couponCreation.feature@couponCreationtwo")
    * def couponCreation3 = callonce read("couponCreation.feature@couponCreationthree")
    * def couponId1 = couponCreation1.response["id"]
    * def couponId2 = couponCreation2.response["id"]
    * def couponId3 = couponCreation3.response["id"]

  @campaignCreationOneCoupon
  Scenario: campaign creation
    * def body = 
    """
    {
      "name": "Automation_campaign",
      "startTime": "2019-12-09 00:00:00",
      "endTime": "2023-12-31 23:59:59",
      "lineItems": [
        {
          "coupons": [#(couponId1)],
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
    Given path "/v1/cms/coupon-campaign/"
    And request body
    And header x-anti-forgery = xAntiForgery
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
    Given path "/v1/cms/coupon-campaign/"
    And request body
    And header x-anti-forgery = xAntiForgery
    When method post
    Then status 200


