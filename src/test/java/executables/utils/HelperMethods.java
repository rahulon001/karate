package executables.utils;
import com.opencsv.CSVReader;
import com.opencsv.CSVReaderBuilder;
import com.opencsv.CSVWriter;

import javax.sound.midi.Soundbank;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.DirectoryNotEmptyException;
import java.nio.file.Files;
import java.nio.file.NoSuchFileException;
import java.nio.file.Paths;
import java.util.*;

public class HelperMethods {
    private static final char SEPARATOR = ',';

    // function to generate a random string of length n
    static String getAlphaNumericString(int n)
    {

        // chose a Character random from this String
        String AlphaNumericString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" + "0123456789" + "abcdefghijklmnopqrstuvxyz";

        // create StringBuffer size of AlphaNumericString
        StringBuilder sb = new StringBuilder(n);

        for (int i = 0; i < n; i++) {

            // generate a random number between
            // 0 to AlphaNumericString variable length
            int index
                    = (int)(AlphaNumericString.length()
                    * Math.random());

            // add Character one by one in end of sb
            sb.append(AlphaNumericString
                    .charAt(index));
        }

        return sb.toString();
    }

    public static void deleteCSV(String path)
    {
        {
            try
            {
                Files.deleteIfExists(Paths.get(path));
            }
            catch(NoSuchFileException e)
            {
                System.out.println("No such file/directory exists");
            }
            catch(DirectoryNotEmptyException e)
            {
                System.out.println("Directory is not empty.");
            }
            catch(IOException e)
            {
                System.out.println("Invalid permissions.");
            }

            System.out.println("Deletion successful.");
        }
    }

    static int countCsvLines(String path) throws IOException {
        BufferedReader bufferedReader = new BufferedReader(new FileReader(path));
        String input;
        int count = 0;
        while(bufferedReader.readLine() != null)
        {
            count++;
        }
        System.out.println("------++++++++++------"+count);
        return count;
    }

    public static boolean compareNumbrs(int x, int y){
        return (x == y);
    }

    public static String getRandomString(int n)
    {

        // chose a Character random from this String
        String AlphaNumericString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" + "&" + " " + "abcdefghijklmnopqrstuvxyz";

        // create StringBuffer size of AlphaNumericString
        StringBuilder sb = new StringBuilder(n);

        for (int i = 0; i < n; i++) {

            // generate a random number between
            // 0 to AlphaNumericString variable length
            int index
                    = (int)(AlphaNumericString.length()
                    * Math.random());

            // add Character one by one in end of sb
            sb.append(AlphaNumericString
                    .charAt(index));
        }

        return sb.toString();
    }

    public static void B2B_BulkUpload(String path) throws IOException, InterruptedException {
        String destination = "src/test/java/executables/helperFiles/files/flatDiscountTemplate1.csv";
        Reader reader = Files.newBufferedReader(Paths.get(path));
        CSVReader csvReader = new CSVReaderBuilder(reader).withSkipLines(0).build();
        List<String[]> csvBody = csvReader.readAll();
        for (int i = 1; i<=2; i++) {
            csvBody.get(i)[0] = "Automated_b2b_coupon_codes" + System.currentTimeMillis();
            Thread.sleep(1000);
        }
        reader.close();

        CSVWriter writer = new CSVWriter(
                new OutputStreamWriter(new FileOutputStream(destination), StandardCharsets.UTF_8), SEPARATOR,
                CSVWriter.NO_QUOTE_CHARACTER, CSVWriter.DEFAULT_ESCAPE_CHARACTER, CSVWriter.DEFAULT_LINE_END);
        writer.writeAll(csvBody);
        writer.flush();
        writer.close();
    }

