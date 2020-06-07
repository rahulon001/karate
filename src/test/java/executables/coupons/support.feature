#@ignore
Feature: B2B Bulk Upload Support

  Background:
    * url baseUrl
    * def login = callonce read('loginToCMS.feature')
    * def xAntiForgery = $login.responseHeaders['x-anti-forgery'][0]
    * header Cookie = $login.responseHeaders['Set-Cookie'][0]
    * header Content-Type = 'multipart/form-data'

  @B2B_bulk_upload_log
  Scenario: B2B Bulk Upload Log Dashboard
    Given path '/coupons/v1/coupons/b2b/bulk-upload-log'
    And header x-anti-forgery = xAntiForgery
    When method get
    Then status 200

  Scenario: cms logout
    Given path '/v1/cms/logout'
    And header x-anti-forgery = xAntiForgery
    When method get
    Then status 204
