Feature: verification of hold status __0036

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * call read('support.feature@activate_coupons')
    * call read('support.feature@switch_on_features_1')
    * def apiComponents = envConfig
    * def schemaAndValidation = envSchema
    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])
    * header Content-Type = 'application/json'
    * header x-client-type = "mpos"
    * def redeem_flags = "false"
    * def headerJson = {}
    * set headerJson.multi_redeem-enabled = redeem_flags
    * set headerJson.Content-Type = 'application/json'
    * set headerJson.x-client-type = 'mpos'


  Scenario: verify diffrent coupons are allocated to merchant 2 and merchant 1 when they call at same time.
    #    Merchant 1
    * def masid_merchant1 = apiComponents['masid_merchant1']
    * def masid_merchant2 = apiComponents['masid_merchant2']

    * def FC_MERCHANT_COUPONS = db.updateRow("UPDATE FC_MERCHANT_COUPONS SET STATUS = \'cancelled'\ WHERE MASID IN (\'" +masid_merchant1+ "\')")

    #Replacement API
    * def body =
      """
          {
          "start" : 0,
          "end" : 1000,
          "sku": "833343212221"
          }
      """
    Given path '/coupons/v1/coupons/merchant/'+masid_merchant1+'/fc/coupons'
    And header x-client-type = "mpos"
    And request body
    When method post
    Then status 200
    * def coupon_count_beforeHold_m1 = response.skus[0].coupons[0].totalCouponCodes

    * def body =
      """
          {
          "start" : 0,
          "end" : 1000,
          "sku": "833343212221"
          }
      """
    Given path '/coupons/v1/coupons/merchant/'+masid_merchant2+'/fc/coupons'
    And header x-client-type = "mpos"
    And request body
    When method post
    Then status 200
    * def coupon_count_beforeHold_m2 = response.skus[0].coupons[0].totalCouponCodes

    * def sku_price = apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].price
    * def bill_amount = apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption__0036"].billAmount
    * def result = call read("support.feature@B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_two_merchants") {requestHeader: #(headerJson) , skuPrice: #(sku_price), billAmount: #(bill_amount), masid: #(masid_merchant1)}

    * def skuID = get result.response.skuCoupons[*].skuId
    * def skuID_index_833343212221 = skuID.indexOf("833343212221")
    * def skuID_index_833343212222 = skuID.indexOf("833343212222")
    * def skuID_index_833343212223 = skuID.indexOf("833343212223")

    * def couponCode1_m1 = result.response["skuCoupons"][skuID_index_833343212221]["coupons"][0]["couponCode"]
    * def couponCode2_m1 = result.response["skuCoupons"][skuID_index_833343212222]["coupons"][0]["couponCode"]
    * def couponCode3_m1 = result.response["skuCoupons"][skuID_index_833343212222]["coupons"][1]["couponCode"]
    * def couponCode4_m1 = result.response["skuCoupons"][skuID_index_833343212223]["coupons"][0]["couponCode"]
    * def couponCode5_m1 = result.response["skuCoupons"][skuID_index_833343212223]["coupons"][1]["couponCode"]
    * def couponCode6_m1 = result.response["skuCoupons"][skuID_index_833343212223]["coupons"][2]["couponCode"]

    #    status validation
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1_m1+ "\',\'" +couponCode2_m1+ "\',\'" +couponCode3_m1+ "\',\'" +couponCode4_m1+ "\',\'" +couponCode5_m1+ "\',\'" +couponCode6_m1+ "\')")
    * print coupon_code_status
    * def masid = masid_merchant1
    * match each coupon_code_status == schemaAndValidation["hold_FC_merchant_coupon"]

    #Replacement API
    * def body =
      """
          {
          "start" : 0,
          "end" : 1000,
          "sku": "833343212221"
          }
      """
    Given path '/coupons/v1/coupons/merchant/'+masid_merchant1+'/fc/coupons'
    And header x-client-type = "mpos"
    And request body
    When method post
    Then status 200
    * def coupon_count_afterHold_m1 = response.skus[0].coupons[0].totalCouponCodes

    * match coupon_count_afterHold_m1 == coupon_count_beforeHold_m1

    #    Merchant 2
     #Replacement API
    * def masid_merchant2 = apiComponents['masid_merchant2']
    * def body =
      """
          {
          "start" : 0,
          "end" : 1000,
          "sku": "833343212221"
          }
      """
    Given path '/coupons/v1/coupons/merchant/'+masid_merchant2+'/fc/coupons'
    And header x-client-type = "mpos"
    And request body
    When method post
    Then status 200
    * def coupon_count_beforeHold_m2_2 = response.skus[0].coupons[0].totalCouponCodes
    * match coupon_count_beforeHold_m2_2 == coupon_count_beforeHold_m2 - 1


    * def FC_MERCHANT_COUPONS = db.updateRow("UPDATE FC_MERCHANT_COUPONS SET STATUS = \'cancelled'\ WHERE MASID IN (\'" +masid_merchant2+ "\')")
    * def sku_price = apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].price
    * def bill_amount = apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption__0036"].billAmount
    * def result1 = call read("support.feature@B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_two_merchants") {requestHeader: #(headerJson) , skuPrice: #(sku_price), billAmount: #(bill_amount), masid: #(masid_merchant2)}

    * def skuID = get result1.response.skuCoupons[*].skuId
    * def skuID_index_833343212221 = skuID.indexOf("833343212221")
    * def skuID_index_833343212222 = skuID.indexOf("833343212222")
    * def skuID_index_833343212223 = skuID.indexOf("833343212223")

    * def couponCode1_m2 = result1.response["skuCoupons"][skuID_index_833343212221]["coupons"][0]["couponCode"]
    * def couponCode2_m2 = result1.response["skuCoupons"][skuID_index_833343212222]["coupons"][0]["couponCode"]
    * def couponCode3_m2 = result1.response["skuCoupons"][skuID_index_833343212222]["coupons"][1]["couponCode"]
    * def couponCode4_m2 = result1.response["skuCoupons"][skuID_index_833343212223]["coupons"][0]["couponCode"]
    * def couponCode5_m2 = result1.response["skuCoupons"][skuID_index_833343212223]["coupons"][1]["couponCode"]
    * def couponCode6_m2 = result1.response["skuCoupons"][skuID_index_833343212223]["coupons"][2]["couponCode"]

      #    status validation
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1_m2+ "\',\'" +couponCode2_m2+ "\',\'" +couponCode3_m2+ "\',\'" +couponCode4_m2+ "\',\'" +couponCode5_m2+ "\',\'" +couponCode6_m2+ "\')")
    * print coupon_code_status
    * def masid = masid_merchant2
    * match each coupon_code_status == schemaAndValidation["hold_FC_merchant_coupon"]

    *  def transactionID =
    """
      function(){ return java.lang.System.currentTimeMillis() }
    """
    * def transaction_id = callonce transactionID

    # separate codes are generated for both merchants.
    * def m1 = [#(couponCode1_m1),#(couponCode2_m1),#(couponCode3_m1),#(couponCode4_m1),#(couponCode5_m1),#(couponCode6_m1)]
    * def m2 = [#(couponCode1_m2),#(couponCode2_m2),#(couponCode3_m2),#(couponCode4_m2),#(couponCode5_m2),#(couponCode6_m2)]

    * match m1 != m2

    * def FC_MERCHANT_COUPONS = db.updateRow("UPDATE FC_MERCHANT_COUPONS SET STATUS = \'cancelled'\ WHERE MASID IN (\'" +masid_merchant1+ "\')")
    * def FC_MERCHANT_COUPONS = db.updateRow("UPDATE FC_MERCHANT_COUPONS SET STATUS = \'cancelled'\ WHERE MASID IN (\'" +masid_merchant2+ "\')")

  Scenario: verify coupons are allocated to merchant 2 when merchant 1 abandons the codes
    #    Merchant 1
    * def masid_merchant1 = apiComponents['masid_merchant1']
    * def masid = masid_merchant1

    * def sku_price = apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].price
    * def bill_amount = apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption__0036"].billAmount
    * def result = call read("support.feature@B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_two_merchants") {requestHeader: #(headerJson) , skuPrice: #(sku_price), billAmount: #(bill_amount), masid: #(masid_merchant1)}

    * def skuID = get result.response.skuCoupons[*].skuId
    * def skuID_index_833343212221 = skuID.indexOf("833343212221")
    * def skuID_index_833343212222 = skuID.indexOf("833343212222")
    * def skuID_index_833343212223 = skuID.indexOf("833343212223")

    * def couponCode1_m1 = result.response["skuCoupons"][skuID_index_833343212221]["coupons"][0]["couponCode"]
    * def couponCode2_m1 = result.response["skuCoupons"][skuID_index_833343212222]["coupons"][0]["couponCode"]
    * def couponCode3_m1 = result.response["skuCoupons"][skuID_index_833343212222]["coupons"][1]["couponCode"]
    * def couponCode4_m1 = result.response["skuCoupons"][skuID_index_833343212223]["coupons"][0]["couponCode"]
    * def couponCode5_m1 = result.response["skuCoupons"][skuID_index_833343212223]["coupons"][1]["couponCode"]
    * def couponCode6_m1 = result.response["skuCoupons"][skuID_index_833343212223]["coupons"][2]["couponCode"]

    * print "<<<<<<<<<<<<<status validation>>>>>>>>>>>>>>>>>"
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1_m1+ "\',\'" +couponCode2_m1+ "\',\'" +couponCode3_m1+ "\',\'" +couponCode4_m1+ "\',\'" +couponCode5_m1+ "\',\'" +couponCode6_m1+ "\')")
    * print coupon_code_status
    * match each coupon_code_status == schemaAndValidation["hold_FC_merchant_coupon"]
    * def m1_1 = [#(couponCode1_m1),#(couponCode2_m1),#(couponCode3_m1),#(couponCode4_m1),#(couponCode5_m1),#(couponCode6_m1)]

    * def hold_time = db.readRows("SELECT CONFIG_VALUE FROM configuration WHERE CONFIG_NAME=\'get_eligible_hold_duration\'")
    * def hold_time = parseInt(hold_time[0].CONFIG_VALUE)/60
    * def update_hold_ts = db.updateRow("update fc_merchant_coupons set hold_ts=(systimestamp - numtodsinterval(\'"+hold_time+"\','MINUTE')) where merchant_coupon_code in (\'" +couponCode1_m1+ "\',\'" +couponCode2_m1+ "\',\'" +couponCode3_m1+ "\',\'" +couponCode4_m1+ "\',\'" +couponCode5_m1+ "\',\'" +couponCode6_m1+ "\')")

    * call read('support.feature@activate_coupons')

     #   recalling  Merchant to check if coupon codes are active or not
    * def sku_price = apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].price
    * def bill_amount = apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption__0036"].billAmount
    * def result = call read("support.feature@B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_two_merchants") {requestHeader: #(headerJson) , skuPrice: #(sku_price), billAmount: #(bill_amount), masid: #(masid_merchant1)}

    * def skuID = get result.response.skuCoupons[*].skuId
    * def skuID_index_833343212221 = skuID.indexOf("833343212221")
    * def skuID_index_833343212222 = skuID.indexOf("833343212222")
    * def skuID_index_833343212223 = skuID.indexOf("833343212223")

    * def couponCode1_m1 = result.response["skuCoupons"][skuID_index_833343212221]["coupons"][0]["couponCode"]
    * def couponCode2_m1 = result.response["skuCoupons"][skuID_index_833343212222]["coupons"][0]["couponCode"]
    * def couponCode3_m1 = result.response["skuCoupons"][skuID_index_833343212222]["coupons"][1]["couponCode"]
    * def couponCode4_m1 = result.response["skuCoupons"][skuID_index_833343212223]["coupons"][0]["couponCode"]
    * def couponCode5_m1 = result.response["skuCoupons"][skuID_index_833343212223]["coupons"][1]["couponCode"]
    * def couponCode6_m1 = result.response["skuCoupons"][skuID_index_833343212223]["coupons"][2]["couponCode"]

    * print "<<<<<<<<<<<<<status re-validation>>>>>>>>>>>>>>>>>"
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1_m1+ "\',\'" +couponCode2_m1+ "\',\'" +couponCode3_m1+ "\',\'" +couponCode4_m1+ "\',\'" +couponCode5_m1+ "\',\'" +couponCode6_m1+ "\')")
    * print coupon_code_status
    * match each coupon_code_status == schemaAndValidation["hold_FC_merchant_coupon"]

    #    Merchant 2
    * def masid_merchant2 = apiComponents['masid_merchant2']
    * def masid = masid_merchant2

    * def sku_price = apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].price
    * def bill_amount = apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption__0036"].billAmount
    * def result1 = call read("support.feature@B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_two_merchants") {requestHeader: #(headerJson) , skuPrice: #(sku_price), billAmount: #(bill_amount), masid: #(masid_merchant2)}

    * def skuID = get result1.response.skuCoupons[*].skuId
    * def skuID_index_833343212221 = skuID.indexOf("833343212221")
    * def skuID_index_833343212222 = skuID.indexOf("833343212222")
    * def skuID_index_833343212223 = skuID.indexOf("833343212223")

    * def couponCode1_m2 = result1.response["skuCoupons"][skuID_index_833343212221]["coupons"][0]["couponCode"]
    * def couponCode2_m2 = result1.response["skuCoupons"][skuID_index_833343212222]["coupons"][0]["couponCode"]
    * def couponCode3_m2 = result1.response["skuCoupons"][skuID_index_833343212222]["coupons"][1]["couponCode"]
    * def couponCode4_m2 = result1.response["skuCoupons"][skuID_index_833343212223]["coupons"][0]["couponCode"]
    * def couponCode5_m2 = result1.response["skuCoupons"][skuID_index_833343212223]["coupons"][1]["couponCode"]
    * def couponCode6_m2 = result1.response["skuCoupons"][skuID_index_833343212223]["coupons"][2]["couponCode"]

    * def m1 = [#(couponCode1_m1),#(couponCode2_m1),#(couponCode3_m1),#(couponCode4_m1),#(couponCode5_m1),#(couponCode6_m1)]
    * def m2 = [#(couponCode1_m2),#(couponCode2_m2),#(couponCode3_m2),#(couponCode4_m2),#(couponCode5_m2),#(couponCode6_m2)]


#    status validation
    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1_m2+ "\',\'" +couponCode2_m2+ "\',\'" +couponCode3_m2+ "\',\'" +couponCode4_m2+ "\',\'" +couponCode5_m2+ "\',\'" +couponCode6_m2+ "\')")
    * print coupon_code_status
    * match each coupon_code_status == schemaAndValidation["hold_FC_merchant_coupon"]

    * header override_flag = redeem_flags
    * def body =
    """
      {
      "masId": "#(masid_merchant2)",
      "billAmount": #(apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption__0043"].billAmount),
      "transactionId": "#(transaction_id)",
      "couponCodes":[#(couponCode1_m2), #(couponCode2_m2), #(couponCode3_m2), #(couponCode4_m2), #(couponCode5_m2), #(couponCode6_m2)],
      "skuData": #(apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption__0043"].skuData)
      }
    """

    Given path '/coupons/v1/coupons/merchant/fc/checkout'
    And request body
    When method post
    Then status 200
    # validation of response schema.

    # validation of discount for SKUs only.
    * assert response.discountAmount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].discountAmount
    * assert response.newBillAmount == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].newBillAmount
 #   * match each response.data[*].discountType == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].discountType
    * match each response.data[*].quantity == apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_responseData__0036"].quantity

    * def coupon_code_status = db.readRows("SELECT * FROM FC_MERCHANT_COUPONS WHERE MERCHANT_COUPON_CODE IN (\'" +couponCode1_m2+ "\',\'" +couponCode2_m2+ "\',\'" +couponCode3_m2+ "\',\'" +couponCode4_m2+ "\',\'" +couponCode5_m2+ "\',\'" +couponCode6_m2+ "\')")
    * print coupon_code_status
    * def schema = schemaAndValidation["checkout_FC_merchant_coupon"]
    And match each coupon_code_status == schema

    * def FC_MERCHANT_COUPONS = db.updateRow("UPDATE FC_MERCHANT_COUPONS SET STATUS = \'cancelled'\ WHERE MASID IN (\'" +masid_merchant2+ "\')")


  Scenario: Switching off the features __0036.
    * def call_configuration_table = callonce read('support.feature@switch_off_features')
