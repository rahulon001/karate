@db_table
Feature: verify CMS DB__0000

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')

    * def apiComponents = envConfig

    * def ArrayList = Java.type('java.util.ArrayList')
    * def Collections = Java.type('java.util.Collections')

    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])

  Scenario Outline: verify DB columns__0000.

    * print "<<<<<<<<<<<<<<<<<< table_name for column verification is >>>>>>>>>>>>>>>", "<table_name>"

    # extracting the column and constraint data from DB
    * def table = db.readRows("SELECT * FROM <table_name> WHERE ROWNUM <= 1")
    * def response_Key = karate.keysOf(table[0])

    # sorting the extracted column list
    * eval Collections.sort(response_Key, java.lang.String.CASE_INSENSITIVE_ORDER)
    * print "<<<<<<<<<<<<Response_Key>>>>>>>>>>", response_Key

    # sorting the expected column list
    * def column_list = <column_list>
    * eval Collections.sort(column_list, java.lang.String.CASE_INSENSITIVE_ORDER)
    * print "<<<<<<<<<<<<Expected_Key>>>>>>>>>>", column_list

    # matching the expected and extracted column list
    * match <column_list> contains response_Key

    Examples:
      |table_name|column_list|
      |COUPON    |["ID","TITLE","DESCRIPTION","DETAILS","CREATE_TS","MERCHANT","STATUS","VALID_FROM","VALID_TO","TERMS","IMAGE_ID","URL","AFFILIATE_URL","NOTE","REDEEM_DAYHOUR","REDEEM_GENDER","REDEEM_MIN_AGE","REDEEM_MAX_AGE","REDEEM_LOCATION","REDEEM_EXEMPT_DATES","DOWNLOAD_CAP","REDEEM_CAP","PRIVATE","COUPON_CODE","REDUCTION_TYPE","AMOUNT_THRESHOLD","REDUCTION","REDUCTION_MAX","DISCOUNT_TYPE","DISCOUNT_EXTRA_RULES","STICKER","WIFI_SSID","VENDOR_CID","BANNER_NAME","BANNER_IMAGE_ID","SHORT_TERM_TYPE","SHORT_TERM_TIME","MERCHANT_GROUP","BRAND","COUPON_TYPE","MAX_REDEEM","SOURCE","BOOST","COUPON_LABEL","REDEEM_COUNT","DISCOUNT_MAX","DISCOUNT_MIN_BILL","DISCOUNT_ABS_VALUE","DISCOUNT_PERCENTAGE_VALUE","USER_GROUP","MERCHANT_REDEEM_CAP","DEMO_COUPON","BLOCK_COUNT","DISCOUNT_COUPON","PER_CART_REDEEM","ENABLEDFORMULTIREDEMPTION"]|

      |CLOSED_LOOP_REDEMPTION|["CANCELLED_QUANTITY","BLOCKED_QUANTITY","ACCEPT_TS","RETURN_UPTO","DELIVERED_TS","RETURN_TS","RELEASE_TS","SETTLING_TS","BUSINESS_TS","BLOCK_TS","TRANSACTION_ID","BATCH_ID","REDEEM_TS","CHECKOUT_TS","CREATE_TS","MASID","STORE_ID","TERMINAL_ID","STATUS","BILL_AMOUNT","DISCOUNT_AMOUNT","COUPON_CODE","CUSTOMER","COUPON","ID","MERCHANT_DISCOUNT_CONTRIBUTION"]|

      |SKU_CONDITION_DATA |["ID","SKU","NAME","QUANTITY","COUPON_CONDITION","ACTUAL_PRICE","SELLING_PRICE","MINIMUM_BILL_VALUE"]|

      |B2B_COUPON     |["VENDOR_CONTRIBUTION","MINIMUM_BILL_VALUE","BILL_CONDITION","ID","B2C_COUPON_ID","CAMPAIGN_ID","CAMPAIGN_TYPE","CONDITIONAL_COUPON_ID","COUPON_TITLE","CREATE_TS","DERIVED_FROM","DISCOUNT_AMOUNT","MASID","MERCHANT_GROUP","MERCHANT_REDEEM_CAP","QUANTITY","REDEEM_COUNT","SKU_ID","SKU_NAME","STATUS","TOTAL_REDEEM_CAP","UPDATE_TS","VALID_FROM","VALID_TO","VENDOR_FUNDING"]|

      |FC_MERCHANT_COUPONS|["HOLD_TS","VENDOR_CONTRIBUTION","MINIMUM_BILL_VALUE","ID","COUPON","COUPON_TITLE","MASID","CUSTOMER_COUPON_CODE","MERCHANT_COUPON_CODE","DISCOUNT_AMOUNT","STATUS","TRANSACTION_ID","CREATE_TS","CHECKOUT_TS","VERIFY_TS","REDEEM_TS","UPDATE_TS","CANCEL_TS","VALID_FROM","VALID_TO","DELIVERED_TS","CAMPAIGN_TYPE","B2B_COUPON_ID","CONDITIONAL_COUPON","DISPLAY_NAME_ID","CATEGORY_ID","SUB_CATEGORY_ID","CAMPAIGN_ID"]|

      |B2B_UNREALIZED_REDEMPTION|["HOLD_TS","VENDOR_CONTRIBUTION","MINIMUM_BILL_VALUE","ID","COUPON","COUPON_TITLE","MASID","CUSTOMER_COUPON_CODE","MERCHANT_COUPON_CODE","DISCOUNT_AMOUNT","STATUS","TRANSACTION_ID","CREATE_TS","CHECKOUT_TS","VERIFY_TS","REDEEM_TS","UPDATE_TS","CANCEL_TS","VALID_FROM","VALID_TO","DELIVERED_TS","CAMPAIGN_TYPE","B2B_COUPON_ID","CONDITIONAL_COUPON","DISPLAY_NAME_ID","CATEGORY_ID","SUB_CATEGORY_ID","CAMPAIGN_ID"]|

      |B2B_REALIZED_REDEMPTION|["HOLD_TS","VENDOR_CONTRIBUTION","MINIMUM_BILL_VALUE","ID","COUPON","COUPON_TITLE","MASID","CUSTOMER_COUPON_CODE","MERCHANT_COUPON_CODE","DISCOUNT_AMOUNT","STATUS","TRANSACTION_ID","CREATE_TS","CHECKOUT_TS","VERIFY_TS","REDEEM_TS","UPDATE_TS","CANCEL_TS","VALID_FROM","VALID_TO","DELIVERED_TS","CAMPAIGN_TYPE","B2B_COUPON_ID","CONDITIONAL_COUPON","DISPLAY_NAME_ID","CATEGORY_ID","SUB_CATEGORY_ID","CAMPAIGN_ID"]|

      |FC_SKU_CONDITION_DATA  |["FC_MERCHANT_COUPON","NAME","QUANTITY","SKU"]|

      |B2B_REALIZED_SKU_CONDITION|["FC_MERCHANT_COUPON","SKU","NAME","QUANTITY"]|

      |B2B_UNREALIZED_SKU_CONDITION|["FC_MERCHANT_COUPON","SKU","NAME","QUANTITY"]|

      |B2B_SEGMENT_COUPON_MAPPING|["B2B_COUPON_ID","SEGMENT"]|

    #  B2B_COUPON_REDEMPTION
