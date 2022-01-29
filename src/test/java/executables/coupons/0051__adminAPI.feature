@ignore
Feature: Admin API.

  Background:
    * url baseUrl
    * call read('support.feature@common_functions')
    * def apiComponents = envConfig
    * def schemaAndValidation = envSchema
    * header Content-Type = 'application/json'
    * header x-client-type = "mpos"
    * def redeem_flags = "false"
    * def headerJson = {}
    * set headerJson.multi_redeem-enabled = redeem_flags
    * set headerJson.Content-Type = 'application/json'
    * set headerJson.x-client-type = 'mpos'

    * def DBUtils = Java.type('executables.utils.DBUtils')
    * def db = new DBUtils(apiComponents['DB_url'], apiComponents['DB_username'], apiComponents['DB_password'])

    * def masid = apiComponents['CMS_masid']

    *  def transactionID =
    """
      function(){ return java.lang.System.currentTimeMillis() }
    """
    * def transaction_id = callonce transactionID

#  Scenario :  Old and new coupons in replacement API Flow __0037 when b2b percent and fixed is off
    """
    get
    https://10.159.20.62:8081/v1/cms/admin/admins/?page-size=25&page=1
    https://10.159.20.62:8081/v1/cms/admin/admins/?role=3&status=&page-size=25&page=1
    https://10.159.20.62:8081/v1/cms/admin/admins/?first-name=Rahul&role=3&status=&page-size=25&page=1
    https://10.159.20.62:8081/v1/cms/userGroups/
    https://10.159.20.62:8081/v1/cms/admin/info/
    https://10.159.20.62:8081/v1/cms/client-types/
    https://10.159.20.62:8081/v1/cms/userGroups/?page-size=25&page=1
    curl 'https://10.159.20.62:8081/v1/cms/admin/admins/?id=1546' \
      -H 'Connection: keep-alive' \
      -H 'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="96", "Google Chrome";v="96"' \
      -H 'x-anti-forgery: d0pgh75BcROQZE6fXC5O91zAxYU-jFAYmR0.Q0YWlFHwxEFxQZVQRVo0xLd56Mx0' \
      -H 'Content-Type: application/json' \
      -H 'sec-ch-ua-mobile: ?0' \
      -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.55 Safari/537.36' \
      -H 'sec-ch-ua-platform: "macOS"' \
      -H 'Accept: */*' \
      -H 'Sec-Fetch-Site: same-site' \
      -H 'Sec-Fetch-Mode: cors' \
      -H 'Sec-Fetch-Dest: empty' \
      -H 'Referer: https://10.159.20.62:8080/' \
      -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8' \
      -H 'Cookie: PLAY_SESSION=eyJhbGciOiJIUzI1NiJ9.eyJkYXRhIjp7ImF1dGhEZXRhaWxzIjoiMjYxJiNyYWh1bDgucmFuamFuJiNhZG1pbiYjMCYjMTYzOTEyOTkyMzY0NiJ9LCJuYmYiOjE2MzkxMjk5MjMsImlhdCI6MTYzOTEyOTkyM30.X4YhkC4Puysl3NHmGZutVXe9N0COE8tEkeOxVF8pwMM; globals=0; cm=d0pgh75BcROQZE6fXC5O91zAxYU-jFAYmR0.Q0YWlFHwxEFxQZVQRVo0xLd56Mx0' \
      --compressed \
      --insecure

curl 'https://10.159.20.62:8081/v1/cms/userGroup/1199' \
  -H 'Connection: keep-alive' \
  -H 'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="96", "Google Chrome";v="96"' \
  -H 'x-anti-forgery: l9Rw9lhf0kMH2c3VE7bJUuRPEyHRCjFTzkpW7FyuSr4YYqTTKZvaquimcKAtsKdf' \
  -H 'Content-Type: application/json' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.55 Safari/537.36' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'Accept: */*' \
  -H 'Sec-Fetch-Site: same-site' \
  -H 'Sec-Fetch-Mode: cors' \
  -H 'Sec-Fetch-Dest: empty' \
  -H 'Referer: https://10.159.20.62:8080/' \
  -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8' \
  -H 'Cookie: PLAY_SESSION=eyJhbGciOiJIUzI1NiJ9.eyJkYXRhIjp7ImF1dGhEZXRhaWxzIjoiMjYxJiNyYWh1bDgucmFuamFuJiNhZG1pbiYjMCYjMTYzOTEzMzYwMTc3MiJ9LCJuYmYiOjE2MzkxMzM2MDEsImlhdCI6MTYzOTEzMzYwMX0.IW7xraiz1kGSe36W2S7YlYDHmBMpEf0dx5t967GObYg; globals=0; cm=l9Rw9lhf0kMH2c3VE7bJUuRPEyHRCjFTzkpW7FyuSr4YYqTTKZvaquimcKAtsKdf' \
  --compressed \
  --insecure











    Delete

    curl 'https://10.159.20.62:8081/v1/cms/admin/admins/1544' \
      -X 'DELETE' \
      -H 'Connection: keep-alive' \
      -H 'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="96", "Google Chrome";v="96"' \
      -H 'x-anti-forgery: d0pgh75BcROQZE6fXC5O91zAxYU-jFAYmR0.Q0YWlFHwxEFxQZVQRVo0xLd56Mx0' \
      -H 'Content-Type: application/json' \
      -H 'sec-ch-ua-mobile: ?0' \
      -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.55 Safari/537.36' \
      -H 'sec-ch-ua-platform: "macOS"' \
      -H 'Accept: */*' \
      -H 'Sec-Fetch-Site: same-site' \
      -H 'Sec-Fetch-Mode: cors' \
      -H 'Sec-Fetch-Dest: empty' \
      -H 'Referer: https://10.159.20.62:8080/' \
      -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8' \
      -H 'Cookie: PLAY_SESSION=eyJhbGciOiJIUzI1NiJ9.eyJkYXRhIjp7ImF1dGhEZXRhaWxzIjoiMjYxJiNyYWh1bDgucmFuamFuJiNhZG1pbiYjMCYjMTYzOTEyOTkyMzY0NiJ9LCJuYmYiOjE2MzkxMjk5MjMsImlhdCI6MTYzOTEyOTkyM30.X4YhkC4Puysl3NHmGZutVXe9N0COE8tEkeOxVF8pwMM; globals=0; cm=d0pgh75BcROQZE6fXC5O91zAxYU-jFAYmR0.Q0YWlFHwxEFxQZVQRVo0xLd56Mx0' \
      --compressed \
      --insecure

      PUT :

      same phone number is not allowed.

      curl 'https://10.159.20.62:8081/v1/cms/user/1546' \
        -X 'PUT' \
        -H 'Connection: keep-alive' \
        -H 'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="96", "Google Chrome";v="96"' \
        -H 'x-anti-forgery: l9Rw9lhf0kMH2c3VE7bJUuRPEyHRCjFTzkpW7FyuSr4YYqTTKZvaquimcKAtsKdf' \
        -H 'Content-Type: multipart/form-data; boundary=----WebKitFormBoundarysGpWZdBtSMBp0tAM' \
        -H 'sec-ch-ua-mobile: ?0' \
        -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.55 Safari/537.36' \
        -H 'sec-ch-ua-platform: "macOS"' \
        -H 'Accept: */*' \
        -H 'Sec-Fetch-Site: same-site' \
        -H 'Sec-Fetch-Mode: cors' \
        -H 'Sec-Fetch-Dest: empty' \
        -H 'Referer: https://10.159.20.62:8080/' \
        -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8' \
        -H 'Cookie: PLAY_SESSION=eyJhbGciOiJIUzI1NiJ9.eyJkYXRhIjp7ImF1dGhEZXRhaWxzIjoiMjYxJiNyYWh1bDgucmFuamFuJiNhZG1pbiYjMCYjMTYzOTEzMzYwMTc3MiJ9LCJuYmYiOjE2MzkxMzM2MDEsImlhdCI6MTYzOTEzMzYwMX0.IW7xraiz1kGSe36W2S7YlYDHmBMpEf0dx5t967GObYg; globals=0; cm=l9Rw9lhf0kMH2c3VE7bJUuRPEyHRCjFTzkpW7FyuSr4YYqTTKZvaquimcKAtsKdf' \
        --data-raw $'------WebKitFormBoundarysGpWZdBtSMBp0tAM\r\nContent-Disposition: form-data; name="first-name"\r\n\r\nAbhilash\r\n------WebKitFormBoundarysGpWZdBtSMBp0tAM\r\nContent-Disposition: form-data; name="last-name"\r\n\r\nSingh\r\n------WebKitFormBoundarysGpWZdBtSMBp0tAM\r\nContent-Disposition: form-data; name="phone"\r\n\r\n8728782882\r\n------WebKitFormBoundarysGpWZdBtSMBp0tAM\r\nContent-Disposition: form-data; name="email"\r\n\r\nabhilash.singh@ril.com\r\n------WebKitFormBoundarysGpWZdBtSMBp0tAM\r\nContent-Disposition: form-data; name="username"\r\n\r\nabhilash.singh\r\n------WebKitFormBoundarysGpWZdBtSMBp0tAM\r\nContent-Disposition: form-data; name="password"\r\n\r\n\r\n------WebKitFormBoundarysGpWZdBtSMBp0tAM\r\nContent-Disposition: form-data; name="user-group"\r\n\r\n1198\r\n------WebKitFormBoundarysGpWZdBtSMBp0tAM\r\nContent-Disposition: form-data; name="role"\r\n\r\noperator\r\n------WebKitFormBoundarysGpWZdBtSMBp0tAM\r\nContent-Disposition: form-data; name="status"\r\n\r\nunblock\r\n------WebKitFormBoundarysGpWZdBtSMBp0tAM--\r\n' \
        --compressed \
        --insecure


    curl 'https://10.159.20.62:8081/v1/cms/userGroup/1199' \
      -X 'PUT' \
      -H 'Connection: keep-alive' \
      -H 'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="96", "Google Chrome";v="96"' \
      -H 'Accept: text/json' \
      -H 'X-Anti-Forgery: l9Rw9lhf0kMH2c3VE7bJUuRPEyHRCjFTzkpW7FyuSr4YYqTTKZvaquimcKAtsKdf' \
      -H 'Content-Type: application/json' \
      -H 'sec-ch-ua-mobile: ?0' \
      -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.55 Safari/537.36' \
      -H 'sec-ch-ua-platform: "macOS"' \
      -H 'Sec-Fetch-Site: same-site' \
      -H 'Sec-Fetch-Mode: cors' \
      -H 'Sec-Fetch-Dest: empty' \
      -H 'Referer: https://10.159.20.62:8080/' \
      -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8' \
      -H 'Cookie: PLAY_SESSION=eyJhbGciOiJIUzI1NiJ9.eyJkYXRhIjp7ImF1dGhEZXRhaWxzIjoiMjYxJiNyYWh1bDgucmFuamFuJiNhZG1pbiYjMCYjMTYzOTEzMzYwMTc3MiJ9LCJuYmYiOjE2MzkxMzM2MDEsImlhdCI6MTYzOTEzMzYwMX0.IW7xraiz1kGSe36W2S7YlYDHmBMpEf0dx5t967GObYg; globals=0; cm=l9Rw9lhf0kMH2c3VE7bJUuRPEyHRCjFTzkpW7FyuSr4YYqTTKZvaquimcKAtsKdf' \
      --data-raw '{"name":"new c22222","description":"new campaig2","clientType":[7]}' \
      --compressed \
      --insecure


    post

    https://10.159.20.62:8081/v1/cms/userGroup/
    {"name":"Tests","description":"Test_discription","clientType":[3]}
    POST /v1/cms/userGroup/ HTTP/1.1
    Host: 10.159.20.62:8081
    Connection: keep-alive
    Content-Length: 66
    sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="96", "Google Chrome";v="96"
    Accept: text/json
    X-Anti-Forgery: xzBiBovkjACEHujZPk3AgipKUCUC4Wizvh9lVcj32ZvLfOoKA.pekDUZ2gdZv8e6
    Content-Type: application/json
    sec-ch-ua-mobile: ?0
    User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.55 Safari/537.36
    sec-ch-ua-platform: "macOS"
    Sec-Fetch-Site: same-site
    Sec-Fetch-Mode: cors
    Sec-Fetch-Dest: empty
    Referer: https://10.159.20.62:8080/
    Accept-Encoding: gzip, deflate, br
    Accept-Language: en-GB,en-US;q=0.9,en;q=0.8
    Cookie: PLAY_SESSION=eyJhbGciOiJIUzI1NiJ9.eyJkYXRhIjp7ImF1dGhEZXRhaWxzIjoiMjYxJiNyYWh1bDgucmFuamFuJiNhZG1pbiYjMCYjMTYzOTA2NzA1OTcyOSJ9LCJuYmYiOjE2MzkwNjcwNTksImlhdCI6MTYzOTA2NzA1OX0.ibE1aYGaQbOwovDDGp-diFFLz7yyCE6AQChYdW6A__U; globals=0; cm=xzBiBovkjACEHujZPk3AgipKUCUC4Wizvh9lVcj32ZvLfOoKA.pekDUZ2gdZv8e6

    Bug : not able to reselect the user group
    Bug : nt able to change the user group while edit
    bug : All the lists of user groups are at bottom screem of screen without any scrollable option.
    bug : while edit user group id is visible and not the user group
    bug : when a user is edited , the user list stopped diplayed.


    https://10.159.20.62:8081/v1/cms/admin/admins/
    &username=arshad3.shaikh&password=07b221534342e3ea4c30ffbbcaf0855d4ecabd20e82a08049fa19609634c6835&role=supervisor&email=arshad3.shaikh@ril.com&first-name=Arshad&last-name=Shaikh&phone=8806132342&user-group=42&status=approve

    POST /v1/cms/admin/admins/ HTTP/1.1
    Host: 10.159.20.62:8081
    Connection: keep-alive
    Content-Length: 224
    sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="96", "Google Chrome";v="96"
    Accept: text/json
    X-Anti-Forgery: 6.yHR8gA7N4toCg1KJ1iONbErTL68NglVM1vEFTzwssrnLGk26vdsfeYhCVTYF5t
    Content-Type: application/x-www-form-urlencoded
    sec-ch-ua-mobile: ?0
    User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.55 Safari/537.36
    sec-ch-ua-platform: "macOS"
    Sec-Fetch-Site: same-site
    Sec-Fetch-Mode: cors
    Sec-Fetch-Dest: empty
    Referer: https://10.159.20.62:8080/
    Accept-Encoding: gzip, deflate, br
    Accept-Language: en-GB,en-US;q=0.9,en;q=0.8
    Cookie: PLAY_SESSION=eyJhbGciOiJIUzI1NiJ9.eyJkYXRhIjp7ImF1dGhEZXRhaWxzIjoiMjYxJiNyYWh1bDgucmFuamFuJiNhZG1pbiYjMCYjMTYzOTEyMDI0MTUyMyJ9LCJuYmYiOjE2MzkxMjAyNDMsImlhdCI6MTYzOTEyMDI0M30.kscZ_V6Yh3RlZ0o_BjHE3Gq-9uLOWC59NLgsuoCpku0; globals=0; cm=6.yHR8gA7N4toCg1KJ1iONbErTL68NglVM1vEFTzwssrnLGk26vdsfeYhCVTYF5t

    """
#  Scenario: Switching off the features __0043.1.
#    * def call_configuration_table_b2b = callonce read('support.feature@switch_off_features_b2b')