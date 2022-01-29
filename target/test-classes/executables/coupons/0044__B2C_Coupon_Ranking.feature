@ignore
Feature: B2C Ranking Upload.

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
    * def headerJson1 = {}
    * set headerJson1.Content-Type = 'application/json'
    * def helperMethods = Java.type('executables.utils.HelperMethods')
    * def getId =

    """
    function(arg){
    return arg[arg.length-1].id
    }
    """
    * def sleep = function(millis){ java.lang.Thread.sleep(millis) }


Scenario Outline: B2C Ranking upload with data <file_description>
 # * eval sleep(1000)
    #    deleting the csv file
 # * def deleting_the_csv_file = helperMethods.deleteCSV('../helperFiles/files/flatDiscountTemplate1.csv')
  Given path '/v1/cms/coupons/uploadFile/csv'
  * print "<============== file_description ==============>", <file_description>
  * def path = <path>
  * def read_path = <read_path>
 # * def updateB2BBulkUploadCSV = helperMethods.B2B_coupon_Bulk_edit(path)
 # * def temp = karate.readAsString('../helperFiles/files/flatDiscountTemplate1.csv')
  * def temp = karate.readAsString(read_path)
 # And multipart file file = { value: '#(temp)', filename: 'flatDiscountTemplate1.csv', contentType: 'text/csv' }
  And multipart file file = { value: '#(temp)', filename: <file_name>, contentType: 'text/csv' }
  And headers headerJson
  When method post
  # get the upload ID of the file
  # ----Replace API endpoint----
  * def result = call read('support.feature@b2c_ranking_bulk_upload_log') {requestHeader: #(headerJson)}
  * def Id = result.response["data"][0]["id"]
  * print "<<<<<<<<<<<<<<<<<< log_Id >>>>>>>>>>>>>>", Id
  Then status <status>
 # Download the O/P file
  # ----Replace API endpoint----
  Given path '/v1/cms/bulk/download/outputFile/'+Id
  * set headerJson.Content-Type = 'application/json'
  And headers headerJson
  When method get
  Then status 200
  * print response
   # Download the I/P file
  # ----Replace API endpoint----
  Given path '/v1/cms/bulk/download/inputFile/'+Id
  * set headerJson.Content-Type = 'application/json'
  And headers headerJson
  When method get
  Then status 200
  * print response

    Examples:
   | path                                                              |file_description                            |status|file_name             |read_path                                                            |
   |apiComponents["b2c_ranking_upload_path"]+"/B2C_Ranking_1.csv"      |"Valid data"                                |200   | "B2C_Ranking_1.csv"  |apiComponents["b2c_ranking_upload_path_read"]+"/B2C_Ranking_1.csv"   |
   |apiComponents["b2c_ranking_upload_path"]+"/B2C_Ranking_2.csv"      |"Decimal value for Boost"                   |400   |"B2C_Ranking_2.csv"    | apiComponents["b2c_ranking_upload_path_read"]+"/B2C_Ranking_2.csv" |
   |apiComponents["b2c_ranking_upload_path"]+"/B2C_Ranking_3.csv"      |"Duplicate coupon records"                  |200   |"B2C_Ranking_3.csv"    | apiComponents["b2c_ranking_upload_path_read"]+"/B2C_Ranking_3.csv" |
   |apiComponents["b2c_ranking_upload_path"]+"/B2C_Ranking_4.csv"      |"InValid /null/junk coupon id"              |400   |"B2C_Ranking_4.csv"    |apiComponents["b2c_ranking_upload_path_read"]+"/B2C_Ranking_4.csv"  |
   |apiComponents["b2c_ranking_upload_path"]+"/B2C_Ranking_5.csv"      |"null/junk/negative value for boost"        |400   |"B2C_Ranking_5.csv"     |apiComponents["b2c_ranking_upload_path_read"]+"/B2C_Ranking_5.csv" |
   |apiComponents["b2c_ranking_upload_path"]+"/B2C_Ranking_6.csv"      |"couponid/boost with spaces"                |400   |"B2C_Ranking_6.csv"     |apiComponents["b2c_ranking_upload_path_read"]+"/B2C_Ranking_6.csv" |
 #  |apiComponents["b2c_ranking_upload_path"]+"/B2C_Ranking_7.csv"      |"Max allowed records"                       |200   |"B2C_Ranking_7.csv"     |apiComponents["b2c_ranking_upload_path_read"]+"/B2C_Ranking_7.csv"|

Scenario Outline: B2C Ranking upload with data, DB validation and GetCouponAPI for high boost <file_description>
  * eval sleep(1000)
  * print "****FILE****","'"+<read_path>+"'"
  * def read_path = "'"+<read_path>+"'"
  * def data = read(<read_path>)
  * def couponId = data[0].Id
  * def boost = data[0].Boost
  * print "*****DATA***", data
  * def deleting_the_csv_file = helperMethods.deleteCSV('../helperFiles/files/flatDiscountTemplate1.csv')
  Given path '/v1/cms/coupons/uploadFile/csv'
  * print "<============== file_description ==============>", <file_description>
  * def path = <path>
  * def read_path = <read_path>
  #* def updateB2BBulkUploadCSV = helperMethods.B2B_coupon_Bulk_edit(path)
  #* def temp = karate.readAsString('../helperFiles/files/flatDiscountTemplate1.csv')
  * def temp = karate.readAsString(read_path)
  And multipart file file = { value: '#(temp)', filename: <file_name>, contentType: 'text/csv' }
  And headers headerJson
  When method post
  # get the upload ID of the file
  # ----Replace API endpoint----
  * def result = call read('support.feature@b2c_ranking_bulk_upload_log') {requestHeader: #(headerJson)}
  * def Id = result.response["data"][0]["id"]
  * print "<<<<<<<<<<<<<<<<<< log_Id >>>>>>>>>>>>>>", Id
  Then status <status>
 # Download the O/P file
  # ----Replace API endpoint----
  Given path '/v1/cms/bulk/download/outputFile/'+Id
  * set headerJson.Content-Type = 'application/json'
  And headers headerJson
  When method get
  Then status 200
  * print response
   # Download the I/P file
  # ----Replace API endpoint----
  Given path '/v1/cms/bulk/download/inputFile/'+Id
  * set headerJson.Content-Type = 'application/json'
  And headers headerJson
  When method get
  Then status 200
  * print response

  * def new_boost = db.readRows("SELECT BOOST FROM COUPON WHERE ID =\'"+couponId+"\'")
  * match new_boost[0].BOOST == parseInt(boost)

  * def masid = apiComponents['CMS_masid']

  Given path '/coupons/v1/coupons/invalidateCache'
  And headers headerJson1
  When method DELETE
  Then status 200
  #validate GETCoupon API shows this couponid first for high boost
  * eval sleep(1000)
  Given url baseUrl+ '/coupons/v1/coupons/'
  And header x-client-type = 'microsite'
  And header x-loginid = '7977558623'
  And params {version:"v5", start:"0", end:"1000", externalMerchantId: #(masid)}
  When method get
  Then status 200
  * match response.result[0].id == parseInt(couponId)

  Examples:
    | path                                                                |file_description                            |status|read_path                                                                |file_name            |
    |apiComponents["b2c_ranking_upload_path"]+"/B2C_Ranking_0.csv"        |"Valid data"                                |200   |apiComponents["b2c_ranking_upload_path_read"]+"/B2C_Ranking_0.csv"       |"B2C_Ranking_0.csv"   |

  Scenario: Download Current booster
    # Replace the endpoint
    Given url baseUrl+'/v1/cms/coupons/downloadCouponCSV/'
    And headers headerJson
    And header Content-Type = 'text/csv'
    When method get
    Then status 200
   * print response
    * csv response_new = response
    * def ranking_count = db.readRows("select count(*) as COUNT from coupon where boost>0 and valid_to >= SYSTIMESTAMP and status='0'")
    * def ranking_count = parseInt(ranking_count[0].COUNT)
    * match parseInt(response_new.length) == ranking_count

# @logout @ignore
# Scenario: cms logout
#  * def logout = callonce read('support.feature@logout') {requestHeader: #(headerJson)}

