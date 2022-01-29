function(){
          var info = karate.info;
          karate.log(info);
          if(info.errorMessage){
             for (var i = 0; i = 1; i++) {
                try {
                  karate.call(info.featureFileName);
                  karate.log('*** RETRY SUCCESS *****')
                  return;
                } catch (e) {
                  karate.log('*** RETRY FAILED ***', i, e);
                }
              }
              karate.fail('test failed after retries: ' + i);
           }
          }