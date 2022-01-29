package executables.utils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

import java.util.List;
import java.util.Map;

public class DBUtils {
    private static final Logger logger = LoggerFactory.getLogger(DBUtils.class);
    private final JdbcTemplate jdbc;

    public DBUtils(String db_url,String db_username,String db_password) {

//        SIT DB details
//        "jdbc:oracle:thin:JIOCOUPONS/jiocoupons_123#@10.144.109.111:1521:JCUPONDB";
//        String url = "jdbc:oracle:thin:@10.144.109.111:1521:JCUPONDB";
//        String username = "JIOCOUPONS";
//        String password = "jiocoupons_123#";

//        String username = "SIJIOCOUPONODB";
//        String password = "Aghtjh#gh7";

//        EAT DB details
//        String url = "jdbc:oracle:thin:@10.159.20.64:1521:JCUPONDB";
//        String username = "JIOCOUPONS";
//        String password = "jiocoupons_123#";

        String driver = "oracle.jdbc.driver.OracleDriver";
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName(driver);
        dataSource.setUrl(db_url);
        dataSource.setUsername(db_username);
        dataSource.setPassword(db_password);
        jdbc = new JdbcTemplate(dataSource);
        logger.info("init jdbc template: {}", db_url);
    }

    public Object readValue(String query) {
        System.out.println("query --------" + query);
        System.out.println("response --------" + jdbc.queryForObject(query, Object.class));
        return jdbc.queryForObject(query, Object.class);
    }
    public Map<String, Object> readRow(String query) {
        System.out.println("query --------" + query);
        System.out.println("response --------" + jdbc.queryForMap(query));
        return jdbc.queryForMap(query);
    }

    public List<Map<String, Object>> readRows(String query) {
        System.out.println("query --------" + query);
        System.out.println("response --------" + jdbc.queryForList(query));
        return jdbc.queryForList(query);
    }

    public void updateRow(String query) {
        System.out.println("query --------" + query);
        jdbc.update(query);
        System.out.println("----update done-----"); }
}