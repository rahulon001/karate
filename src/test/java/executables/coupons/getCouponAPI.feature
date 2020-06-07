@ignore
Feature: Get coupons

  Background:
    * url baseUrl
    * header Content-Type = 'application/json'

#  @ignore
  Scenario Outline: Verify Get all the offline coupons Response Status
    Given path <Path>
    When method GET
    Then match responseStatus == <Status>

    # As discussed with dev team
    Examples:
      |Path                                               |Status|
      |'/coupons/v1/coupons/merchant/1901000067818'       |200   |
      |'/coupons/v1/coupons/merchant/'                    |404   |
      |'/coupons/v1/coupons/1901000067818'                |404   |
      |'/coupons/v1/coupons/test'                         |404   |

#  @ignore
  Scenario Outline: Get coupons server side API
    Given path '/coupons/v1/coupons/'
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
          "couponurl": "#string",
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
    And match each $response.result[*] == schema

    Examples:
    |client        |version|
    |"myjio"       |"v5"   |
    |'jiomoney'    |'v4'   |
    |'microsite'   |'v4'   |
    |'RJIL_JioKart'|'v5'   |

#  @ignore
  Scenario Outline: Get coupon client side API response status
    Given path <Path>
    And header x-client-type = <client_type>
    And header x-loginid = '7977558623'
    And params {version:<version>, categoryId:"1", start:"0", end:"1000", reductionType:"2"}
    When method get
    Then match responseStatus == <Status>

    # As discussed with dev team
    Examples:
      |Path                                               |client_type    |version  |Status|
            #This should work as all versions are available foe all clients as per dev team.
      |'/coupons/v1/coupons/'                             |'jiomoney'     |"v5"     |200   |
      |'/coupons/v1/coupons/merchant/'                    |'myjio'        |"v4"     |404   |
      |'/coupons/v1/coupons/123'                          |'jiomoney'     |"v4"     |404   |
      |'/coupons/v1/coupons/$$$'                          |'myjio'        |"v5"     |404   |
            #by default client type is 'jiomoney'
      |'/coupons/v1/coupons/'                             |'t12&&'        |"v4"     |200   |
            #by default version is 'v3'
      |'/coupons/v1/coupons/'                             |'RJIL_JioKart' |"v1"     |200   |


#  @ignoreClientAPI
#  Scenario Outline: Get coupons client side API
#    * url baseUrlApp
#    * def token_response = call read('AccessToken.feature')
#    * def access_token = $token_response.response["access_token"]
#    Given path '/cr/v2/coupons'
#    And header X-CLIENT-TYPE = <client>
#    And header X-API-Key = <x_api_key>
#    And header Authorization = "Bearer " + access_token
#    And params {version:<version>, categoryId:"1", start:"0", end:"1000", reductionType:"2", "lat":"12.97159", "lng":"77.6056679"}
#    When method get
#    Then status 200
#    And def response = karate.lowerCase(response)
#    * print response["result"][0]
#    Then match header Content-Type == 'application/json'
#    Then match response["result"][0] ==
#       """
#       {
#          "discountcoupon":"##number",
#          "description": "#string",
#          "source": "#string",
#          "id": "#number",
#          "code": "#string",
#          "likecount": "#number",
#          "usergroup": "#number",
#          "status": "#number",
#          "likeddate": "#number",
#          "enddate": "#number",
#          "couponbuckets": "##null",
#          "locations": "##[]",
#          "categories": "#[]",
#          "title": "#string",
#          "coupontype": "#number",
#          "merchantgroup": "#number",
#          "merchant": "#number",
#          "merchantname": "#string",
#          "terms": "#string",
#          "startdate": "#number",
#          "cdnbrandimageid": "#string",
#          "cdnimageurl": "#string",
#          "brand": "##number",
#          "reductiontype": "#string",
#          "imageurl": "#string",
#          "merchantphone": "##null",
#          "merchanturl": "##null",
#          "couponurl": "#string",
#          "affiliateurl": "##string",
#          "discountabsvalue": "#number",
#          "discountminbill": "#number",
#          "discountmax": "##number",
#          "discounttype": "#string",
#          "discountextrarules": "#string",
#          "coupontag": "#string",
#          "bannername": "##null",
#          "bannerimageid": "##null",
#          "merchantimageid": "#string",
#          "details": "##null",
#          "createts": "#number",
#          "cdnsponsorimageurl": "#string",
#          "note": "##null",
#          "sticker": "##null",
#          "redeemdayhour": "#number",
#          "redeemgender": "#number",
#          "redeemminage": "#number",
#          "redeemmaxage": "#number",
#          "redeemlocation": "#number",
#          "redeemexempdates": "##null",
#          "downloadcap": "#number",
#          "redeemcap": "#number",
#          "pushtype": "#number",
#          "vendorcid": "##null",
#          "skuconditions": "#[]",
#          "skuoffer": "#[]",
#          "userredeempercart": "##number",
#          "merchantgroupname": "##string",
#          "maxredeem": "#number",
#          "discountpercentagevalue": "#number",
#          "tags": "#[]",
#          "exemptdates": "##null",
#          "couponlabel": "#string",
#          "brandimageid": "#string",
#          "brandname": "##string",
#          "merchantredeemcap": "#number",
#          "cdnmerchantimageurl": "#string"
#          }
#       """
#
#    Examples:
#      |client        |version|x_api_key                             |
##      |"myjio"       |"v5"   |"null"                                |
#      |'jiomoney'    |'v4'   |"l7xx3e887403b5ed40e78ca8edef65c87587"|
#      |'microsite'   |'v4'   |"l7xx3e887403b5ed40e78ca8edef65c87587"|
##      |'RJIL_JioKart'|'v5'   |"null"                                |
