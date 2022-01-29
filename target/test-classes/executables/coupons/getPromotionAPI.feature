@ignore
Feature: Get promotions

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * header Content-Type = 'application/json'

#  Scenario Outline: Verify Get all the offline coupons Response Status
#    Given path <Path>
#    And header x-client-type = 'mpos'
#    When method GET
#    Then match responseStatus == <Status>
#
#    Examples:
#      |Path                                               |Status|
#      |'/coupons/v1/coupons/merchant/'                    |404   |
#      |'/coupons/v1/coupons/100001000217521'              |404   |
#      |'/coupons/v1/coupons/test'                                         |404   |
#      |'/coupons/v1/coupons/merchant/100001000217521?active=true'         |200   |
#      |'/coupons/v1/coupons/merchant/100001000217521?active=true'         |200   |

  Scenario Outline: Get promotions as per clusters.
    Given path 'v1/cms/promotions'
    And header x-client-type = <client>
    And header x-loginid = '7977558623'
    And params {clusterId:<clusterId>}
    When method get
    Then status 200
    And def response = karate.lowerCase(response)
    Then match header Content-Type == 'application/json'
    * def schema =
       """

       """
    And match each $response.result[*] == schema

    Examples:
    |client        |version|
    |"myjio"       |"v5"   |
    |'microsite'   |'v5'   |
    |'RJIL_JioKart'|'v5'   |

  Scenario Outline: Get all promotions.
    Given path 'v1/cms/promotions'
    And header x-client-type = <client>
    And header x-loginid = '7977558623'
    When method get
    Then status 200
    And def response = karate.lowerCase(response)
    Then match header Content-Type == 'application/json'
    * def schema =
       """

       """
    And match each $response.result[*] == schema

    Examples:
      |clusterId        |version|
      |"myjio"          |"v5"   |
      |'microsite'      |'v5'   |
      |'RJIL_JioKart'   |'v5'   |

#  Scenario Outline: Get coupon client side API response status
#    Given path <Path>
#    And header x-client-type = <client_type>
#    And header x-loginid = '7977558623'
#    And params {version:<version>, categoryId:"1", start:"0", end:"1000", reductionType:"2"}
#    When method get
#    Then match responseStatus == <Status>
#
#    # As discussed with dev team
#    Examples:
#      |Path                                               |client_type    |version  |Status|
#            #This should work as all versions are available foe all clients as per dev team.
#      |'/coupons/v1/coupons/'                             |'jiomoney'     |"v5"     |200   |
#      |'/coupons/v1/coupons/merchant/'                    |'myjio'        |"v4"     |404   |
#      |'/coupons/v1/coupons/123'                          |'jiomoney'     |"v4"     |404   |
#      |'/coupons/v1/coupons/$$$'                          |'myjio'        |"v5"     |404   |
#            #by default client type is 'jiomoney'
#      |'/coupons/v1/coupons/'                             |'t12&&'        |"v4"     |200   |
#            #by default version is 'v3'
#      |'/coupons/v1/coupons/'                             |'RJIL_JioKart' |"v1"     |200   |
