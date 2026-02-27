package net.kato.lottospringboot.backend.controller;

import net.kato.lottospringboot.backend.dao.GameDrawEuroRepository;
import net.kato.lottospringboot.backend.dao.GameDrawLottoRepository;
import net.kato.lottospringboot.backend.model.GameDrawEuro;
import net.kato.lottospringboot.backend.model.GameDrawLotto;
import net.kato.lottospringboot.backend.service.DataImportService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
public class ApiController {

    private final DataImportService dataImportService;
    private final GameDrawLottoRepository lottoRepo;
    private final GameDrawEuroRepository euroRepo;

    public ApiController(DataImportService dataImportService,
                         GameDrawLottoRepository lottoRepo,
                         GameDrawEuroRepository euroRepo) {
        this.dataImportService = dataImportService;
        this.lottoRepo = lottoRepo;
        this.euroRepo = euroRepo;
    }

    // 🔄 JSON Import
    @PostMapping("/import")
    public ResponseEntity<String> importData(@RequestParam String filePath) {
        try {
            dataImportService.importJsonData(filePath);
            return ResponseEntity.ok("✅ Importiert: " + filePath);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("❌ Fehler: " + e.getMessage());
        }
    }

    // 🔵 Lotto
    @GetMapping("/lotto")
    public List<GameDrawLotto> getAllLotto() {
        return lottoRepo.findAll();
    }

    @GetMapping("/lotto/latest")
    public GameDrawLotto getLatestLotto() {
        return lottoRepo.findTopByOrderByIdDesc();
    }

    // 🟡 Eurojackpot
    @GetMapping("/eurojackpot")
    public List<GameDrawEuro> getAllEuro() {
        return euroRepo.findAll();
    }

    @GetMapping("/eurojackpot/latest")
    public GameDrawEuro getLatestEuro() {
        return euroRepo.findTopByOrderByIdDesc();
    }
}