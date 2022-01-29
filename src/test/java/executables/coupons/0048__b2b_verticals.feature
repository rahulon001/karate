@ignore
Feature:B2B Coupon Verticals __0048
  """
  1) Create b2b coupon with different segments(retry if upload is not success.)
  2) check if those coupons are available in replacement API against the segments .
  3) check if those coupons are not available in replacement API not against the segments.
  """
  Background:
    * url baseUrl
#    * call read('support.feature@common_functions')
    * def apiComponents = envConfig
    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])
    * def helperMethods = Java.type('executables.utils.HelperMethods')
    * def getId =

    """
    function(arg){
    return arg[arg.length-1].id
    }
    """
    * def login = callonce read('support.feature@login')
    * def headerJson = {}
    * set headerJson.Cookie = $login.responseHeaders['Set-Cookie'][0]
    * set headerJson.X-Anti-Forgery = $login.responseHeaders['x-anti-forgery'][0]
    * set headerJson.Content-Type = 'multipart/form-data'
    * def sleep = function(millis){ java.lang.Thread.sleep(millis) }
    * def call_configuration_table = callonce read('support.feature@switch_on_features_b2b_segment')
    * def masid = apiComponents['CMS_masid']
    *  def random =
      """
      function(){ return java.lang.System.currentTimeMillis() }
      """

  Scenario Outline: B2B coupons bulk upload <discount_type> with data <file_description>
    * def random_date = call random
    * eval sleep(1000)
    #    Creation of B2B coupon by uploading the create file.
    Given path '/coupons/v1/coupons/b2b-upload/createjob'
    * print "<============== file_description ==============>", <file_description>
    * def path = <path>
    * def updateB2BBulkUploadCSV = helperMethods.B2B_coupon_BulkUpload(path, discount_type, random_date)
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
    * def random_date = "%"+random_date
    * def b2b_coupon_id = db.readRows("SELECT ID FROM B2B_COUPON WHERE COUPON_TITLE LIKE (\'" +random_date+ "\')")
    * print "nnnnnnnnnnn", b2b_coupon_id

    * def b2b_coupon_segs = db.readRows("SELECT SEGMENT FROM B2B_SEGMENT_COUPON_MAPPING WHERE B2B_COUPON_ID in (\'" +b2b_coupon_id[0].ID+ "\')")
    * def fun = function(arg) { return karate.jsonPath(arg, '$[*].SEGMENT') }
    * print "mmmmmmmmm", fun(b2b_coupon_segs)

    * match fun(b2b_coupon_segs) contains <expected>
    * match fun(b2b_coupon_segs) !contains <not_expected>

    * def d1 = db.updateRow("UPDATE B2B_COUPON SET STATUS = \'16\' WHERE ID IN (\'" +b2b_coupon_id[0].ID+ "\')")

    Examples:
      | path                                                                                           |file_description                                |status|discount_type         |cron_status|expected                         |not_expected|
      |apiComponents["b2b_coupon_bulk_upload_path"]+"/PERCENT_DISCOUNT/PERCENT_DISCOUNT_33.csv"        |"b2b verticals valid  'All','KIRANA','HORECA','INSTITUTIONS'." |201   |"PERCENT_DISCOUNT"    |200        |["ALL"]                          |["KIRANA","HORECA"]|
      |apiComponents["b2b_coupon_bulk_upload_path"]+"/FLAT_DISCOUNT_ON_SKU/FLAT_DISCOUNT_ON_SKU_33.csv"|"b2b verticals valid  'HORECA'."                |201   |"FLAT_DISCOUNT_ON_SKU"|200        |["HORECA","INSTITUTIONS"]        |["KIRANA","ALL"]  |
      |apiComponents["b2b_coupon_bulk_upload_path"]+"/SKU_AT_FIXED_PRICE/SKU_AT_FIXED_PRICE_33.csv"    |"b2b verticals valid  'KIRANA','HORECA."        |201   |"SKU_AT_FIXED_PRICE"  |200        |["KIRANA","HORECA"]              |["ALL"]    |


  Scenario Outline:  verify verticals in replacement API success case __0048.
    * print "scenario =========== >", <scenario_description>

    Given path '/coupons/v1/coupons/merchant/'+masid+'/fc/coupons'
    And header x-client-type = 'mpos'
    And request <body>
    And params <parameters>
    When method post
    And status <status>
    * def couponData =
    """
      {
                      "couponId": "#number",
                      "totalDiscount": "#number",
                      "totalCouponCodes": "#number",
                      "validFrom": "#number",
                      "validTo": "#number",
                      "campaignType": "#string",
                      "conditionalCouponId": "##number"
      }
    """

    * def categoryData =
    """
       "##number"
    """

    * def actualSchema =
    """
        {
                "id": "#string",
                "skuName": "#string",
                "totalDiscount": "#number",
                "earliestExpiryDate": "#number",
                "totalCouponCodes": "#number",
                "categories": ##[] categoryData,
                "coupons": '##[] couponData'
        }
    """
    * match each response.skus contains actualSchema

    Examples:
      |scenario_description              |body                                    |parameters                                                          |status |
      |"search_HORECA_coupon"            |{"start":0,"end":10}                    |{"sort":earliest-expiry, "sort-order":dsc, "segment":'HORECA'}      |200    |
      |"search_KIRANA_coupon"            |{"status":"active","start":0,"end":1000}|{"sort":earliest-expiry, "sort-order":dsc, "segment":'KIRANA'}      |200    |
      |"search_all_coupon"               |{"start":0,"end":1000}                  |{"sort":earliest-expiry, "sort-order":dsc, "segment":'ALL'}         |200    |
      |"search_INSTITUTIONS_coupon"      |{"start":0,"end":1000}                  |{"sort":earliest-expiry, "sort-order":dsc, "segment":'INSTITUTIONS'}|200    |
      |"search_horeca_coupon in KIRANA"  |{"start":0,"end":1000}                  |{"sort":earliest-expiry, "sort-order":dsc, "segment":'HORECA'}      |200    |

  Scenario Outline:  verify verticals in replacement API negative case __0048.
    * print "scenario =========== >", <scenario_description>
    * def b2b_coupon = db.readRows(<DB_request>)
    Given path '/coupons/v1/coupons/merchant/'+masid+'/fc/coupons'
    And header x-client-type = 'mpos'
    And request <body>
    And params <parameters>
    When method post
    And status <status>

    Examples:
      |scenario_description                   |body                     |parameters                                                       |status |DB_request|
      |"search_invalid_coupon in HORECA"      |{"start":0,"end":1000}   |{"sort":earliest-expiry, "sort-order":asc, "segment":'MEDICAL'}  |400    |"SELECT B2B_COUPON_ID FROM B2B_SEGMENT_COUPON_MAPPING WHERE SEGMENT = 'HORECA' AND  ROWNUM = 1 ORDER BY B2B_COUPON_ID DESC"|

  Scenario: switching off verticals
      * def call_configuration_table = callonce read('support.feature@switch_off_features_b2b_segment')
