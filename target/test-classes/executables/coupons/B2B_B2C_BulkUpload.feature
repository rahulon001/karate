@ignore
Feature: B2B Bulk Upload.

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * def apiComponents = envConfig
    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])
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
    * def sleep = function(millis){ java.lang.Thread.sleep(millis) }
    * def call_configuration_table = callonce read('support.feature@switch_on_features')

  
  Scenario Outline: B2C <discount_type> coupon bulk upload with data <file_description>.
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
    Then status <cron_status>
    #    Download of B2B coupon edit success file
    Given path '/v1/coupons/maker-checker/outputFile/'+Id
    And headers headerJson
    When method get
    Then status 200

    * def delete_coupons = db.updateRow("UPDATE COUPON SET STATUS = '16' WHERE TITLE LIKE '% Santoor Orange %'")

    Examples:

      |path                                                                                               |file_name                       |file_description                                      |status|discount_type                 | cron_status|
 |"../helperFiles/files/b2c_bulk_uploads/FLAT_DISCOUNT_WITH_SKU/data_fds_1.zip"                        |"data_fds_1.zip"                | "Valid without min Bill Conditon"                    |201   |"FLAT_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/FLAT_DISCOUNT_WITH_SKU/data_fds_2.zip"                        |"data_fds_2.zip"                |" Valid with min Bill Condition"                      |201   |"FLAT_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/FLAT_DISCOUNT_WITH_SKU/data_fds_3.zip"                        |"data_fds_3.zip"                | "Negative value for min Bill Condition"              |415   |"FLAT_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/FLAT_DISCOUNT_WITH_SKU/data_fds_4.zip"                        |"data_fds_4.zip"                | "junk value for min Bill condition"                  |415   |"FLAT_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/FLAT_DISCOUNT_WITH_SKU/data_fds_5.zip"                        |"data_fds_5.zip"                | "valid file and decimal value for discount amount"   |201   |"FLAT_DISCOUNT_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/FLAT_DISCOUNT_WITH_SKU/data_fds_6.zip"                       |"data_fds_6.zip"                | "without merchant group"                             |415   |"FLAT_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/FLAT_DISCOUNT_WITH_SKU/data_fds_7.zip"                        |"data_fds_7.zip"                | "from date is greater than to date"                  |415   |"FLAT_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/FLAT_DISCOUNT_WITH_SKU/data_fds_8.zip"                        |"data_fds_8.zip"                | "redeem caps are negative"                           |415   |"FLAT_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/FLAT_DISCOUNT_WITH_SKU/data_fds_9.zip"                        |"data_fds_9.zip"                | "SkuID is negative"                                  |415   |"FLAT_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/FLAT_DISCOUNT_WITH_SKU/data_fds_10.zip"                       |"data_fds_10.zip"               | "without b2c coupon title"                           |415   |"FLAT_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/FLAT_DISCOUNT_WITH_SKU/data_fds_11.zip"                       |"data_fds_11.zip"               | "without date"                                       |415   |"FLAT_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/FLAT_DISCOUNT_WITH_SKU/data_fds_12.zip"                       |"data_fds_12.zip"               | "without redeem caps"                                |415   |"FLAT_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/FLAT_DISCOUNT_WITH_SKU/data_fds_13.zip"                       |"data_fds_13.zip"               | "redeem caps & all numeric fields with letter 'e'"   |415   |"FLAT_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/FLAT_DISCOUNT_WITH_SKU/data_fds_14.zip"                       |"data_fds_14.zip"               | "field with spaces at start and end"                 |201   |"FLAT_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/FLAT_DISCOUNT_WITH_SKU/data_fds_15.zip"                       |"data_fds_15.zip"               | "discount amount with .. i.e. 2..1"                  |415   |"FLAT_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/FLAT_DISCOUNT_WITH_SKU/data_fds_16.zip"                       |"data_fds_16.zip"               | "wrong date format"                                  |415   |"FLAT_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/FLAT_DISCOUNT_WITH_SKU/data_fds_17.zip"                       |"data_fds_17.zip"               | "-ve value for brand,merchant,reliance contr"        |415   |"FLAT_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/FLAT_DISCOUNT_WITH_SKU/data_fds_18.zip"                       |"data_fds_18.zip"               | ">100%  for brand,merchant,reliance contr"           |415   |"FLAT_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/FLAT_DISCOUNT_WITH_SKU/data_fds_19.zip"                       |"data_fds_19.zip"               | "valid brand,merchant,reliance contr"                |201   |"FLAT_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/FLAT_DISCOUNT_WITH_SKU/data_fds_20.zip"                       |"data_fds_20.zip"               | "brand,merchant,reliance contr total>100"            |415   |"FLAT_DISCOUNT_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/FLAT_DISCOUNT_WITH_SKU/data_fds_21.zip"                       |"data_fds_21.zip"               | "Missing fields"                                    |415   |"FLAT_DISCOUNT_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/FLAT_DISCOUNT_WITH_SKU/data_fds_22.zip"                       |"data_fds_22.zip"               | "Missing fields"                                    |415   |"FLAT_DISCOUNT_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/FLAT_DISCOUNT_WITH_SKU/data_fds_23.zip"                       |"data_fds_23.zip"               | "Missing fields-MBV"                                |415   |"FLAT_DISCOUNT_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/FLAT_DISCOUNT_WITH_SKU/data_fds_24.zip"                       |"data_fds_24.zip"               | "Missing fields-image"                              |415   |"FLAT_DISCOUNT_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/FLAT_DISCOUNT_WITH_SKU/data_fds_25.zip"                       |"data_fds_25.zip"               | "Payment Coupon"                                    |201   |"FLAT_DISCOUNT_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/FLAT_DISCOUNT_WITH_SKU/data_fds_26.zip"                       |"data_fds_26.zip"               | "Only Future coupons"                               |201   |"FLAT_DISCOUNT_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/FLAT_DISCOUNT_WITH_SKU/data_fds_27.zip"                       |"data_fds_27.zip"               | "Duplicate Title"                                   |201   |"FLAT_DISCOUNT_WITH_SKU"      |200         |

 |"../helperFiles/files/b2c_bulk_uploads/PERCENTAGE_DISCOUNT_WITH_SKU/data_pds_1.zip"                  |"data_pds_1.zip"                | "Valid without min Bill Conditon"                    |201   |"PERCENTAGE_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/PERCENTAGE_DISCOUNT_WITH_SKU/data_pds_2.zip"                  |"data_pds_2.zip"                |" Valid with min Bill Condition"                      |201   |"PERCENTAGE_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/PERCENTAGE_DISCOUNT_WITH_SKU/data_pds_3.zip"                  |"data_pds_3.zip"                | "Negative value for min Bill Condition"              |415   |"PERCENTAGE_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/PERCENTAGE_DISCOUNT_WITH_SKU/data_pds_4.zip"                  |"data_pds_4.zip"                | "junk value for min Bill condition"                  |415   |"PERCENTAGE_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/PERCENTAGE_DISCOUNT_WITH_SKU/data_pds_5.zip"                  |"data_pds_5.zip"                | "valid file and decimal value for discount amount"   |201   |"PERCENTAGE_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/PERCENTAGE_DISCOUNT_WITH_SKU/data_pds_6.zip"                  |"data_pds_6.zip"                | "merchant group"                                     |415   |"PERCENTAGE_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/PERCENTAGE_DISCOUNT_WITH_SKU/data_pds_7.zip"                  |"data_pds_7.zip"                | "from date is greater than to date"                  |415   |"PERCENTAGE_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/PERCENTAGE_DISCOUNT_WITH_SKU/data_pds_8.zip"                  |"data_pds_8.zip"                | "redeem caps are negative"                           |415   |"PERCENTAGE_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/PERCENTAGE_DISCOUNT_WITH_SKU/data_pds_9.zip"                  |"data_pds_9.zip"                | "SkuID is negative"                                  |415   |"PERCENTAGE_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/PERCENTAGE_DISCOUNT_WITH_SKU/data_pds_10.zip"                 |"data_pds_10.zip"               | "without b2c coupon title"                           |415   |"PERCENTAGE_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/PERCENTAGE_DISCOUNT_WITH_SKU/data_pds_11.zip"                 |"data_pds_11.zip"               | "without date"                                       |415   |"PERCENTAGE_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/PERCENTAGE_DISCOUNT_WITH_SKU/data_pds_12.zip"                 |"data_pds_12.zip"               | "without redeem caps"                                |415   |"PERCENTAGE_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/PERCENTAGE_DISCOUNT_WITH_SKU/data_pds_13.zip"                 |"data_pds_13.zip"               | "redeem caps & all numeric fields with letter 'e'"   |415   |"PERCENTAGE_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/PERCENTAGE_DISCOUNT_WITH_SKU/data_pds_14.zip"                 |"data_pds_14.zip"               | "field with spaces at start and end"                 |201   |"PERCENTAGE_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/PERCENTAGE_DISCOUNT_WITH_SKU/data_pds_15.zip"                 |"data_pds_15.zip"               | "discount amount with .. i.e. 2..1"                  |415   |"PERCENTAGE_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/PERCENTAGE_DISCOUNT_WITH_SKU/data_pds_16.zip"                 |"data_pds_16.zip"               | "wrong date format"                                  |415   |"PERCENTAGE_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/PERCENTAGE_DISCOUNT_WITH_SKU/data_pds_17.zip"                 |"data_pds_17.zip"               | "-ve value for brand,merchant,reliance contr"        |415   |"PERCENTAGE_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/PERCENTAGE_DISCOUNT_WITH_SKU/data_pds_18.zip"                 |"data_pds_18.zip"               | ">100%  for brand,merchant,reliance contr"           |415   |"PERCENTAGE_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/PERCENTAGE_DISCOUNT_WITH_SKU/data_pds_19.zip"                 |"data_pds_19.zip"               | "valid brand,merchant,reliance contr"                |201   |"PERCENTAGE_DISCOUNT_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/PERCENTAGE_DISCOUNT_WITH_SKU/data_pds_20.zip"                 |"data_pds_20.zip"               | "brand,merchant,reliance contr total>100"            |415   |"PERCENTAGE_DISCOUNT_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/PERCENTAGE_DISCOUNT_WITH_SKU/data_pds_21.zip"                 |"data_pds_21.zip"               | "Missing fields"                                     |415   |"PERCENTAGE_DISCOUNT_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/PERCENTAGE_DISCOUNT_WITH_SKU/data_pds_22.zip"                 |"data_pds_22.zip"               | "Missing fields"                                     |415   |"PERCENTAGE_DISCOUNT_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/PERCENTAGE_DISCOUNT_WITH_SKU/data_pds_23.zip"                 |"data_pds_23.zip"               | "Missing fields-MBV"                                 |415   |"PERCENTAGE_DISCOUNT_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/PERCENTAGE_DISCOUNT_WITH_SKU/data_pds_24.zip"                 |"data_pds_24.zip"               | "Missing fields-Title"                               |415   |"PERCENTAGE_DISCOUNT_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/PERCENTAGE_DISCOUNT_WITH_SKU/data_pds_25.zip"                 |"data_pds_25.zip"               | "Payment Coupon"                                     |201   |"PERCENTAGE_DISCOUNT_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/PERCENTAGE_DISCOUNT_WITH_SKU/data_pds_26.zip"                 |"data_pds_26.zip"               | "Future coupon "                                     |201   |"PERCENTAGE_DISCOUNT_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/PERCENTAGE_DISCOUNT_WITH_SKU/data_pds_27.zip"                 |"data_pds_27.zip"               | "Dsicount Percent >100"                              |415   |"PERCENTAGE_DISCOUNT_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/PERCENTAGE_DISCOUNT_WITH_SKU/data_pds_28.zip"                 |"data_pds_28.zip"               | "Duplicate Title"                                  |201   |"PERCENTAGE_DISCOUNT_WITH_SKU"      |200         |

  |"../helperFiles/files/b2c_bulk_uploads/FREE_SKU_WITH_SKU/BxGy_parent_child_1.zip"                    |"BxGy_parent_child_1.zip"       | "Valid without min Bill Conditon"                    |201   |"FREE_SKU_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/FREE_SKU_WITH_SKU/BxGy_parent_child_2.zip"                    |"BxGy_parent_child_2.zip"       |" Valid with min Bill Condition"                      |201   |"FREE_SKU_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/FREE_SKU_WITH_SKU/BxGy_parent_child_3.zip"                    |"BxGy_parent_child_3.zip"       | "Negative value for min Bill Condition"              |415   |"FREE_SKU_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/FREE_SKU_WITH_SKU/BxGy_parent_child_4.zip"                    |"BxGy_parent_child_4.zip"       | "junk value for min Bill condition"                  |415   |"FREE_SKU_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/FREE_SKU_WITH_SKU/BxGy_parent_child_5.zip"                    |"BxGy_parent_child_5.zip"       | "valid file and decimal value for min Bill Condition"|201   |"FREE_SKU_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/FREE_SKU_WITH_SKU/BxGy_parent_child_6.zip"                    |"BxGy_parent_child_6.zip"       | "without merchant group"                             |415   |"FREE_SKU_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/FREE_SKU_WITH_SKU/BxGy_parent_child_7.zip"                    |"BxGy_parent_child_7.zip"       | "from date is greater than to date"                  |415   |"FREE_SKU_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/FREE_SKU_WITH_SKU/BxGy_parent_child_8.zip"                    |"BxGy_parent_child_8.zip"       | "redeem caps are negative"                           |415   |"FREE_SKU_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/FREE_SKU_WITH_SKU/BxGy_parent_child_9.zip"                    |"BxGy_parent_child_9.zip"       | "SkuID is negative"                                  |415   |"FREE_SKU_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/FREE_SKU_WITH_SKU/BxGy_parent_child_10.zip"                   |"BxGy_parent_child_10.zip"      | "without b2c coupon title"                           |415   |"FREE_SKU_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/FREE_SKU_WITH_SKU/BxGy_parent_child_11.zip"                   |"BxGy_parent_child_11.zip"      | "without date"                                       |415   |"FREE_SKU_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/FREE_SKU_WITH_SKU/BxGy_parent_child_12.zip"                   |"BxGy_parent_child_12.zip"      | "without redeem caps"                                |415   |"FREE_SKU_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/FREE_SKU_WITH_SKU/BxGy_parent_child_13.zip"                   |"BxGy_parent_child_13.zip"      | "redeem caps & all numeric fields with letter 'e'"   |415   |"FREE_SKU_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/FREE_SKU_WITH_SKU/BxGy_parent_child_14.zip"                   |"BxGy_parent_child_14.zip"      | "field with spaces at start and end"                 |201   |"FREE_SKU_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/FREE_SKU_WITH_SKU/BxGy_parent_child_15.zip"                   |"BxGy_parent_child_15.zip"      | "discount amount with .. i.e. 2..1"                  |415   |"FREE_SKU_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/FREE_SKU_WITH_SKU/BxGy_parent_child_16.zip"                   |"BxGy_parent_child_16.zip"      | "wrong date format"                                  |415   |"FREE_SKU_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/FREE_SKU_WITH_SKU/BxGy_parent_child_17.zip"                   |"BxGy_parent_child_17.zip"      | "-ve value for brand,merchant,reliance contr"        |415   |"FREE_SKU_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/FREE_SKU_WITH_SKU/BxGy_parent_child_18.zip"                   |"BxGy_parent_child_18.zip"      | ">100%  for brand,merchant,reliance contr"           |415   |"FREE_SKU_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/FREE_SKU_WITH_SKU/BxGy_parent_child_19.zip"                   |"BxGy_parent_child_19.zip"      | "valid brand,merchant,reliance contr"                |201   |"FREE_SKU_WITH_SKU"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/FREE_SKU_WITH_SKU/BxGy_parent_child_20.zip"                   |"BxGy_parent_child_20.zip"      | "brand,merchant,reliance contr total>100"            |415   |"FREE_SKU_WITH_SKU"      |200         |
