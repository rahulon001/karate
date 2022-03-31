@ignore
Feature: All supporting scenarios

  Background:
    * url baseUrl
    * def apiComponents = envConfig
    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])

    @common_functions
    Scenario: common function.
#      * configure afterScenario =
#      """
#          function(){
#          var info = karate.info;
#          karate.log(info);
#          if(info.errorMessage){
#             for (var i = 0; i = 0; i++) {
#                try {
#                  karate.call(info.featureFileName);
#                  karate.log('*** RETRY SUCCESS *****')
#                  return;
#                } catch (e) {
#                  karate.log('*** RETRY FAILED ***', i, e);
#                }
#              }
#              karate.fail('test failed after retries: ' + i);
#           }
#          }
#      """

      * def isValidDate =
      """
        function(testDate){
        //        var date_regex = /^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1]) (2[0-3]|[01][0-9]):[0-5][0-9]:[0-5][0-9].[0-9]+$/;
        //        if (!(date_regex.test(testDate))) {
        if (!(testDate)){
        return true;
        }return true;
        }
      """

      * def now =
      """
        function() {
          return java.lang.System.currentTimeMillis()
        }
      """

  @promotion_bulk_upload_log
  Scenario: B2B Bulk Upload Log Dashboard promotion create
    Given path '/v1/cms/bulk-upload-log/?page=1&page-size=10&type=promotion_create'
#    And headers requestHeader
    When method get
    Then status 200

  @promotion_bulk_edit_log
  Scenario: B2B Bulk Upload Log Dashboard promotion edit
    Given path '/v1/cms/bulk-upload-log/?page=1&page-size=10&type=promotion_edit'
    And headers requestHeader
    When method get
    Then status 200


  @create_userGroup @template
  Scenario: Create userGroup
    Given url  baseUrl+'/v1/cms/userGroup/'
    And headers requestHeader
    And request {"name":"testgroup1234", "description":"testgroup1234", "clientType":[7]}
    When method POST
    Then status 200

  @access_token
  Scenario: Access tokens for client facing applications
    * url baseUrlApp
    * header Content-Type = 'application/x-www-form-urlencoded'
    Given path '/jm/auth/oauth/v2/token'
    And header Authorization = "Basic bDd4eDNlODg3NDAzYjVlZDQwZTc4Y2E4ZWRlZjY1Yzg3NTg3OmM2NDU1NjhhOTI3NzQ1YTY5NmUwZTUyZTU4NzFiZTgz"
    And form field username = '7977558623'
    And form field password = 'Test@1357'
    And form field grant_type = 'password'
    When method post
    Then status 200
