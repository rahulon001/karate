@redis_off
Feature: Get coupons

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * def apiComponents = envConfig
    * def masid = apiComponents['MAS_masId']
    * def headerJson = {}
    * set headerJson.x-loginid = '9945240311'
    * def Collections = Java.type('java.util.Collections')
    * def call_configuration_table = callonce read('support.feature@switch_off_redis')

  Scenario Outline: Verify Get all the offline coupons Response Status without cache clearing
    * set headerJson.x-client-type = <client>
    Given url  baseUrl+'/coupons/v1/coupons/'
    And params <parameters>
    When headers headerJson
    When method GET
    Then match responseStatus == <Status>
    Then print "<====responseTime====>", responseTime
#    And assert responseTime < 5000

    Examples:
      |parameters                                                                                                                           |client     |Status|
      |{ version: v5, start: 0, externalMerchantId: #(masid) , categoryId: 1, end: 10, lat: 19.6712179806, lng: 73.2293543592}              |'microsite'|200   |
      |{ version: v5, start: 0, externalMerchantId: #(masid), categoryId: 1, end: 10, lat: 19.6712179806, lng: 73.2293543592}               |'mpos'     |200   |
      |{ version: v5, start: 0, categoryId: 1, end: 10, lat: 19.6712179806, lng: 73.2293543592}                                             |'microsite'|200   |

  Scenario Outline: Verify Get all the offline coupons Response Status with cache clearing
    * call read('support.feature@invalidate_cms_cache')
    * set headerJson.x-client-type = <client>
    Given url  baseUrl+'/coupons/v1/coupons/'
    And params <parameters>
    When headers headerJson
    When method GET
    Then match responseStatus == <Status>
    Then print "<====responseTime====>", responseTime
#    And assert responseTime < 8000

    Examples:
      |parameters                                                                                                                           |client     |Status|
      |{ version: v5, start: 0, externalMerchantId: #(masid) , categoryId: 1, end: 10, lat: 19.6712179806, lng: 73.2293543592}              |'microsite'|200   |
      |{ version: v5, start: 0, externalMerchantId: #(masid), categoryId: 1, end: 10, lat: 19.6712179806, lng: 73.2293543592}               |'mpos'     |200   |
      |{ version: v5, start: 0, categoryId: 1, end: 30, lat: 23.3440997, lng: 85.309562}                                                    |'microsite'|200   |

  Scenario Outline: Get coupons server side API
    Given url baseUrl+'/coupons/v1/coupons/'
    And header x-client-type = <client>
    And header x-loginid = '7977558623'
    And params {version:<version>, categoryId:"1", start:"0", end:"1000", reductionType:"2"}
    When method get
    Then status 200
    And def response = karate.lowerCase(response)
    Then match header Content-Type == 'application/json'
    * def schema =
       """
       {
          "discountcoupon":"##number",
          "description": "#string",
          "source": "#string",
          "id": "#number",
          "code": "#string",
          "likecount": "#number",
          "usergroup": "#number",
          "status": "#number",
          "likeddate": "#number",
          "enddate": "#number",
          "couponbuckets": "##null",
          "locations": "##null",
          "categories": "#[]",
          "title": "#string",
          "coupontype": "#number",
          "merchantgroup": "#number",
          "merchant": "#number",
          "merchantname": "#string",
          "terms": "#string",
          "startdate": "#number",
          "cdnbrandimageid": "#string",
          "cdnimageurl": "#string",
          "brand": "##number",
          "reductiontype": "#string",
          "imageurl": "#string",
          "merchantphone": "##null",
          "merchanturl": "##null",
          "couponurl": "##string",
          "affiliateurl": "##string",
          "discountabsvalue": "#number",
          "discountminbill": "#number",
          "discountmax": "##number",
          "discounttype": "#string",
          "discountextrarules": "#string",
          "coupontag": "#string",
          "bannername": "##null",
          "bannerimageid": "##null",
          "merchantimageid": "#string",
          "details": "##null",
          "createts": "#number",
          "cdnsponsorimageurl": "#string",
          "note": "##null",
          "sticker": "##null",
          "redeemdayhour": "#number",
          "redeemgender": "#number",
          "redeemminage": "#number",
          "redeemmaxage": "#number",
          "redeemlocation": "#number",
          "redeemexempdates": "##null",
          "downloadcap": "#number",
          "redeemcap": "#number",
          "userredeempercart": "##number",
          "pushtype": "#number",
          "vendorcid": "##null",
          "skuconditions": "#[]",
          "skuoffer": "#[]",
          "merchantgroupname": "##string",
          "maxredeem": "#number",
          "discountpercentagevalue": "#number",
          "tags": "#[]",
          "exemptdates": "##null",
          "couponlabel": "##string",
          "brandimageid": "#string",
          "brandname": "##string",
          "merchantredeemcap": "#number",
          "cdnmerchantimageurl": "#string"
          }
       """
#    And match each $response.result[*] == schema

    Examples:
    |client        |version|
    |"myjio"       |"v5"   |
    |'jiomoney'    |'v4'   |
    |'microsite'   |'v4'   |
    |'RJIL_JioKart'|'v5'   |

  Scenario Outline: Get coupon client side API response status
    Given url baseUrl+<Path>
    And header x-client-type = <client_type>
    And header x-loginid = '7977558623'
    And params {version:<version>, categoryId:"1", start:"0", end:"1000", reductionType:"2"}
    When method get
    Then match responseStatus == <Status>

    # As discussed with dev team
    Examples:
      |Path                                               |client_type    |version  |Status|
            #This should work as all versions are available foe all clients as per dev team.
      |'/coupons/v1/coupons/'                             |'microsite'    |"v5"     |200   |
      |'/coupons/v1/coupons/merchant/'                    |'myjio'        |"v4"     |404   |
      |'/coupons/v1/coupons/123'                          |'jiomoney'     |"v4"     |404   |
      |'/coupons/v1/coupons/$$$'                          |'myjio'        |"v5"     |404   |
            #by default client type is 'jiomoney'
      |'/coupons/v1/coupons/'                             |'t12&&'        |"v4"     |200   |
            #by default version is 'v4'
      |'/coupons/v1/coupons/'                             |'RJIL_JioKart' |"v1"     |200   |

  Scenario Outline: Get active b2c coupons.
    Given url  baseUrl+'/coupons/v1/coupons/merchant/'+<MASID>
    And params {active: <state>}
    And headers headerJson
    When method get
    Then status 200
    * def disc_types = $response.coupons[*].discountType
    * json response = new java.util.HashSet(karate.toJava(disc_types))
    * eval Collections.sort(response, java.lang.String.CASE_INSENSITIVE_ORDER)
    * print response

    * def discount_types_allowed = ['FLAT_DISCOUNT_WITH_SKU','FREE_SKU_WITH_SKU','PERCENTAGE_DISCOUNT_WITH_SKU']
    * eval Collections.sort(discount_types_allowed, java.lang.String.CASE_INSENSITIVE_ORDER)
    * print discount_types_allowed

    * match response contains only discount_types_allowed

    Examples:
      |MASID                        |state |
      |apiComponents['CMS_masid']   |true  |
      |apiComponents['CMS_masid']   |false |

  Scenario: List B2B coupons
    * def headerJson = {}
    * def login = call read('support.feature@login')
    * set headerJson.Cookie = $login.responseHeaders['Set-Cookie'][0]
    * set headerJson.X-Anti-Forgery = $login.responseHeaders['x-anti-forgery'][0]
    * set headerJson.Content-Type = 'application/json'
    Given url  baseUrl+'/coupons/v1/coupons/b2b-coupon/'
    And params {page: 1, page-size: 10}
    And headers headerJson
    When method get
    Then status 200

  Scenario Outline: GetCoupon API with invalid lat&long
    * set headerJson.x-client-type = <client>
    Given url  baseUrl+'/coupons/v1/coupons/'
    And params <parameters>
    When headers headerJson
    When method GET
    Then match responseStatus == <Status>
    And  match response.content.message == "Invalid location parameters"

    Examples:
      |parameters                                                                                                                           |client     |Status|
      |{ version: v5, start: 0, externalMerchantId: #(masid) , categoryId: 1, end: 10, lat:'-', lng: 73.2293543592}                          |'microsite'|400   |
     |{ version: v5, start: 0, externalMerchantId: #(masid), categoryId: 1, end: 10, lat: 19.6712179806, lng: &}                           |'mpos'     |400   |
     |{ version: v5, start: 0, categoryId: 1, end: 30, lat: abc, lng: 85.309562}                                                             |'microsite'|400   |
     |{ version: v5, start: 0, categoryId: 1, end: 30, lat: abc, lng: '-'}                                                                     |'microsite'|400   |