    public static void B2B_coupon_BulkUpload(String path, String discount_type, long random_date) throws IOException, InterruptedException {
        String destination = "src/test/java/executables/helperFiles/files/flatDiscountTemplate1.csv";
//        deleteCSV(destination);
        Reader reader = Files.newBufferedReader(Paths.get(path));
        CSVReader csvReader = new CSVReaderBuilder(reader).withSkipLines(0).build();
        String discountType = discount_type.substring(1, discount_type.length()-1);
        List<String[]> csvBody = csvReader.readAll();
        int st_count = countCsvLines(path);
        System.out.println("<=============>In Program<=============>");
        System.out.println("<=============>path<=============>" + path);
        System.out.println("<=============>discountType<=============>" + discount_type);

        switch (discountType) {
            case "FLAT_DISCOUNT_ON_SKU":
                for (int i = 1; i<=st_count-1; i++) {
                    Random random = new Random();
                    System.out.println("____________FLAT_DISCOUNT_ON_SKU_____________");
                    double x = random.nextInt(900) + 10.1;
                    csvBody.get(i)[0] = "Automated_b2b_coupons" + String.valueOf(random_date);
                    csvBody.get(i)[8] = String.valueOf(x);
                    Thread.sleep(1000);
                }
                break;
            case "PERCENT_DISCOUNT":
                for (int i = 1; i<=st_count-1; i++) {
                    Random random = new Random();
                    System.out.println("____________PERCENT_DISCOUNT_____________");
                    double x = random.nextInt(100) + 1.23;
                    csvBody.get(i)[0] = "Automated_b2b_coupons" + String.valueOf(random_date);
                    csvBody.get(i)[13] = String.valueOf(x);
                    double y = random.nextInt(1000) + 1.23;
                    csvBody.get(i)[14] = String.valueOf(y);
                    Thread.sleep(1000);
                }
                break;
            case "SKU_AT_FIXED_PRICE":
                for (int i = 1; i<=st_count-1; i++) {
                    Random random = new Random();
                    System.out.println("____________SKU_AT_FIXED_PRICE_____________");
                    double x = random.nextInt(9000) + 10.1;
                    csvBody.get(i)[0] = "Automated_b2b_coupons" + String.valueOf(random_date);
                    csvBody.get(i)[13] = String.valueOf(x);
                    Thread.sleep(1000);
                }
                break;
        }
        reader.close();

        CSVWriter writer = new CSVWriter(
                new OutputStreamWriter(new FileOutputStream(destination), StandardCharsets.UTF_8), SEPARATOR,
                CSVWriter.NO_QUOTE_CHARACTER, CSVWriter.DEFAULT_ESCAPE_CHARACTER, CSVWriter.DEFAULT_LINE_END);
        writer.writeAll(csvBody);
        writer.flush();
        writer.close();
    }

    public static void B2B_coupon_BulkUpload(String path, String discount_type) throws IOException, InterruptedException {
        String destination = "src/test/java/executables/helperFiles/files/flatDiscountTemplate1.csv";
//        deleteCSV(destination);
        Reader reader = Files.newBufferedReader(Paths.get(path));
        CSVReader csvReader = new CSVReaderBuilder(reader).withSkipLines(0).build();
        String discountType = discount_type.substring(1, discount_type.length()-1);
        List<String[]> csvBody = csvReader.readAll();
        int st_count = countCsvLines(path);
//        System.out.println("____________In Program_____________");
        System.out.println("____________path_____________" + path);
//        System.out.println("____________discountType_____________" + discount_type);

        switch (discountType) {
            case "FLAT_DISCOUNT_ON_SKU":
                for (int i = 1; i<=st_count-1; i++) {
                    Random random = new Random();
                    System.out.println("____________FLAT_DISCOUNT_ON_SKU_____________");
                    double x = random.nextInt(900) + 10.1;
                    csvBody.get(i)[0] = "Automated_b2b_coupons" + String.valueOf(System.currentTimeMillis());
                    csvBody.get(i)[8] = String.valueOf(x);
                    Thread.sleep(1000);
                }
                break;
            case "PERCENT_DISCOUNT":
                for (int i = 1; i<=st_count-1; i++) {
                    Random random = new Random();
                    System.out.println("____________PERCENT_DISCOUNT_____________");
                    double x = random.nextInt(100) + 1.23;
                    csvBody.get(i)[0] = "Automated_b2b_coupons" + String.valueOf(System.currentTimeMillis());
                    csvBody.get(i)[13] = String.valueOf(x);
                    double y = random.nextInt(1000) + 1.23;
                    csvBody.get(i)[14] = String.valueOf(y);
                    Thread.sleep(1000);
                }
                break;
            case "SKU_AT_FIXED_PRICE":
                for (int i = 1; i<=st_count-1; i++) {
                    Random random = new Random();
                    System.out.println("____________SKU_AT_FIXED_PRICE_____________");
                    double x = random.nextInt(9000) + 10.1;
                    csvBody.get(i)[0] = "Automated_b2b_coupons" + String.valueOf(System.currentTimeMillis());
                    csvBody.get(i)[13] = String.valueOf(x);
                    Thread.sleep(1000);
                }
                break;
        }
        reader.close();

        CSVWriter writer = new CSVWriter(
                new OutputStreamWriter(new FileOutputStream(destination), StandardCharsets.UTF_8), SEPARATOR,
                CSVWriter.NO_QUOTE_CHARACTER, CSVWriter.DEFAULT_ESCAPE_CHARACTER, CSVWriter.DEFAULT_LINE_END);
        writer.writeAll(csvBody);
        writer.flush();
        writer.close();
    }