#   |"../helperFiles/files/b2c_bulk_uploads/FREE_SKU_WITH_SKU/BxGy_parent_child_21.zip"                   |"BxGy_parent_child_21.zip"      | "Missing fields"                                    |415   |"FREE_SKU_WITH_SKU"      |200         |
#   |"../helperFiles/files/b2c_bulk_uploads/FREE_SKU_WITH_SKU/BxGy_parent_child_22.zip"                   |"BxGy_parent_child_22.zip"      | "Missing fields"                                   |415   |"FREE_SKU_WITH_SKU"      |200         |
#   |"../helperFiles/files/b2c_bulk_uploads/FREE_SKU_WITH_SKU/BxGy_parent_child_23.zip"                   |"BxGy_parent_child_23.zip"      | "Missing fields-MBV"                                |415   |"FREE_SKU_WITH_SKU"      |200         |
#   |"../helperFiles/files/b2c_bulk_uploads/FREE_SKU_WITH_SKU/BxGy_parent_child_24.zip"                   |"BxGy_parent_child_24.zip"      | "Missing fields-fcSKUCoupon"                        |415   |"FREE_SKU_WITH_SKU"      |200         |
#   |"../helperFiles/files/b2c_bulk_uploads/FREE_SKU_WITH_SKU/BxGy_parent_child_25.zip"                   |"BxGy_parent_child_25.zip"      | "Payment Coupon"                                    |201   |"FREE_SKU_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/FREE_SKU_WITH_SKU/BxGy_parent_child_26.zip"                   |"BxGy_parent_child_26.zip"      | "Future Coupons"                                     |201   |"FREE_SKU_WITH_SKU"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/FREE_SKU_WITH_SKU/BxGy_parent_child_27.zip"                   |"BxGy_parent_child_27.zip"      | "Duplicate Title"                                    |201   |"FREE_SKU_WITH_SKU"      |200         |

  |"../helperFiles/files/b2c_bulk_uploads/BXGY_FLAT_WITH_SKU/BxGy_flat_parent_child_1.zip"                    |"BxGy_flat_parent_child_1.zip"       | "Valid without min Bill Conditon"                    |201   |"BXGY_AT_FLAT_DISCOUNT"      |200         |
