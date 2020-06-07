function fn() {    
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  karate.configure('ssl', { trustAll: true });
  if (!env) {
    env = 'dev';
  }
  var config = {
    env: env,
	myVarName: 'someValue',
//	baseUrl:'http://localhost:8089'
    baseUrl: "http://10.144.108.127:9001",
//    baseUrl:'https://10.144.62.107:3001'
//    baseUrlApp: "https://api-sit.jio.com:8443"
  }

  if (env == 'dev') {
    // customize
    // e.g. config.foo = 'bar';
  }

   else if (env == 'e2e') {
    // customize
  }
  karate.configure('connectTimeout', 30000);
  karate.configure('readTimeout', 60000);
  return config;
}