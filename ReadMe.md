## Load Testing
1. Update performanct/GatlinTest Scala Class
2. Run: 
```mvn clean test-compile gatling:test```
> Test cases : All the feature files are at "src/test/java/executables/coupons"
> Runner files : There are three runner files in suite.
1) "src/test/java/executables/ExamplesTest.java": This File is used to run and monitor tests locally after development.
2) "src/test/java/executables/MainApp.java": This file is used for fatJar execution.
3) "src/test/java/executables/TestRunner.java": This file is used bt MainApp.jaya to impose any changes on tests while runner execution. eg : imposing of various tags on tests.


Future Action items: 
1) adding conditional coupons to all b2b discount types.
 