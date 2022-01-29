function fn() {
	var env = karate.env;
	karate.configure('ssl', {
		trustAll: true
	});
	var envData_dev = read('../helperFiles/files/apiComponents_dev.json')
	var envData_sit = read('../helperFiles/files/apiComponents_sit.json')
	var envData_eat = read('../helperFiles/files/apiComponents_eat.json')
	var envData_pp = read('../helperFiles/files/apiComponents_pp.json')
	var schemaAndValidationDetails = read('../helperFiles/files/schemaAndValidation.json')
	if (!env) {
		env = 'sit';
	}
	var config = {
		env: env,
	}

	config.isValidDate = read('../utils/is-valid-date.js');
	config.retryScenario = read('../utils/retry_scenario.js');

	if (env == 'dev') {
		karate.log('Environment value is==========>', env);
		config.baseUrl = "http://10.157........:9001";
		config.baseUrlApp = "https://api-sit.jio.com:8443";
		config.envConfig = envData_dev["dev"];
		config.envSchema = schemaAndValidationDetails["dev"];
	} else if (env == 'sit') {
		karate.log('Environment value is==========>', env);
		config.baseUrl = "http://10.144........:9000";
		config.baseUrlApp = "https://api-sit.jio.com:8443";
		config.envConfig = envData_sit["sit"];
		config.envSchema = schemaAndValidationDetails["sit"];
	} else if (env == 'eat') {
		karate.log('Environment value is==========>', env);
		config.baseUrl = "http://10.159........:9000";
		config.baseUrlApp = "https://api-sit.jio.com:8443";
		config.envConfig = envData_eat["eat"];
		config.envSchema = schemaAndValidationDetails["eat"];
	}else if (env == 'pp') {
     	karate.log('Environment value is==========>', env);
        config.baseUrl = "https://10.144........:9000";
        config.envConfig = envData_pp["pp"];
        config.envSchema = schemaAndValidationDetails["pp"];
    }
	karate.configure('connectTimeout', 30000);
	karate.configure('readTimeout', 90000);
	return config;
}