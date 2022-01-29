@ignore
Feature:  promotions

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * header Content-Type = 'application/json'

  Scenario Outline: create promotions
    Given set <couponBody>["title"] = "automation_coupon_" + couponId

    Given path "/v1/cms/promotions"
    And multipart file image = <couponImage>
    And multipart fields myMessage = <couponBody>
    And headers headerJson
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
      "masId": "##number"
      }
    """
    Then match coupon == schema

    Examples:
      |couponBody|couponImage |title|description|status|validFrom|validTo|terms|url|A_url|gender|redeemCap|reductionType|discountType|brand|brandName|merchantGroup|couponType|
      |apiComponents[data_add_coupon_pull_brand_type_Free_SKUs_on_SKUs'] |apiComponents[file_add_coupon_pull_brand_type_Free_SKUs_on_SKUs'] |1 Aeriel bar free with 1 kg Aeriel|Test Coupons Online and physical both|APPROVE|2019-11-29|2022-05-31|Test Coupons Online and physical both|https://www.google.com|https://www.google.com|MALE|10000000 |1|FREE_SKU_WITH_SKU|99374|Mtr|581|2 |



  Scenario Outline: edit promotions
    Given set <couponBody>["title"] = "automation_coupon_" + couponId

    Given path "/v1/cms/promotions"
    And multipart file image = <couponImage>
    And multipart fields myMessage = <couponBody>
    And headers headerJson
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
      "masId": "##number"
      }
    """
    Then match coupon == schema

    Examples:
      |couponBody|couponImage |title|description|status|validFrom|validTo|terms|url|A_url|gender|redeemCap|reductionType|discountType|brand|brandName|merchantGroup|couponType|
      |apiComponents['data_add_coupon_pull_brand_type_Free_SKUs_on_SKUs'] |apiComponents['file_add_coupon_pull_brand_type_Free_SKUs_on_SKUs'] |1 Aeriel bar free with 1 kg Aeriel|Test Coupons Online and physical both|APPROVE|2019-11-29|2022-05-31|Test Coupons Online and physical both|https://www.google.com|https://www.google.com|MALE|10000000 |1|FREE_SKU_WITH_SKU|99374|Mtr|581|2 |