    public static void B2B_coupon_Bulk_edit(String path) throws IOException {
        String destination = "src/test/java/executables/helperFiles/files/flatDiscountTemplate1.csv";
//        deleteCSV(destination);
        Reader reader = Files.newBufferedReader(Paths.get(path));
        CSVReader csvReader = new CSVReaderBuilder(reader).withSkipLines(0).build();
        List<String[]> csvBody = csvReader.readAll();
        reader.close();

        CSVWriter writer = new CSVWriter(
                new OutputStreamWriter(new FileOutputStream(destination), StandardCharsets.UTF_8), SEPARATOR,
                CSVWriter.NO_QUOTE_CHARACTER, CSVWriter.DEFAULT_ESCAPE_CHARACTER, CSVWriter.DEFAULT_LINE_END);
        writer.writeAll(csvBody);
        writer.flush();
        writer.close();
    }

    public static void B2B_campaign_Bulk_update_edit(String path) throws IOException {
        String destination = "src/test/java/executables/helperFiles/files/flatDiscountTemplate1.csv";
        Reader reader = Files.newBufferedReader(Paths.get(path));
        CSVReader csvReader = new CSVReaderBuilder(reader).withSkipLines(0).build();
        List<String[]> csvBody = csvReader.readAll();
        reader.close();

        CSVWriter writer = new CSVWriter(
                new OutputStreamWriter(new FileOutputStream(destination), StandardCharsets.UTF_8), SEPARATOR,
                CSVWriter.NO_QUOTE_CHARACTER, CSVWriter.DEFAULT_ESCAPE_CHARACTER, CSVWriter.DEFAULT_LINE_END);
        writer.writeAll(csvBody);
        writer.flush();
        writer.close();
    }

    public static void Promotions_BulkUpload(String path) throws IOException, InterruptedException {
        String destination = "src/test/java/executables/helperFiles/files/flatDiscountTemplate1.csv";
        Reader reader = Files.newBufferedReader(Paths.get(path));
        CSVReader csvReader = new CSVReaderBuilder(reader).withSkipLines(0).build();
        List<String[]> csvBody = csvReader.readAll();
        for (int i = 1; i<=5; i++) {
            csvBody.get(i)[0] = getAlphaNumericString(10);
            Thread.sleep(1000);
        }
        reader.close();

        CSVWriter writer = new CSVWriter(
                new OutputStreamWriter(new FileOutputStream(destination), StandardCharsets.UTF_8), SEPARATOR,
                CSVWriter.NO_QUOTE_CHARACTER, CSVWriter.DEFAULT_ESCAPE_CHARACTER, CSVWriter.DEFAULT_LINE_END);
        writer.writeAll(csvBody);
        writer.flush();
        writer.close();
    }

