Feature: Get coupon categories

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * header Content-Type = 'application/json'
    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def apiComponents = envConfig
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])


  @getCouponCategories
  Scenario: Get coupons
    Given path '/coupons/v1/coupons/categories'
    And header x-loginid = '8369353463'
    And param version = "v5"
    And param client = "microsite"
    When method get
    Then status 200
    And assert responseTime < 3000


  @getCategorybyclientid
  Scenario Outline: Get Category details by client id
    * def headerJson = {}
    * def login = call read('support.feature@login')
    * set headerJson.Cookie = $login.responseHeaders['Set-Cookie'][0]
    * set headerJson.X-Anti-Forgery = $login.responseHeaders['x-anti-forgery'][0]
    * set headerJson.Content-Type = 'application/json'

    Given path <path>
    And headers headerJson
    * print "<============== file_description ==============>", "<scenario>"
    When method get
    Then match responseStatus == <Status>

    Examples:
      |path                          |   Status    | scenario           |
      |'/v1/cms/category/7'          |  200        |  Valid client_id   |
      |'/v1/cms/category/20'         |  200        | client_id          |
      | '/v1/cms/category/'          |  404        |  null client_id    |
      |'/v1/cms/category/&'          |  400        |  junk value        |


    Scenario:
    Scenario Outline: Allowed categories as per clients <client>.
      * def b2b_coupon_segs = db.readRows("SELECT NAME FROM CATEGORY WHERE CLIENT_TYPE IN (SELECT ID FROM CLIENT_TYPE WHERE NAME = \'<client>\') AND STATUS = \'active\'")
      * def category_list = function(arg) { return karate.jsonPath(arg, '$[*].NAME') }
      * print "<==========category_list========>", category_list(b2b_coupon_segs)
      * print "<==========allowed_categories========>", <allowed_categories>
      * def c = category_list(b2b_coupon_segs)
      * match <allowed_categories> contains only c

      Examples:
      |client|allowed_categories|
      |microsite|["Bakery & Dairy","Beauty & Hygiene","Foodgrains\, Oils & Masala","Health Drinks & Beverages","Health & Wellness","Home & Living","Cleaning & Household Care","Instant & Ready Foods","Mom & Baby","Snacks & Confectionery","Marka & Bulk Packs","Fruits & Vegetables"]|