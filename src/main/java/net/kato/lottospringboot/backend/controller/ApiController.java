package net.kato.lottospringboot.backend.controller;

import net.kato.lottospringboot.backend.dao.GameDrawRepository;
import net.kato.lottospringboot.backend.model.GameDraw;
import net.kato.lottospringboot.backend.service.DataImportService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
public class ApiController {

    private final DataImportService dataImportService;
    private final GameDrawRepository gameDrawRepo;

    public ApiController(DataImportService dataImportService, GameDrawRepository gameDrawRepo) {
        this.dataImportService = dataImportService;
        this.gameDrawRepo = gameDrawRepo;
    }

    @PostMapping("/import")
    public ResponseEntity<String> importData(@RequestParam String filePath) {
        try {
            dataImportService.importJsonData(filePath);
            return ResponseEntity.ok("✅ Importiert: " + filePath);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("❌ Fehler: " + e.getMessage());
        }
    }

    @GetMapping("/draws/{gameName}")
    public List<GameDraw> getDraws(@PathVariable String gameName) {
        return gameDrawRepo.findByGameName(gameName);
    }
}
