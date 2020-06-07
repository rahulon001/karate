package executables.utils;
import com.opencsv.CSVReader;
import com.opencsv.CSVReaderBuilder;
import com.opencsv.CSVWriter;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;

public class HelperMethods {
    private static final char SEPARATOR = ',';

    public static void B2B_BulkUpload() throws IOException, InterruptedException {
        String path = "src/test/java/executables/helperFiles/files/flatDiscountTemplate.csv";
        String destination = "src/test/java/executables/helperFiles/files/flatDiscountTemplate1.csv";
        Reader reader = Files.newBufferedReader(Paths.get(path));
        CSVReader csvReader = new CSVReaderBuilder(reader).withSkipLines(0).build();
        List<String[]> csvBody = csvReader.readAll();
        csvBody.get(1)[0] = 'A' + String.valueOf(System.currentTimeMillis());
        Thread.sleep(1000);
        csvBody.get(2)[0] = 'A' + String.valueOf(System.currentTimeMillis());
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
