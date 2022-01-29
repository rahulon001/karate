Feature: Store location
  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * def apiComponents = envConfig
    * headers requestHeader = apiComponents['data_header']
    * def label = apiComponents['data_userLocation']['label']
    * def latitude = apiComponents['data_userLocation']['latitude']
    * def longitude = apiComponents['data_userLocation']['longitude']
    * def address = apiComponents['data_userLocation']['address']
    * def locality = apiComponents['data_userLocation']['locality']
    * def city = apiComponents['data_userLocation']['city']
    * def state = apiComponents['data_userLocation']['state']
    * def pincode = apiComponents['data_userLocation']['pincode']
    * def title = apiComponents['data_userLocation']['title']

  Scenario Outline: User Location
    * def requestbody =
    """
     {
     "label":#(label),
     "latitude":#(latitude),
     "longitude":#(longitude),
     "address":"#(address)",
     "locality":"#(locality)",
     "city":"#(city)",
     "state":"#(state)",
     "pincode":"#(pincode)",
     "title":"#(title)"
     }
    """
    Given path '/coupons/v1/coupons/user-location'
    And request requestbody
    When method POST
    Then status 200
    And match response.message == '<message>'
    And match response.code == <code>

    Examples:
    |message|code|
    |  ok   |200 |

