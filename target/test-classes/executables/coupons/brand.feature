@ignore
Feature: create brand coupons

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * def login = callonce read('support.feature@login')
    * def headerJson = {}
    * set headerJson.Cookie = $login.responseHeaders['Set-Cookie'][0]
    * set headerJson.X-Anti-Forgery = $login.responseHeaders['x-anti-forgery'][0]
    * set headerJson.Content-Type = 'multipart/form-data'

  Scenario: create brand
    Given path '/v1/cms/brands/'
    * def random_string =
         """
         function(s) {
           var text = "";
           var possible = "123456789";
           for (var i = 0; i < s; i++)
             text += possible.charAt(Math.floor(Math.random() * possible.length));
           return text;
         }
         """
    * def ExternalId = random_string(9)

    And multipart file myFile = { read: '../helperFiles/images/M.jpg', filename: 'M.jpg', contentType: 'image/jpg'}
    And multipart fields myMessage = {'name': 'jff', 'desc': 'Test_DESC', 'externalId': ExternalId, "userGroup": "42"}
    And headers headerJson
    When method post
    Then status 200

  @logout
  Scenario: cms logout
    * def logout = callonce read('support.feature@logout') {requestHeader: #(headerJson)}