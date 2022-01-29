package executables;

import com.intuit.karate.junit5.Karate;

class ExamplesTest {
@Karate.Test
    Karate testTags() {
    return Karate.run("classpath:executables/coupons/").tags("~@ignore","~@logout");
}
}