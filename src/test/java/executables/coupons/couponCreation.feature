@ignore
Feature: create coupon

  Background:
    * url baseUrl
    * def login = callonce read('loginToCMS.feature')
    * def xAntiForgery = $login.responseHeaders['x-anti-forgery'][0]
    * header Cookie = $login.responseHeaders['Set-Cookie'][0]
    * header Content-Type = 'multipart/form-data'
    * def apiComponents = read('../helperFiles/files/apiComponents.json')
    * def couponId = function(){ return java.lang.System.currentTimeMillis() }


  @couponCreationone @ignoreClientAPI
  Scenario Outline: create discount type brand coupon 1
    * set <couponBody>["title"] = "automation_coupon_" + couponId

    Given path "/v1/cms/merchant/" + <merchantGroup> + "/coupon"
    And multipart file image = <couponImage>
    And multipart fields myMessage = <couponBody>
    And header x-anti-forgery = xAntiForgery
    When method post
    Then status 200
    * def coupon = $response
    * def schema =
    """
      {
      "id": "#number",
      "title": "<title>",
      "description": "<description>",
      "details": "##string",
      "merchant": "##number",
      "status": "<status>",
      "validTo": "<validTo>",
      "validFrom": "<validFrom>",
      "terms": "<terms>",
      "imageId": null,
      "url": "<url>",
      "affiliateUrl": "<A_url>",
      "note": null,
      "redeemDayHour": "#number",
      "redeemGender": "<gender>",
      "redeemMinAge": "#number",
      "redeemMaxAge": "#number",
      "redeemLocation": 1,
      "redeemExemptDates": null,
      "downloadCap": null,
      "redeemCap": <redeemCap>,
      "privateCoupon": false,
      "couponCode": "$GENERATE_PER_CUSTOMER",
      "reductionType": "<reductionType>",
      "amountThreshold": 0,
      "reduction": null,
      "reductionMax": null,
      "discountAbsValue": "##number",
      "discountPercentageValue": "##number",
      "discountMinBill": "##number",
      "discountMaxBill": "##number",
      "discountType": "<discountType>",
      "discountExtraRules": "#string",
      "sticker": 0,
      "bannerName": "##string",
      "bannerImageId": null,
      "couponType": <couponType>,
      "merchantGroup": <merchantGroup>,
      "brand": <brand>,
      "brandName": "<brandName>",
      "merchantName": "##string",
      "createTs": "#number",
      "masId": "##number",
      }
    """
    Then match coupon == schema

    Examples:
      |couponBody|couponImage |title|description|status|validFrom|validTo|terms|url|A_url|gender|redeemCap|reductionType|discountType|brand|brandName|merchantGroup|couponType|
      |apiComponents['apiBody']['data_add_coupon_pull_brand_type_flat_discount'] |apiComponents['apiBody']['file_add_coupon_pull_brand_type_flat_discount'] |10_rs_off_on_all_products|Test Coupons Online and physical both|APPROVE|2019-11-29|2022-05-31|Test Coupons Online and physical both|https://www.google.com|https://www.google.com|MALE|10000000 |1|FLAT_DISCOUNT|99374|Mtr|581|2 |

  @couponCreationtwo @ignoreClientAPI
  Scenario Outline: create discount type brand coupon 2
    Given set <couponBody>["title"] = "automation_coupon_" + couponId

    Given path "/v1/cms/merchant/" + <merchantGroup> + "/coupon"
    And multipart file image = <couponImage>
    And multipart fields myMessage = <couponBody>
    And header x-anti-forgery = xAntiForgery
    When method post
    Then status 200
    * def coupon = $response
    * def schema =
    """
      {
      "id": "#number",
      "title": "<title>",
      "description": "<description>",
      "details": "##string",
      "merchant": "##number",
      "status": "<status>",
      "validTo": "<validTo>",
      "validFrom": "<validFrom>",
      "terms": "<terms>",
      "imageId": null,
      "url": "<url>",
      "affiliateUrl": "<A_url>",
      "note": null,
      "redeemDayHour": "#number",
      "redeemGender": "<gender>",
      "redeemMinAge": "#number",
      "redeemMaxAge": "#number",
      "redeemLocation": 1,
      "redeemExemptDates": null,
      "downloadCap": null,
      "redeemCap": <redeemCap>,
      "privateCoupon": false,
      "couponCode": "$GENERATE_PER_CUSTOMER",
      "reductionType": "<reductionType>",
      "amountThreshold": 0,
      "reduction": null,
      "reductionMax": null,
      "discountAbsValue": "##number",
      "discountPercentageValue": "##number",
      "discountMinBill": "##number",
      "discountMaxBill": "##number",
      "discountType": "<discountType>",
      "discountExtraRules": "#string",
      "sticker": 0,
      "bannerName": "##string",
      "bannerImageId": null,
      "couponType": <couponType>,
      "merchantGroup": <merchantGroup>,
      "brand": <brand>,
      "brandName": "<brandName>",
      "merchantName": "##string",
      "createTs": "#number",
      "masId": "##number",
      }
    """
    Then match coupon == schema

    Examples:
      |couponBody|couponImage |title|description|status|validFrom|validTo|terms|url|A_url|gender|redeemCap|reductionType|discountType|brand|brandName|merchantGroup|couponType|
      |apiComponents['apiBody']['data_add_coupon_pull_brand_type_Free_SKUs_on_Bill'] |apiComponents['apiBody']['file_add_coupon_pull_brand_type_Free_SKUs_on_Bill'] |rin_on_100_rs_purchase|Test Coupons Online and physical both|APPROVE|2019-11-29|2022-05-31|Test Coupons Online and physical both|https://www.google.com|https://www.google.com|MALE|10000000 |1|FREE_SKU_WITH_BILL|99374|Mtr|581|2 |

  @couponCreationthree @ignoreClientAPI
  Scenario Outline: create discount type brand coupon 3
    Given set <couponBody>["title"] = "automation_coupon_" + couponId

    Given path "/v1/cms/merchant/" + <merchantGroup> + "/coupon"
    And multipart file image = <couponImage>
    And multipart fields myMessage = <couponBody>
    And header x-anti-forgery = xAntiForgery
    When method post
    Then status 200
    * def coupon = $response
    * def schema =
    """
      {
      "id": "#number",
      "title": "<title>",
      "description": "<description>",
      "details": "##string",
      "merchant": "##number",
      "status": "<status>",
      "validTo": "<validTo>",
      "validFrom": "<validFrom>",
      "terms": "<terms>",
      "imageId": null,
      "url": "<url>",
      "affiliateUrl": "<A_url>",
      "note": null,
      "redeemDayHour": "#number",
      "redeemGender": "<gender>",
      "redeemMinAge": "#number",
      "redeemMaxAge": "#number",
      "redeemLocation": 1,
      "redeemExemptDates": null,
      "downloadCap": null,
      "redeemCap": <redeemCap>,
      "privateCoupon": false,
      "couponCode": "$GENERATE_PER_CUSTOMER",
      "reductionType": "<reductionType>",
      "amountThreshold": 0,
      "reduction": null,
      "reductionMax": null,
      "discountAbsValue": "##number",
      "discountPercentageValue": "##number",
      "discountMinBill": "##number",
      "discountMaxBill": "##number",
      "discountType": "<discountType>",
      "discountExtraRules": "#string",
      "sticker": 0,
      "bannerName": "##string",
      "bannerImageId": null,
      "couponType": <couponType>,
      "merchantGroup": <merchantGroup>,
      "brand": <brand>,
      "brandName": "<brandName>",
      "merchantName": "##string",
      "createTs": "#number",
      "masId": "##number",
      }
    """
    Then match coupon == schema

    Examples:
      |couponBody|couponImage |title|description|status|validFrom|validTo|terms|url|A_url|gender|redeemCap|reductionType|discountType|brand|brandName|merchantGroup|couponType|
      |apiComponents['apiBody']['data_add_coupon_pull_brand_type_Free_SKUs_on_SKUs'] |apiComponents['apiBody']['file_add_coupon_pull_brand_type_Free_SKUs_on_SKUs'] |1 rin on 1kg ariel|Test Coupons Online and physical both|APPROVE|2019-11-29|2022-05-31|Test Coupons Online and physical both|https://www.google.com|https://www.google.com|MALE|10000000 |1|FREE_SKU_WITH_SKU|99374|Mtr|581|2 |

  Scenario Outline: create discount type brand coupon 4 and 5
    Given set <couponBody>["title"] = "automation_coupon_" + couponId
    Given path "/v1/cms/merchant/" + <merchantGroup> + "/coupon"
    And multipart file image = <couponImage>
    And multipart fields myMessage = <couponBody>
    And header x-anti-forgery = xAntiForgery
    When method post
    Then status 200
    * def coupon = $response
    * def schema =
    """
      {
      "id": "#number",
      "title": "<title>",
      "description": "<description>",
      "details": "##string",
      "merchant": "##number",
      "status": "<status>",
      "validTo": "<validTo>",
      "validFrom": "<validFrom>",
      "terms": "<terms>",
      "imageId": null,
      "url": "<url>",
      "affiliateUrl": "<A_url>",
      "note": null,
      "redeemDayHour": "#number",
      "redeemGender": "<gender>",
      "redeemMinAge": "#number",
      "redeemMaxAge": "#number",
      "redeemLocation": 1,
      "redeemExemptDates": null,
      "downloadCap": null,
      "redeemCap": <redeemCap>,
      "privateCoupon": false,
      "couponCode": "$GENERATE_PER_CUSTOMER",
      "reductionType": "<reductionType>",
      "amountThreshold": 0,
      "reduction": null,
      "reductionMax": null,
      "discountAbsValue": "##number",
      "discountPercentageValue": "##number",
      "discountMinBill": "##number",
      "discountMaxBill": "##number",
      "discountType": "<discountType>",
      "discountExtraRules": "#string",
      "sticker": 0,
      "bannerName": "##string",
      "bannerImageId": null,
      "couponType": <couponType>,
      "merchantGroup": <merchantGroup>,
      "brand": <brand>,
      "brandName": "<brandName>",
      "merchantName": "##string",
      "createTs": "#number",
      "masId": "##number",
      }
    """
    Then match coupon == schema

    Examples:
      |couponBody|couponImage |title|description|status|validFrom|validTo|terms|url|A_url|gender|redeemCap|reductionType|discountType|brand|brandName|merchantGroup|couponType|
      |apiComponents['apiBody']['data_add_coupon_pull_brand_type_Percentage_discount_on_SKU'] |apiComponents['apiBody']['file_add_coupon_pull_brand_type_Percentage_discount_on_SKU'] |10% discount on tide|Test Coupons Online and physical both|APPROVE|2019-11-29|2022-05-31|Test Coupons Online and physical both|https://www.google.com|https://www.google.com|MALE|10000000 |1|PERCENTAGE_DISCOUNT_WITH_SKU|99374|Mtr|581|2 |
      |apiComponents['apiBody']['data_add_coupon_pull_brand_type_Percentage_discount_on_Bill'] |apiComponents['apiBody']['file_add_coupon_pull_brand_type_Percentage_discount_on_Bill'] |10% off on a minimum bill amount of Rs. 500|Test Coupons Online and physical both|APPROVE|2019-11-29|2022-05-31|Test Coupons Online and physical both|https://www.google.com|https://www.google.com|MALE|10000000 |1 |PERCENTAGE_DISCOUNT|99374|Mtr|581|2|

  Scenario: cms logout
    Given path '/v1/cms/logout'
    And header x-anti-forgery = xAntiForgery
    When method get
    Then status 204