package executables.utils;

import static com.github.tomakehurst.wiremock.client.WireMock.*;
import static com.github.tomakehurst.wiremock.client.WireMock.aResponse;
import static com.github.tomakehurst.wiremock.client.WireMock.equalTo;

public class WiremockStubUtils {
    public static void couponStubs(){
        stubFor(
                get(urlPathMatching("/coupons/v1/coupons/merchant/\\w+"))
                        .withHeader("content-type", equalTo("application/json"))
                        .willReturn(aResponse()
                                .withStatus(200)
                                .withHeader("Content-Type", "application/json")
                                .withBody("You've reached a valid WireMock endpoint"))
        );

        stubFor(
                get(urlPathMatching("/coupons/v1/coupons/merchant/"))
                        .willReturn(aResponse()
                                        .withStatus(404))
        );

        stubFor(
                get(urlPathMatching("/coupons/v1/coupons/\\w+"))
                        .willReturn(aResponse()
                                .withStatus(404))
        );

        stubFor(
                get(urlPathEqualTo("/coupons/v1/coupons/"))
                        .withHeader("content-type", equalTo("application/json"))
                        .withHeader("x-client-type", equalTo("RJIL_JioKart"))
                        .withQueryParam("version", containing("v5"))
                        .willReturn(aResponse()
                                .withStatus(200)
                                .withHeader("Content-Type", "application/json")
                                .withBodyFile("/wiremockJsonResponse.json"))
        );

        stubFor(
                get(urlPathEqualTo("/coupons/v1/coupons/"))
                        .withHeader("content-type", equalTo("application/json"))
                        .withHeader("x-client-type", equalTo("myjio"))
                        .withQueryParam("version", containing("v5"))
                        .willReturn(aResponse()
                                .withStatus(200)
                                .withHeader("Content-Type", "application/json")
                                .withBodyFile("/wiremockJsonResponse.json"))
        );

        stubFor(
                get(urlPathEqualTo("/coupons/v1/coupons/"))
                        .withHeader("content-type", equalTo("application/json"))
                        .withHeader("x-client-type", equalTo("microsite"))
                        .withQueryParam("version", containing("v4"))
                        .willReturn(aResponse()
                                .withStatus(200)
                                .withHeader("Content-Type", "application/json")
                                .withBodyFile("/wiremockJsonResponse.json"))
        );

        stubFor(
                get(urlPathEqualTo("/coupons/v1/coupons/"))
                        .withHeader("content-type", equalTo("application/json"))
                        .withHeader("x-client-type", matching("\\w+..|jiomoney"))
                        .withQueryParam("version", matching("\\w+"))
                        .willReturn(aResponse()
                                .withStatus(200)
                                .withHeader("Content-Type", "application/json")
                                .withBodyFile("/wiremockJsonResponse.json"))
        );

        stubFor(
                get(urlPathEqualTo("/coupons/v1/coupons/"))
                        .withHeader("content-type", equalTo("application/json"))
                        .withQueryParam("query", containing("off"))
                        .willReturn(aResponse()
                                .withStatus(200)
                                .withHeader("Content-Type", "application/json"))
        );

    }

    public static void categories(){
        stubFor(
                get(urlPathEqualTo("/coupons/v1/coupons/categories"))
                        .withQueryParam("version", matching("\\w+"))
                        .withQueryParam("client", containing("myjio"))
                        .withHeader("Content-Type", equalTo("application/json"))
                        .withHeader("x-loginid", equalTo("8369353463"))
                        .willReturn(aResponse()
                                .withStatus(200))
        );
    }

    public static void loginStubs(){
        stubFor(
                post(urlEqualTo("/legacy/login"))
                        .withHeader("content-type", containing("application/x-www-form-urlencoded"))
                        .willReturn(aResponse()
                                .withStatus(200)
                                .withHeader("Content-Type", "application/json")
                                .withHeader("x-anti-forgery", "p223yRy3zyTRgutnMwBfJlJX6Xrpk9zcfnQrYuO9E6M54oPz86LTMvZlNz2mFkyJ"))
        );

        stubFor(
                get(urlEqualTo("/v1/cms/logout"))
                        .willReturn(aResponse()
                                .withStatus(200))
        );

        stubFor(
                get(urlEqualTo("/v1/cms/logout"))
                        .willReturn(aResponse()
                                .withStatus(204))
        );
    }

    public static void brandStubs(){
        stubFor(
                post(urlPathEqualTo("/v1/cms/brands/"))
                        .withHeader("Content-Type", containing("multipart/form-data"))
                        .withHeader("x-loginid", equalTo("8369353463"))
                        .withHeader("x-anti-forgery", equalTo("p223yRy3zyTRgutnMwBfJlJX6Xrpk9zcfnQrYuO9E6M54oPz86LTMvZlNz2mFkyJ"))
                        .willReturn(aResponse()
                                .withStatus(200))
        );
    }



}
