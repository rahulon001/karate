@ignore
Feature: Generate B2B and B2C coupon codes.

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * def apiComponents = envConfig
    * header Content-Type = 'application/json'
    * def call_configuration_table = callonce read('support.feature@switch_on_features')

  @BxGy_parent_cart
  Scenario: BxGy parent cart __0001
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_parent_discountType__0001"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_parent_cart_mrpc
  Scenario: BxGy parent cart __0001.4
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_parent_discountType_mrpc__0001.4"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_parent_cart_payment
  Scenario: BxGy parent cart __0001.5
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_parent_paymentType__0001.5"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_child_cart
  Scenario: BxGy child cart __0002
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_child_discountType__0002"]
    #* set body.billAmount = billAmount
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_parent_percentage_cart_mrpc
  Scenario: BxGy parent cart __0007.4
    * header x-client-type = "mpos"
    * def body = body
    * set body.skuData[0].skuPrice = skuPrice1
    * set body.skuData[1].skuPrice = skuPrice2
    * set body.billAmount = billAmount
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_parent_percentage_cart_payment
  Scenario: BxGy parent cart __0007.5
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_parent_percentage_off_paymentType__0007.5"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_parent_percentage_cart_payment_BillCondition
  Scenario: BxGy parent cart __0007.5
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_parent_percentage_off_paymentType__0007.10"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_child_percentage_cart_mrpc
  Scenario: BxGy parent cart __0008.4
    * header x-client-type = "mpos"
    * def body = body
    * set body.skuData[0].skuPrice = skuPrice1
    * set body.skuData[1].skuPrice = skuPrice2
    * set body.billAmount = billAmount
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_child_percentage_cart_payment
  Scenario: BxGy parent cart __0008.5
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_child_percentage_off_paymentType__0008.5"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_child_percentage_cart_payment_BillCondition
  Scenario: BxGy parent cart __0008.5
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_child_percentage_off_paymentType__0008.10"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_parent_flat_cart_mrpc
  Scenario: BxGy parent cart __0009.4
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_parent_flat_off_discountType_mrpc__0009.4"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_parent_flat_cart_payment
  Scenario: BxGy parent cart __0009.5
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_parent_flat_off_paymentType__0009.5"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_parent_flat_cart_payment_BillCondition
  Scenario: BxGy parent cart __0009.5
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_parent_flat_off_paymentType__0009.10"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_child_flat_cart_mrpc
  Scenario: BxGy child cart __0010.4
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_child_flat_off_discountType_mrpc__0010.4"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_child_flat_cart_payment
  Scenario: BxGy child cart __0010.5
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_child_flat_off_paymentType__0010.5"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_child_flat_cart_payment_BillCondition
  Scenario: BxGy child cart __0010.10
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_child_flat_off_paymentType__0010.10"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_child_cart_mrpc
  Scenario: BxGy parent cart __0002.4
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_child_discountType_mrpc__0002.4"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_child_cart_payment
  Scenario: BxGy parent cart __0002.5
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_child_paymentType__0002.5"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_percentage_parent_cart
  Scenario: BxGy percentage parent cart __0007
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_parent_percentage_off_discountType__0007"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_percentage_parent_cart_BillCondition
  Scenario: BxGy percentage parent cart __0007.7
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_parent_percentage_off_discountType__0007.7"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_percentage_parent_cart_prompter
  Scenario: BxGy percentage parent cart __0007
    * header x-client-type = "mpos"
    * def body = body
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_percentage_child_cart
  Scenario: BxGy percentage child cart __0008
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_child_percentage_off_discountType__0008"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_percentage_child_cart_BillCondition
  Scenario: BxGy percentage child cart __0008
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_child_percentage_off_discountType__0008.7"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_percentage_child_cart_prompter
  Scenario: BxGy percentage child cart __0008
    * header x-client-type = "mpos"
    * def body = body
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_flat_parent_cart
  Scenario: BxGy flat parent cart __0009
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_parent_flat_off_discountType__0009"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_flat_parent_cart_BillCondition
  Scenario: BxGy flat parent cart __0009
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_parent_flat_off_discountType__0009.7"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_flat_parent_cart_prompter
  Scenario: BxGy flat parent cart __0009
    * header x-client-type = "mpos"
    * def body = body
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_flat_parent_cart_lessprice
  Scenario: BxGy flat parent cart __0009
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_parent_flat_off_discountType__0009"]
    * set body.skuData[1].skuPrice = skuPrice
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @B2B_BxGy_flat_parent_cart
  Scenario: b2b BxGy flat parent cart __0009.2
    * def body = apiComponents["B2B_BxGy_parent_flat_discountType__0009.2"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @B2B_BxGy_flat_parent_cart_BillCondition
  Scenario: b2b BxGy flat parent cart __0009.11
    * def body = apiComponents["B2B_BxGy_parent_flat_discountType__0009.11"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @BxGy_flat_child_cart
  Scenario: BxGy flat child cart __0010
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_child_flat_off_discountType__0010"]
    #* set body.skuData[1].skuPrice = skuPrice
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_flat_child_cart_BillCondition
  Scenario: BxGy flat child cart __0010
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_child_flat_off_discountType__0010.7"]
    #* set body.skuData[1].skuPrice = skuPrice
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_flat_child_cart_prompter
  Scenario: BxGy flat child cart __0010
    * header x-client-type = "mpos"
    * def body = body
    #* set body.skuData[1].skuPrice = skuPrice
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_flat_child_cart_lessprice
  Scenario: BxGy flat child cart __0010
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_child_flat_off_discountType__0010"]
    * set body.skuData[1].skuPrice = skuPrice
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @B2C_BxGy_combined_cart_verification
  Scenario: B2C BxGy combined cart verification __0038
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_combined_partial_return__0038"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @BxGy_parent_cart_BillCondition
  Scenario: BxGy parent cart BillCondition __0001.6
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_parent_discountType__0001.6"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200


  @BxGy_parent_cart_payment_BillCondition
  Scenario: BxGy parent cart __0001.9
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_parent_paymentType__0001.9"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200


  @B2B_BxGy_parent_cart_redemption_BillCondition
  Scenario: b2b cart redemption__0001.10
    * def body = apiComponents["B2B_BxGy_parent_discountType__0001.10"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @BxGy_child_cart_BillCondition
  Scenario: BxGy child cart __0002.6
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_child_discountType__0002.6"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200


  @BxGy_child_cart_payment_BillCondition
  Scenario: BxGy parent cart __0002.9
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_BxGy_child_paymentType__0002.9"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @B2B_BxGy_child_cart_redemption_BillCondition
  Scenario: b2b cart redemption__0002.10
    * def body = apiComponents["B2B_BxGy_child_discountType__0002.10"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @B2C_flat_discount_on_SKU
  Scenario: B2C flat discount on SKU __0041
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_flat_discount_on_SKU_discountType__0041"]
   # * set body.skuData[0].skuPrice=skuPrice
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @B2C_flat_discount_on_SKU_lessprice
  Scenario: B2C flat discount on SKU __0041
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_flat_discount_on_SKU_discountType__0041"]
    * set body.skuData[0].skuPrice = skuPrice
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @B2C_flat_discount_SKU_Upload
  Scenario: B2C flat discount on SKU __0041
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_flat_discount_on_SKU_discountType__0041.12"]
    * set body.skuData = skuData
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @B2B_flat_discount_on_SKU_redemption
  Scenario: b2b flat discount on SKU redemption__0041.2
    * def body = apiComponents["B2B_flat_discount_on_SKU_discountType__0041.2"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @B2B_flat_discount_on_SKU_redemption_SKU_Upload_OR
  Scenario: b2b flat discount on SKU redemption__0041.2
    * def body = apiComponents["B2B_flat_discount_on_SKU_discountType__0041.18"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @B2C_flat_discount_on_SKU_mrpc
  Scenario: BxGy parent cart __0041.4
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_flat_discount_on_SKU_discountType_mrpc__0041.4"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @B2C_flat_discount_on_SKU_payment
  Scenario: BxGy parent cart __0001.5
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_flat_discount_on_SKU_paymentType__0041.5"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @B2C_flat_discount_on_SKU_BillCondition
  Scenario: B2C_flat_discount_on_SKU_BillCondition __0041.6
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_flat_discount_on_SKU_discountType__0041.6"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @B2C_flat_discount_on_SKU_payment_BillCondition
  Scenario: BxGy parent cart __0041.9
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_flat_discount_on_SKU_paymentType__0041.9"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @B2B_B2C_flat_discount_on_SKU_redemption_BillCondition
  Scenario: b2b cart redemption__0041.10
    * def body = apiComponents["B2B_flat_discount_on_SKU_discountType__0041.10"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @B2C_percentage_discount_on_SKU
  Scenario: B2C percentage discount on SKU __0042
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_percentage_discount_on_SKU_discountType__0042"]
   # * set body.skuData[0].skuPrice=skuPrice
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @B2C_percentage_discount_SKU_Upload
  Scenario: B2C percentage discount on SKU __0042
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_percentage_discount_on_SKU_discountType__0042.12"]
    * set body.skuData = skuData
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @B2B_percentage_discount_on_SKU_redemption
  Scenario: b2b percentage discount on SKU redemption__0042.2
    * def body = apiComponents["B2B_percentage_discount_on_SKU_discountType__0042.2"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @B2B_percentage_discount_on_SKU_redemption_SKU_Upload_OR
  Scenario: b2b percentage discount on SKU redemption__0042.2
    * def body = apiComponents["B2B_percentage_discount_on_SKU_discountType__0042.14"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @B2C_percentage_discount_on_SKU_mrpc
  Scenario:B2C percentage__0042.4
    * header x-client-type = "mpos"
    * def body = body
    * set body.skuData[*].skuPrice = skuPrice
    * set body.billAmount = billAmount
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @B2C_percentage_discount_on_SKU_payment
  Scenario: B2C percentage __0042.5
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_percentage_discount_on_SKU_paymentType__0042.5"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200


  @B2C_percentage_discount_on_SKU_BillCondition
  Scenario: B2C_percentage_discount_on_SKU_BillCondition __0041.6
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_percentage_discount_on_SKU_discountType__0042.6"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @B2C_percentage_discount_on_SKU_payment_BillCondition
  Scenario: percentage __0041.9
    * header x-client-type = "mpos"
    * def body = apiComponents["B2C_percentage_discount_on_SKU_paymentType__0042.9"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @B2B_B2C_percentage_discount_on_SKU_redemption_BillCondition
  Scenario: b2b cart redemption__0041.10
    * def body = apiComponents["B2B_percentage_discount_on_SKU_discountType__0042.10"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200


  @B2C_cart_redemption
  Scenario: Perform B2C cart redemption discount type1
    * header x-client-type = "mpos"
    * def body =
    """
    {
          "masId": "#(apiComponents['CMS_masid'])",
          "phone": "#(apiComponents['phone'])",
          "billAmount": #(apiComponents['billAmount']),
          "skuData": [
            {
              "skuId": "#(apiComponents['skuid'])",
              "skuQty": #(apiComponents['skuQty']),
              "skuPrice": #(apiComponents['skuPrice'])
            },
            {
              "skuId": "#(apiComponents['skuid1'])",
              "skuQty": #(apiComponents['skuQty1']),
              "skuPrice": #(apiComponents['skuPrice1'])
            },
            {
              "skuId": "#(apiComponents['skuid2'])",
              "skuQty": #(apiComponents['skuQty2']),
              "skuPrice": #(apiComponents['skuPrice2'])
            },
            {
              "skuId": "#(apiComponents['skuid3'])",
              "skuQty": #(apiComponents['skuQty3']),
              "skuPrice": #(apiComponents['skuPrice3'])
            },
             {
              "skuId": "#(apiComponents['skuid4'])",
              "skuQty": #(apiComponents['skuQty4']),
              "skuPrice": #(apiComponents['skuPrice4'])
            },
            {
              "skuId": "#(apiComponents['skuid5'])",
              "skuQty": #(apiComponents['skuQty5']),
              "skuPrice": #(apiComponents['skuPrice5'])
            }
        ]
      }
    """
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

  @B2C_cart_redemption_paymentType
  Scenario: Perform B2C cart redemption payment
    * header x-client-type = "mpos"
    * def body =
    """
    {
          "masId": "#(apiComponents['CMS_masid'])",
          "phone": "#(apiComponents['phone'])",
          "billAmount": #(apiComponents['billAmount']),
          "skuData": [
            {
              "skuId": "#(apiComponents['skuId_payment'])",
              "skuQty": #(apiComponents['skuQty_payment']),
              "skuPrice": #(apiComponents['skuPrice_payment'])
            },
            {
              "skuId": "#(apiComponents['skuId_payment1'])",
              "skuQty": #(apiComponents['skuQty_payment1']),
              "skuPrice": #(apiComponents['skuPrice_payment1'])
            },
            {
              "skuId": "#(apiComponents['skuId_payment2'])",
              "skuQty": #(apiComponents['skuQty_payment2']),
              "skuPrice": #(apiComponents['skuPrice_payment2'])
            },
            {
              "skuId": "#(apiComponents['skuId_payment3'])",
              "skuQty": #(apiComponents['skuQty_payment3']),
              "skuPrice": #(apiComponents['skuPrice_payment3'])
            },
             {
              "skuId": "#(apiComponents['skuId_payment4'])",
              "skuQty": #(apiComponents['skuQty_payment4']),
              "skuPrice": #(apiComponents['skuPrice_payment4'])
            }
            {
              "skuId": "#(apiComponents['skuId_payment5'])",
              "skuQty": #(apiComponents['skuQty_payment5']),
              "skuPrice": #(apiComponents['skuPrice_payment5'])
            }
        ]
      }
    """
    Given path '/coupons/v1/coupons/mastercode/coupon-codes'
    And request body
    When method post
    Then status 200

    @B2C_MRPC
    Scenario: Perform B2C cart redemption MRPC
      * header x-client-type = "mpos"
      * def body =
    """
    {
          "masId": "#(apiComponents['CMS_masid'])",
          "phone": "#(apiComponents['phone'])",
          "billAmount": #(apiComponents['billAmount']),
          "skuData": [
            {
              "skuId": "#(apiComponents['skuid_MRPC'])",
              "skuQty": #(apiComponents['skuQty_MRPC']),
              "skuPrice": #(apiComponents['skuPrice_MRPC'])
            },
            {
              "skuId": "#(apiComponents['skuid_MRPC1'])",
              "skuQty": #(apiComponents['skuQty_MRPC1']),
              "skuPrice": #(apiComponents['skuPrice_MRPC1'])
            },
            {
              "skuId": "#(apiComponents['skuid_MRPC2'])",
              "skuQty": #(apiComponents['skuQty_MRPC2']),
              "skuPrice": #(apiComponents['skuPrice_MRPC2'])
            },
            {
              "skuId": "#(apiComponents['skuid_MRPC3'])",
              "skuQty": #(apiComponents['skuQty_MRPC3']),
              "skuPrice": #(apiComponents['skuPrice_MRPC3'])
            },
             {
              "skuId": "#(apiComponents['skuid_MRPC4'])",
              "skuQty": #(apiComponents['skuQty_MRPC4']),
              "skuPrice": #(apiComponents['skuPrice_MRPC4'])
            },
            {
              "skuId": "#(apiComponents['skuid_MRPC5'])",
              "skuQty": #(apiComponents['skuQty_MRPC5']),
              "skuPrice": #(apiComponents['skuPrice_MRPC5'])
            },
            {
              "skuId": "#(apiComponents['skuid_MRPC6'])",
              "skuQty": #(apiComponents['skuQty_MRPC6']),
              "skuPrice": #(apiComponents['skuPrice_MRPC6'])
            },
            {
              "skuId": "#(apiComponents['skuid_MRPC7'])",
              "skuQty": #(apiComponents['skuQty_MRPC7']),
              "skuPrice": #(apiComponents['skuPrice_MRPC7'])
            },
            {
              "skuId": "#(apiComponents['skuid_MRPC8'])",
              "skuQty": #(apiComponents['skuQty_MRPC8']),
              "skuPrice": #(apiComponents['skuPrice_MRPC8'])
            },
            {
              "skuId": "#(apiComponents['skuid_MRPC9'])",
              "skuQty": #(apiComponents['skuQty_MRPC9']),
              "skuPrice": #(apiComponents['skuPrice_MRPC9'])
            }
        ]
      }
    """
      Given path '/coupons/v1/coupons/mastercode/coupon-codes'
      And request body
      When method post
      Then status 200
      * print response

  @B2B_cart_redemption
  Scenario: Perform B2B cart redemption
    * def body =
    """
    {
          "masId": "#(apiComponents['CMS_masid'])",
          "billAmount": #(apiComponents['billAmount']),
          "skuData": [
            {
              "skuId": "#(apiComponents['skuid'])",
              "skuQty": #(apiComponents['skuQty']),
              "skuPrice": #(apiComponents['skuPrice'])
            },
            {
              "skuId": "#(apiComponents['skuid1'])",
              "skuQty": #(apiComponents['skuQty1']),
              "skuPrice": #(apiComponents['skuPrice1'])
            },
            {
              "skuId": "#(apiComponents['skuid5'])",
              "skuQty": #(apiComponents['skuQty5']),
              "skuPrice": #(apiComponents['skuPrice5'])
            },
            {
              "skuId": "#(apiComponents['skuid3'])",
              "skuQty": #(apiComponents['skuQty3']),
              "skuPrice": #(apiComponents['skuPrice3'])
            },
             {
              "skuId": "#(apiComponents['skuid4'])",
              "skuQty": #(apiComponents['skuQty4']),
              "skuPrice": #(apiComponents['skuPrice4'])
            }
        ]
      }
    """
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @B2B_coupon_redemption
  Scenario: Perform B2B cart redemption for b2b coupon 6
      * def body =
    """
    {
      "masId": "#(apiComponents['CMS_masid'])",
      "billAmount": #(apiComponents['billAmount']),
      "skuData": [
        {
          "skuId": "#(apiComponents['skuId_b2b_coupon'])",
          "articleId": "#(apiComponents['articleId'])",
          "skuQty": #(apiComponents['skuQty_b2b_coupon']),
          "skuPrice": #(apiComponents['skuPrice_b2b_coupon']),
        },
        {
          "skuId": "#(apiComponents['skuId_b2b_coupon1'])",
          "articleId": "#(apiComponents['articleId'])",
          "skuQty": #(apiComponents['skuQty_b2b_coupon1']),
          "skuPrice": #(apiComponents['skuPrice_b2b_coupon1']),
        },
        {
          "skuId": "#(apiComponents['skuId_b2b_coupon2'])",
          "articleId": "#(apiComponents['articleId'])",
          "skuQty": #(apiComponents['skuQty_b2b_coupon2']),
          "skuPrice": #(apiComponents['skuPrice_b2b_coupon2']),
        },
        {
          "skuId": "#(apiComponents['skuId_b2b_coupon3'])",
          "articleId": "#(apiComponents['articleId'])",
          "skuQty": #(apiComponents['skuQty_b2b_coupon3']),
          "skuPrice": #(apiComponents['skuPrice_b2b_coupon3']),
        },
        {
          "skuId": "#(apiComponents['skuId_b2b_coupon4'])",
          "articleId": "#(apiComponents['articleId'])",
          "skuQty": #(apiComponents['skuQty_b2b_coupon4']),
          "skuPrice": #(apiComponents['skuPrice_b2b_coupon4']),
        }
      ]
    }
    """
      Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
      And headers requestHeader
      And request body
      When method post
      Then status 200

  @B2B_verticals_coupon_redemption
  Scenario: Perform B2B SKU_AT_FIXED_PRICE cart redemption__0025.6
    * def body = api_body
    * set body.skuData[*].skuPrice = skuPrice
    * set body.billAmount = billAmount
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @B2B_SKU_AT_FIXED_PRICE_coupon_redemption
  Scenario: Perform B2B SKU_AT_FIXED_PRICE cart redemption__0025
    * def call_configuration_table_b2b = callonce read('support.feature@switch_on_features_b2b')
    * def body = apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption__0025"]
    * set body.skuData[*].skuPrice = skuPrice
    * set body.billAmount = billAmount
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @B2B_SKU_AT_FIXED_PRICE_coupon_redemption_combination
  Scenario: Perform B2B SKU_AT_FIXED_PRICE cart redemption__0025
    * def call_configuration_table_b2b = callonce read('support.feature@switch_on_features_b2b')
    * def body = apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption__0025.10"]
    * set body.skuData[*].skuPrice = skuPrice
    * set body.billAmount = billAmount
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @B2B_SKU_AT_FIXED_PRICE_coupon_redemption_BillCondition
  Scenario: Perform B2B SKU_AT_FIXED_PRICE cart redemption__0025.6
    * def body = apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption__0025.6"]
    * set body.skuData[*].skuPrice = skuPrice
    * set body.billAmount = billAmount
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200


  @B2B_PERCENT_DISCOUNT_coupon_redemption
  Scenario: Perform B2B_PERCENT_DISCOUNT cart redemption__0029
    * def call_configuration_table_b2b = callonce read('support.feature@switch_on_features_b2b')
    * def body = apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption__0029"]
    * set body.skuData[*].skuPrice = skuPrice
    * set body.billAmount = billAmount
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @B2B_PERCENT_DISCOUNT_coupon_redemption_combination
  Scenario: Perform B2B_PERCENT_DISCOUNT cart redemption__0029
    * def call_configuration_table_b2b = callonce read('support.feature@switch_on_features_b2b')
    * def body = apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption__0029.10"]
    * set body.skuData[*].skuPrice = skuPrice
    * set body.billAmount = billAmount
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption
  Scenario: Perform B2B_FLAT_DISCOUNT_ON_SKU cart redemption__0036
    * def body = apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption__0036"]
    * set body.skuData[*].skuPrice = skuPrice
    * set body.billAmount = billAmount
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_combination
  Scenario: Perform B2B_FLAT_DISCOUNT_ON_SKU cart redemption__0036
    * def body = apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption__0036.12"]
    * set body.skuData[*].skuPrice = skuPrice
    * set body.billAmount = billAmount
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_combination_B2C&B2B
  Scenario: Perform B2B_FLAT_DISCOUNT_ON_SKU cart redemption__0036
    * def body = apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption__0036.16"]
    * set body.skuData = skuData
    * set body.skuData[*].skuPrice = skuPrice
    * set body.billAmount = billAmount
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @B2B_FLAT_DISCOUNT_ON_SKU_flash_coupon_verification
  Scenario: Perform B2B_FLAT_DISCOUNT_ON_SKU flash coupon __0037
    * def body = apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_flash_coupon__0037"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
#    And headers requestHeader
    And request body
    When method post
    Then status 200

  @B2B_coupon_redemption_MAS_merchant
  Scenario: Perform B2B cart redemption for b2b coupon with MAS merchant.
    * def body =
    """
    {
      "masId": "#(apiComponents['MAS_masId'])",
      "billAmount": #(apiComponents['billAmount']),
      "skuData": [
        {
          "skuId": "#(apiComponents['skuId_MAS_b2b_coupon'])",
          "articleId": "#(apiComponents['articleId'])",
          "skuQty": #(apiComponents['skuQty_MAS_b2b_coupon']),
          "skuPrice": #(apiComponents['skuPrice_MAS_b2b_coupon']),
        }
      ]
    }
    """
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200


  @B2B_ConditionalCoupon_redemption_merchant
  Scenario: Perform B2B cart redemption for b2b conditional coupon.
    * def body =
    """
    {
      "masId": "#(apiComponents['CMS_masid'])",
      "billAmount": #(apiComponents['billAmount']),
      "skuData": [
        {
          "skuId": "#(apiComponents['conditional_coupon_sku1'])",
          "articleId": "#(apiComponents['articleId'])",
          "skuQty": #(apiComponents['conditional_coupon_skuQuantity']),
          "skuPrice": #(apiComponents['conditional_coupon_skuPrice1']),
        },
        {
          "skuId": "#(apiComponents['conditional_coupon_sku2'])",
          "articleId": "#(apiComponents['articleId'])",
          "skuQty": #(apiComponents['conditional_coupon_skuQuantity']),
          "skuPrice": #(apiComponents['conditional_coupon_skuPrice2']),
        }
      ]
    }
    """
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @B2B_conditional_coupon_redemption_MAS_merchant
  Scenario: Perform B2B cart redemption for b2b conditional coupon with MAS merchant.
    * def body =
    """
    {
      "masId": "#(apiComponents['MAS_masId'])",
      "billAmount": #(apiComponents['billAmount']),
      "skuData": [
        {
          "skuId": "#(apiComponents['conditional_coupon_MAS_sku1'])",
          "articleId": "#(apiComponents['articleId'])",
          "skuQty": #(apiComponents['skuQty_MAS_b2b_coupon']),
          "skuPrice": #(apiComponents['conditional_coupon_MAS_skuPrice1']),
        }
      ]
    }
    """
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200


  @B2B_conditional_coupon_redeeming_MAS
  Scenario: Perform B2B conditional coupon redemption1.
    * def body =
    """
    {
      "masId": "#(apiComponents['MAS_masId'])",
      "billAmount": #(apiComponents['billAmount']),
      "skuData": [
        {
          "skuId": "#(apiComponents['Conditional_coupon_sku'])",
          "articleId": "#(apiComponents['articleId'])",
          "skuQty": #(apiComponents['skuQty_MAS_b2b_coupon']),
          "skuPrice": #(apiComponents['conditional_coupon_MAS_skuPrice1']),
        }
      ]
    }
    """
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @B2B_conditional_coupon_redeeming_CMS
  Scenario: Perform B2B conditional coupon redemption.
    * def body =
    """
    {
      "masId": "#(apiComponents['CMS_masid'])",
      "billAmount": #(apiComponents['billAmount']),
      "skuData": [
        {
          "skuId": "#(apiComponents['Conditional_coupon_sku'])",
          "articleId": "#(apiComponents['articleId'])",
          "skuQty": #(apiComponents['skuQty_MAS_b2b_coupon']),
          "skuPrice": #(apiComponents['conditional_coupon_MAS_skuPrice1']),
        }
      ]
    }
    """
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200


  @B2B_coupon_redemption_for_Performance1
  Scenario: Perform B2B cart redemption for b2b coupon 1
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request apiComponents["b2b_perf_1"]
    When method post
    Then status 200

  @B2B_coupon_redemption_for_Performance2
  Scenario: Perform B2B cart redemption for b2b coupon 2
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request apiComponents["b2b_perf_2"]
    When method post
    Then status 200

  @B2B_coupon_redemption_for_Performance3
  Scenario: Perform B2B cart redemption for b2b coupon 3
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request apiComponents["b2b_perf_3"]
    When method post
    Then status 200

  @B2B_BxGy_parent_cart_redemption
  Scenario: b2b cart redemption__0001.2
    * def body = apiComponents["B2B_BxGy_parent_discountType__0001.2"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @B2B_BxGy_child_cart_redemption
  Scenario: b2b cart redemption__0002.2
    * def body = apiComponents["B2B_BxGy_child_discountType__0002.2"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @B2B_BxGy_percentage_parent_cart_redemption
  Scenario: b2b cart percentage redemption__0007.2
    * def body = apiComponents["B2B_BxGy_parent_percentage_discountType__0007.2"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @B2B_BxGy_percentage_parent_cart_redemption_BillCondition
  Scenario: b2b cart percentage redemption__0007.2
    * def body = apiComponents["B2B_BxGy_parent_percentage_discountType__0007.11"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @B2B_BxGy_percentage_child_cart_redemption
  Scenario: b2b cart percentage redemption_0008.2
    * def body = apiComponents["B2B_BxGy_child_percentage_discountType__0008.2"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @B2B_BxGy_percentage_child_cart_redemption_BillCondition
  Scenario: b2b cart percentage redemption_0008.2
    * def body = apiComponents["B2B_BxGy_child_percentage_discountType__0008.11"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @B2B_BxGy_flat_parent_cart_redemption
  Scenario: b2b cart percentage redemption__0009.2
    * def body = apiComponents["B2B_BxGy_parent_flat_discountType__0009.2"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @B2B_BxGy_flat_child_cart_redemption
  Scenario: b2b cart flat redemption_0010.2
    * def body = apiComponents["B2B_BxGy_child_flat_discountType__0010.2"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @B2B_BxGy_flat_child_cart_redemption_BillCondition
  Scenario: b2b cart flat redemption_0010.11
    * def body = apiComponents["B2B_BxGy_child_flat_discountType__0010.11"]
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption_JPM
  Scenario: Perform B2B_FLAT_DISCOUNT_ON_SKU cart redemption__0036
    * def body = apiComponents["B2B_FLAT_DISCOUNT_ON_SKU_coupon_redemption__0043"]
    * set body.skuData[*].skuPrice = skuPrice
    * set body.billAmount = billAmount
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @B2B_PERCENT_DISCOUNT_coupon_redemption_JPM
  Scenario: Perform B2B_PERCENT_DISCOUNT cart redemption__0029
    * def call_configuration_table_b2b = callonce read('support.feature@switch_on_features_b2b')
    * def body = apiComponents["B2B_PERCENT_DISCOUNT_coupon_redemption__0043"]
    * set body.skuData[*].skuPrice = skuPrice
    * set body.billAmount = billAmount
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

  @B2B_SKU_AT_FIXED_PRICE_coupon_redemption_JPM
  Scenario: Perform B2B SKU_AT_FIXED_PRICE cart redemption__0025
    * def call_configuration_table_b2b = callonce read('support.feature@switch_on_features_b2b')
    * def body = apiComponents["B2B_SKU_AT_FIXED_PRICE_coupon_redemption__0043"]
    * set body.skuData[*].skuPrice = skuPrice
    * set body.billAmount = billAmount
    * set body.masId = apiComponents['CMS_masid']
    Given path '/coupons/v1/coupons/merchant/fc/coupon-codes'
    And headers requestHeader
    And request body
    When method post
    Then status 200