#    * def access_token_response = response
#    * print access_token_response["access_token"]

  @login
  Scenario: legacy login
    * header Content-Type = 'application/x-www-form-urlencoded'
    * configure ssl = true
    Given path '/legacy/login'
    And form field username = 'super5'
    And form field password = 'foobar'
    When method post
    Then status 200

  @logout
  Scenario: cms logout
    Given path '/v1/cms/logout'
    And headers requestHeader
    * header Content-Type = 'application/json'
    When method get
    Then status 204

  @B2B_bulk_upload_log
  Scenario: B2B Bulk Upload Log Dashboard  bulk upload logs
    Given path '/coupons/v1/coupons/b2b/bulk-upload-log'
    And headers headerJson
    And header Content-Type = 'application/json'
    When method get
    Then status 200

  @b2b_coupon_bulk_upload_log
  Scenario: B2B Bulk Upload Log Dashboard
    Given url baseUrl+ '/v1/coupons/maker-checker/jobDetails/'
    And headers headerJson
    And header Content-Type = 'application/json'
    And params {page:1, page-size:"10", "job-type":"B2B_CREATE"}
    When method get
    Then status 200

  @b2b_coupon_bulk_edit_log
  Scenario: B2B Bulk Upload Log Dashboard
    Given url baseUrl+ '/v1/coupons/maker-checker/jobDetails/'
    And headers headerJson
    And header Content-Type = 'application/json'
    And params {page:1, page-size:"10", job-type:"B2B_EDIT"}
    When method get
    Then status 200

  @b2c_coupon_bulk_upload_log
  Scenario: B2B Bulk edit Log Dashboard
    Given url baseUrl+ '/v1/coupons/maker-checker/jobDetails/'
    And headers headerJson
    And header Content-Type = 'application/json'
    And params {page:1, page-size:"10", "job-type":"B2C_CREATE"}
    When method get
    Then status 200

    #update endpoints
  @b2c_ranking_bulk_upload_log
  Scenario: B2C Ranking Log Dashboard
    Given url baseUrl+ '/v1/cms/bulk-upload-log/'
    And headers headerJson
    And header Content-Type = 'application/json'
    And params {page:1, page-size:"10", "type":"ranking"}
    When method get
    Then status 200

  @merchant_group_bulk_upload
  Scenario: B2B Bulk edit Log Dashboard
    Given url baseUrl+ '/v1/coupons/maker-checker/jobDetails/'
    And headers headerJson
    And header Content-Type = 'application/json'
    And params {page:1, page-size:"10", "job-type":"MERCHANT_GROUP_UPLOAD"}
    When method get
    Then status 200

  @merchant_group_bulk_delete
  Scenario: B2B Bulk edit Log Dashboard
    Given path '/v1/cms/merchant-group/bulk-delete/logs'
    And headers headerJson
    And header Content-Type = 'application/json'
    And params {page:1, page-size:"10"}
    When method get
    Then status 200

  @b2b_campaign_bulk_upload_log
  Scenario: B2B campaign creation1
    Given url baseUrl+'/v1/cms/bulk-upload-log/'
    And headers headerJson
    And header Content-Type = 'application/json'
    And params {page:1, page-size:"10", "type":"b2b_campaign_create"}
    When method get
    Then status 200



  @vouchers_bulk_upload_log
  Scenario: vouchers Bulk Upload Log Dashboard1
    Given url baseUrl+'/v1/cms/bulk-upload-log/'
    And headers headerJson
    And header Content-Type = 'application/json'
    And params {page:1, page-size:"10", type:"voucher_create"}
    When method get
    Then status 200

  @download_b2b_bulk_upload_file
  Scenario: vouchers Bulk Upload Log Dashboard
    Given url baseUrl+'/v1/coupons/maker-checker/outputFile/'+Id
    And headers headerJson
    And header Content-Type = 'application/json'
    When method get
    Then status 200

  @invalidate_cms_cache
  Scenario: invalidate cache
    Given path '/coupons/v1/coupons/invalidateCache'
    And header Content-Type = 'application/json'
    When method delete
    Then status 200

  @invalidate_promotion_cache
  Scenario: refresh promotion cache
    Given path '/v1/cms/promotions/refreshCache'
    And header Content-Type = 'application/json'
    When method get
    Then status 200

  @B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_two_merchants
  Scenario: Perform B2B_FLAT_DISCOUNT_ON_SKU cart redemption__0036
    * def body = apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption__0043"]
    * set body.skuData[*].skuPrice = skuPrice
    * set body.billAmount = billAmount
    * set body.masId = masid
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @ReplacementAPI
  Scenario: To validate Replacement API
    * def masid = apiComponents['CMS_masid']
    * def body =
      """
          {
          "start" : 0,
          "end" : 1000,
          "sku": "sku-id"
          }
      """
    * set body.sku = skuID
    Given path '/coupons/v1/coupons/merchant/'+masid+'/fc/coupons'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @switch_on_features_1
  Scenario: switching on the features from configuration table.
    * def enable_promotion = db.updateRow("UPDATE CONFIGURATION SET CONFIG_VALUE = \'true\' WHERE CONFIG_NAME = \'promotion.enabled\'")
    * def enable_voucher = db.updateRow("UPDATE CONFIGURATION SET CONFIG_VALUE = \'true\' WHERE CONFIG_NAME = \'voucher.enabled\'")
    * def enable_prompter = db.updateRow("UPDATE CONFIGURATION SET CONFIG_VALUE = \'true\' WHERE CONFIG_NAME = \'prompter.enabled\'")

  @switch_on_features
  Scenario: switching on the features from configuration table.
     * def enable_promotion = db.updateRow("UPDATE CONFIGURATION SET CONFIG_VALUE = \'true\' WHERE CONFIG_NAME = \'promotion.enabled\'")
      * def enable_voucher = db.updateRow("UPDATE CONFIGURATION SET CONFIG_VALUE = \'true\' WHERE CONFIG_NAME = \'voucher.enabled\'")
      * def enable_prompter = db.updateRow("UPDATE CONFIGURATION SET CONFIG_VALUE = \'true\' WHERE CONFIG_NAME = \'prompter.enabled\'")
      Given path '/coupons/v1/coupons/merchant/fc/resetGetEligibleTxn'
      When method post
      Then status 200

  @switch_off_features
  Scenario: switching off the features from configuration table.
    * def masid = apiComponents['CMS_masid']
    #* def CLOSED_LOOP_REDEMPTION = db.updateRow("UPDATE CLOSED_LOOP_REDEMPTION SET STATUS = \'redeemed'\ WHERE MASID IN (\'" +masid+ "\')")
    * def FC_MERCHANT_COUPONS = db.updateRow("UPDATE FC_MERCHANT_COUPONS SET STATUS = \'cancelled'\ WHERE MASID IN (\'" +masid+ "\')")
    * def enable_promotion = db.updateRow("UPDATE CONFIGURATION SET CONFIG_VALUE = \'false\' WHERE CONFIG_NAME = \'promotion.enabled\'")
    * def enable_voucher = db.updateRow("UPDATE CONFIGURATION SET CONFIG_VALUE = \'false\' WHERE CONFIG_NAME = \'voucher.enabled\'")
    * def enable_prompter = db.updateRow("UPDATE CONFIGURATION SET CONFIG_VALUE = \'false\' WHERE CONFIG_NAME = \'prompter.enabled\'")

  @switch_on_features_b2b
  Scenario: switching on the features from configuration table.
    * def enable_b2b_percent = db.updateRow("UPDATE CONFIGURATION SET CONFIG_VALUE = \'true\' WHERE CONFIG_NAME = \'b2b_percent_discount_enabled\'")
    * def enable_b2b_fixed = db.updateRow("UPDATE CONFIGURATION SET CONFIG_VALUE = \'true\' WHERE CONFIG_NAME = \'b2b_fixed_price_discount_enabled\'")

  @switch_off_features_b2b
  Scenario: switching on the features from configuration table.
    * def enable_b2b_percent = db.updateRow("UPDATE CONFIGURATION SET CONFIG_VALUE = \'false\' WHERE CONFIG_NAME = \'b2b_percent_discount_enabled\'")
    * def enable_b2b_fixed = db.updateRow("UPDATE CONFIGURATION SET CONFIG_VALUE = \'false\' WHERE CONFIG_NAME = \'b2b_fixed_price_discount_enabled\'")

  @switch_on_features_mbv
  Scenario: switching on the features from configuration table.
    * def enable_mbv = db.updateRow("UPDATE CONFIGURATION SET CONFIG_VALUE = \'true\' WHERE CONFIG_NAME = \'minimum_bill_value_enabled\'")

  @switch_off_features_mbv
  Scenario: switching on the features from configuration table.
    * def enable_mbv = db.updateRow("UPDATE CONFIGURATION SET CONFIG_VALUE = \'false\' WHERE CONFIG_NAME = \'minimum_bill_value_enabled\'")

  @switch_on_features_b2b_segment
  Scenario: switching on the features from configuration table.
    * def enable_verticals = db.updateRow("UPDATE CONFIGURATION SET CONFIG_VALUE = \'true\' WHERE CONFIG_NAME = \'segment.enabled\'")

  @switch_off_features_b2b_segment
  Scenario: switching on the features from configuration table.
    * def disable_verticals = db.updateRow("UPDATE CONFIGURATION SET CONFIG_VALUE = \'false\' WHERE CONFIG_NAME = \'segment.enabled\'")

  @switch_off_redis
  Scenario: switching off redis.
    * def disable_verticals = db.updateRow("UPDATE CONFIGURATION SET CONFIG_VALUE = \'false\' WHERE CONFIG_NAME = \'redis.getcoupon.useRedisCache\'")

  @switch_on_features_b2c
  Scenario: switching on the features from configuration table.
    * def enable_prompter = db.updateRow("UPDATE CONFIGURATION SET CONFIG_VALUE = \'true\' WHERE CONFIG_NAME = \'b2c.prompter.enabled\'")

  @switch_off_features_b2c
  Scenario: switching on the features from configuration table.
    * def enable_prompter = db.updateRow("UPDATE CONFIGURATION SET CONFIG_VALUE = \'false\' WHERE CONFIG_NAME = \'b2c.prompter.enabled\'")

  @activate_coupons
  Scenario: activate hold coupons b2b.
    Given path '/coupons/v1/coupons/merchant/fc/resetGetEligibleTxn'
    When method post
    Then status 200

