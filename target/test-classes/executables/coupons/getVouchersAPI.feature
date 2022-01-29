@ignore
Feature: Get Vouchers

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * header Content-Type = 'application/json'
    * json result = callonce read("support.feature@switch_on_features")

  Scenario Outline: Verify Get all the offline coupons Response Status
    Given path <Path>
    And header x-client-type = 'mpos'
    When method GET
    Then match responseStatus == <Status>
    * def schema =
    """
    {
        "voucherCode": "#String",
        "voucherType": "BILL",
        "autoApplicable": #,
        "validFrom": "2020-05-13 00:00:00",
        "validTo": "2021-12-11 23:59:59",
    }
    """
    * def schema1 =
    """
    {
      "type": "FLAT_DISCOUNT",
      "value": 151.0,
      "maxDiscount": 53.0
    }
    """

    * def schema2 =
    """
    {
      "minBillValue": 503.0
    }
    """

    Examples:
      |Path                                                             |Status|
      |'/v1/cms/vouchers?type=bill&masid=100001000071385'               |200   |
#      |'/v1/cms/vouchers?type=category&masid=100001000217520'           |404   |


  Scenario Outline: Valid voucher display.
    * def body =
    """
    {
      "quantity": 2,
      "cartValue": 500,
      "products": [
        {
            "skuId": "811143212223",
            "articleId": "lol",
            "skuQty": 2,
            "skuPrice": 100,
            "categoryId": "6",
            "subCategoryId": "6"
        }
      ]
    }
    """

    Given path '/v1/cms/vouchers_for_cart'
    And params {type:<type_>, masid:<masid_>}
    And request body
    When method post
    Then status 200

    Examples:
    |type_         |masid_              |
    |"bill"        |"100001000071385"   |
    |"bill"        |"100001000069194"   |
    |"bill"        |"100001000183906"   |
    |"bill"        |"100001000183846"   |
    |'category'    |'100001000073658'   |

  Scenario: Switching off the features __0036.3.
    * def call_configuration_table = callonce read('support.feature@switch_off_features')