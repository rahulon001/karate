@ignore
Feature: B2B campaign creation bulk upload.

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * def login = callonce read('support.feature@login')
    * def headerJson = {}
    * set headerJson.Cookie = $login.responseHeaders['Set-Cookie'][0]
    * set headerJson.X-Anti-Forgery = $login.responseHeaders['x-anti-forgery'][0]
    * set headerJson.Content-Type = 'multipart/form-data'
    * def helperMethods = Java.type('executables.utils.HelperMethods')

  Scenario Outline: B2B campaign upload
    #    Creation of B2B campaign.
    Given path '/coupons/v1/coupons/b2b-campaign/bulk-upload'
    * print "<============== file_description ==============>", <file_description>
    * def path = <path>
    * def updateB2BBulkUploadCSV = helperMethods.B2B_campaign_Bulk_update_edit(path)
    * def temp = karate.readAsString('../helperFiles/files/flatDiscountTemplate1.csv')
    * print "jjjjjjjjjjjjjjjjjjjjjjjjjjjjjj", temp
    And multipart file B2BFile = { value: '#(temp)', filename: 'flatDiscountTemplate1.csv', contentType: 'text/csv' }
    And headers headerJson
    When method post
    * def result = call read('support.feature@b2b_campaign_bulk_upload_log') {requestHeader: #(headerJson)}
    * def Id = result.response["data"][0]["id"]
    * print "<<<<<<<<<<<<<<<<<< log_Id >>>>>>>>>>>>>>", Id
    Then status <status>
    #    Download of B2B campaign success file
    Given path '/v1/cms/bulk/download/outputFile/'+Id
    And headers headerJson
    When method get
    Then status 200

    Examples:
      | path                                                                                           |file_description                              |status|
      |"src/test/java/executables/helperFiles/files/b2b_Campaign_BulkUpload/B2BCampaignBulkUpload.csv" |"check b2b campaign success"                  |201   |

  Scenario Outline: B2B campaign edit
    #    Creation of B2B campaign.
    Given path '/coupons/v1/coupons/b2b-campaign/bulk-upload'
    * print "<============== file_description ==============>", <file_description>
    * def path = <path>
    * def updateB2BBulkUploadCSV = helperMethods.B2B_campaign_Bulk_update_edit(path)
    * def temp = karate.readAsString('../helperFiles/files/flatDiscountTemplate1.csv')
    And multipart file B2BFile = { value: '#(temp)', filename: 'flatDiscountTemplate1.csv', contentType: 'text/csv' }
    And headers headerJson
    When method post
    * def result = call read('support.feature@b2b_campaign_bulk_upload_log') {requestHeader: #(headerJson)}
    * def Id = result.response["data"][0]["id"]
    * print "<<<<<<<<<<<<<<<<<< log_Id >>>>>>>>>>>>>>", Id
    Then status <status>
    #    Download of B2B campaign success file
    Given path '/v1/cms/bulk/download/outputFile/'+Id
    And headers headerJson
    When method get
    Then status 200

    Examples:
      | path                                                                                         |file_description                              |status|
      |"src/test/java/executables/helperFiles/files/b2b_Campaign_BulkEdit/B2BCampaignBulkUpload.csv" |"check b2b campaign success"                  |201   |

  Scenario: Get B2B campaign
    Given path "/coupons/v1/coupons/b2b-campaign"
    And headers headerJson
    And params {page:1, page-size:"10"}
    When method get
    Then status 200
