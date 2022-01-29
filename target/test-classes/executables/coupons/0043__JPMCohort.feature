@redis_off
Feature: create Merchant Cohort

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * def login = callonce read('support.feature@login')
    * def headerJson = {}
    * set headerJson.Cookie = $login.responseHeaders['Set-Cookie'][0]
    * set headerJson.X-Anti-Forgery = $login.responseHeaders['x-anti-forgery'][0]
    * set headerJson.Content-Type = 'application/json'
    * def headerJson1 = {}
    * set headerJson1.Content-Type = 'application/json'
    * def apiComponents = envConfig
    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])
    * def unique_cohort = function(){ return java.lang.System.currentTimeMillis() }
    * def call_configuration_table = callonce read('support.feature@switch_off_redis')

  Scenario: create new JPM Merchant Cohort
    * def cohort_name = "Cohort"+ unique_cohort()
    * def cohort_id = unique_cohort()

    * def body =
    """
      {
        "cohorts": [
          {
            "id": "#(cohort_id)",
            "name": "#(cohort_name)",
            "added_merchants": [
              "#(apiComponents['mas_id3_add'])",
              "#(apiComponents['mas_id2_add'])"
            ],
            "removed_merchants": [

            ]
          }
        ]
      }
    """
    Given path '/coupons/v1/coupons/merchants/cohort-sync'
    And  request body
    And headers headerJson1
    When method post
    Then status 200

    Given path '/coupons/v1/coupons/merchants/jpm-cohorts-sync-status'
    And headers headerJson
    And params {page: 1, page-size: 10}
    When method get
    Then status 200
    And match response.data[0].id == cohort_id
    And match response.data[0].action == "inProcess"
    And match each response.data ==
    """
        {
        "id": "#number",
        "mgid": "##number",
        "name": "#string",
        "createdAt": "##? isValidDate(_)",
        "updatedAt": "#? isValidDate(_)",
        "requestTs": "#? isValidDate(_)",
        "addedMerchants": "#string",
        "removedMerchants": "#string",
        "action":"#string"
        }
  """
    Given path '/coupons/v1/coupons/merchants/downloadFutureCohortMerchants/'+cohort_id
    And headers headerJson
    When method get
    Then status 200
    * print response


    Given path '/coupons/v1/coupons/merchants/initiate-jpm-cohort-sync'
    And  request {}
    When method put
    Then status 200
    * def jpm_cohort_id = db.readRows("SELECT * FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id+ "\'")
    * match jpm_cohort_id != []
    * print jpm_cohort_id
    * def mgidmasid = db.readRows("SELECT * FROM mgid_mid_masid where mgid in (select id FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id+ "\' )")
    * match mgidmasid != []
    * def merchant_group = db.readRows("SELECT * FROM merchant_group where id in (select id FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id+ "\' )")
    * match merchant_group[0].user_group != null
    * match merchant_group[0].merchant_count == 2


    Given url  baseUrl+ '/v1/cms/merchant-group/'
    And params {page: 1, page-size: 10}
    And headers headerJson
    When method get
    Then status 200
    * match response.data[0].id == mgidmasid[0].mgid
    * match response.data[0].status == 2

  Scenario:  JPM Merchant Cohort Update

    * def cohort_name = "Cohort"+ unique_cohort()
    * def cohort_id = unique_cohort()

    * def body =
    """
            {
        "cohorts": [
          {
            "id": "#(cohort_id)",
            "name": "#(cohort_name)",
            "added_merchants": [
              "#(apiComponents['mas_id3_add'])",
              "#(apiComponents['mas_id2_add'])"
            ],
            "removed_merchants": [

            ]
          }
        ]
      }
    """
    Given path '/coupons/v1/coupons/merchants/cohort-sync'
    And  request body
    And headers headerJson1
    When method post
    Then status 200

    Given path '/coupons/v1/coupons/merchants/initiate-jpm-cohort-sync'
    And  request {}
    When method put
    Then status 200

    Given path '/coupons/v1/coupons/merchants/jpm-cohorts'
    And headers headerJson
    And params {page: 1, page-size: 10}
    When method get
    Then status 200
    * def cohort_id = response.data[0].id
    * def cohort_name = response.data[0].name
    * def new_name = cohort_name+'_new'
    * def remove_mas_ids = db.readRows("SELECT masid FROM mgid_mid_masid where mgid in (select id FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id+ "\' )")
    * def merchant_group = db.readRows("SELECT merchant_count FROM merchant_group where id in (select id FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id+ "\' )")

    * def body =
    """
            {
        "cohorts": [
          {
            "id": "#(cohort_id)",
            "name": "#(new_name)",
            "added_merchants": [
              "#(apiComponents['mas_id1_add'])"
            ],
            "removed_merchants": [
                "#(remove_mas_ids[0].masid)"

            ]
          }
        ]
      }
    """
    Given path '/coupons/v1/coupons/merchants/cohort-sync'
    And  request body
    And headers headerJson1
    When method post
    Then status 200

    Given path '/coupons/v1/coupons/merchants/jpm-cohorts-sync-status'
    And headers headerJson
    And params {page: 1, page-size: 10}
    When method get
    Then status 200
    And match each response.data ==
    """
        {
        "id": "#number",
        "mgid": "##number",
        "name": "#string",
        "createdAt": "##? isValidDate(_)",
        "updatedAt": "#? isValidDate(_)",
        "requestTs": "#? isValidDate(_)",
        "addedMerchants": "#string",
        "removedMerchants": "#string",
        "action":"#string"
        }
  """

    Given path '/coupons/v1/coupons/merchants/initiate-jpm-cohort-sync'
    And  request {}
    When method put
    Then status 200
    * def mgidmasid_removed = db.readRows("SELECT masid FROM mgid_mid_masid where mgid in (select id FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id+ "\' ) and masid in (\'" +remove_mas_ids[0].masid+ "\' )")
    * match mgidmasid_removed == []
    * def added_merchant = apiComponents['mas_id1_add']
    * def mgidmasid_added = db.readRows("SELECT masid FROM mgid_mid_masid where mgid in (select id FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id+ "\' ) and masid in (\'" +added_merchant+ "\' )")
    * match mgidmasid_added != []
    * def merchant_group_after = db.readRows("SELECT merchant_count FROM merchant_group where id in (select id FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id+ "\' )")
    * match merchant_group_after[0].merchant_count == merchant_group[0].merchant_count

    Given path '/coupons/v1/coupons/merchants/jpm-cohorts'
    And headers headerJson
    And params {page: 1, page-size: 10}
    When method get
    Then status 200
    And match response.data[0].name == new_name

  Scenario Outline:  JPM Merchant Cohort- negative cases
    * def cohort_name = "Cohort"+ unique_cohort()
    * def cohort_id = unique_cohort()
    * def body =
   """
           {
       "cohorts": [
         {
           "id": "#(cohort_id)",
           "name": "#(cohort_name)",
           "added_merchants": [
             "#(apiComponents['mas_id3_add'])"
           ],
           "removed_merchants": [

           ]
         }
       ]
     }
   """
    * print "<============== test_description ==============>", <scenario_description>
    * print "<============== request_body ==============>", <request_body>
    * print "<============== additional_changes ==============>", <additional_changes>
    * print "<============== additional_changes ==============>", body

    Given path '/coupons/v1/coupons/merchants/cohort-sync'
    And  request body
    And headers headerJson1
    When method post
    Then status <status_code>

    Examples:
      |scenario_description                 |status_code|request_body                                                              |additional_changes                                                                    |
      |" duplicate masid in added=> "       |400        |body.cohorts[0].added_merchants = ["100001000183843","100001000183843"]   |null                                                                                  |
      |" duplicate masid in removed=> "     |400        |body.cohorts[0].removed_merchants = ["100001000183843","100001000183843"] |null                                                                                  |
      |"null cohort id"                     |400        |body.cohorts[0].id = ""                                                   |null                                                                                  |
      |"null cohort name"                   |400        |body.cohorts[0].name = ""                                                 |null                                                                                  |
      |" same masid in added&removed=> "    |400        |body.cohorts[0].added_merchants = ["100001000183843"]                     |body.cohorts[0].removed_merchants = ["100001000183843"]                                                                                 |

  Scenario: create new JPM Merchant Cohort- checking no duplicate entries created for same req
    * def cohort_name = "Cohort"+ unique_cohort()
    * def cohort_id = unique_cohort()

    * def body =
    """
            {
        "cohorts": [
          {
            "id": "#(cohort_id)",
            "name": "#(cohort_name)",
            "added_merchants": [
              "#(apiComponents['mas_id3_add'])"
            ],
            "removed_merchants": [

            ]
          }
        ]
      }
    """
    Given path '/coupons/v1/coupons/merchants/cohort-sync'
    And  request body
    And headers headerJson1
    When method post
    Then status 200

    Given path '/coupons/v1/coupons/merchants/jpm-cohorts-sync-status'
    And headers headerJson
    And params {page: 1, page-size: 10}
    When method get
    Then status 200
    And match response.data[0].action == "inProcess"
    And match each response.data ==
    """
        {
        "id": "#number",
        "mgid": "##number",
        "name": "#string",
        "createdAt": "##? isValidDate(_)",
        "updatedAt": "#? isValidDate(_)",
        "requestTs": "#? isValidDate(_)",
        "addedMerchants": "#string",
        "removedMerchants": "#string",
        "action":"#string"
        }
  """

    Given path '/coupons/v1/coupons/merchants/initiate-jpm-cohort-sync'
    And  request {}
    When method put
    Then status 200
    * def jpm_cohort_id = db.readRows("SELECT * FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id+ "\'")
    * match jpm_cohort_id != []
    * print jpm_cohort_id
    * def mgidmasid = db.readRows("SELECT * FROM mgid_mid_masid where mgid in (select id FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id+ "\' )")
    * match mgidmasid != []
    * def merchant_group = db.readRows("SELECT * FROM merchant_group where id in (select id FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id+ "\' )")
    * match merchant_group[0].user_group != null
    * match merchant_group[0].merchant_count == 1

    * def body =
    """
            {
        "cohorts": [
          {
            "id": "#(cohort_id)",
            "name": "#(cohort_name)",
            "added_merchants": [
              "#(apiComponents['mas_id3_add'])"
            ],
            "removed_merchants": [

            ]
          }
        ]
      }
    """
    Given path '/coupons/v1/coupons/merchants/cohort-sync'
    And  request body
    And headers headerJson1
    When method post
    Then status 200

    Given path '/coupons/v1/coupons/merchants/jpm-cohorts-sync-status'
    And headers headerJson
    And params {page: 1, page-size: 10}
    When method get
    Then status 200
    And match each response.data ==
    """
        {
        "id": "#number",
        "mgid": "##number",
        "name": "#string",
        "createdAt": "##? isValidDate(_)",
        "updatedAt": "#? isValidDate(_)",
        "requestTs": "#? isValidDate(_)",
        "addedMerchants": "#string",
        "removedMerchants": "#string",
        "action":"#string"
        }
  """
    Given path '/coupons/v1/coupons/merchants/initiate-jpm-cohort-sync'
    And  request {}
    When method put
    Then status 200
    * def jpm_cohort_id = db.readRows("SELECT * FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id+ "\'")
    * match jpm_cohort_id != []
    * print jpm_cohort_id
    * def mgidmasid = db.readRows("SELECT count(*) as count FROM mgid_mid_masid where mgid in (select id FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id+ "\' ) and masid=\'" +apiComponents['mas_id3_add']+ "\'")
    * match mgidmasid[0].count == 1
    * def merchant_group = db.readRows("SELECT * FROM merchant_group where id in (select id FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id+ "\' )")
    * match merchant_group[0].user_group != null
    * match merchant_group[0].merchant_count == 1

  Scenario: create new JPM Merchant Cohort- Removing masid not in cohort
    * def cohort_name = "Cohort"+ unique_cohort()
    * def cohort_id = unique_cohort()

    * def body =
    """
            {
        "cohorts": [
          {
            "id": "#(cohort_id)",
            "name": "#(cohort_name)",
            "added_merchants": [
              "#(apiComponents['mas_id3_add'])"
            ],
            "removed_merchants": [

            ]
          }
        ]
      }
    """
    Given path '/coupons/v1/coupons/merchants/cohort-sync'
    And  request body
    And headers headerJson1
    When method post
    Then status 200

    Given path '/coupons/v1/coupons/merchants/jpm-cohorts-sync-status'
    And headers headerJson
    And params {page: 1, page-size: 10}
    When method get
    Then status 200
    And match each response.data ==
    """
        {
        "id": "#number",
        "mgid": "##number",
        "name": "#string",
        "createdAt": "##? isValidDate(_)",
        "updatedAt": "#? isValidDate(_)",
        "requestTs": "#? isValidDate(_)",
        "addedMerchants": "#string",
        "removedMerchants": "#string",
        "action":"#string"
        }
  """

    Given path '/coupons/v1/coupons/merchants/initiate-jpm-cohort-sync'
    And  request {}
    When method put
    Then status 200
    * def jpm_cohort_id = db.readRows("SELECT * FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id+ "\'")
    * match jpm_cohort_id != []
    * print jpm_cohort_id
    * def mgidmasid = db.readRows("SELECT * FROM mgid_mid_masid where mgid in (select id FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id+ "\' )")
    * match mgidmasid != []
    * def merchant_group = db.readRows("SELECT * FROM merchant_group where id in (select id FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id+ "\' )")
    * match merchant_group[0].user_group != null
    * match merchant_group[0].merchant_count == 1


    * def jpm_cohort_id = db.readRows("SELECT * FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id+ "\'")
    * def cohort_name2 = "Cohort"+ unique_cohort()
    * def cohort_id2 = unique_cohort()
    * def body =
    """
            {
        "cohorts": [
          {
            "id": "#(cohort_id)",
            "name": "#(cohort_name)",
            "added_merchants": [

            ],
            "removed_merchants": [
                "#(apiComponents['mas_id1_add'])"
            ]
          },
          {
            "id": "#(cohort_id2)",
            "name": "#(cohort_name2)",
            "added_merchants": [
              "#(apiComponents['mas_id3_add'])"
            ],
            "removed_merchants": [

            ]
          }
        ]
      }
    """
    Given path '/coupons/v1/coupons/merchants/cohort-sync'
    And  request body
    And headers headerJson1
    When method post
    Then status 200

    Given path '/coupons/v1/coupons/merchants/jpm-cohorts-sync-status'
    And headers headerJson
    And params {page: 1, page-size: 10}
    When method get
    Then status 200
    And match each response.data ==
    """
        {
        "id": "#number",
        "mgid": "##number",
        "name": "#string",
        "createdAt": "##? isValidDate(_)",
        "updatedAt": "#? isValidDate(_)",
        "requestTs": "#? isValidDate(_)",
        "addedMerchants": "#string",
        "removedMerchants": "#string",
        "action":"#string"
        }
  """

    Given path '/coupons/v1/coupons/merchants/initiate-jpm-cohort-sync'
    And  request {}
    When method put
    Then status 200
    * def jpm_cohort_id_after = db.readRows("SELECT * FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id+ "\'")
    * match jpm_cohort_id_after != []
    * print jpm_cohort_id_after
    * match jpm_cohort_id[0].UPDATEDAT == jpm_cohort_id_after[0].UPDATEDAT
    * def mgidmasid = db.readRows("SELECT count(*) as count FROM mgid_mid_masid where mgid in (select id FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id+ "\' ) and masid=\'" +apiComponents['mas_id3_add']+ "\'")
    * match mgidmasid[0].count == 1
    * def merchant_group = db.readRows("SELECT * FROM merchant_group where id in (select id FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id+ "\' )")
    * match merchant_group[0].user_group != null
    * match merchant_group[0].merchant_count == 1
    * def jpm_cohort_id_2 = db.readRows("SELECT * FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id2+ "\'")
    * match jpm_cohort_id_2 != []

  Scenario: create new JPM Merchant Cohort- Removing masid not in/in cohort-combination
    * def cohort_name = "Cohort"+ unique_cohort()
    * def cohort_id = unique_cohort()

    * def body =
    """
            {
        "cohorts": [
          {
            "id": "#(cohort_id)",
            "name": "#(cohort_name)",
            "added_merchants": [
              "#(apiComponents['mas_id3_add'])"
            ],
            "removed_merchants": [

            ]
          }
        ]
      }
    """
    Given path '/coupons/v1/coupons/merchants/cohort-sync'
    And  request body
    And headers headerJson1
    When method post
    Then status 200

    Given path '/coupons/v1/coupons/merchants/jpm-cohorts-sync-status'
    And headers headerJson
    And params {page: 1, page-size: 10}
    When method get
    Then status 200
    And match each response.data ==
    """
        {
        "id": "#number",
        "mgid": "##number",
        "name": "#string",
        "createdAt": "##? isValidDate(_)",
        "updatedAt": "#? isValidDate(_)",
        "requestTs": "#? isValidDate(_)",
        "addedMerchants": "#string",
        "removedMerchants": "#string",
        "action":"#string"
        }
  """

    Given path '/coupons/v1/coupons/merchants/initiate-jpm-cohort-sync'
    And  request {}
    When method put
    Then status 200
    * def jpm_cohort_id = db.readRows("SELECT * FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id+ "\'")
    * match jpm_cohort_id != []
    * print jpm_cohort_id
    * def mgidmasid = db.readRows("SELECT * FROM mgid_mid_masid where mgid in (select id FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id+ "\' )")
    * match mgidmasid != []
    * def merchant_group = db.readRows("SELECT * FROM merchant_group where id in (select id FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id+ "\' )")
    * match merchant_group[0].user_group != null
    * match merchant_group[0].merchant_count == 1

    * def body =
    """
            {
        "cohorts": [
          {
            "id": "#(cohort_id)",
            "name": "#(cohort_name)",
            "added_merchants": [

            ],
            "removed_merchants": [
                "#(apiComponents['mas_id3_add'])",
                "#(apiComponents['mas_id1_add'])"
            ]
          }
        ]
      }
    """
    Given path '/coupons/v1/coupons/merchants/cohort-sync'
    And  request body
    And headers headerJson1
    When method post
    Then status 200

    Given path '/coupons/v1/coupons/merchants/jpm-cohorts-sync-status'
    And headers headerJson
    And params {page: 1, page-size: 10}
    When method get
    Then status 200
    And match each response.data ==
    """
        {
        "id": "#number",
        "mgid": "##number",
        "name": "#string",
        "createdAt": "##? isValidDate(_)",
        "updatedAt": "#? isValidDate(_)",
        "requestTs": "#? isValidDate(_)",
        "addedMerchants": "#string",
        "removedMerchants": "#string",
        "action":"#string"
        }
  """

    Given path '/coupons/v1/coupons/merchants/initiate-jpm-cohort-sync'
    And  request {}
    When method put
    Then status 200
    * def jpm_cohort_id_after = db.readRows("SELECT * FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id+ "\'")
    * match jpm_cohort_id_after != []
    * print jpm_cohort_id_after
    * def mgidmasid = db.readRows("SELECT count(*) as count FROM mgid_mid_masid where mgid in (select id FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id+ "\' ) and masid=\'" +apiComponents['mas_id3_add']+ "\'")
    * match mgidmasid[0].count == 0
    * def merchant_group = db.readRows("SELECT * FROM merchant_group where id in (select id FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id+ "\' )")
    * match merchant_group[0].user_group != null
    * match merchant_group[0].merchant_count == 0

  Scenario: Checking Retry mechanism when cohort request contains combination of Valid & invalid merchants
    * def retry_count_update = db.updateRow("UPDATE configuration set CONFIG_VALUE=2 where config_name=\'retry_cohort_frequency\'")
    * def retry_count = 2

    Given path '/coupons/v1/coupons/invalidateCache'
    And headers headerJson1
    When method DELETE
    Then status 200

    * def cohort_name = "Cohort_testRetry"+ unique_cohort()
    * def cohort_id = unique_cohort()

    * def body =
    """
            {
        "cohorts": [
          {
            "id": "#(cohort_id)",
            "name": "#(cohort_name)",
            "added_merchants": [
              "#(apiComponents['mas_id3_add'])",
              "#(apiComponents['mas_id2_add'])",
              "#(apiComponents['mas_id1_invalid'])"
            ],
            "removed_merchants": [

            ]
          }
        ]
      }
    """
    Given path '/coupons/v1/coupons/merchants/cohort-sync'
    And  request body
    And headers headerJson1
    When method post
    Then status 200

    Given path '/coupons/v1/coupons/merchants/jpm-cohorts-sync-status'
    And headers headerJson
    And params {page: 1, page-size: 10}
    When method get
    Then status 200
    And match response.data[0].id == cohort_id
    And match each response.data ==
    """
        {
        "id": "#number",
        "mgid": "##number",
        "name": "#string",
        "createdAt": "##? isValidDate(_)",
        "updatedAt": "#? isValidDate(_)",
        "requestTs": "#? isValidDate(_)",
        "addedMerchants": "#string",
        "removedMerchants": "#string",
        "action": "##string"
        }
  """
    Given path '/coupons/v1/coupons/merchants/downloadFutureCohortMerchants/'+cohort_id
    And headers headerJson
    When method get
    Then status 200
    * print response

    Given path '/coupons/v1/coupons/merchants/initiate-jpm-cohort-sync'
    And  request {}
    When method put
    Then status 200
    * def jpm_cohort_id = db.readRows("SELECT * FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id+ "\'")
    * match jpm_cohort_id != []
    * print jpm_cohort_id
    * def mgidmasid = db.readRows("SELECT * FROM mgid_mid_masid where mgid in (select id FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id+ "\' )")
    * match mgidmasid != []
    * def merchant_group = db.readRows("SELECT * FROM merchant_group where id in (select id FROM jpm_merchant_cohort where jpmcohortid=\'" +cohort_id+ "\' )")
    * match merchant_group[0].user_group != null
    * match merchant_group[0].merchant_count == 2

    Given path '/coupons/v1/coupons/merchants/jpm-cohorts'
    And headers headerJson
    And params {page: 1, page-size: 10}
    When method get
    Then status 200
    And match response.data[0].id == cohort_id
    And match each response.data ==
    """
        {
        "id": "#number",
        "mgid": "#number",
        "name": "#string",
        "createdAt": "#? isValidDate(_)",
        "updatedAt": "#? isValidDate(_)",
        "merchants": "#string"
        }
  """

    Given url  baseUrl+ '/v1/cms/merchant-group/'
    And params {page: 1, page-size: 10}
    And headers headerJson
    When method get
    Then status 200
    * match response.data[0].id == mgidmasid[0].mgid
    * match response.data[0].status == 2

    * url baseUrl
    Given path '/coupons/v1/coupons/merchants/jpm-cohorts-sync-status'
    And headers headerJson
    And params {page: 1, page-size: 10}
    When method get
    Then status 200
    And match response.data[0].id == cohort_id
    And match response.data[0].action == "inRetry"
    And match each response.data ==
    """
        {
        "id": "#number",
        "mgid": "##number",
        "name": "#string",
        "createdAt": "##? isValidDate(_)",
        "updatedAt": "#? isValidDate(_)",
        "requestTs": "#? isValidDate(_)",
        "addedMerchants": "#string",
        "removedMerchants": "#string",
        "action": "##string"
        }
  """
    Given path '/coupons/v1/coupons/merchants/downloadFutureCohortMerchants/'+cohort_id
    And headers headerJson
    And params {action: 'inRetry'}
    When method get
    Then status 200
    * print response


    Given path 'coupons/v1/coupons/merchants/initiate-retry-cohort-sync'
    And  request body
    And headers headerJson1
    When method put
    Then status 200

    Given path '/coupons/v1/coupons/merchants/jpm-cohorts-sync-status'
    And headers headerJson
    And params {page: 1, page-size: 10}
    When method get
    Then status 200
    And match response.data[0].id == cohort_id
    And match response.data[0].action == "inRetry"
    And match each response.data ==
    """
        {
        "id": "#number",
        "mgid": "##number",
        "name": "#string",
        "createdAt": "##? isValidDate(_)",
        "updatedAt": "#? isValidDate(_)",
        "requestTs": "#? isValidDate(_)",
        "addedMerchants": "#string",
        "removedMerchants": "#string",
        "action": "##string"
        }
  """

    Given path 'coupons/v1/coupons/merchants/initiate-retry-cohort-sync'
    And  request body
    And headers headerJson1
    When method put
    Then status 200

    Given path '/coupons/v1/coupons/merchants/jpm-cohorts-sync-status'
    And headers headerJson
    And params {page: 1, page-size: 10}
    When method get
    Then status 200
    And match response.data[0].id == cohort_id
    And match response.data[0].action == "inRetry"
    And match each response.data ==
    """
        {
        "id": "#number",
        "mgid": "##number",
        "name": "#string",
        "createdAt": "##? isValidDate(_)",
        "updatedAt": "#? isValidDate(_)",
        "requestTs": "#? isValidDate(_)",
        "addedMerchants": "#string",
        "removedMerchants": "#string",
        "action": "##string"
        }
  """

    Given path 'coupons/v1/coupons/merchants/initiate-retry-cohort-sync'
    And  request body
    And headers headerJson1
    When method put
    Then status 200

    Given path '/coupons/v1/coupons/merchants/jpm-cohorts-sync-status'
    And headers headerJson
    And params {page: 1, page-size: 10}
    When method get
    Then status 200
    And match response.data[0].id == cohort_id
    And match response.data[0].action == "failed"
    And match each response.data ==
    """
        {
        "id": "#number",
        "mgid": "##number",
        "name": "#string",
        "createdAt": "##? isValidDate(_)",
        "updatedAt": "#? isValidDate(_)",
        "requestTs": "#? isValidDate(_)",
        "addedMerchants": "#string",
        "removedMerchants": "#string",
        "action": "##string"
        }
  """

  Scenario: View cohorts in CMS
    Given path '/coupons/v1/coupons/merchants/jpm-cohorts'
    And headers headerJson
    And params {page: 1, page-size: 10}
    When method get
    Then status 200
    And match each response.data ==
    """
        {
        "id": "#number",
        "mgid": "#number",
        "name": "#string",
        "createdAt": "#? isValidDate(_)",
        "updatedAt": "#? isValidDate(_)",
        "merchants": "#string"
        }
  """

  Scenario: Download cohorts in CMS
    Given path '/coupons/v1/coupons/merchants/jpm-cohorts'
    And headers headerJson
    And params {page: 1, page-size: 10}
    When method get
    Then status 200
    * def cohort_mg_id = response.data[0].mgid

    Given path '/coupons/v1/coupons/merchants/downloadCohortMerchants/'+cohort_mg_id
    And headers headerJson
    When method get
    Then status 200
    * print response

  Scenario: Switching off the features __0043.1.
    * def call_configuration_table = callonce read('support.feature@revert_cohort_retry')

    Given path '/coupons/v1/coupons/invalidateCache'
    And headers headerJson1
    When method DELETE
    Then status 200
#  @ignore
#  Scenario: cms logout
#    * def logout = callonce read('support.feature@logout') {requestHeader: #(headerJson)}

