package executables;

import com.github.tomakehurst.wiremock.WireMockServer;
import com.github.tomakehurst.wiremock.core.WireMockConfiguration;
import com.github.tomakehurst.wiremock.junit.WireMockRule;
import com.intuit.karate.junit4.Karate;
import cucumber.api.CucumberOptions;
import executables.utils.WiremockStubUtils;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Rule;
import org.junit.runner.RunWith;

import static com.github.tomakehurst.wiremock.client.WireMock.*;

@RunWith(Karate.class)
@CucumberOptions(features = {"classpath:executables/coupons/"},
        tags = {"~@ignore_","~@ignoreClientAPI"},
        plugin = {"pretty", "html:target/cucumber"})
public class ExamplesTest {
    @Rule
    public WireMockRule wireMockRule = new WireMockRule();

    private static WireMockServer wireMockServer =
            new WireMockServer(new WireMockConfiguration().port(8089).bindAddress("localhost"));


    @BeforeClass
    public static void setUp() {
        wireMockServer.start();
        configureFor("localhost", 8089);
        WiremockStubUtils.couponStubs();
        WiremockStubUtils.loginStubs();
        WiremockStubUtils.brandStubs();
        WiremockStubUtils.categories();
    }


    @AfterClass
    public static void tearDown() {
        wireMockServer.stop();
    }
}

