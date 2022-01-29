Feature: B2C_prompter __0045

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * def apiComponents = envConfig
    * def schemaAndValidation = envSchema
    * def redeem_flags = "false"
    * def headerJson = {}
    * set headerJson.multi_redeem-enabled = redeem_flags
    * set headerJson.Content-Type = 'application/json'
    * set headerJson.x-client-type = 'mpos'
    * def call_configuration_table_b2c = callonce read('support.feature@switch_on_features_b2c')
    * def cache_invalidate = callonce read('support.feature@invalidate_cms_cache')

  Scenario: B2C_BxGy_Flat_off_parent prompter verification __0045. multiredeem
    * def result = call read("B2C_B2B_CouponCodeGeneration.feature@BxGy_parent_flat_cart_mrpc")
    * def b2c_prompter1 = result.response.prompter
    * print "B2C_BxGy_Flat_off_parent prompter", b2c_prompter1
    * match  b2c_prompter1[0] ==
    """
    {
            "couponId": "#number",
            "couponTitle": "#string",
            "discountType": "BXGY_AT_FLAT_DISCOUNT",
            "discountValue": "#number",
            "skuCondition": {
                "skuId": "#string",
                "skuName": "#string",
                "qtyToBeAdded": 1,
                "requiredQuantity": 3
            }
        }
    """

  Scenario: B2C_BxGy_Flat_off_parent prompter verification __0045. single redeem
    * def body = apiComponents["B2C_BxGy_parent_flat_off_discountType_prompter__0009"].skuData1
    * def result = call read("B2C_B2B_CouponCodeGeneration.feature@BxGy_flat_parent_cart_prompter"){body: #(body)}
    * def b2c_prompter1 = result.response.prompter
    * print "B2C_BxGy_Flat_off_parent prompter", b2c_prompter1
    * match  b2c_prompter1[0] ==
    """
   {
            "couponId": "#number",
            "couponTitle": "#string",
            "discountType": "BXGY_AT_FLAT_DISCOUNT",
            "discountValue": "#number",
            "skuOffer": {
                "skuId": "#string",
                "skuName": "#string",
                "qtyToBeAdded": 1,
                "requiredQuantity": 2
            },
            "skuCondition": {
                "skuId": "#string",
                "skuName": "#string",
                "qtyToBeAdded": 1,
                "requiredQuantity": 3
            }
        }
    """

  Scenario: B2C_BxGy_Flat_off_parent prompter verification __0045. single redeem
    * def body = apiComponents["B2C_BxGy_parent_flat_off_discountType_prompter__0009"].skuData2
    * def result = call read("B2C_B2B_CouponCodeGeneration.feature@BxGy_flat_parent_cart_prompter"){body: #(body)}
    * def b2c_prompter1 = result.response.prompter
    * print "B2C_BxGy_Flat_off_parent prompter", b2c_prompter1
    * match  b2c_prompter1[0] ==
    """
   {
            "couponId": "#number",
            "couponTitle": "#string",
            "discountType": "BXGY_AT_FLAT_DISCOUNT",
            "discountValue": "#number",
            "skuOffer": {
                "skuId": "#string",
                "skuName": "#string",
                "qtyToBeAdded": 2,
                "requiredQuantity": 2
            },
            "skuCondition": {
                "skuId": "#string",
                "skuName": "#string",
                "qtyToBeAdded": 1,
                "requiredQuantity": 3
            }
        }
    """

  Scenario: B2C_BxGy_Flat_off_child prompter verification __0045. Multiredeem
    * def result = call read("B2C_B2B_CouponCodeGeneration.feature@BxGy_child_flat_cart_mrpc")
    * def b2c_prompter2 = result.response.prompter
    * print "B2C_BxGy_Flat_off_child prompter", b2c_prompter2
    * match  b2c_prompter2[0] ==
    """
    {
            "couponId": "#number",
            "couponTitle": "#string",
            "discountType": "BXGY_AT_FLAT_DISCOUNT",
            "discountValue": "#number",
            "skuCondition": {
                "skuId": "#string",
                "skuName": "#string",
                "qtyToBeAdded": 1,
                "requiredQuantity": 3
            }
        }
    """

  Scenario: B2C_BxGy_Flat_off_child prompter verification __0045. Single redeem
    * def body = apiComponents["B2C_BxGy_child_flat_off_discountType_prompter__0010"].skuData1
    * def result = call read("B2C_B2B_CouponCodeGeneration.feature@BxGy_flat_child_cart_prompter"){body: #(body)}
    * def b2c_prompter2 = result.response.prompter
    * print "B2C_BxGy_Flat_off_child prompter", b2c_prompter2
    * match  b2c_prompter2[0] ==
    """
   {
            "couponId": "#number",
            "couponTitle": "#string",
            "discountType": "BXGY_AT_FLAT_DISCOUNT",
            "discountValue": "#number",
            "skuOffer": {
                "skuId": "#string",
                "skuName": "#string",
                "qtyToBeAdded": 1,
                "requiredQuantity": 2
            },
            "skuCondition": {
                "skuId": "#string",
                "skuName": "#string",
                "qtyToBeAdded": 1,
                "requiredQuantity": 3
            }
        }
    """

  Scenario: B2C_BxGy_Flat_off_child prompter verification __0045. Single redeem
    * def body = apiComponents["B2C_BxGy_child_flat_off_discountType_prompter__0010"].skuData2
    * def result = call read("B2C_B2B_CouponCodeGeneration.feature@BxGy_flat_child_cart_prompter"){body: #(body)}
    * def b2c_prompter2 = result.response.prompter
    * print "B2C_BxGy_Flat_off_child prompter", b2c_prompter2
    * match  b2c_prompter2[0] ==
    """
   {
            "couponId": "#number",
            "couponTitle": "#string",
            "discountType": "BXGY_AT_FLAT_DISCOUNT",
            "discountValue": "#number",
            "skuOffer": {
                "skuId": "#string",
                "skuName": "#string",
                "qtyToBeAdded": 2,
                "requiredQuantity": 2
            },
            "skuCondition": {
                "skuId": "#string",
                "skuName": "#string",
                "qtyToBeAdded": 1,
                "requiredQuantity": 3
            }
        }
    """

  Scenario: B2C_BxGy_Percent_off_parent prompter verification __0045. Multiredeem
    * def sku_price1 = apiComponents["B2C_BxGy_parent_percentage_off_discountType_mrpc__0007.4"].skuData[0].skuPrice
    * def sku_price2 = apiComponents["B2C_BxGy_parent_percentage_off_discountType_mrpc__0007.4"].skuData[1].skuPrice
    * def body = apiComponents["B2C_BxGy_parent_percentage_off_discountType_mrpc__0007.4"]
    * def bill_amount = apiComponents["B2C_BxGy_parent_percentage_off_discountType_mrpc__0007.4"].billAmount
    * def result = call read("B2C_B2B_CouponCodeGeneration.feature@BxGy_parent_percentage_cart_mrpc"){skuPrice1: #(sku_price1),skuPrice2: #(sku_price2), billAmount: #(bill_amount), body: #(body)}
    * def b2c_prompter3 = result.response.prompter
    * print "B2C_BxGy_Percent_off_parent prompter", b2c_prompter3
    * match  b2c_prompter3[0] ==
     """
    {
            "couponId": "#number",
            "couponTitle": "#string",
            "discountType": "BXGY_AT_PERCENTAGE_DISCOUNT",
            "discountValue": "#number",
            "skuCondition": {
                "skuId": "#string",
                "skuName": "#string",
                "qtyToBeAdded": 1,
                "requiredQuantity": 3
            }
        }
    """

  Scenario: B2C_BxGy_Percent_off_parent prompter verification __0045. Single redeem
    * def body = apiComponents["B2C_BxGy_parent_percentage_off_discountType_prompter__0007"].skuData1
    * def result = call read("B2C_B2B_CouponCodeGeneration.feature@BxGy_percentage_parent_cart_prompter"){body: #(body)}
    * def b2c_prompter3 = result.response.prompter
    * print "B2C_BxGy_Percent_off_parent prompter", b2c_prompter3
    * match  b2c_prompter3[0] ==
     """
   {
            "couponId": "#number",
            "couponTitle": "#string",
            "discountType": "BXGY_AT_PERCENTAGE_DISCOUNT",
            "discountValue": "#number",
            "skuOffer": {
                "skuId": "#string",
                "skuName": "#string",
                "qtyToBeAdded": 1,
                "requiredQuantity": 2
            },
            "skuCondition": {
                "skuId": "#string",
                "skuName": "#string",
                "qtyToBeAdded": 1,
                "requiredQuantity": 3
            }
        }
    """

  Scenario: B2C_BxGy_Percent_off_parent prompter verification __0045. Single redeem
    * def body = apiComponents["B2C_BxGy_parent_percentage_off_discountType_prompter__0007"].skuData2
    * def result = call read("B2C_B2B_CouponCodeGeneration.feature@BxGy_percentage_parent_cart_prompter"){body: #(body)}
    * def b2c_prompter3 = result.response.prompter
    * print "B2C_BxGy_Percent_off_parent prompter", b2c_prompter3
    * match  b2c_prompter3[0] ==
     """
   {
            "couponId": "#number",
            "couponTitle": "#string",
            "discountType": "BXGY_AT_PERCENTAGE_DISCOUNT",
            "discountValue": "#number",
            "skuOffer": {
                "skuId": "#string",
                "skuName": "#string",
                "qtyToBeAdded": 2,
                "requiredQuantity": 2
            },
            "skuCondition": {
                "skuId": "#string",
                "skuName": "#string",
                "qtyToBeAdded": 1,
                "requiredQuantity": 3
            }
        }
    """

  Scenario: B2C_BxGy_Percent_off_child prompter verification __0045. Multiredeem
    * def sku_price1 = apiComponents["B2C_BxGy_child_percentage_off_discountType_mrpc__0008.4"].skuData[0].skuPrice
    * def sku_price2 = apiComponents["B2C_BxGy_child_percentage_off_discountType_mrpc__0008.4"].skuData[1].skuPrice
    * def body = apiComponents["B2C_BxGy_child_percentage_off_discountType_mrpc__0008.4"]
    * def bill_amount = apiComponents["B2C_BxGy_child_percentage_off_discountType_mrpc__0008.4"].billAmount
    * def result = call read("B2C_B2B_CouponCodeGeneration.feature@BxGy_child_percentage_cart_mrpc"){skuPrice1: #(sku_price1),skuPrice2: #(sku_price2), billAmount: #(bill_amount), body: #(body)}
    * def b2c_prompter4 = result.response.prompter
    * print "B2C_BxGy_Percent_off_child prompter", b2c_prompter4
    * match  b2c_prompter4[0] ==
  """
   {
            "couponId": "#number",
            "couponTitle": "#string",
            "discountType": "BXGY_AT_PERCENTAGE_DISCOUNT",
            "discountValue": "#number",
            "skuOffer": {
                "skuId": "#string",
                "skuName": "#string",
                "qtyToBeAdded": 2,
                "requiredQuantity": 2
            },
            "skuCondition": {
                "skuId": "#string",
                "skuName": "#string",
                "qtyToBeAdded": 3,
                "requiredQuantity": 3
            }
        }
    """

  Scenario: B2C_BxGy_Percent_off_child prompter verification __0045. Single Redeem
    * def body = apiComponents["B2C_BxGy_child_percentage_off_discountType_prompter__0008"].skuData1
    * def result = call read("B2C_B2B_CouponCodeGeneration.feature@BxGy_percentage_child_cart_prompter"){body: #(body)}
    * def b2c_prompter4 = result.response.prompter
    * print "B2C_BxGy_Percent_off_child prompter", b2c_prompter4
    * match  b2c_prompter4[0] ==
  """
   {
            "couponId": "#number",
            "couponTitle": "#string",
            "discountType": "BXGY_AT_PERCENTAGE_DISCOUNT",
            "discountValue": "#number",
            "skuOffer": {
                "skuId": "#string",
                "skuName": "#string",
                "qtyToBeAdded": 1,
                "requiredQuantity": 2
            },
            "skuCondition": {
                "skuId": "#string",
                "skuName": "#string",
                "qtyToBeAdded": 1,
                "requiredQuantity": 3
            }
        }
    """

  Scenario: B2C_BxGy_Percent_off_child prompter verification __0045. Single Redeem
    * def body = apiComponents["B2C_BxGy_child_percentage_off_discountType_prompter__0008"].skuData2
    * def result = call read("B2C_B2B_CouponCodeGeneration.feature@BxGy_percentage_child_cart_prompter"){body: #(body)}
    * def b2c_prompter4 = result.response.prompter
    * print "B2C_BxGy_Percent_off_child prompter", b2c_prompter4
    * match  b2c_prompter4[0] ==
  """
   {
            "couponId": "#number",
            "couponTitle": "#string",
            "discountType": "BXGY_AT_PERCENTAGE_DISCOUNT",
            "discountValue": "#number",
            "skuOffer": {
                "skuId": "#string",
                "skuName": "#string",
                "qtyToBeAdded": 2,
                "requiredQuantity": 2
            },
            "skuCondition": {
                "skuId": "#string",
                "skuName": "#string",
                "qtyToBeAdded": 1,
                "requiredQuantity": 3
            }
        }
    """


  Scenario: Switching off the features __0033.
    * def call_configuration_table_b2c = callonce read('support.feature@switch_off_features_b2c')
    * def cache_invalidate = callonce read('support.feature@invalidate_cms_cache')
