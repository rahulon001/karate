Feature: Search coupon API

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * header Content-Type = 'application/json'

  Scenario Outline: Search coupons via server side API
    Given url  baseUrl+'/coupons/v1/coupons/'
    And header x-client-type = <client>
    And header x-loginid = '7977558623'
    And params {"categoryId":"1","reductionType":"2","query":<search_for>,"lat":"19.1275105","lng":"73.0076079","source":"all","version":<Version>,"format":"group","start":"0","end":"10"}
    When method get
    Then status 200

    Examples:
    |search_for|client   |  Version|
    |"off"       | "microsite" | "v5"    |