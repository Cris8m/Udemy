package features;
import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import net.minidev.json.JSONArray;
import net.minidev.json.JSONValue;
import org.apache.commons.io.FileUtils;
import org.junit.Test;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import static org.junit.Assert.assertTrue;

public class TestRunner {
    private static final Logger logger = Logger.getLogger(TestRunner.class.getName());
    private static final String ERROR_MSG = "ERROR: ";

    @Test
    public void testRunner() throws IOException {
        // Ejecutar los tests en paralelo con los tags correspondientes
        Results results = Runner.path("src/test/java")
                .tags("@SpCustomer").outputCucumberJson(true).parallel(5);

        // Ruta de salida para los reportes
        String karateOutputPath = "build/karate-reports";
        generateReport(karateOutputPath);

        // Validación de que no haya fallos en los tests
        assertTrue(results.getErrorMessages(), results.getFailCount() == 0);
    }

    public static void generateReport(String karateOutputPath) throws IOException {
        // Obtener todos los archivos JSON generados por Karate
        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[]{"json"}, true);
        List<String> jsonPaths = new ArrayList<>(jsonFiles.size());
        JSONArray karateJson = new JSONArray();

        // Leer los archivos JSON y agregarlos al arreglo
        jsonFiles.forEach(file -> {
            karateJson.add(getReportJsonByFile(file.getAbsolutePath()));
            jsonPaths.add(file.getAbsolutePath());
        });

        // Crear la carpeta para el reporte consolidado
        String karateResumePath = "./build/karate-reports/json";
        File pathFile = new File(karateResumePath);
        if (!Files.exists(Paths.get(karateResumePath))) {
            pathFile.mkdir();
        }

        // Guardar un solo archivo JSON consolidado
        Files.write(Paths.get(karateResumePath + "/karate.json"), karateJson.toJSONString().getBytes());

        // Configurar el reporte HTML
        Configuration config = new Configuration(new File("build"), "Banca Movil");
        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
        reportBuilder.generateReports();
    }

    public static Object getReportJsonByFile(String filePath) {
        Object jsonReport = null;
        try (FileReader reader = new FileReader(filePath)) {
            // Usar JSONValue.parse para parsear el archivo JSON sin warnings
            JSONArray jsonArray = (JSONArray) JSONValue.parse(reader);
            if (!jsonArray.isEmpty()) {
                jsonReport = jsonArray.get(0);
            }
        } catch (IOException e) {
            logger.log(Level.WARNING, ERROR_MSG, e);
        }
        return jsonReport;
    }
}
