@ignore
Feature: create coupon

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * def login = callonce read('support.feature@login')
    * def headerJson = {}
    * set headerJson.Cookie = $login.responseHeaders['Set-Cookie'][0]
    * set headerJson.X-Anti-Forgery = $login.responseHeaders['x-anti-forgery'][0]
    * set headerJson.Content-Type = 'multipart/form-data'
    * def apiComponents = envConfig
    * def couponId = function(){ return java.lang.System.currentTimeMillis() }
    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])
    * def today =
        """
        function(date_format) {
          var SimpleDateFormat = Java.type('java.text.SimpleDateFormat');
          var sdf = new SimpleDateFormat(date_format);
          return sdf.format(new java.util.Date());
        }
        """
    * print "mmmmmmmmmmmm", today('yyyy-MM-dd')

  Scenario Outline: create discount type brand coupon 1
    * def couponBody =
    """
    {
        "userGroup": "42",
        "title": "flat discount  1",
        "couponLabel": "TESTCoupon",
        "couponTag": "3",
        "couponType": "2",
        "validFrom": "2019/11/29 00:00:00",
        "validTo": "2029/05/31 23:59:00",
        "brand": "99374",
        "merchantGroup": "29",
        "pushType": "0",
        "priv": "0",
        "discountExtraRules": "NA",
        "brandFunding": "100",
        "merchantFunding": "0",
        "relianceFunding": "0",
        "description": "buy tea get coffee free",
        "terms": "buy tea get coffee free",
        "clients[]": "5",
        "clients[]": "3",
        "categories": "80101",
        "demoCoupon": "0",
        "discountCoupon": "1",
        "discountType": "FLAT_DISCOUNT_WITH_SKU",
        "skuCondition": "10100982",
        "skuConditionName": "Tata Tea",
        "skuConditionQuantity": "2",
        "skuConditionActualPrice": "123",
        "skuConditionSellingPrice": "122",
        "skuConditionMinimumBillValue": "6434",
        "discountAbsValue": "10",
        "skuConditionType": "1",
        "redeemableOnline": "1",
        "url": "https://www.google.com",
        "redeemCap": "100000000",
        "maxRedeem": "100000000",
        "merchantRedeemCap": "100000000",
        "perCartRedeem": "1",
        "isLimitedRedeem": "true",
        "redeemDays": "1|2|3|4|5|6|7",
        "redeemHours": "0|24",
        "redeemMinTime": "0",
        "redeemMaxTime": "24",
        "redeemGender": "OTHER",
        "redeemMinAge": "0",
        "redeemMaxAge": "150",
        "couponCode": "$GENERATE_PER_CUSTOMER",
        "isUniversalCode": "0",
        "redeemLocation": "1",
        "locations": "none",
        "status": "APPROVE",
        "reductionType": "1",
        "redeem-age-interval": "100",
        "subscribe": "true"
    }
    """
    * set couponBody.title = <skuConditionName>
    * set couponBody.skuConditionName = <skuConditionName>
    * set couponBody.skuCondition = <skuCondition>
    * set couponBody.discountAbsValue = <discountAbsValue>
    * def couponImage =
    """
        {
        "read": "classpath:/executables/helperFiles/images/L.jpg",
        "filename": "L.jpg",
        "contentType": "image/jpg"
        }
    """

    Given path "/v1/cms/merchant/" + 581 + "/coupon"
    And multipart file image = couponImage
    And multipart fields myMessage = couponBody
    And headers headerJson
    When method post
    Then status 200

    Examples:
      |skuCondition|skuConditionName                |discountAbsValue|
      |"101010982"|	"KIRUBAI MACRONI MURUKKU 150g"  |	"10"|
