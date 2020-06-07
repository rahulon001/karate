package executables.utils;

import java.io.*;
import java.util.Map;
import java.util.Properties;

public class setterGetter {
    private static final String FILE_NAME = "test.properties";
    private FileOutputStream output;
    private FileInputStream input;
    private Properties prop;

    public setterGetter() {
        prop = new Properties();
    }

    public void write(Map<String, Object> config) throws IOException {
        String key = (String) config.get("key");
        output = new FileOutputStream(FILE_NAME);
        prop.setProperty("key", key);
        prop.store(output, null);
    }

    public String read(String key) throws IOException {
        input = new FileInputStream(FILE_NAME);
        prop.load(input);
        return prop.getProperty(key);
    }
}