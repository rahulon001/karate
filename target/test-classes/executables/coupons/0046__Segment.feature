Feature: create Segment

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * def login = callonce read('support.feature@login')
    * def headerJson = {}
    * set headerJson.Cookie = $login.responseHeaders['Set-Cookie'][0]
    * set headerJson.X-Anti-Forgery = $login.responseHeaders['x-anti-forgery'][0]
    * set headerJson.Content-Type = 'application/json'
    * def apiComponents = envConfig
    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])
    * def unique_segment = function(){ return java.lang.System.currentTimeMillis() }

  Scenario Outline: create new Segment
   * def segment_name = "Segment_"+ unique_segment()
     * def body =
   """
         {
       "name": #(segment_name),
       "customSegmentId": <rtrs_id>
     }
   """
   Given url baseUrl+ '/v1/cms/custom-user-segment/'
   And  request body
   And headers headerJson
   When method post
   Then status 200

    Examples:
    |rtrs_id|
    |"12"     |
    |"abcd"   |


  Scenario Outline:  list segments
    Given url baseUrl+ '/v1/cms/user-segment/'
    And headers headerJson
    And params {page: 1, page-size: 10, order: "id"}
    When method get
    Then status 200
    And match each response.data[*] ==
    """
        {
        "name": "#string",
        "id": "#number",
        "rtrs_id": "#string"
        }
  """
    * match response contains {"total": #number }
    * match <validations_1>
    * match <validations_2>

    Examples:
    | validations_1                       | validations_2                       |
    |response.data[0].rtrs_id == "abcd"   | response.data[1].rtrs_id == "12"    |

  Scenario Outline: search with single & multiple rtrs segment id
    * def query_params = "12,ab"
    Given url baseUrl+ '/v1/cms/user-segment/'
    And headers headerJson
    And params {page: 1, page-size: 10, order: "id", query: <query_param>}
    When method get
    Then status 200
    * match  <validations>

    Examples:
    |query_param    | validations                                                                |
    |"12"           | each response.data[*].rtrs_id contains "#regex (?i).*" + 12 + ".*"        |
    |query_params   | each response.data[*].rtrs_id contains "#regex (?i).*" + 12 + ".*"        |
    |query_params   | each response.data[*].rtrs_id contains "#regex (?i).*" + 'ab' + ".*"      |

  Scenario: search with multiple duplicate rtrs segment id
    Given url baseUrl+ '/v1/cms/user-segment/'
    And headers headerJson
    And params {page: 1, page-size: 10, order: "id", query: "12"}
    When method get
    Then status 200
    And match each response.data[*].rtrs_id contains "#regex (?i).*" + 12 + ".*"
  * def total_segments = response.total

    * def query_param = "12,12"
    Given url baseUrl+ '/v1/cms/user-segment/'
    And headers headerJson
    And params {page: 1, page-size: 10, order: "id", query: #(query_param)}
    When method get
    Then status 200
    And match each response.data[*].rtrs_id contains "#regex (?i).*" + 12 + ".*"
    * match response.total == total_segments

#  @ignore
 # Scenario: cms logout
 #   * def logout = callonce read('support.feature@logout') {requestHeader: #(headerJson)}

