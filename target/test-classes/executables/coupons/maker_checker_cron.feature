@test @ignore
Feature: Bulk Upload with maker and checker.

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * def apiComponents = envConfig
    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])

    * def login = callonce read('support.feature@login')
    * def helperMethods = Java.type('executables.utils.HelperMethods')
    * def headerJson = {}
    * set headerJson.Cookie = $login.responseHeaders['Set-Cookie'][0]
    * set headerJson.X-Anti-Forgery = $login.responseHeaders['x-anti-forgery'][0]
    * set headerJson.Content-Type = 'multipart/form-data'
    * def sleep = function(millis){ java.lang.Thread.sleep(millis) }
    * def getId =
      """
        function(arg){
        return arg[arg.length-1].id
        }
      """

  Scenario Outline: B2B coupons bulk upload <discount_type> with data <file_description>
    #    deleting the csv file
    * def deleting_the_csv_file = helperMethods.deleteCSV('../helperFiles/files/flatDiscountTemplate1.csv')
    #    Creation of B2B coupon by uploading the create file.
    Given path '/coupons/v1/coupons/b2b-upload/createjob'
    * print "<============== file_description ==============>", <file_description>
    * def path = <path>
       * def updateB2BBulkUploadCSV = helperMethods.B2B_coupon_BulkUpload(path, discount_type)
    * eval sleep(1000)
    * def temp = karate.readAsString('../helperFiles/files/flatDiscountTemplate1.csv')
    * eval sleep(4000)
    And multipart file B2BFile = { value: '#(temp)', filename: 'flatDiscountTemplate1.csv', contentType: 'text/csv' }
    And multipart field discountType = <discount_type>
    And headers headerJson
    When method put
    * def result = call read('support.feature@b2b_coupon_bulk_upload_log') {requestHeader: #(headerJson)}
    * def Id = result.response["data"][0]["id"]
    * print "<<<<<<<<<<<<<<<<<< log_Id >>>>>>>>>>>>>>", Id
    Then status <status>
    #    Approval of B2B coupon
    Given path '/v1/coupons/maker-checker/'+Id+'/status-approval'
    And request {"approved":true,"comments":<discount_type>}
    * set headerJson.Content-Type = 'application/json'
    And headers headerJson
    When method post
    Then status 200
    #    cron of B2B coupon for final approval
    Given path '/v1/coupons/maker-checker/b2b-upload/trigger/B2B_CREATE'
    And request {}
    When method post
    #    Download of B2B coupon success file
    Given path '/v1/coupons/maker-checker/outputFile/'+Id
    And headers headerJson
    When method get
    Then status 200

    Examples:
      | path                                                                                                         |file_description                                             |status|discount_type         |
      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_maker_checker.csv"           |"valid file and decimal value for discount amount1"           |201   |"PERCENT_DISCOUNT"    |
      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_maker_checker.csv"   |"valid file and decimal value for discount amount2"           |201   |"FLAT_DISCOUNT_ON_SKU"|
      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_maker_checker.csv"       |"valid file and decimal value for discount amount3"           |201   |"SKU_AT_FIXED_PRICE"  |

    @ignore
  Scenario Outline: B2B coupons bulk edit <discount_type> with data <file_description>
    * eval sleep(1000)
    #    deleting the csv file
    * def deleting_the_csv_file = helperMethods.deleteCSV('../helperFiles/files/flatDiscountTemplate1.csv')

    #   Editing of B2B coupon by uploading the b2b edit file.
    Given path '/coupons/v1/coupons/b2b-update/createjob'
    * print "<============== file_description ==============>", <file_description>
    * def path = <path>
    * def updateB2BBulkUploadCSV = helperMethods.B2B_coupon_Bulk_edit(path)
    * eval sleep(5000)
    * def temp = karate.readAsString('../helperFiles/files/flatDiscountTemplate1.csv')
    And multipart file B2BFile = { value: '#(temp)', filename: 'flatDiscountTemplate1.csv', contentType: 'text/csv' }
    And multipart field discountType = <discount_type>
    And headers headerJson
    When method post
    * def result = call read('support.feature@b2b_coupon_bulk_edit_log') {requestHeader: #(headerJson)}
    * def Id = result.response["data"][0]["id"]
    * print "<<<<<<<<<<<<<<<<<< log_Id >>>>>>>>>>>>>>", Id
    Then status <status>
    #    Approval of B2B coupon edit
    Given path '/v1/coupons/maker-checker/'+Id+'/status-approval'
    And request {"approved":true,"comments":<discount_type>}
    * set headerJson.Content-Type = 'application/json'
    And headers headerJson
    When method post
    Then status 200
    #    cron of B2B coupon edit for final approval
    Given path '/v1/coupons/maker-checker/b2b-upload/trigger/B2B_EDIT'
    And request {}
    When method post
    #    Download of B2B coupon edit success file
    Given path '/v1/coupons/maker-checker/outputFile/'+Id
    And headers headerJson
    When method get
    Then status 200
    * def b2b_conditional_coupons = db.readRows("SELECT * FROM B2B_COUPON WHERE ID IN (\'" +<b2b_coupon>+ "\')")
    * print b2b_conditional_coupons
    * match b2b_conditional_coupons[0] contains <validations>

    Examples:
      | path                                                                                                                |file_description                  |status|discount_type           |  b2b_coupon                                                        |validations              |
      |apiComponents["b2b_coupon_bulk_edit_path"]+"/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_maker_checker.csv"        |"valid data"                      |201   |"FLAT_DISCOUNT_ON_SKU"  | apiComponents["b2b_coupon_idFor_bulk_upload_FLAT_DISCOUNT_ON_SKU"] |{"CAMPAIGN_ID":'#? _> 0'}|
      |apiComponents["b2b_coupon_bulk_edit_path"]+"/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_maker_checker.csv"   |"valid data"                      |201   |"SKU_AT_FIXED_PRICE"    | apiComponents["b2b_coupon_idFor_bulk_upload_SKU_AT_FIXED_PRICE"]   |{"CAMPAIGN_ID":'#? _> 0'}|
      |apiComponents["b2b_coupon_bulk_edit_path"]+"/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_maker_checker.csv"       |"valid data"                      |201   |"PERCENT_DISCOUNT"      | apiComponents["b2b_coupon_idFor_bulk_upload_PERCENT_DISCOUNT"]     |{"CAMPAIGN_ID":'#? _> 0'}|

  @ignore
  Scenario Outline: B2C <discount_type> coupon bulk upload.
    * eval sleep(1000)
    Given path '/coupons/v1/coupons/b2c-coupon/createjob'
    * print "<============== file_description ==============>", <file_description>
    And multipart file data = { read: <path>, filename: <file_name>, contentType: 'application/zip' }
    And multipart field discountType = <discount_type>
    And headers headerJson
    When method post
    * def result = call read('support.feature@b2c_coupon_bulk_upload_log') {requestHeader: #(headerJson)}
    * def Id = result.response["data"][0]["id"]
    * print "<<<<<<<<<<<<<<<<<< log_Id >>>>>>>>>>>>>>", Id
    Then status <status>
    #    Approval of B2C coupon upload
    Given path '/v1/coupons/maker-checker/'+Id+'/status-approval'
    And request {"approved":true,"comments":""}
    * set headerJson.Content-Type = 'application/json'
    And headers headerJson
    When method post
    Then status 200
    #    cron of B2C coupon edit for final approval
    Given path '/v1/coupons/maker-checker/b2b-upload/trigger/B2C_CREATE'
    And request {}
    When method post
    #    Download of B2B coupon edit success file
    Given path '/v1/coupons/maker-checker/outputFile/'+Id
    And headers headerJson
    When method GET
    Then status 200

    * def delete_coupons = db.updateRow("UPDATE COUPON SET STATUS = '16' WHERE TITLE LIKE '% Santoor Orange %'")

    Examples:
        |path                                                                                  |file_name              |status|discount_type              |file_description|
        |"../helperFiles/files/b2c_bulk_uploads/FLAT_DISCOUNT_WITH_SKU/data_fds_1.zip"         |"data_fds_1.zip"       |201   |"FLAT_DISCOUNT_WITH_SKU"   | "FLAT_DISCOUNT_WITH_SKU"               |
        |"../helperFiles/files/b2c_bulk_uploads/PERCENTAGE_DISCOUNT_WITH_SKU/data_pds_1.zip"   |"data_pds_1.zip"       |201   |"PERCENTAGE_DISCOUNT_WITH_SKU"|   "PERCENTAGE_DISCOUNT_WITH_SKU"       |
        |"../helperFiles/files/b2c_bulk_uploads/FREE_SKU_WITH_SKU/BxGy_parent_child_1.zip"     |"BxGy_parent_child.zip"|201   |"FREE_SKU_WITH_SKU"        |           "FREE_SKU_WITH_SKU"          |

  @ignore
  Scenario Outline: Add/deleting merchant to merchant Group creation
    * eval sleep(1000)
    #    deleting the csv file
    * def deleting_the_csv_file = helperMethods.deleteCSV('../helperFiles/files/flatDiscountTemplate1.csv')
    #   Adding of merchant group by uploading the merchant group upload file.
    Given path '/v1/coupons/maker-checker/merchant-group-upload/createJob'
    * print "<============== file_description ==============>", <file_description>
    * def path = <path>
    * print "lllll", path
    * def updateB2BBulkUploadCSV = helperMethods.B2B_coupon_Bulk_edit(path)
    * def temp = karate.readAsString('../helperFiles/files/flatDiscountTemplate1.csv')
    And multipart file File = { value: '#(temp)', filename: 'flatDiscountTemplate1.csv', contentType: 'text/csv' }
    And headers headerJson
    When method post
    * def result = call read('support.feature@merchant_group_bulk_upload') {requestHeader: #(headerJson)}
    * def Id = result.response["data"][0]["id"]
    * print "<<<<<<<<<<<<<<<<<< log_Id >>>>>>>>>>>>>>", Id
    Then status <status>
    #    cron of merchant group upload for final approval
    Given path '/v1/coupons/maker-checker/b2b-upload/trigger/MERCHANT_GROUP_UPLOAD'
    And request {}
    When method post
    Then status 200
    #    Download of  merchant group upload success file
#    Given url baseUrl + '/v1/coupons/maker-checker/inputFile/'+Id
#    And headers headerJson
#    * set headerJson.Content-Type = 'application/json'
#    * print headerJson
#    When method GET
#    Then status 200

    #    deleting the csv file
    * def deleting_the_csv_file = helperMethods.deleteCSV('../helperFiles/files/flatDiscountTemplate1.csv')
    #   Deleting of merchant group by uploading the merchant group upload file.
    Given path '/v1/cms/merchant-group/bulk-delete'
    * print "<============== file_description ==============>", <file_description>
    * def path = <path>
    * print "lllll", path
    * def updateB2BBulkUploadCSV = helperMethods.B2B_coupon_Bulk_edit(path)
    * def temp = karate.readAsString('../helperFiles/files/flatDiscountTemplate1.csv')
    And multipart file File = { value: '#(temp)', filename: 'flatDiscountTemplate1.csv', contentType: 'text/csv' }
    And headers headerJson
    When method post
    * def result = call read('support.feature@merchant_group_bulk_delete') {requestHeader: #(headerJson)}
    * def Id = call getId result.response
    * print "<<<<<<<<<<<<<<<<<< log_Id >>>>>>>>>>>>>>", Id
    Then status <status>
    #    cron of merchant group upload for final approval
    Given path '/v1/coupons/maker-checker/b2b-upload/trigger/MERCHANT_GROUP_UPLOAD'
    And request {}
    When method post
    * assert (status == 200)||(status == 400)
    #    Download of  merchant group upload success file
#    Given url baseUrl + '/v1/cms/merchant-group/bulk-delete/logs/input/'+Id
#    And headers headerJson
#    * set headerJson.Content-Type = 'text/csv'
#    When method GET
#    Then status 200

    Examples:
      | path                                                                                                |file_description                                          |status|
      |apiComponents["merchant_group_bulk_upload_path"]+"/MerchantGroupBulkUpload.csv"                      |"merchant group bulk upload"                              |200   |
