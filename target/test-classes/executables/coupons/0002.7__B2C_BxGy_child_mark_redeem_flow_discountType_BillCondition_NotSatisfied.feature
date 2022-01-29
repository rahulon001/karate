@bxgy_parent
#BxGy coupon with min bill amount specified and cart bill amount<min bill amount. minbill=200
Feature: BxGy parent mark redeem flow __0001.7

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * header Content-Type = 'application/json'
    * header x-client-type = "mpos"
    * def apiComponents = envConfig
    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])
    * def helperMethods = Java.type('executables.utils.HelperMethods')
    * def sku_price = apiComponents["B2C_BxGy_child_discountType_responseData__0002.6"].skuPrice1
    * def bill_Amount = apiComponents["B2C_BxGy_child_discountType_responseData__0002.6"].billAmount_notsatisfyingcondition
  #  * print #(bill_Amount)
  #  * json result = callonce read("B2C_B2B_CouponCodeGeneration.feature@BxGy_parent_cart") {requestHeader: #(headerJson) , billAmount: #(bill_Amount)}
    * assert bill_Amount<apiComponents["B2C_BxGy_child_discountType_responseData__0002.6"].minbillCondition
    * print "<============== Bill Condition Not Satisfied ==============>"

    *  def transactionID =
    """
    function(){ return java.lang.System.currentTimeMillis() }
    """
    * def transaction_id = callonce transactionID
    * def masid = apiComponents['CMS_masid']

  Scenario: Generate Coupon code b2c BxGy parent __0001.7
    * def body = apiComponents["B2C_BxGy_child_discountType__0002.6"]
    * set body.masId = apiComponents['CMS_masid']
    * set body.billAmount = bill_Amount
    * set body.skuData[0].skuPrice = sku_price
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200
    * match response.skuCoupons == []