#      |"101010970"|	"SHASTI 150gJANGIRY MURUKKU"    |	"10"|
#      |"101010978"|	"SHARP FOODS MASOOR DAL 30 kg"  |	"10"|
#      |"100919572"|	"Mung Dal Boost-12-03"          |	"10"|
#      |"100919571"|	"RS 10 Gift Voucher -15-12-2020"|	"10"|
#      |"101010444"|	"RR's JAGGERY VALUE 100"        |	"10"|
#      |"101010501"|	"SAMS Soya Sauce 700 g"         |	"10"|
#      |"100919774"|	"XS SANTRA1L TP 28 08 taak 08Oct2020"|	"10"|
#      |"100919566"|	"Indrayani Rice -31-03"|	"10"|
#      |"101010973"|	"SHARP FOODS MASOOR MALKA PREMIUM 30 kg"|	"10"|
#      |"101011028"|	"A PLUS LOBIYA RED 1kg"|	"10"|
#      |"101011027"|	"FARMLEY PREM MAKHANA POUCH 250g"|	"10"|
#      |"101010979"|	"HAPPILO PRM CLF ALMONDS RS 35 g"|	"10"|


  @ignore1
  Scenario Outline: create b2c coupon with exception dates.
    * def couponBody =
    """
    {
        "userGroup": "42",
        "title": "flat discount  1",
        "couponLabel": "TESTCoupon",
        "couponTag": "3",
        "couponType": "2",
        "validFrom": "2019/11/29 00:00:00",
        "validTo": "2029/05/31 23:59:00",
        "brand": "99374",
        "merchantGroup": "29",
        "pushType": "0",
        "priv": "0",
        "discountExtraRules": "NA",
        "brandFunding": "100",
        "merchantFunding": "0",
        "relianceFunding": "0",
        "description": "buy tea get coffee free",
        "terms": "buy tea get coffee free",
        "clients[]": "5",
        "clients[]": "3",
        "categories": "80101",
        "demoCoupon": "0",
        "discountCoupon": "1",
        "discountType": "FLAT_DISCOUNT_WITH_SKU",
        "skuCondition": "10100982",
        "skuConditionName": "Tata Tea",
        "skuConditionQuantity": "2",
        "skuConditionActualPrice": "123",
        "skuConditionSellingPrice": "122",
        "skuConditionMinimumBillValue": "6434",
        "discountAbsValue": "10",
        "skuConditionType": "1",
        "redeemableOnline": "1",
        "url": "https://www.google.com",
        "redeemCap": "100000000",
        "maxRedeem": "100000000",
        "merchantRedeemCap": "100000000",
        "perCartRedeem": "1",
        "isLimitedRedeem": "true",

        "redeemDays": "1|2|3|4|5|6|7",
        "redeemHours": "0|24",
        "redeemMinTime": "0",
        "redeemMaxTime": "24",
        "redeemExemptDate[]": 2021/10/25,
        "exemptDates": 20211025,

        "redeemGender": "OTHER",
        "redeemMinAge": "0",
        "redeemMaxAge": "150",
        "couponCode": "$GENERATE_PER_CUSTOMER",
        "isUniversalCode": "0",
        "redeemLocation": "1",
        "locations": "none",
        "status": "APPROVE",
        "reductionType": "1",
        "redeem-age-interval": "100",
        "subscribe": "true"
    }
    """
    * set couponBody.title = <skuConditionName>
    * set couponBody.skuConditionName = <skuConditionName>
    * set couponBody.skuCondition = <skuCondition>
    * set couponBody.discountAbsValue = <discountAbsValue>
    * set couponBody.exemptDates = <excemptionDates>
    * set couponBody.redeemExemptDate[] = <excemptionDates>

    * def couponImage =
    """
        {
        "read": "classpath:/executables/helperFiles/images/L.jpg",
        "filename": "L.jpg",
        "contentType": "image/jpg"
        }
    """

    Given path "/v1/cms/merchant/" + 581 + "/coupon"
    And multipart file image = couponImage
    And multipart fields myMessage = couponBody
    And headers headerJson
    When method post
    Then status 200
    #create campaign
    #clean cache
    #search in get coupon API

    Examples:
      |skuCondition|skuConditionName                |discountAbsValue|excemptionDates|
      |"101010982"|	"KIRUBAI MACRONI MURUKKU 150g"  |	"10"|today('yyyy/MM/dd')|

