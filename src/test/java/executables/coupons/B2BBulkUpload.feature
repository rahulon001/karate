#@ignore
Feature: B2B Bulk Upload.

  Background:
    * url baseUrl
    * def login = callonce read('loginToCMS.feature')
    * def xAntiForgery = $login.responseHeaders['x-anti-forgery'][0]
    * header Cookie = $login.responseHeaders['Set-Cookie'][0]
    * header Content-Type = 'multipart/form-data'
    * def helperMethods = Java.type('executables.utils.HelperMethods')
    * def result = callonce read('support.feature@B2B_bulk_upload_log')
    * def getId =
    """
    function(arg){
    return arg[arg.length-1].id
    }
    """

  Scenario: B2B Bulk Upload
    Given path '/coupons/v1/coupons/b2b/bulk-upload'
    * def updateB2BBulkUploadCSV = helperMethods.B2B_BulkUpload()
    * def temp = karate.readAsString('../helperFiles/files/flatDiscountTemplate1.csv')
    And multipart file B2BFile = { value: '#(temp)', filename: 'flatDiscountTemplate1.csv', contentType: 'text/csv' }
    And header x-anti-forgery = xAntiForgery
    When method post
    Then status 201


  Scenario: B2B Bulk Upload Log Dashboard
    Given path '/coupons/v1/coupons/b2b/bulk-upload-log'
    And header x-anti-forgery = xAntiForgery
    When method get
    Then status 200


  Scenario: B2B Download Input File
    * def Id = call getId result.response
    Given path '/coupons/v1/coupons/b2b/download-inputFile/'+Id
    And header x-anti-forgery = xAntiForgery
    When method get
    Then status 200


  Scenario: B2B Download Output File
    * def Id = call getId result.response
    Given path '/coupons/v1/coupons/b2b/download-outputFile/'+Id
    And header x-anti-forgery = xAntiForgery
    When method get
    Then status 200


  Scenario: cms logout
    Given path '/v1/cms/logout'
    And header x-anti-forgery = xAntiForgery
    When method get
    Then status 204
