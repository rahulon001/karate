@ignore
Feature: Merchant Settlement
  Background:
    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def apiComponents = envConfig
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])
    *  def random =
    """
    function(){ return java.lang.System.currentTimeMillis() }
    """

  Scenario: Merchant settlement
    * def random_date = "%"+1638782474380


#    * def b2b_coupon_id = db.readRows("SELECT ID FROM B2B_COUPON WHERE COUPON_TITLE LIKE (\'" +random_date+ "\')")
#    * print "nnnnnnnnnnn", b2b_coupon_id

    * def b2b_coupon_segs = db.readRows("SELECT SEGMENT FROM B2B_SEGMENT_COUPON_MAPPING WHERE B2B_COUPON_ID in (\'" +168676+ "\')")
    * print "mmmmmmmmm", b2b_coupon_segs

    * def fun = function(arg) { return karate.jsonPath(arg, '$[*].SEGMENT') }
    * print "yyyyyyyyyy", fun(b2b_coupon_segs)