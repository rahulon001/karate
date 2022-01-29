Feature:B2C Coupon Details

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * def apiComponents = envConfig
    * def requestHeader = apiComponents['data_header']
    * headers requestHeader

    Scenario: GetHotZones
      Given path '/coupons/v1/coupons/999999999/details'
      When method GET
      Then status 200
      And match response.result[0].id == 1


    Scenario Outline: Coupons Nearby
      Given path '/coupons/v1/coupons/nearby'
      And param version = <version>
      And param lat = <lat>
      And param lng = <lng>
      When method GET
      Then status 200
      And match response.result[0].group_name == <groupname>

      Examples:
      |lat     |lng       |version |groupname|
      |12.97159|77.6056679|'v5'    |'general'|


    Scenario Outline: Coupon Detail By CouponId
      Given url baseUrl+'/coupons/v1/coupons/'
      And header x-client-type = 'microsite'
      And header x-loginid = '7977558623'
      And params {version:"v5", categoryId:"1", start:"0", end:"1000", reductionType:"2", lat:"19.6712179806", lng:"73.2293543592"}
      When method get
      Then status 200
      * def couponId = response.result[0].id

      * print "----------SCENARIO DESCRIPTION-----------", <scenario>
      Given url baseUrl+ <path>
      When method GET
      Then status <status>
   #   And match response.<validation>
      * match  <validations>
  #    And match response.result[0].description == <description>

     Examples:
    |path                                          |scenario           | status |validations                                           |
    | '/coupons/v1/coupons/'+couponId+'/details'   |'Valid coupon id'  | 200    |response.result[0] contains {"id": #number }          |
    | '/coupons/v1/coupons/$/details'               |'junk value'       |400     | response.message contains 'Invalid coupons id'        |
   | '/coupons/v1/coupons/&@/details'              | 'junk value'      |400     | response.message contains 'Invalid coupons id'        |
   | '/coupons/v1/coupons/234@123/details'          | 'junk value'      |400     | response.message contains 'Invalid coupons id'        |

  Scenario: B2C Get Coupons Terms By CouponId
      Given url baseUrl+'/coupons/v1/coupons/'
      And header x-client-type = 'microsite'
      And header x-loginid = '7977558623'
      And params {version:"v5", categoryId:"1", start:"0", end:"1000", reductionType:"2", lat:"19.6712179806", lng:"73.2293543592"}
      When method get
      Then status 200
      * def couponId = response.result[0].id
      * def terms = response.result[0].terms

      Given url baseUrl+ '/coupons/v1/coupons/'+couponId+'/terms'
      When method GET
      Then status 200
      And match response.terms == terms

  #   Examples:
  #     |couponId |couponTerms                                                                                                          |
  #     | 258259  |'Buy 3 quantities of Tropicana 500ml and  2 quantities of Hide&Seek get 10% off on Hide&Seek. Maximum discount 100/-'|

  Scenario: Coupon Action
      * def actionId = apiComponents['data_user_action']['action']['actionId']
      * def couponId = apiComponents['data_user_action']['action']['couponId']
      * def category = apiComponents['data_user_action']['action']['category']
      * def context = apiComponents['data_user_action']['action']['context']
      * def time = apiComponents['data_user_action']['action']['time']
      * def lat = apiComponents['data_user_action']['action']['lat']
      * def long = apiComponents['data_user_action']['action']['long']
      * def requestBody =
      """
      {
      "action": {
        "actionId": #(actionId),
        "couponId": #(couponId),
        "category": #(category),
        "context": #(context),
        "time": #(time),
        "lat": #(lat),
        "long": #(long)
      }
      }
      """
      Given path '/coupons/v1/coupons/'+couponId+'/user-action'
      And request requestBody
      When method POST
      Then status 200
      And match response.message == 'ok'
      And match response.code == 200