#  vendor_funding_detail
#  campaign_line_item
#  CLIENT_TYPE
#  JOB_DEFINITION
#  JOB_DETAIL
#  JOB_STATE
#  CATEGORY
#  B2BCOUPONMAPPING
#  MERCHANT
#  ADMINISTRATOR
#  CONFIGURATION
#  USER_CONS_COLUMNS
#  MIDMASID
#  MGID_MID_MASID
#  MERCHANT_ADDRESS
#  NM_CAMPAIGN_MERCHANTS
#  NM_CAMPAIGN_RULES
#  NM_CAMPAIGN_MERCHANTS
#  MERCHANT_GROUP_EXCLUSION_LIST
#  AGGREGATE_COUPON_CODE
#  BRAND
#  MERCHANT_PROPERTY_VALUE
#  VENDOR_FUNDING_HISTORY
#  COUPON_UPLOAD_LOG
#  USER_SEGMENT
#  COMPOSITE_SEGMENT
#  USER_SEGMENT_OPERAND
#  COMPOSITE_SEGMENT_OPERAND
#  MG_DEFINITION
#  B2B_CAMPAIGN
#  DISCOUNT_TYPE
#  VOUCHER
#  CRITERIA
#  CRITERIA_TYPE
#  PROMOTION_CRITERIA
#  PROMOTION
#  Promotion_Type
#  voucher_merchant_redemption
#  VOUCHER_REDEMPTION
#  B2B_DISCOUNT_MAPPING
#  mas_copy_log
#  B2B_SEGMENT_COUPON_MAPPING
#  JPM_MERCHANT_COHORT

  Scenario Outline: verification DB constraints__0000.
    # extracting the column and constraint data from DB
    * print "<<<<<<<<<<<<<<<<<< table_name for constraint verification is >>>>>>>>>>>>>>>", "<table_name>"
    * def table = db.readRows("SELECT USER_CONS_COLUMNS.COLUMN_NAME, USER_CONSTRAINTS.CONSTRAINT_TYPE FROM USER_CONSTRAINTS INNER JOIN USER_CONS_COLUMNS ON USER_CONSTRAINTS.CONSTRAINT_NAME = USER_CONS_COLUMNS.CONSTRAINT_NAME WHERE USER_CONS_COLUMNS.TABLE_NAME IN (\'" +"<table_name>"+ "\')")
    * print "<<<<<<<<<<<<Response_Key>>>>>>>>>>", table

    # Extracting the column name from the DB data and sorted them
    * def column_name = $table[*].COLUMN_NAME
    * eval Collections.sort(column_name, java.lang.String.CASE_INSENSITIVE_ORDER)
    * print "<<<<<<<<<<<<Response_Key1>>>>>>>>>>", column_name

    # Expected column and constraints
    * def constraint_type_and_column = <constraint_type_and_column>
    * print "<<<<<<<<<<<<Expected_Key>>>>>>>>>>", constraint_type_and_column

    # Extracted the column name from the DB data and sorted them
    * def respective_columns = $constraint_type_and_column[*].COLUMN_NAME
    * eval Collections.sort(respective_columns, java.lang.String.CASE_INSENSITIVE_ORDER)
    * print "<<<<<<<<<<<<Expected_Key1>>>>>>>>>>", respective_columns

    # matching the column and constraints one by one
    * match <constraint_type_and_column> contains deep table

    Examples:
      |table_name|constraint_type_and_column|
      |COUPON|[{"COLUMN_NAME":"REDUCTION_TYPE","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"VALID_FROM","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"VALID_TO","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"REDEEM_MIN_AGE","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"REDEEM_MAX_AGE","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"REDUCTION_TYPE","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"AMOUNT_THRESHOLD","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"REDUCTION","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"REDUCTION_TYPE","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"REDUCTION","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"ID","CONSTRAINT_TYPE":"P"},{"COLUMN_NAME":"MERCHANT","CONSTRAINT_TYPE":"R"},{"COLUMN_NAME":"DISCOUNT_TYPE","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"DISCOUNT_EXTRA_RULES","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"STICKER","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"BRAND","CONSTRAINT_TYPE":"R"},{"COLUMN_NAME":"COUPON_TYPE","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"ID","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"TITLE","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"DESCRIPTION","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"CREATE_TS","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"COUPON_TYPE","CONSTRAINT_TYPE":"R"},{"COLUMN_NAME":"STATUS","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"VALID_FROM","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"VALID_TO","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"TERMS","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"REDEEM_DAYHOUR","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"REDEEM_GENDER","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"REDEEM_MIN_AGE","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"REDEEM_MAX_AGE","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"REDEEM_LOCATION","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"PRIVATE","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"COUPON_CODE","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"REDUCTION_TYPE","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"AMOUNT_THRESHOLD","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"IMAGE_ID","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"URL","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"AFFILIATE_URL","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"REDEEM_DAYHOUR","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"REDEEM_GENDER","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"REDEEM_LOCATION","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"PRIVATE","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"COUPON_CODE","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"WIFI_SSID","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"MERCHANT_GROUP","CONSTRAINT_TYPE":"R"},{"COLUMN_NAME":"DISCOUNT_COUPON","CONSTRAINT_TYPE":"C"}]|

      |CLOSED_LOOP_REDEMPTION|[{"COLUMN_NAME":"CUSTOMER","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"COUPON_CODE","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"DISCOUNT_AMOUNT","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"CREATE_TS","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"CHECKOUT_TS","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"ID","CONSTRAINT_TYPE":"P"},{"COLUMN_NAME":"COUPON","CONSTRAINT_TYPE":"R"},{"COLUMN_NAME":"TRANSACTION_ID","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"STATUS","CONSTRAINT_TYPE":"R"},{"COLUMN_NAME":"ID","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"COUPON","CONSTRAINT_TYPE":"C"}]|

      |SKU_CONDITION_DATA |[{"COLUMN_NAME":"MINIMUM_BILL_VALUE","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"ID","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"SKU","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"NAME","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"QUANTITY","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"COUPON_CONDITION","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"ID","CONSTRAINT_TYPE":"P"},{"COLUMN_NAME":"COUPON_CONDITION","CONSTRAINT_TYPE":"R"}]|

      |B2B_COUPON|[{"COLUMN_NAME":"ID","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"ID","CONSTRAINT_TYPE":"P"},{"COLUMN_NAME":"QUANTITY","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"SKU_NAME","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"SKU_ID","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"DISCOUNT_AMOUNT","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"STATUS","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"COUPON_TITLE","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"MASID","CONSTRAINT_TYPE":"R"},{"COLUMN_NAME":"MERCHANT_GROUP","CONSTRAINT_TYPE":"R"},{"COLUMN_NAME":"CAMPAIGN_ID","CONSTRAINT_TYPE":"R"},{"COLUMN_NAME":"CAMPAIGN_TYPE","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"CREATE_TS","CONSTRAINT_TYPE":"C"}]|

      |FC_MERCHANT_COUPONS|[{"COLUMN_NAME":"HOLD_TS","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"ID","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"COUPON_TITLE","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"MASID","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"MERCHANT_COUPON_CODE","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"DISCOUNT_AMOUNT","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"STATUS","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"TRANSACTION_ID","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"CREATE_TS","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"UPDATE_TS","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"CAMPAIGN_TYPE","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"ID","CONSTRAINT_TYPE":"P"},{"COLUMN_NAME":"COUPON","CONSTRAINT_TYPE":"R"},{"COLUMN_NAME":"MASID","CONSTRAINT_TYPE":"R"},{"COLUMN_NAME":"STATUS","CONSTRAINT_TYPE":"R"},{"COLUMN_NAME":"B2B_COUPON_ID","CONSTRAINT_TYPE":"R"}]|

      |B2B_UNREALIZED_REDEMPTION|[{"COLUMN_NAME":"HOLD_TS","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"COUPON_TITLE","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"MASID","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"MERCHANT_COUPON_CODE","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"DISCOUNT_AMOUNT","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"STATUS","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"TRANSACTION_ID","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"CREATE_TS","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"UPDATE_TS","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"CAMPAIGN_TYPE","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"ID","CONSTRAINT_TYPE":"P"},{"COLUMN_NAME":"MASID","CONSTRAINT_TYPE":"R"},{"COLUMN_NAME":"STATUS","CONSTRAINT_TYPE":"R"}]|

      |B2B_REALIZED_REDEMPTION|[{"COLUMN_NAME":"HOLD_TS","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"COUPON_TITLE","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"MASID","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"MERCHANT_COUPON_CODE","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"DISCOUNT_AMOUNT","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"STATUS","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"TRANSACTION_ID","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"CREATE_TS","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"UPDATE_TS","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"CAMPAIGN_TYPE","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"ID","CONSTRAINT_TYPE":"P"},{"COLUMN_NAME":"MASID","CONSTRAINT_TYPE":"R"},{"COLUMN_NAME":"STATUS","CONSTRAINT_TYPE":"R"}]|

      |FC_SKU_CONDITION_DATA  |[{"COLUMN_NAME":"FC_MERCHANT_COUPON","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"QUANTITY","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"SKU","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"FC_MERCHANT_COUPON","CONSTRAINT_TYPE":"R"}]|

      |B2B_REALIZED_SKU_CONDITION|[{"COLUMN_NAME":"SKU","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"NAME","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"QUANTITY","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"FC_MERCHANT_COUPON","CONSTRAINT_TYPE":"R"}]|

      |B2B_UNREALIZED_SKU_CONDITION|[{"COLUMN_NAME":"SKU","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"NAME","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"QUANTITY","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"FC_MERCHANT_COUPON","CONSTRAINT_TYPE":"R"}]|

      |B2B_SEGMENT_COUPON_MAPPING|[{"COLUMN_NAME":"SEGMENT","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"B2B_COUPON_ID","CONSTRAINT_TYPE":"C"},{"COLUMN_NAME":"B2B_COUPON_ID","CONSTRAINT_TYPE":"R"},{"COLUMN_NAME":"SEGMENT","CONSTRAINT_TYPE":"U"},{"COLUMN_NAME":"B2B_COUPON_ID","CONSTRAINT_TYPE":"U"}]|

    #  B2B_COUPON_REDEMPTION
#  vendor_funding_detail
#  campaign_line_item
#  CLIENT_TYPE
#  JOB_DEFINITION
#  JOB_DETAIL
#  JOB_STATE
#  CATEGORY
#  B2BCOUPONMAPPING
#  MERCHANT
#  ADMINISTRATOR
#  CONFIGURATION
#  USER_CONS_COLUMNS
#  MIDMASID
#  MGID_MID_MASID
#  MERCHANT_ADDRESS
#  NM_CAMPAIGN_MERCHANTS
#  NM_CAMPAIGN_RULES
#  NM_CAMPAIGN_MERCHANTS
#  MERCHANT_GROUP_EXCLUSION_LIST
#  AGGREGATE_COUPON_CODE
#  BRAND
#  MERCHANT_PROPERTY_VALUE
#  VENDOR_FUNDING_HISTORY
#  COUPON_UPLOAD_LOG
#  USER_SEGMENT
#  COMPOSITE_SEGMENT
#  USER_SEGMENT_OPERAND
#  COMPOSITE_SEGMENT_OPERAND
#  MG_DEFINITION
#  B2B_CAMPAIGN
#  DISCOUNT_TYPE
#  VOUCHER
#  CRITERIA
#  CRITERIA_TYPE
#  PROMOTION_CRITERIA
#  PROMOTION
#  Promotion_Type
#  voucher_merchant_redemption
#  VOUCHER_REDEMPTION
#  B2B_DISCOUNT_MAPPING
#  mas_copy_log
#  B2B_SEGMENT_COUPON_MAPPING
#  JPM_MERCHANT_COHORT