#   |"../helperFiles/files/b2c_bulk_uploads/BXGY_FLAT_WITH_SKU/BxGy_flat_parent_child_2.zip"                    |"BxGy_flat_parent_child_2.zip"       |" Valid with min Bill Condition"                      |201   |"BXGY_AT_FLAT_DISCOUNT"      |200         |
#   |"../helperFiles/files/b2c_bulk_uploads/BXGY_FLAT_WITH_SKU/BxGy_flat_parent_child_3.zip"                    |"BxGy_flat_parent_child_3.zip"       | "Negative value for min Bill Condition"              |415   |"BXGY_AT_FLAT_DISCOUNT"      |200         |
#   |"../helperFiles/files/b2c_bulk_uploads/BXGY_FLAT_WITH_SKU/BxGy_flat_parent_child_4.zip"                    |"BxGy_flat_parent_child_4.zip"       | "junk value for min Bill condition"                  |415   |"BXGY_AT_FLAT_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_FLAT_WITH_SKU/BxGy_flat_parent_child_5.zip"                    |"BxGy_flat_parent_child_5.zip"       | "valid file and decimal value for min Bill Condition"|201   |"BXGY_AT_FLAT_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_FLAT_WITH_SKU/BxGy_flat_parent_child_6.zip"                    |"BxGy_flat_parent_child_6.zip"       | "without merchant group"                             |415   |"BXGY_AT_FLAT_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_FLAT_WITH_SKU/BxGy_flat_parent_child_7.zip"                    |"BxGy_flat_parent_child_7.zip"       | "from date is greater than to date"                  |415   |"BXGY_AT_FLAT_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_FLAT_WITH_SKU/BxGy_flat_parent_child_8.zip"                    |"BxGy_flat_parent_child_8.zip"       | "redeem caps are negative"                           |415   |"BXGY_AT_FLAT_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_FLAT_WITH_SKU/BxGy_flat_parent_child_9.zip"                    |"BxGy_flat_parent_child_9.zip"       | "SkuID is negative"                                  |415   |"BXGY_AT_FLAT_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_FLAT_WITH_SKU/BxGy_flat_parent_child_10.zip"                   |"BxGy_flat_parent_child_10.zip"      | "without b2c coupon title"                           |415   |"BXGY_AT_FLAT_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_FLAT_WITH_SKU/BxGy_flat_parent_child_11.zip"                   |"BxGy_flat_parent_child_11.zip"      | "without date"                                       |415   |"BXGY_AT_FLAT_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_FLAT_WITH_SKU/BxGy_flat_parent_child_12.zip"                   |"BxGy_flat_parent_child_12.zip"      | "without redeem caps"                                |415   |"BXGY_AT_FLAT_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_FLAT_WITH_SKU/BxGy_flat_parent_child_13.zip"                   |"BxGy_flat_parent_child_13.zip"      | "redeem caps & all numeric fields with letter 'e'"   |415   |"BXGY_AT_FLAT_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_FLAT_WITH_SKU/BxGy_flat_parent_child_14.zip"                   |"BxGy_flat_parent_child_14.zip"      | "field with spaces at start and end"                 |201   |"BXGY_AT_FLAT_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_FLAT_WITH_SKU/BxGy_flat_parent_child_15.zip"                   |"BxGy_flat_parent_child_15.zip"      | "discount amount with .. i.e. 2..1"                  |415   |"BXGY_AT_FLAT_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_FLAT_WITH_SKU/BxGy_flat_parent_child_16.zip"                   |"BxGy_flat_parent_child_16.zip"      | "wrong date format"                                  |415   |"BXGY_AT_FLAT_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_FLAT_WITH_SKU/BxGy_flat_parent_child_17.zip"                   |"BxGy_flat_parent_child_17.zip"      | "-ve value for brand,merchant,reliance contr"        |415   |"BXGY_AT_FLAT_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_FLAT_WITH_SKU/BxGy_flat_parent_child_18.zip"                   |"BxGy_flat_parent_child_18.zip"      | ">100%  for brand,merchant,reliance contr"           |415   |"BXGY_AT_FLAT_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_FLAT_WITH_SKU/BxGy_flat_parent_child_19.zip"                   |"BxGy_flat_parent_child_19.zip"      | "valid brand,merchant,reliance contr"                |201   |"BXGY_AT_FLAT_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_FLAT_WITH_SKU/BxGy_flat_parent_child_20.zip"                   |"BxGy_flat_parent_child_20.zip"      | "brand,merchant,reliance contr total>100"            |415   |"BXGY_AT_FLAT_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_FLAT_WITH_SKU/BxGy_flat_parent_child_21.zip"                   |"BxGy_flat_parent_child_21.zip"      | "Missing fields"                                      |415   |"BXGY_AT_FLAT_DISCOUNT"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/BXGY_FLAT_WITH_SKU/BxGy_flat_parent_child_22.zip"                   |"BxGy_flat_parent_child_22.zip"      | "Missing fields"                                      |415   |"BXGY_AT_FLAT_DISCOUNT"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/BXGY_FLAT_WITH_SKU/BxGy_flat_parent_child_23.zip"                   |"BxGy_flat_parent_child_23.zip"      | "Missing fields-MBV"                                 |415   |"BXGY_AT_FLAT_DISCOUNT"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/BXGY_FLAT_WITH_SKU/BxGy_flat_parent_child_24.zip"                   |"BxGy_flat_parent_child_24.zip"      | "Missing fields-fcSKUCoupon"                         |415   |"BXGY_AT_FLAT_DISCOUNT"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/BXGY_FLAT_WITH_SKU/BxGy_flat_parent_child_25.zip"                   |"BxGy_flat_parent_child_25.zip"      | "Payment Coupon"                                     |201   |"BXGY_AT_FLAT_DISCOUNT"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/BXGY_FLAT_WITH_SKU/BxGy_flat_parent_child_26.zip"                   |"BxGy_flat_parent_child_26.zip"      | "Future Coupons"                                     |201   |"BXGY_AT_FLAT_DISCOUNT"      |200         |
# |"../helperFiles/files/b2c_bulk_uploads/BXGY_FLAT_WITH_SKU/BxGy_flat_parent_child_27.zip"                   |"BxGy_flat_parent_child_27.zip"      | "Duplicate Title"                                    |201   |"BXGY_AT_FLAT_DISCOUNT"      |200         |

  |"../helperFiles/files/b2c_bulk_uploads/BXGY_PERCENT_WITH_SKU/BxGy_percent_parent_child_1.zip"                    |"BxGy_percent_parent_child_1.zip"       | "Valid without min Bill Conditon"                    |201   |"BXGY_AT_PERCENTAGE_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_PERCENT_WITH_SKU/BxGy_percent_parent_child_2.zip"                    |"BxGy_percent_parent_child_2.zip"       |" Valid with min Bill Condition"                      |201   |"BXGY_AT_PERCENTAGE_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_PERCENT_WITH_SKU/BxGy_percent_parent_child_3.zip"                    |"BxGy_percent_parent_child_3.zip"       | "Negative value for min Bill Condition"              |415   |"BXGY_AT_PERCENTAGE_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_PERCENT_WITH_SKU/BxGy_percent_parent_child_4.zip"                    |"BxGy_percent_parent_child_4.zip"       | "junk value for min Bill condition"                  |415   |"BXGY_AT_PERCENTAGE_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_PERCENT_WITH_SKU/BxGy_percent_parent_child_5.zip"                    |"BxGy_percent_parent_child_5.zip"       | "valid file and decimal value for min Bill Condition"|201   |"BXGY_AT_PERCENTAGE_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_PERCENT_WITH_SKU/BxGy_percent_parent_child_6.zip"                    |"BxGy_percent_parent_child_6.zip"       | "without merchant group"                             |415   |"BXGY_AT_PERCENTAGE_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_PERCENT_WITH_SKU/BxGy_percent_parent_child_7.zip"                    |"BxGy_percent_parent_child_7.zip"       | "from date is greater than to date"                  |415   |"BXGY_AT_PERCENTAGE_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_PERCENT_WITH_SKU/BxGy_percent_parent_child_8.zip"                    |"BxGy_percent_parent_child_8.zip"       | "redeem caps are negative"                           |415   |"BXGY_AT_PERCENTAGE_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_PERCENT_WITH_SKU/BxGy_percent_parent_child_9.zip"                    |"BxGy_percent_parent_child_9.zip"       | "SkuID is negative"                                  |415   |"BXGY_AT_PERCENTAGE_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_PERCENT_WITH_SKU/BxGy_percent_parent_child_10.zip"                   |"BxGy_percent_parent_child_10.zip"      | "without b2c coupon title"                           |415   |"BXGY_AT_PERCENTAGE_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_PERCENT_WITH_SKU/BxGy_percent_parent_child_11.zip"                   |"BxGy_percent_parent_child_11.zip"      | "without date"                                       |415   |"BXGY_AT_PERCENTAGE_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_PERCENT_WITH_SKU/BxGy_percent_parent_child_12.zip"                   |"BxGy_percent_parent_child_12.zip"      | "without redeem caps"                                |415   |"BXGY_AT_PERCENTAGE_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_PERCENT_WITH_SKU/BxGy_percent_parent_child_13.zip"                   |"BxGy_percent_parent_child_13.zip"      | "redeem caps & all numeric fields with letter 'e'"   |415   |"BXGY_AT_PERCENTAGE_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_PERCENT_WITH_SKU/BxGy_percent_parent_child_14.zip"                   |"BxGy_percent_parent_child_14.zip"      | "field with spaces at start and end"                 |201   |"BXGY_AT_PERCENTAGE_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_PERCENT_WITH_SKU/BxGy_percent_parent_child_15.zip"                   |"BxGy_percent_parent_child_15.zip"      | "discount amount with .. i.e. 2..1"                  |415   |"BXGY_AT_PERCENTAGE_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_PERCENT_WITH_SKU/BxGy_percent_parent_child_16.zip"                   |"BxGy_percent_parent_child_16.zip"      | "wrong date format"                                  |415   |"BXGY_AT_PERCENTAGE_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_PERCENT_WITH_SKU/BxGy_percent_parent_child_17.zip"                   |"BxGy_percent_parent_child_17.zip"      | "-ve value for brand,merchant,reliance contr"        |415   |"BXGY_AT_PERCENTAGE_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_PERCENT_WITH_SKU/BxGy_percent_parent_child_18.zip"                   |"BxGy_percent_parent_child_18.zip"      | ">100%  for brand,merchant,reliance contr"           |415   |"BXGY_AT_PERCENTAGE_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_PERCENT_WITH_SKU/BxGy_percent_parent_child_19.zip"                   |"BxGy_percent_parent_child_19.zip"      | "valid brand,merchant,reliance contr"                |201   |"BXGY_AT_PERCENTAGE_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_PERCENT_WITH_SKU/BxGy_percent_parent_child_20.zip"                   |"BxGy_percent_parent_child_20.zip"      | "brand,merchant,reliance contr total>100"            |415   |"BXGY_AT_PERCENTAGE_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_PERCENT_WITH_SKU/BxGy_percent_parent_child_21.zip"                   |"BxGy_percent_parent_child_21.zip"      | "Missing fields"                                      |415   |"BXGY_AT_PERCENTAGE_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_PERCENT_WITH_SKU/BxGy_percent_parent_child_22.zip"                   |"BxGy_percent_parent_child_22.zip"      | "Missing fields"                                      |415   |"BXGY_AT_PERCENTAGE_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_PERCENT_WITH_SKU/BxGy_percent_parent_child_23.zip"                   |"BxGy_percent_parent_child_23.zip"      | "Missing fields-MBV"                                  |415   |"BXGY_AT_PERCENTAGE_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_PERCENT_WITH_SKU/BxGy_percent_parent_child_24.zip"                   |"BxGy_percent_parent_child_24.zip"      | "Missing fields-fcSKUCoupon"                          |415   |"BXGY_AT_PERCENTAGE_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_PERCENT_WITH_SKU/BxGy_percent_parent_child_25.zip"                   |"BxGy_percent_parent_child_25.zip"      | "Payment Coupon"                                      |201   |"BXGY_AT_PERCENTAGE_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_PERCENT_WITH_SKU/BxGy_percent_parent_child_26.zip"                   |"BxGy_percent_parent_child_26.zip"      | "Future Coupons"                                      |201   |"BXGY_AT_PERCENTAGE_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_PERCENT_WITH_SKU/BxGy_percent_parent_child_27.zip"                   |"BxGy_percent_parent_child_27.zip"      | "Discount Percent >100"                               |415   |"BXGY_AT_PERCENTAGE_DISCOUNT"      |200         |
