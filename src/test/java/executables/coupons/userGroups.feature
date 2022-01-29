Feature: UserGroup Test

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * def login = callonce read('support.feature@login')
    * def headerJson = {}
    * set headerJson.Cookie = $login.responseHeaders['Set-Cookie'][0]
    * set headerJson.X-Anti-Forgery = $login.responseHeaders['x-anti-forgery'][0]
    * set headerJson.Content-Type = 'application/json'
    * def POSTuserGroup = callonce read('support.feature@create_userGroup') {requestHeader: #(headerJson)}
    * def GroupId = POSTuserGroup.response

  @get_userGroup
  Scenario Outline: Get userGroup
    Given path '/v1/cms/userGroup/'+GroupId
    And headers headerJson
    When method GET
    Then status 200
    And match response.name == <userGroupName>
    And match response.description == <userGroupDescription>

    Examples:
    | userGroupName |userGroupDescription|
    |'testgroup1234'|   'testgroup1234'  |


  @update_userGroup
  Scenario Outline: Update userGroup
    Given path '/v1/cms/userGroup/'+GroupId
    And headers headerJson
    And request {"name":<userGroupName>, "description":<userGroupDescription>, "clientType":<userGroupClient>}
    When method PUT
    Then status 200
    And match response == '1'

    Examples:
    |userGroupName       |userGroupDescription|userGroupClient|
    |updatedtestgroup1234|updatedtestgroup1234|      [7]      |


  @delete_userGroup
  Scenario: Delete userGroup
    Given path '/v1/cms/userGroup/'+GroupId
    And headers headerJson
    When method DELETE
    Then status 200
    And match response == '1'


  @get_userGroups
  Scenario Outline: Get userGroups
    Given url baseUrl+'/v1/cms/userGroups/'
    And headers headerJson
    When method GET
    Then status 200
    And match response.data[0].id == <groupId>
    And match response.data[0].name == <userGroupName>

    Examples:
    |userGroupName       |groupId|
    |'The Founders Group'|   1   |

  @logout @ignore
  Scenario: cms logout
    * def logout = callonce read('support.feature@logout') {requestHeader: #(headerJson)}