#  @couponCreationtwo @ignoreClientAPI
#  Scenario Outline: create discount type brand coupon 2
#    Given set <couponBody>["title"] = "automation_coupon_" + couponId
#
#    Given path "/v1/cms/merchant/" + <merchantGroup> + "/coupon"
#    And multipart file image = <couponImage>
#    And multipart fields myMessage = <couponBody>
#    And headers headerJson
#    When method post
#    Then status 200
#    * def coupon = $response
#    * def schema =
#    """
#      {
#      "id": "#number",
#      "title": "<title>",
#      "description": "<description>",
#      "details": "##string",
#      "merchant": "##number",
#      "status": "<status>",
#      "validTo": "<validTo>",
#      "validFrom": "<validFrom>",
#      "terms": "<terms>",
#      "imageId": null,
#      "url": "<url>",
#      "affiliateUrl": "<A_url>",
#      "note": null,
#      "redeemDayHour": "#number",
#      "redeemGender": "<gender>",
#      "redeemMinAge": "#number",
#      "redeemMaxAge": "#number",
#      "redeemLocation": 1,
#      "redeemExemptDates": null,
#      "downloadCap": null,
#      "redeemCap": <redeemCap>,
#      "privateCoupon": false,
#      "couponCode": "$GENERATE_PER_CUSTOMER",
#      "reductionType": "<reductionType>",
#      "amountThreshold": 0,
#      "reduction": null,
#      "reductionMax": null,
#      "discountAbsValue": "##number",
#      "discountPercentageValue": "##number",
#      "discountMinBill": "##number",
#      "discountMaxBill": "##number",
#      "discountType": "<discountType>",
#      "discountExtraRules": "#string",
#      "sticker": 0,
#      "bannerName": "##string",
#      "bannerImageId": null,
#      "couponType": <couponType>,
#      "merchantGroup": <merchantGroup>,
#      "brand": <brand>,
#      "brandName": "<brandName>",
#      "merchantName": "##string",
#      "createTs": "#number",
#      "masId": "##number"
#      }
#    """
#    Then match coupon == schema
#
#    Examples:
#      |couponBody|couponImage |title|description|status|validFrom|validTo|terms|url|A_url|gender|redeemCap|reductionType|discountType|brand|brandName|merchantGroup|couponType|
#      |apiComponents['data_add_coupon_pull_brand_type_Free_SKUs_on_Bill'] |apiComponents['file_add_coupon_pull_brand_type_Free_SKUs_on_Bill'] |rin_on_100_rs_purchase|Test Coupons Online and physical both|APPROVE|2019-11-29|2022-05-31|Test Coupons Online and physical both|https://www.google.com|https://www.google.com|MALE|10000000 |1|FREE_SKU_WITH_BILL|99374|Mtr|581|2 |
#
#  @logout
#  Scenario: cms logout
#    * def logout = callonce read('support.feature@logout') {requestHeader: #(headerJson)}
#
#  @couponCreationthree @ignoreClientAPI
#  Scenario Outline: create discount type brand coupon 3
#    Given set <couponBody>["title"] = "automation_coupon_" + couponId
#
#    Given path "/v1/cms/merchant/" + <merchantGroup> + "/coupon"
#    And multipart file image = <couponImage>
#    And multipart fields myMessage = <couponBody>
#    And headers headerJson
#    When method post
#    Then status 200
#    * def coupon = $response
#    * def schema =
#    """
#      {
#      "id": "#number",
#      "title": "<title>",
#      "description": "<description>",
#      "details": "##string",
#      "merchant": "##number",
#      "status": "<status>",
#      "validTo": "<validTo>",
#      "validFrom": "<validFrom>",
#      "terms": "<terms>",
#      "imageId": null,
#      "url": "<url>",
#      "affiliateUrl": "<A_url>",
#      "note": null,
#      "redeemDayHour": "#number",
#      "redeemGender": "<gender>",
#      "redeemMinAge": "#number",
#      "redeemMaxAge": "#number",
#      "redeemLocation": 1,
#      "redeemExemptDates": null,
#      "downloadCap": null,
#      "redeemCap": <redeemCap>,
#      "privateCoupon": false,
#      "couponCode": "$GENERATE_PER_CUSTOMER",
#      "reductionType": "<reductionType>",
#      "amountThreshold": 0,
#      "reduction": null,
#      "reductionMax": null,
#      "discountAbsValue": "##number",
#      "discountPercentageValue": "##number",
#      "discountMinBill": "##number",
#      "discountMaxBill": "##number",
#      "discountType": "<discountType>",
#      "discountExtraRules": "#string",
#      "sticker": 0,
#      "bannerName": "##string",
#      "bannerImageId": null,
#      "couponType": <couponType>,
#      "merchantGroup": <merchantGroup>,
#      "brand": <brand>,
#      "brandName": "<brandName>",
#      "merchantName": "##string",
#      "createTs": "#number",
#      "masId": "##number"
#      }
#    """
#    Then match coupon == schema
#
#    Examples:
#      |couponBody|couponImage |title|description|status|validFrom|validTo|terms|url|A_url|gender|redeemCap|reductionType|discountType|brand|brandName|merchantGroup|couponType|
#      |apiComponents['data_add_coupon_pull_brand_type_Free_SKUs_on_SKUs'] |apiComponents['file_add_coupon_pull_brand_type_Free_SKUs_on_SKUs'] |1 Aeriel bar free with 1 kg Aeriel|Test Coupons Online and physical both|APPROVE|2019-11-29|2029-12-12|Test Coupons Online and physical both|https://www.google.com|https://www.google.com|MALE|11111111 |1|FREE_SKU_WITH_SKU|105279|jff|581|2 |
#
#
#  @logout
#  Scenario: cms logout
#    * def logout = callonce read('support.feature@logout') {requestHeader: #(headerJson)}
#
#
#  Scenario Outline: create and edit discount type brand coupon and verify for vendor funding details.
#    Given set <couponBody>["title"] = "automation_coupon_<title>" + couponId
#    Given path "/v1/cms/merchant/" + <merchantGroup> + "/coupon"
#    And multipart file image = <couponImage>
#    And multipart fields myMessage = <couponBody>
#    And headers headerJson
#    When method post
#    Then status 200
#    * def coupon = response["id"]
#    * def VENDOR_FUNDING_DETAIL = db.readRows("SELECT * FROM VENDOR_FUNDING_DETAIL WHERE COUPONID = \'" +coupon+ "\' ")
#    * print VENDOR_FUNDING_DETAIL
#    * def schema =
#      """
#        {
#          "ID": "#number",
#          "COUPONID": "#number",
#          "MERCHANT_CONTRIBUTION": "#number",
#          "RELIANCE_CONTRIBUTION": "#number",
#          "BRAND_CONTRIBUTION": "#number",
#          "UPDATED_TS": '#? isValidDate(_)',
#        }
#      """
##    And match each VENDOR_FUNDING_DETAIL == schema
#    Given path "/v1/cms/merchant/" + <merchantGroup> + "/coupon/" + coupon
#    And multipart file image = <couponImage>
#    And multipart fields myMessage = <couponEditBody>
#    And headers headerJson
#    When method put
#    Then status 200
#    * def VENDOR_FUNDING_HISTORY = db.readRows("SELECT * FROM VENDOR_FUNDING_HISTORY WHERE COUPONID = \'" +coupon+ "\' ")
#    * print VENDOR_FUNDING_HISTORY
#    * def schema =
#      """
#        {
#          "ID": "#number",
#          "COUPONID": "#number",
#          "MERCHANT_CONTRIBUTION": "#number",
#          "RELIANCE_CONTRIBUTION": "#number",
#          "BRAND_CONTRIBUTION": "#number",
#          "VALID_FROM": '#? isValidDate(_)',
#          "VALID_TO": '#? isValidDate(_)'
#        }
#      """
##    And match each VENDOR_FUNDING_HISTORY == schema
#
#    Examples:
#      |couponBody                                                                            |discountType              |couponEditBody                                                                          |couponImage                                                                            |title                 |merchantGroup|
#      |apiComponents['data_add_coupon_pull_brand_type_Percentage_discount_on_SKU']|Percentage_discount_on_SKU|apiComponents['data_edit_coupon_pull_brand_type_Percentage_discount_on_SKU'] |apiComponents['file_add_coupon_pull_brand_type_Percentage_discount_on_SKU'] |10% discount on tide  |581          |
#      |apiComponents['data_add_coupon_pull_brand_type_flat_discount_on_SKU']      |flat_discount_on_SKU      |apiComponents['data_edit_coupon_pull_brand_type_flat_discount_on_SKU']       |apiComponents['file_add_coupon_pull_brand_type_flat_discount_on_SKU']       |10rs discount on tide |581          |
#      |apiComponents['data_add_coupon_pull_brand_type_Free_SKUs_on_SKUs']         |SKUs_on_SKUs              |apiComponents['data_edit_coupon_pull_brand_type_Free_SKUs_on_SKUs']          |apiComponents['file_add_coupon_pull_brand_type_Free_SKUs_on_SKUs']          |1 rin on 1kg ariel    |581          |
#
#  @logout
#  Scenario: cms logout
#    * def logout = callonce read('support.feature@logout') {requestHeader: #(headerJson)}