    public static void Promotions_BulkEdit(String path) throws IOException {
        String destination = "src/test/java/executables/helperFiles/files/flatDiscountTemplate1.csv";
        Reader reader = Files.newBufferedReader(Paths.get(path));
        CSVReader csvReader = new CSVReaderBuilder(reader).withSkipLines(0).build();
        List<String[]> csvBody = csvReader.readAll();
        reader.close();

        CSVWriter writer = new CSVWriter(
                new OutputStreamWriter(new FileOutputStream(destination), StandardCharsets.UTF_8), SEPARATOR,
                CSVWriter.NO_QUOTE_CHARACTER, CSVWriter.DEFAULT_ESCAPE_CHARACTER, CSVWriter.DEFAULT_LINE_END);
        writer.writeAll(csvBody);
        writer.flush();
        writer.close();
    }

    public static void B2C_coupon_BulkUpload(String path) throws IOException, InterruptedException {
        String destination = "src/test/java/executables/helperFiles/files/flatDiscountTemplate1.csv";
        Reader reader = Files.newBufferedReader(Paths.get(path));
        CSVReader csvReader = new CSVReaderBuilder(reader).withSkipLines(0).build();
        List<String[]> csvBody = csvReader.readAll();
        for (int i = 1; i<=2; i++) {
            csvBody.get(i)[0] = "Automated_b2b_coupon_codes" + System.currentTimeMillis();
            Thread.sleep(1000);
        }
        reader.close();

        CSVWriter writer = new CSVWriter(
                new OutputStreamWriter(new FileOutputStream(destination), StandardCharsets.UTF_8), SEPARATOR,
                CSVWriter.NO_QUOTE_CHARACTER, CSVWriter.DEFAULT_ESCAPE_CHARACTER, CSVWriter.DEFAULT_LINE_END);
        writer.writeAll(csvBody);
        writer.flush();
        writer.close();
    }

    public static void Vouchers_BulkUpload(String path) throws IOException, InterruptedException {
        String destination = "src/test/java/executables/helperFiles/files/flatDiscountTemplate1.csv";
        Reader reader = Files.newBufferedReader(Paths.get(path));
        CSVReader csvReader = new CSVReaderBuilder(reader).withSkipLines(0).build();
        List<String[]> csvBody = csvReader.readAll();
        for (int i = 1; i<=4; i++) {
            csvBody.get(i)[11] = "VoucherCode" + System.currentTimeMillis();
            Thread.sleep(1000);
        }
        reader.close();

        CSVWriter writer = new CSVWriter(
                new OutputStreamWriter(new FileOutputStream(destination), StandardCharsets.UTF_8), SEPARATOR,
                CSVWriter.NO_QUOTE_CHARACTER, CSVWriter.DEFAULT_ESCAPE_CHARACTER, CSVWriter.DEFAULT_LINE_END);
        writer.writeAll(csvBody);
        writer.flush();
        writer.close();
    }

    public static void Vouchers_BulkEdit(String path) throws IOException {
        String destination = "src/test/java/executables/helperFiles/files/flatDiscountTemplate1.csv";
        Reader reader = Files.newBufferedReader(Paths.get(path));
        CSVReader csvReader = new CSVReaderBuilder(reader).withSkipLines(0).build();
        List<String[]> csvBody = csvReader.readAll();
//        for (int i = 1; i<=6; i++) {
//            csvBody.get(i)[11] = "VoucherCode" + String.valueOf(System.currentTimeMillis());
//            Thread.sleep(1000);
//        }
        reader.close();

        CSVWriter writer = new CSVWriter(
                new OutputStreamWriter(new FileOutputStream(destination), StandardCharsets.UTF_8), SEPARATOR,
                CSVWriter.NO_QUOTE_CHARACTER, CSVWriter.DEFAULT_ESCAPE_CHARACTER, CSVWriter.DEFAULT_LINE_END);
        writer.writeAll(csvBody);
        writer.flush();
        writer.close();
    }

    public static HashMap<Object, Object> MapIt(List<String> CouponCodes,  List<Integer>CouponIds){
        HashMap<Object,Object> IdCode = new HashMap<>();

        for (int i=0;i<CouponIds.size();++i){
            IdCode.put(Integer.toString(CouponIds.get(i)), CouponCodes.get(i));
        }
        return IdCode;
    }
}
