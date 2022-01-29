Feature: BxGy_child_percentage_off_mark_redeem_flow_discount_type __0008.7

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * header Content-Type = 'application/json'
    * header x-client-type = "mpos"
    * def apiComponents = envConfig
    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])
    * def helperMethods = Java.type('executables.utils.HelperMethods')
    * def sku_price = apiComponents["B2C_BxGy_child_percentage_off_discountType_responseData__0008.7"].skuPrice1
    * def bill_Amount = apiComponents["B2C_BxGy_child_percentage_off_discountType_responseData__0008.7"].billAmount_notsatisfyingcondition
    * assert bill_Amount<apiComponents["B2C_BxGy_child_percentage_off_discountType_responseData__0008.7"].minbillCondition
    * print "<============== Bill Condition Not Satisfied ==============>"

    *  def transactionID =
    """
    function(){ return java.lang.System.currentTimeMillis() }
    """
    * def transaction_id = callonce transactionID
    * def masid = apiComponents['CMS_masid']

  Scenario: Generate Coupon code b2c BxGy parent __0001.7
    * def body = apiComponents["B2C_BxGy_child_percentage_off_discountType__0008.7"]
    * set body.masId = apiComponents['CMS_masid']
    * set body.billAmount = bill_Amount
    * set body.skuData[0].skuPrice = sku_price
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200
    * match response.skuCoupons == []