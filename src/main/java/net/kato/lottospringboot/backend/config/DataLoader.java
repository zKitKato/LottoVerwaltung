package net.kato.lottospringboot.backend.config;

import net.kato.lottospringboot.backend.service.DataImportService;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class DataLoader implements CommandLineRunner {

    private final DataImportService dataImportService;

    public DataLoader(DataImportService dataImportService) {
        this.dataImportService = dataImportService;
    }

    @Override
    public void run(String... args) throws Exception {
        String filePath = "lotto-Euro-liste.json"; // Pfad zu deiner JSON
        dataImportService.importJsonData(filePath);
        System.out.println("Lotto- und Eurojackpot-Daten importiert!");
    }
}