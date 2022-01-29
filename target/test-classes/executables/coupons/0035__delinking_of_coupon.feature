@ignore
Feature: De-linking of b2b coupons __0035

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * def login = callonce read('support.feature@login')
    * def headerJson = {}
    * set headerJson.Cookie = $login.responseHeaders['Set-Cookie'][0]
    * set headerJson.X-Anti-Forgery = $login.responseHeaders['x-anti-forgery'][0]
    * set headerJson.Content-Type = 'multipart/form-data'
    * def helperMethods = Java.type('executables.utils.HelperMethods')
    * def getId =

    """
    function(arg){
    return arg[arg.length-1].id
    }
    """

  Scenario Outline: de-link B2B coupons for <discount_type> with data <file_description>
    #   Editing of B2B coupon by uploading the b2b edit file.
    Given path '/coupons/v1/coupons/b2b-update/createjob'
    * print "<============== file_description ==============>", <file_description>
    * def path = <path>
    * def updateB2BBulkUploadCSV = helperMethods.B2B_coupon_Bulk_edit(path)
    * print "*****INSIDE1********"
    * def temp = karate.readAsString('../helperFiles/files/flatDiscountTemplate1.csv')
    * print "*****INSIDE2********"
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
    And request {"approved":true,"comments":""}
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

    Examples:
      | path                                                                                                                |file_description                                     |status|discount_type         |
      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_30.csv"     |"delink no  with conditional couponid"               |201   |"FLAT_DISCOUNT_ON_SKU"|
     |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_31.csv"     |"delink yes, conditional coupon blank "              |415   |"FLAT_DISCOUNT_ON_SKU"|
     |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_35.csv"     |"YES/NO "                                            |201   |"FLAT_DISCOUNT_ON_SKU"|
     |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_36.csv"     |"Yes, wrong conditional coupon id"                   |415   |"FLAT_DISCOUNT_ON_SKU"|
     |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_32.csv"     |"delink column blank"                                |201   |"FLAT_DISCOUNT_ON_SKU"|
     |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_30.csv"    |"delink no  with conditional couponid"               |201   |"PERCENT_DISCOUNT"    |
     |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_31.csv"    |"delink yes, conditional coupon blank "              |415   |"PERCENT_DISCOUNT"    |
     |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_36.csv"    |"no/YES"                                             |201   |"PERCENT_DISCOUNT"    |
     |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_37.csv"    |"Yes, wrong conditional coupon id"                   |415   |"PERCENT_DISCOUNT"    |
     |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_32.csv"    |"delink column blank"                                |201   |"PERCENT_DISCOUNT"    |
     |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_30.csv"|"delink no  with conditional couponid"               |201   |"SKU_AT_FIXED_PRICE"  |
     |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_31.csv"|"delink yes, conditional coupon blank "              |415   |"SKU_AT_FIXED_PRICE"  |
     |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_35.csv"|"NO/yes"                                             |201   |"SKU_AT_FIXED_PRICE"  |
     |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_36.csv"|"Yes, wrong conditional coupon id"                   |415   |"SKU_AT_FIXED_PRICE"  |
     |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_32.csv"|"delink column blank"                                |201   |"SKU_AT_FIXED_PRICE"  |