#  |"../helperFiles/files/b2c_bulk_uploads/BXGY_PERCENT_WITH_SKU/BxGy_percent_parent_child_28.zip"                   |"BxGy_percent_parent_child_28.zip"      | "Duplicate Title"                                      |201   |"BXGY_AT_PERCENTAGE_DISCOUNT"      |200         |


  Scenario Outline:: B2B coupon codes Bulk Upload
    Given path '/coupons/v1/coupons/b2b/bulk-upload'
    * print "<============== file_description ==============>", <file_description>
    * def path = <path>
    * def updateB2BBulkUploadCSV = helperMethods.B2B_BulkUpload(path)
    * def temp = karate.readAsString('../helperFiles/files/flatDiscountTemplate1.csv')
    And multipart file B2BFile = { value: '#(temp)', filename: 'flatDiscountTemplate1.csv', contentType: 'text/csv' }
    And headers headerJson
    When method post
    * def result = call read('support.feature@b2b_coupon_bulk_upload_log') {requestHeader: #(headerJson)}
    * def Id = call getId result.response
    * print "<<<<<<<<<<<<<<<<<< log_Id >>>>>>>>>>>>>>", Id
    Then status <status>
    Given path '/coupons/v1/coupons/b2b/download-outputFile/'+Id
    And headers headerJson
    When method get

    Examples:
      | path                                                                                   |file_description|status|
      |"src/test/java/executables/helperFiles/files/b2b_bulk_uploads/flatDiscountTemplate.csv" |"Valid Data"    |201   |

  
  Scenario Outline: B2B coupons bulk upload <discount_type> with data <file_description>

    * eval sleep(1000)
    #    Creation of B2B coupon by uploading the create file.
    Given path '/coupons/v1/coupons/b2b-upload/createjob'
    * print "<============== file_description ==============>", <file_description>
    * def path = <path>
    * def updateB2BBulkUploadCSV = helperMethods.B2B_coupon_BulkUpload(path, discount_type)
    * def temp = karate.readAsString('../helperFiles/files/flatDiscountTemplate1.csv')
    And multipart file B2BFile = { value: '#(temp)', filename: 'flatDiscountTemplate1.csv', contentType: 'text/csv' }
    And multipart field discountType = <discount_type>
    And headers headerJson
    When method post
    # get the upload ID of the file
    * def result = call read('support.feature@b2b_coupon_bulk_upload_log') {requestHeader: #(headerJson)}
    * def Id = result.response["data"][0]["id"]
    * print "<<<<<<<<<<<<<<<<<< log_Id >>>>>>>>>>>>>>", Id
    Then status <status>
    #    Approval of B2B coupon
    Given path '/v1/coupons/maker-checker/'+Id+'/status-approval'
    And request {"approved":true,"comments":""}
    * set headerJson.Content-Type = 'application/json'
    And headers headerJson
    When method post
    Then status 200
    #    cron of B2B coupon for final approval
    Given path '/v1/coupons/maker-checker/b2b-upload/trigger/B2B_CREATE'
    And request {}
    When method post
    # Download of B2B coupon success file
    Then call read('support.feature@download_b2b_bulk_upload_file') {"Id": #(Id)}
    Then status <cron_status>

      Examples:
      | path                                                                                                  |file_description                                           |status|discount_type     |cron_status|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_1.csv" |"with MAS ID and merchant group"                           |415   |"PERCENT_DISCOUNT"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_2.csv" |"valid file and decimal value for discount amount"         |201   |"PERCENT_DISCOUNT"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_3.csv" |"without MAS ID and merchant group"                        |415   |"PERCENT_DISCOUNT"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_4.csv" |"from date is greater than to date"                        |415   |"PERCENT_DISCOUNT"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_5.csv" |"redeem caps are negative"                                 |415   |"PERCENT_DISCOUNT"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_6.csv" |"SkuID is negative"                                        |415   |"PERCENT_DISCOUNT"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_7.csv" |"quantity,merchant grp,discount% &max discount  negative"  |415   |"PERCENT_DISCOUNT"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_8.csv" |"b2c coupon id and merchant group are not related"         |415   |"PERCENT_DISCOUNT"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_9.csv" |"b2c coupon id and MAS ID are not related"                 |201   |"PERCENT_DISCOUNT"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_10.csv"|"without b2b coupon title"                                 |415   |"PERCENT_DISCOUNT"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_11.csv"|"without date"                                             |415   |"PERCENT_DISCOUNT"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_12.csv"|"with status 16"                                           |415   |"PERCENT_DISCOUNT"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_13.csv"|"without b2c coupon id"                                    |201   |"PERCENT_DISCOUNT"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_14.csv"|"with sku quantity > 2"                                    |201   |"PERCENT_DISCOUNT"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_15.csv"|"without redeem caps"                                      |415   |"PERCENT_DISCOUNT"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_16.csv"|"redeem caps and all the numeric fields with letter 'e'"   |415   |"PERCENT_DISCOUNT"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_17.csv"|"field with spaces at start and end"                       |201   |"PERCENT_DISCOUNT"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_18.csv"|"discount amount with .. i.e. 2..1"                        |415   |"PERCENT_DISCOUNT"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_19.csv"|"field with spaces at middle"                              |201   |"PERCENT_DISCOUNT"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_20.csv"|"wrong date format"                                        |415   |"PERCENT_DISCOUNT"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_21.csv"|"redemption caps in float"                                 |415   |"PERCENT_DISCOUNT"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_22.csv"|"testing max limit of coupon name and sku name"            |415   |"PERCENT_DISCOUNT"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_23.csv"|"Vendor funding-No and Vendor% >0"      				   |415   |"PERCENT_DISCOUNT"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_24.csv"|"Vendor funding-Yes and Vendor% <0"      				   |415   |"PERCENT_DISCOUNT"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_25.csv"|"Vendor funding-Yes and Vendor% >100"      				   |415   |"PERCENT_DISCOUNT"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_27.csv"|"Flash coupons"               				               |201   |"PERCENT_DISCOUNT"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_28.csv"| "with conditional coupon id"                              |201   |"PERCENT_DISCOUNT"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_29.csv"|"mbv with decimal numbers"                             	   |201   |"PERCENT_DISCOUNT"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_30.csv"|"mbv with space between numbers"                           |415   |"PERCENT_DISCOUNT"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_31.csv"|"mbv with sting in place of numbers"                       |415   |"PERCENT_DISCOUNT"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_32.csv"|"mbv with special chars in place of numbers"               |415   |"PERCENT_DISCOUNT"|200|
      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_33.csv"|"b2b verticals valid  'All','KIRANA', 'HORECA','null'."                    |201   |"PERCENT_DISCOUNT"|200|
      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_34.csv"|"b2b verticals valid  lower case 'All','Kirana', 'Horeca','Null'."         |201   |"PERCENT_DISCOUNT"|200|
      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_35.csv"|"b2b verticals invalid  'every','Karina', 'Heroca','empty'. "              |415   |"PERCENT_DISCOUNT"|200|
      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_36.csv"|"b2b verticals with numbers "                                              |415   |"PERCENT_DISCOUNT"|200|
      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_37.csv"|"b2b verticals with special characters "                                   |415   |"PERCENT_DISCOUNT"|200|
      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_38.csv"|"b2b verticals section having space "                                      |415   |"PERCENT_DISCOUNT"|200|
      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_39.csv"|"b2b verticals section having space between vertical types "               |415   |"PERCENT_DISCOUNT"|200|



#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_1.csv" |"with MAS ID and merchant group"                          |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_2.csv" |"valid file and decimal value for discount amount"         |201   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_3.csv" |"without MAS ID and merchant group"                       |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_4.csv" |"from date is greater than to date"                       |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_5.csv" |"redeem caps are negative"                                |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_6.csv" |"SkuID is negative"                                       |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_7.csv" |"quantity, merchant group, discount amount are negatives" |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_8.csv" |"b2c coupon id and merchant group are not related"        |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_9.csv" |"b2c coupon id and MAS ID are not related"                |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_10.csv"|"without b2b coupon title"                                |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_11.csv"|"without date"                                            |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_12.csv"|"with status 16"                                          |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_13.csv"|"without b2c coupon id"                                   |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_14.csv"|"with sku quantity > 2"                                   |201   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_15.csv"|"without redeem caps"                                     |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_16.csv"|"redeem caps and all the numeric fields with letter 'e'"  |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_17.csv"|"field with spaces at start and end"                      |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_18.csv"|"discount amount with .. i.e. 2..1"                       |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_19.csv"|"field with spaces at middle"                             |201   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_20.csv"|"wrong date format"                                       |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_21.csv"|"redemption caps in float"                                |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_22.csv"|"testing max limit of coupon name and sku name"           |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_23.csv"|"Vendor funding-No and Vendor% >0"                             |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_24.csv"|"Vendor funding-Yes and Vendor% <0"                            |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_25.csv"|"Vendor funding-Yes and Vendor% >100"                                |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_27.csv"|"With conditional coupon id"                                         |201   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_28.csv"|"Flash Coupons"                                              |201   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_29.csv"|"mbv with decimal numbers"                                     |201   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_30.csv"|"mbv with space between numbers"                          |201   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_31.csv"|"mbv with sting in place of numbers"                      |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_32.csv"|"mbv with special chars in place of numbers"              |415   |"FLAT_DISCOUNT_ON_SKU"|200|
      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_33.csv"|"b2b verticals valid  'All','KIRANA', 'HORECA','null'."            |201   |"FLAT_DISCOUNT_ON_SKU"|200|
      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_34.csv"|"b2b verticals valid  lower case 'All','Kirana', 'Horeca','Null'." |201   |"FLAT_DISCOUNT_ON_SKU"|200|
      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_35.csv"|"b2b verticals invalid  'every','Karina', 'Heroca','empty'. "      |415   |"FLAT_DISCOUNT_ON_SKU"|200|
      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_36.csv"|"b2b verticals with numbers "                                      |415   |"FLAT_DISCOUNT_ON_SKU"|200|
      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_37.csv"|"b2b verticals with special characters "                           |415   |"FLAT_DISCOUNT_ON_SKU"|200|
      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_38.csv"|"b2b verticals section having space "                              |415   |"FLAT_DISCOUNT_ON_SKU"|200|
      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_39.csv"|"b2b verticals section having space between vertical types "       |415   |"FLAT_DISCOUNT_ON_SKU"|200|

#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_1.csv" |"with MAS ID and merchant group"                          |415   |"SKU_AT_FIXED_PRICE"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_2.csv" |"valid file and decimal value for discount amount"         |201   |"SKU_AT_FIXED_PRICE"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_3.csv" |"without MAS ID and merchant group"                       |415   |"SKU_AT_FIXED_PRICE"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_4.csv" |"from date is greater than to date"                       |415   |"SKU_AT_FIXED_PRICE"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_5.csv" |"redeem caps are negative"                                |415   |"SKU_AT_FIXED_PRICE"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_6.csv" |"SkuID is negative"                                       |415   |"SKU_AT_FIXED_PRICE"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_7.csv" |"quantity, merchant group, discount amount are negatives" |415   |"SKU_AT_FIXED_PRICE"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_8.csv" |"b2c coupon id and merchant group are not related"        |415   |"SKU_AT_FIXED_PRICE"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_9.csv" |"b2c coupon id and MAS ID are not related"                |415   |"SKU_AT_FIXED_PRICE"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_10.csv"|"without b2b coupon title"                                |415   |"SKU_AT_FIXED_PRICE"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_11.csv"|"without date"                                            |415   |"SKU_AT_FIXED_PRICE"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_12.csv"|"with status 16"                                          |415   |"SKU_AT_FIXED_PRICE"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_13.csv"|"without b2c coupon id"                                   |415   |"SKU_AT_FIXED_PRICE"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_14.csv"|"with sku quantity > 2"                                   |201   |"SKU_AT_FIXED_PRICE"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_15.csv"|"without redeem caps"                                     |415   |"SKU_AT_FIXED_PRICE"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_16.csv"|"redeem caps and all the numeric fields with letter 'e'"  |415   |"SKU_AT_FIXED_PRICE"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_17.csv"|"field with spaces at start and end"                      |415   |"SKU_AT_FIXED_PRICE"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_18.csv"|"discount amount with .. i.e. 2..1"                       |415   |"SKU_AT_FIXED_PRICE"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_19.csv"|"field with spaces at middle"                             |201   |"SKU_AT_FIXED_PRICE"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_20.csv"|"wrong date format"                                       |415   |"SKU_AT_FIXED_PRICE"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_21.csv"|"redemption caps in float"                                |415   |"SKU_AT_FIXED_PRICE"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_22.csv"|"testing max limit of coupon name and sku name"           |415   |"SKU_AT_FIXED_PRICE"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_23.csv"|"Vendor funding-No and Vendor% >0"                           |415   |"SKU_AT_FIXED_PRICE"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_24.csv"|"Vendor funding-Yes and Vendor% <0"                                |415   |"SKU_AT_FIXED_PRICE"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_25.csv"|"Vendor funding-Yes and Vendor% >100"                              |415   |"SKU_AT_FIXED_PRICE"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_27.csv"|"with conditional coupon id"                                       |201   |"SKU_AT_FIXED_PRICE"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_28.csv"|"Flash Coupons"                                            |201   |"SKU_AT_FIXED_PRICE"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_29.csv"|"mbv with decimal numbers"                                   |201   |"SKU_AT_FIXED_PRICE"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_30.csv"|"mbv with space between numbers"                          |201   |"SKU_AT_FIXED_PRICE"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_31.csv"|"mbv with sting in place of numbers"                      |415   |"SKU_AT_FIXED_PRICE"|200|
#      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_32.csv"|"mbv with special chars in place of numbers"              |415   |"SKU_AT_FIXED_PRICE"|200|
      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_33.csv"|"b2b verticals valid  'All','KIRANA', 'HORECA','null'."            |201   |"SKU_AT_FIXED_PRICE"|200|
      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_34.csv"|"b2b verticals valid  lower case 'All','Kirana', 'Horeca','Null'." |201   |"SKU_AT_FIXED_PRICE"|200|
      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_35.csv"|"b2b verticals invalid  'every','Karina', 'Heroca','empty'. "      |415   |"SKU_AT_FIXED_PRICE"|200|
      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_36.csv"|"b2b verticals with numbers "                                      |415   |"SKU_AT_FIXED_PRICE"|200|
      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_37.csv"|"b2b verticals with special characters "                           |415   |"SKU_AT_FIXED_PRICE"|200|
      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_38.csv"|"b2b verticals section having space "                              |415   |"SKU_AT_FIXED_PRICE"|200|
      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_39.csv"|"b2b verticals section having space between vertical types "       |415   |"SKU_AT_FIXED_PRICE"|200|

  
  Scenario Outline: B2B coupons bulk edit <discount_type> with data <file_description>
    * eval sleep(1000)
    #   Editing of B2B coupon by uploading the b2b edit file.
    Given path '/coupons/v1/coupons/b2b-update/createjob'
    * print "<============== file_description ==============>", <file_description>
    * def updateB2BBulkUploadCSV = helperMethods.B2B_coupon_Bulk_edit(<path>)
    * def temp = karate.readAsString('../helperFiles/files/flatDiscountTemplate1.csv')
    And multipart file B2BFile = { value: '#(temp)', filename: 'flatDiscountTemplate1.csv', contentType: 'text/csv' }
    And multipart field discountType = <discount_type>
    And headers headerJson
    When method post
    * def result = callonce read('support.feature@b2b_coupon_bulk_edit_log') {requestHeader: #(headerJson)}
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
    # Download of B2B coupon success file
    Then call read('support.feature@download_b2b_bulk_upload_file') {"Id": #(Id)}
    Then status <cron_status>
    * def b2b_coupons = db.readRows("SELECT * FROM B2B_COUPON WHERE ID IN (\'" +apiComponents["b2b_coupon_idFor_bulk_upload"]+ "\')")
    * print b2b_coupons
    * match b2b_coupons[0] contains <validations>

    Examples:
      | path                                                                                                           |file_description                                          |status|discount_type         |cron_status|validations|
#      |apiComponents["b2b_coupon_bulk_edit_path"]+"/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_1.csv" |"making the discount amount as 0"                                      |201   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_2.csv" |"making the discount amout as negative"                   |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_3.csv" |"without b2bCoupon id"                                    |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_4.csv" |"valid update"                                            |201   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_5.csv" |"invalid date format"                                     |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_6.csv" |"non existing b2b coupon"                                 |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_7.csv" |"without to date"                                         |201   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_8.csv" |"b2b coupon id with e"                                    |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_9.csv" |"spaces in front and end of the details except dates"     |201   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_10.csv"|"editing same coupon twice"                               |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_11.csv"|"without both the dates"                                  |201   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_12.csv"|"with status other than 16 or 0"                          |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_13.csv"|"without status"                                          |201   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_14.csv"|"without discounts"                                       |201   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_15.csv"|"without discount field(coma also removed)"               |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_16.csv"|"discount with e"                                         |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_17.csv"|"decimal value with extra dot"                            |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_18.csv"|"from date first"                                         |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_19.csv"|"creating future coupons"                                 |201   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_20.csv"|"field with spaces at middle"                             |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_21.csv"|"extra field created"                                     |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_22.csv"|"testing"                                                 |201   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_23.csv"|"testing 10k edit of b2b coupons"                         |201   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_24.csv"|"Expiring the coupons"                                    |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_25.csv"|"vendor funding no, vendor% >0"                           |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_26.csv"|"vendor funding yes, vendor% <0"                          |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_27.csv"|"vendor funding yes, vendor% >100"                        |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_28.csv"|"vendor funding no, vendor% 0"                            |201   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_29.csv"|"vendor funding Yes, vendor% valid"                       |201   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_30.csv"|"delink no  with conditional couponid"                    |201   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_31.csv"|"delink yes, conditional coupon blank "                   |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_32.csv"|"delink blank"                                            |201   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_33.csv"|"delink yes, conditional coupon invalid"                  |415   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_34.csv"|"flashcoupon"                                             |201   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_35.csv"|"mbv with decimal numbers"                                |201   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_36.csv"|"mbv with space between numbers"                          |201   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_37.csv"|"mbv with sting in place of numbers"                      |201   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_38.csv"|"mbv with special chars in place of numbers"              |201   |"FLAT_DISCOUNT_ON_SKU"|200|
#      |apiComponents["b2b_coupon_bulk_edit_path"]+"/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_39.csv"               |"keeping campaign type field as blank "                  |201   |"FLAT_DISCOUNT_ON_SKU"|200|{"CAMPAIGN_ID":'#? _> 0'} |
      |apiComponents["b2b_coupon_bulk_edit_path"]+"/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_40.csv"               |"verticals edit with valid data "                         |201   |"FLAT_DISCOUNT_ON_SKU"|200|{"CAMPAIGN_ID":'#? _> 0'} |
      |apiComponents["b2b_coupon_bulk_edit_path"]+"/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_41.csv"               |"verticals edit with invalid data "                       |400   |"FLAT_DISCOUNT_ON_SKU"|200|{"CAMPAIGN_ID":'#? _> 0'} |
      |apiComponents["b2b_coupon_bulk_edit_path"]+"/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_42.csv"               |"verticals edit with blank data "                         |201   |"FLAT_DISCOUNT_ON_SKU"|200|{"CAMPAIGN_ID":'#? _> 0'} |
      |apiComponents["b2b_coupon_bulk_edit_path"]+"/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_43.csv"               |"verticals edit section with space  "                     |201   |"FLAT_DISCOUNT_ON_SKU"|200|{"CAMPAIGN_ID":'#? _> 0'} |
      |apiComponents["b2b_coupon_bulk_edit_path"]+"/FLAT_DISCOUNT_ON_SKU/flatDiscountEditTemplate_44.csv"               |"verticals edit with number "                             |201   |"FLAT_DISCOUNT_ON_SKU"|200|{"CAMPAIGN_ID":'#? _> 0'} |


#      |apiComponents["b2b_coupon_bulk_edit_path"]+"/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_1.csv" |"making the discount percentage as 0"                                   |201   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_2.csv" |"making the discount percentage as negative"              |415   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_3.csv" |"without b2bCoupon id"                                    |415   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_4.csv" |"valid update"                                            |201   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_5.csv" |"invalid date format"                                     |415   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_6.csv" |"non existing b2b coupon"                                 |415   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_7.csv" |"without to date"                                         |201   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_8.csv" |"b2b coupon id with e"                                    |415   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_9.csv" |"spaces in front and end of the details except dates"     |201   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_10.csv"|"editing same coupon twice"                               |415   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_11.csv"|"without both the dates"                                  |201   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_12.csv"|"with status other than 16 or 0"                          |415   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_13.csv"|"without status"                                          |201   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_14.csv"|"without discounts"                                       |201   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_15.csv"|"without discount field(coma also removed)"               |415   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_16.csv"|"discount with e"                                         |415   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_17.csv"|"decimal value with extra dot"                            |415   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_18.csv"|"from date first"                                         |415   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_19.csv"|"creating future coupons"                                 |201   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_20.csv"|"field with spaces at middle"                             |415   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_21.csv"|"extra field created"                                     |415   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_22.csv"|"testing"                                                 |201   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_23.csv"|"testing 10k edit of b2b coupons"                         |201   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_24.csv"|"Expiring the coupons"                                    |415   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_25.csv"|"vendor funding no, vendor% >0"                           |415   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_26.csv"|"vendor funding yes, vendor% <0"                          |415   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_27.csv"|"vendor funding yes, vendor% >100"                        |415   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_28.csv"|"vendor funding no, vendor% 0"                            |201   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_29.csv"|"vendor funding Yes, vendor% valid"                       |201   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_30.csv"|"delink no  with conditional couponid"                    |201   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_31.csv"|"delink yes, conditional coupon blank "                   |415   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_32.csv"|"delink blank  "                                          |201   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_33.csv"|"delink yes, conditional coupon invalid"                  |415   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_34.csv"|"Flash Couponss       "                                   |201   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_35.csv"|"Max discount negative"                                   |415   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_36.csv"|"mbv with decimal numbers"                                |415   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_37.csv"|"mbv with space between numbers"                          |415   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_38.csv"|"mbv with sting in place of numbers"                      |415   |"PERCENT_DISCOUNT"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/PERCENT_DISCOUNT/Percent_Discount_EditTemplate_39.csv"|"mbv with special chars in place of numbers"              |415   |"PERCENT_DISCOUNT"|200|
      |apiComponents["b2b_coupon_bulk_edit_path"]+"/PERCENT_DISCOUNT/flatDiscountEditTemplate_40.csv"               |"verticals edit with valid data "                         |201   |"PERCENT_DISCOUNT"|200|{"CAMPAIGN_ID":'#? _> 0'} |
      |apiComponents["b2b_coupon_bulk_edit_path"]+"/PERCENT_DISCOUNT/flatDiscountEditTemplate_41.csv"               |"verticals edit with invalid data "                       |400   |"PERCENT_DISCOUNT"|200|{"CAMPAIGN_ID":'#? _> 0'} |
      |apiComponents["b2b_coupon_bulk_edit_path"]+"/PERCENT_DISCOUNT/flatDiscountEditTemplate_42.csv"               |"verticals edit with blank data "                         |201   |"PERCENT_DISCOUNT"|200|{"CAMPAIGN_ID":'#? _> 0'} |
      |apiComponents["b2b_coupon_bulk_edit_path"]+"/PERCENT_DISCOUNT/flatDiscountEditTemplate_43.csv"               |"verticals edit section with space  "                     |201   |"PERCENT_DISCOUNT"|200|{"CAMPAIGN_ID":'#? _> 0'} |
      |apiComponents["b2b_coupon_bulk_edit_path"]+"/PERCENT_DISCOUNT/flatDiscountEditTemplate_44.csv"               |"verticals edit with number "                             |201   |"PERCENT_DISCOUNT"|200|{"CAMPAIGN_ID":'#? _> 0'} |

#      |apiComponents["b2b_coupon_bulk_edit_path"]+"/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_1.csv" |"making the discount amount as 0"                                       |201   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_2.csv" |"making the discount amout as negative"                   |415   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_3.csv" |"without b2bCoupon id"                                    |415   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_4.csv" |"valid update"                                            |201   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_5.csv" |"invalid date format"                                     |415   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_6.csv" |"non existing b2b coupon"                                 |415   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_7.csv" |"without to date"                                         |201   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_8.csv" |"b2b coupon id with e"                                    |415   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_9.csv" |"spaces in front and end of the details except dates"     |201   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_10.csv"|"editing same coupon twice"                               |415   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_11.csv"|"without both the dates"                                  |201   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_12.csv"|"with status other than 16 or 0"                          |415   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_13.csv"|"without status"                                          |201   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_14.csv"|"without discounts"                                       |201   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_15.csv"|"without discount field(coma also removed)"               |415   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_16.csv"|"discount with e"                                         |415   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_17.csv"|"decimal value with extra dot"                            |415   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_18.csv"|"from date first"                                         |415   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_19.csv"|"creating future coupons"                                 |201   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_20.csv"|"field with spaces at middle"                             |415   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_21.csv"|"extra field created"                                     |415   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_22.csv"|"testing"                                                 |201   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_23.csv"|"testing 10k edit of b2b coupons"                         |201   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_24.csv"|"Expiring the coupons"                                    |415   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_25.csv"|"vendor funding no, vendor% >0"                           |415   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_26.csv"|"vendor funding yes, vendor% <0"                          |415   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_27.csv"|"vendor funding yes, vendor% >100"                        |415   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_28.csv"|"vendor funding no, vendor% 0"                            |201   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_29.csv"|"vendor funding Yes, vendor% valid"                       |201   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_30.csv"|"delink no  with conditional couponid"                    |201   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_31.csv"|"delink yes, conditional coupon blank "                   |415   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_32.csv"|"delink blank  "                                          |201   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_33.csv"|"delink yes, conditional coupon invalid"                  |415   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_34.csv"|"Flash coupons"                                           |201   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_35.csv"|"mbv with decimal numbers"                                |201   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_36.csv"|"mbv with space between numbers"                          |201   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_37.csv"|"mbv with sting in place of numbers"                      |201   |"SKU_AT_FIXED_PRICE"|200|
#      |"src/test/java/executables/helperFiles/files/b2b_bulk_edit/SKU_AT_FIXED_PRICE/Sku_At_Fixed_Price_EditTemplate_38.csv"|"mbv with special chars in place of numbers"              |201   |"SKU_AT_FIXED_PRICE"|200|
      |apiComponents["b2b_coupon_bulk_edit_path"]+"/SKU_AT_FIXED_PRICE/flatDiscountEditTemplate_40.csv"               |"verticals edit with valid data "                         |201   |"SKU_AT_FIXED_PRICE"|200|{"CAMPAIGN_ID":'#? _> 0'} |
      |apiComponents["b2b_coupon_bulk_edit_path"]+"/SKU_AT_FIXED_PRICE/flatDiscountEditTemplate_41.csv"               |"verticals edit with invalid data "                       |400   |"SKU_AT_FIXED_PRICE"|200|{"CAMPAIGN_ID":'#? _> 0'} |
      |apiComponents["b2b_coupon_bulk_edit_path"]+"/SKU_AT_FIXED_PRICE/flatDiscountEditTemplate_42.csv"               |"verticals edit with blank data "                         |201   |"SKU_AT_FIXED_PRICE"|200|{"CAMPAIGN_ID":'#? _> 0'} |
      |apiComponents["b2b_coupon_bulk_edit_path"]+"/SKU_AT_FIXED_PRICE/flatDiscountEditTemplate_43.csv"               |"verticals edit section with space  "                     |201   |"SKU_AT_FIXED_PRICE"|200|{"CAMPAIGN_ID":'#? _> 0'} |
      |apiComponents["b2b_coupon_bulk_edit_path"]+"/SKU_AT_FIXED_PRICE/flatDiscountEditTemplate_44.csv"               |"verticals edit with number "                             |201   |"SKU_AT_FIXED_PRICE"|200|{"CAMPAIGN_ID":'#? _> 0'} |

  Scenario Outline: promotions bulk upload
    Given path '/v1/cms/promotions/bulk-upload'
    * print "<============== file_description ==============>", <file_description>
    * def path = <path>
    * def updateB2BBulkUploadCSV = helperMethods.Promotions_BulkUpload(path)
    * def temp = karate.readAsString('../helperFiles/files/flatDiscountTemplate1.csv')
    And multipart file PromotionFile = { value: '#(temp)', filename: 'flatDiscountTemplate1.csv', contentType: 'text/csv' }
    And headers headerJson
    When method post
    * def result = call read('support.feature@promotion_bulk_upload_log') {requestHeader: #(headerJson)}
    * def Id = call getId result.response
    * print "<<<<<<<<<<<<<<<<<< log_Id >>>>>>>>>>>>>>", Id
    Then status <status>
    Given path '/coupons/v1/coupons/b2b/download-outputFile/'+Id
    And headers headerJson
    When method get

    Examples:
      | path                                                                                     |file_description                                          |status|
#      |"src/test/java/executables/helperFiles/files/promotions_bulk_upload/Promotion-Upload_1.csv" |"MAS ID and merchant group"                               |415   |
      |"src/test/java/executables/helperFiles/files/promotions_bulk_upload/Promotion-Upload_2.csv" |"valid file and decimal value for discount amount"        |201   |
#      |"src/test/java/executables/helperFiles/files/promotions_bulk_upload/Promotion-Upload_3.csv" |"without MAS ID and merchant group"                       |415   |
#      |"src/test/java/executables/helperFiles/files/promotions_bulk_upload/Promotion-Upload_4.csv" |"from date is greater than to date"                       |415   |
#      |"src/test/java/executables/helperFiles/files/promotions_bulk_upload/Promotion-Upload_5.csv" |"redeem caps are negative"                                |415   |
#      |"src/test/java/executables/helperFiles/files/promotions_bulk_upload/Promotion-Upload_6.csv" |"SkuID is negative"                                       |415   |
#      |"src/test/java/executables/helperFiles/files/promotions_bulk_upload/Promotion-Upload_7.csv" |"quantity, merchant group, discount amount are negatives" |415   |
#      |"src/test/java/executables/helperFiles/files/promotions_bulk_upload/Promotion-Upload_8.csv" |"b2c coupon id and merchant group are not related"        |415   |
#      |"src/test/java/executables/helperFiles/files/promotions_bulk_upload/Promotion-Upload_9.csv" |"b2c coupon id and MAS ID are not related"                |415   |
#      |"src/test/java/executables/helperFiles/files/promotions_bulk_upload/Promotion-Upload_10.csv"|"without b2b coupon title"                                |415   |
#      |"src/test/java/executables/helperFiles/files/promotions_bulk_upload/Promotion-Upload_11.csv"|"without date"                                            |415   |
#      |"src/test/java/executables/helperFiles/files/promotions_bulk_upload/Promotion-Upload_12.csv"|"with status 16"                                          |415   |
#      |"src/test/java/executables/helperFiles/files/promotions_bulk_upload/Promotion-Upload_13.csv"|"without b2c coupon id"                                   |415   |
#      |"src/test/java/executables/helperFiles/files/promotions_bulk_upload/Promotion-Upload_14.csv"|"with sku quantity > 2"                                   |201   |
#      |"src/test/java/executables/helperFiles/files/promotions_bulk_upload/Promotion-Upload_15.csv"|"without redeem caps"                                     |415   |
#      |"src/test/java/executables/helperFiles/files/promotions_bulk_upload/Promotion-Upload_16.csv"|"redeem caps and all the numeric fields with letter 'e'"  |415   |
#      |"src/test/java/executables/helperFiles/files/promotions_bulk_upload/Promotion-Upload_17.csv"|"field with spaces at start and end"                      |415   |
#      |"src/test/java/executables/helperFiles/files/promotions_bulk_upload/Promotion-Upload_18.csv"|"discount amount with .. i.e. 2..1"                       |415   |
#      |"src/test/java/executables/helperFiles/files/promotions_bulk_upload/Promotion-Upload_19.csv"|"field with spaces at middle"                             |201   |
#      |"src/test/java/executables/helperFiles/files/promotions_bulk_upload/Promotion-Upload_20.csv"|"wrong date format"                                       |415   |
#      |"src/test/java/executables/helperFiles/files/promotions_bulk_upload/Promotion-Upload_21.csv"|"redemption caps in float"                                |415   |
#      |"src/test/java/executables/helperFiles/files/promotions_bulk_upload/Promotion-Upload_22.csv"|"testing max limit of coupon name and sku name"           |415   |

  Scenario Outline: promotions bulk edit
    Given path '/v1/cms/promotions/bulk-update'
    * print "<============== file_description ==============>", <file_description>
    * def path = <path>
    * def updateB2BBulkUploadCSV = helperMethods.Promotions_BulkEdit(path)
    * def temp = karate.readAsString('../helperFiles/files/flatDiscountTemplate1.csv')
    And multipart file B2BFile = { value: '#(temp)', filename: 'flatDiscountTemplate1.csv', contentType: 'text/csv' }
    And headers headerJson
    When method post
    * def result = call read('support.feature@b2b_coupon_bulk_upload_log') {requestHeader: #(headerJson)}
    * def Id = call getId result.response
    * print "<<<<<<<<<<<<<<<<<< log_Id >>>>>>>>>>>>>>", Id
    Then status <status>
    Given path '/coupons/v1/coupons/b2b/download-outputFile/'+Id
    And headers headerJson
    When method get

    Examples:
      | path                                                                                     |file_description                                          |status|
      |"src/test/java/executables/helperFiles/files/promotion_bulk_edit/Promotion-Edit_1.csv" |"all valid details"                         |201   |
#      |"src/test/java/executables/helperFiles/files/promotion_bulk_edit/Promotion-Edit_2.csv" |"removing the discount value"                   |415   |
#      |"src/test/java/executables/helperFiles/files/promotion_bulk_edit/Promotion-Edit_3.csv" |"removing discount_value_max"                                    |415   |
#      |"src/test/java/executables/helperFiles/files/promotion_bulk_edit/Promotion-Edit_4.csv" |"removing active parameter"                                            |415   |
#      |"src/test/java/executables/helperFiles/files/promotion_bulk_edit/Promotion-Edit_5.csv" |"invalid date format"                                     |415   |
#      |"src/test/java/executables/helperFiles/files/promotion_bulk_edit/Promotion-Edit_6.csv" |"removing one of the to_date"                                 |415   |
#      |"src/test/java/executables/helperFiles/files/promotion_bulk_edit/Promotion-Edit_7.csv" |"removing one of the from_date"                                         |415   |
#      |"src/test/java/executables/helperFiles/files/promotion_bulk_edit/Promotion-Edit_8.csv" |"removing priority"                                    |415   |
#      |"src/test/java/executables/helperFiles/files/promotion_bulk_edit/Promotion-Edit_9.csv" |"negetive discount value"     |415   |
#      |"src/test/java/executables/helperFiles/files/promotion_bulk_edit/Promotion-Edit_10.csv"|"negetive discount_value_max"                               |415   |
#      |"src/test/java/executables/helperFiles/files/promotion_bulk_edit/Promotion-Edit_11.csv"|"1 in place of True in priority"                                  |415   |
#      |"src/test/java/executables/helperFiles/files/promotion_bulk_edit/Promotion-Edit_12.csv"|"negative value in priority"                          |415   |
#      |"src/test/java/executables/helperFiles/files/promotion_bulk_edit/Promotion-Edit_13.csv"|"priority out of bound"                                          |415   |
#      |"src/test/java/executables/helperFiles/files/promotion_bulk_edit/Promotion-Edit_14.csv"|"without min cart quant and min bill value"                                       |415   |
##      |"src/test/java/executables/helperFiles/files/promotion_bulk_edit/Promotion-Edit_15.csv"|"without discount field(coma also removed)"               |415   |
##      |"src/test/java/executables/helperFiles/files/promotion_bulk_edit/Promotion-Edit_16.csv"|"discount with e"                                         |415   |
##      |"src/test/java/executables/helperFiles/files/promotion_bulk_edit/Promotion-Edit_17.csv"|"decimal value with extra dot"                            |415   |
##      |"src/test/java/executables/helperFiles/files/promotion_bulk_edit/Promotion-Edit_18.csv"|"from date first"                                         |415   |
##      |"src/test/java/executables/helperFiles/files/promotion_bulk_edit/Promotion-Edit_19.csv"|"creating future coupons"                                 |201   |
##      |"src/test/java/executables/helperFiles/files/promotion_bulk_edit/Promotion-Edit_20.csv"|"field with spaces at middle"                             |415   |
##      |"src/test/java/executables/helperFiles/files/promotion_bulk_edit/Promotion-Edit_21.csv"|"extra field created"                                     |415   |
##      |"src/test/java/executables/helperFiles/files/promotion_bulk_edit/Promotion-Edit_22.csv"|"testing"                                                 |201   |
##      |"src/test/java/executables/helperFiles/files/promotion_bulk_edit/Promotion-Edit_23.csv"|"testing 10k edit of b2b coupons"                         |201   |
##      |"src/test/java/executables/helperFiles/files/promotion_bulk_edit/Promotion-Edit_24.csv"|"Expiring the coupons"                                    |415   |

  Scenario Outline: Vouchers bulk upload <file_description>.
    * def getVoucherId =
    """
    function(arg){
    return arg[0].id
    }
    """

    Given path '/coupons/v1/coupons/voucher/bulk-upload'
    * print "<============== file_description ==============>", <file_description>
    * def path = <path>
    * def updateVoucherBulkUploadCSV = helperMethods.Vouchers_BulkUpload(path)
    * def temp = karate.readAsString('../helperFiles/files/flatDiscountTemplate1.csv')
    And multipart file voucherFile = { value: '#(temp)', filename: 'flatDiscountTemplate1.csv', contentType: 'text/csv' }
    And headers headerJson
    When method post
    * def result = call read('support.feature@vouchers_bulk_upload_log') {requestHeader: #(headerJson)}
    * def Id = call getVoucherId result.response["data"]
    * print "<<<<<<<<<<<<<<<<<< log_Id >>>>>>>>>>>>>>", Id
    Then status <status>
    Given path '/coupons/v1/coupons/b2b/download-outputFile/'+Id
    And headers headerJson
    When method get

    Examples:
      | path                                                                                             |file_description                                          |status|
      |"src/test/java/executables/helperFiles/files/voucher_bulk_upload/voucherBulkUploadTemplate_1.csv" |"all valid details"                                       |201   |
#      |"src/test/java/executables/helperFiles/files/voucher_bulk_upload/voucherBulkUploadTemplate_2.csv" |"removing the discount amount"                            |415   |
#      |"src/test/java/executables/helperFiles/files/voucher_bulk_upload/voucherBulkUploadTemplate_3.csv" |"removing discount_value_max"                             |415   |
#      |"src/test/java/executables/helperFiles/files/voucher_bulk_upload/voucherBulkUploadTemplate_4.csv" |"removing active parameter"                               |415   |
#      |"src/test/java/executables/helperFiles/files/voucher_bulk_upload/voucherBulkUploadTemplate_5.csv" |"invalid date format"                                     |415   |
#      |"src/test/java/executables/helperFiles/files/voucher_bulk_upload/voucherBulkUploadTemplate_6.csv" |"removing one of the to_date"                             |415   |
#      |"src/test/java/executables/helperFiles/files/voucher_bulk_upload/voucherBulkUploadTemplate_7.csv" |"removing one of the from_date"                           |415   |
#      |"src/test/java/executables/helperFiles/files/voucher_bulk_upload/voucherBulkUploadTemplate_8.csv" |"autoApplicable other than 0 and 1"                       |415   |
#      |"src/test/java/executables/helperFiles/files/voucher_bulk_upload/voucherBulkUploadTemplate_9.csv" |"negetive discount value"                                 |415   |
#      |"src/test/java/executables/helperFiles/files/voucher_bulk_upload/voucherBulkUploadTemplate_10.csv"|"negetive discount_value_max"                             |415   |
#      |"src/test/java/executables/helperFiles/files/voucher_bulk_upload/voucherBulkUploadTemplate_11.csv"|"removing min bill amount"                                |415   |
#      |"src/test/java/executables/helperFiles/files/voucher_bulk_upload/voucherBulkUploadTemplate_12.csv"|"wrong 'funded by' value"                                 |415   |
#      |"src/test/java/executables/helperFiles/files/voucher_bulk_upload/voucherBulkUploadTemplate_13.csv"|"Wrong voucher type"                                      |415   |
#      |"src/test/java/executables/helperFiles/files/voucher_bulk_upload/voucherBulkUploadTemplate_14.csv"|"name with special symbols"                               |201   |
#      |"src/test/java/executables/helperFiles/files/voucher_bulk_upload/voucherBulkUploadTemplate_15.csv"|"Very long voucher title string expected is 100"         |415   |
#      |"src/test/java/executables/helperFiles/files/voucher_bulk_upload/voucherBulkUploadTemplate_16.csv"|"discount with e"                                        |415   |
#      |"src/test/java/executables/helperFiles/files/voucher_bulk_upload/voucherBulkUploadTemplate_17.csv"|"decimal value with extra dot"                           |415   |
#      |"src/test/java/executables/helperFiles/files/voucher_bulk_upload/voucherBulkUploadTemplate_18.csv"|"from date first"                                        |415   |
#      |"src/test/java/executables/helperFiles/files/voucher_bulk_upload/voucherBulkUploadTemplate_19.csv"|"creating future vouchers"                               |201   |
#      |"src/test/java/executables/helperFiles/files/voucher_bulk_upload/voucherBulkUploadTemplate_20.csv"|"Wrong discount type"                                    |415   |
#      |"src/test/java/executables/helperFiles/files/voucher_bulk_upload/voucherBulkUploadTemplate_21.csv"|"Field with space"                                       |415   |
#      |"src/test/java/executables/helperFiles/files/voucher_bulk_upload/voucherBulkUploadTemplate_22.csv"|"status as 16"                                           |201   |
#      |"src/test/java/executables/helperFiles/files/voucher_bulk_upload/voucherBulkUploadTemplate_23.csv"|"Creating expired vochers"                               |415   |
#      |"src/test/java/executables/helperFiles/files/voucher_bulk_upload/voucherBulkUploadTemplate_24.csv"|"Merchant Redeem cap limits > 100000000"                 |415   |


  Scenario Outline: Vochers bulk edit <file_description>
    * def getVoucherId =
    """
    function(arg){
    return arg[0].id
    }
    """

    Given path 'coupons/v1/coupons/voucher/bulk-update'
    * print "<============== file_description ==============>", <file_description>
    * def path = <path>
    * def updateVoucherBulkEditCSV = helperMethods.Vouchers_BulkEdit(path)
    * def temp = karate.readAsString('../helperFiles/files/flatDiscountTemplate1.csv')
    And multipart file voucherFile = { value: '#(temp)', filename: 'flatDiscountTemplate1.csv', contentType: 'text/csv' }
    And headers headerJson
    When method post
    * def result = call read('support.feature@vouchers_bulk_edit_log') {requestHeader: #(headerJson)}
    * def Id = call getVoucherId result.response["data"]
    * print "<<<<<<<<<<<<<<<<<< log_Id >>>>>>>>>>>>>>", Id
    Then status <status>
    Given path '/coupons/v1/coupons/b2b/download-outputFile/'+Id
    And headers headerJson
    When method get

    Examples:
      | path                                                                                          |file_description                                          |status|
      |"src/test/java/executables/helperFiles/files/vouchers_bulk_edit/voucherBulkEditTemplate_1.csv" |"all valid details"                                       |201   |
#      |"src/test/java/executables/helperFiles/files/vouchers_bulk_edit/voucherBulkEditTemplate_2.csv" |"removing the discount amount"                            |201   |
#      |"src/test/java/executables/helperFiles/files/vouchers_bulk_edit/voucherBulkEditTemplate_3.csv" |"removing discount_value_max"                             |201   |
#      |"src/test/java/executables/helperFiles/files/vouchers_bulk_edit/voucherBulkEditTemplate_4.csv" |"removing active parameter"                               |201   |
#      |"src/test/java/executables/helperFiles/files/vouchers_bulk_edit/voucherBulkEditTemplate_5.csv" |"invalid date format"                                     |415   |
#      |"src/test/java/executables/helperFiles/files/vouchers_bulk_edit/voucherBulkEditTemplate_6.csv" |"removing one of the to_date"                             |201   |
#      |"src/test/java/executables/helperFiles/files/vouchers_bulk_edit/voucherBulkEditTemplate_7.csv" |"removing one of the from_date"                           |201   |
#      |"src/test/java/executables/helperFiles/files/vouchers_bulk_edit/voucherBulkEditTemplate_8.csv" |"autoApplicable other than 0 and 1"                       |415   |
#      |"src/test/java/executables/helperFiles/files/vouchers_bulk_edit/voucherBulkEditTemplate_9.csv" |"negetive discount value"                                 |415   |
#      |"src/test/java/executables/helperFiles/files/vouchers_bulk_edit/voucherBulkEditTemplate_10.csv"|"negetive discount_value_max"                             |415   |
#      |"src/test/java/executables/helperFiles/files/vouchers_bulk_edit/voucherBulkEditTemplate_11.csv"|"removing min bill amount"                                |201   |
#      |"src/test/java/executables/helperFiles/files/vouchers_bulk_edit/voucherBulkEditTemplate_12.csv"|"wrong 'funded by' value"                                 |415   |
#      |"src/test/java/executables/helperFiles/files/vouchers_bulk_edit/voucherBulkEditTemplate_13.csv"|"Wrong voucher Category"                                  |415   |
#      |"src/test/java/executables/helperFiles/files/vouchers_bulk_edit/voucherBulkEditTemplate_14.csv"|"name with special symbols"                               |201   |
#      |"src/test/java/executables/helperFiles/files/vouchers_bulk_edit/voucherBulkEditTemplate_15.csv"|"Very long voucher title string"                          |415   |
#      |"src/test/java/executables/helperFiles/files/vouchers_bulk_edit/voucherBulkEditTemplate_16.csv"|"discount with e"                                         |415   |
#      |"src/test/java/executables/helperFiles/files/vouchers_bulk_edit/voucherBulkEditTemplate_17.csv"|"decimal value with extra dot"                            |415   |
#      |"src/test/java/executables/helperFiles/files/vouchers_bulk_edit/voucherBulkEditTemplate_18.csv"|"from date first"                                         |415   |
#      |"src/test/java/executables/helperFiles/files/vouchers_bulk_edit/voucherBulkEditTemplate_19.csv"|"creating future vouchers"                                |201   |
#      |"src/test/java/executables/helperFiles/files/vouchers_bulk_edit/voucherBulkEditTemplate_20.csv"|"No existing voucher code"                                |415   |
#      |"src/test/java/executables/helperFiles/files/vouchers_bulk_edit/voucherBulkEditTemplate_21.csv"|"Field with space"                                        |415   |
#      |"src/test/java/executables/helperFiles/files/vouchers_bulk_edit/voucherBulkEditTemplate_22.csv"|"status as 16"                                            |201   |
#      |"src/test/java/executables/helperFiles/files/vouchers_bulk_edit/voucherBulkEditTemplate_23.csv"|"Creating expired vochers"                                |415   |
#      |"src/test/java/executables/helperFiles/files/vouchers_bulk_edit/voucherBulkEditTemplate_24.csv"|"Merchant Redeem cap limits > 100000000"                  |201   |

  Scenario: B2B Download Input File
    * def result = callonce read('support.feature@B2B_bulk_upload_log') {requestHeader: #(headerJson)}
    * def Id = call getId result.response
    Given path '/coupons/v1/coupons/b2b/download-inputFile/'+Id
    And headers headerJson
    When method get
    Then status 200


  Scenario: B2B Download Output File
    * def result = callonce read('support.feature@B2B_bulk_upload_log') {requestHeader: #(headerJson)}
    * def Id = call getId result.response
    Given path '/coupons/v1/coupons/b2b/download-outputFile/'+Id
    And headers headerJson
    When method get
    Then status 200

  @logout @ignore
  Scenario: cms logout
   * def logout = callonce read('support.feature@logout') {requestHeader: #(headerJson)}

