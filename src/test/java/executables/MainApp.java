package executables;

import org.junit.internal.TextListener;
import org.junit.runner.JUnitCore;

import java.util.ArrayList;
import java.util.List;

public class MainApp {

    public static void main(String[] args) {
        System.out.println("==========Running tests!===========");
        System.getProperty("karate.env");
        System.getProperty("karate.options");
        System.getProperty("karate.url");

        JUnitCore engine = new JUnitCore();
        engine.addListener(new TextListener(System.out)); // required to print reports
        engine.run(TestRunner.class);
    }
}