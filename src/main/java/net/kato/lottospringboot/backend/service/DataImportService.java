package net.kato.lottospringboot.backend.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import net.kato.lottospringboot.backend.dao.GameDrawRepository;
import net.kato.lottospringboot.backend.model.GameDraw;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

@Service
public class DataImportService {

    private final GameDrawRepository gameDrawRepo;

    public DataImportService(GameDrawRepository gameDrawRepo) {
        this.gameDrawRepo = gameDrawRepo;
    }

    public void importJsonData(String filePath) throws IOException {
        ObjectMapper mapper = new ObjectMapper();
        JsonNode root = mapper.readTree(new File(filePath));

        saveLotto(root);
        saveEurojackpot(root);
    }

    private void saveLotto(JsonNode root) {
        JsonNode gewinn = root.get("lotto_gewinnzahlen");
        JsonNode jackpot = root.get("lotto_jackpot");
        JsonNode ziehung = root.get("lotto_ziehung");

        GameDraw lotto = new GameDraw();
        lotto.setGameName("lotto");
        lotto.setGameDate(gewinn.get("Datum").asText());
        lotto.setDrawDay(gewinn.get("Ziehung").asText());
        lotto.setNumbers(toIntegerList(gewinn.get("Zahl")).toString());
        lotto.setExtraNumbers(List.of(gewinn.get("Superzahl").asInt()).toString());
        lotto.setJackpot(new BigDecimal(jackpot.get("ErwarteterJackpot1").asText()));
        lotto.setNextDeadlineDate(ziehung.get("AnnahmeschlussDatum").asText());
        lotto.setNextDeadlineTime(ziehung.get("AnnahmeschlussUhrzeit").asText());

        gameDrawRepo.save(lotto);
    }

    private void saveEurojackpot(JsonNode root) {
        JsonNode gewinn = root.get("eurojackpot_gewinnzahlen");
        JsonNode jackpot = root.get("eurojackpot_jackpot");
        JsonNode ziehung = root.get("eurojackpot_ziehung");

        GameDraw euro = new GameDraw();
        euro.setGameName("eurojackpot");
        euro.setGameDate(gewinn.get("Datum").asText());
        euro.setDrawDay(gewinn.get("Ziehung").asText());
        euro.setNumbers(toIntegerList(gewinn.get("Zahl")).toString());
        euro.setExtraNumbers(toIntegerList(gewinn.get("Eurozahl")).toString());
        euro.setJackpot(BigDecimal.valueOf(jackpot.get("ErwarteterJackpot1").asDouble()));
        euro.setNextDeadlineDate(ziehung.get("AnnahmeschlussDatum").asText());
        euro.setNextDeadlineTime(ziehung.get("AnnahmeschlussUhrzeit").asText());

        gameDrawRepo.save(euro);
    }

    private List<Integer> toIntegerList(JsonNode node) {
        return StreamSupport.stream(node.spliterator(), false)
                .map(JsonNode::asInt)
                .collect(Collectors.toList());
    }
}
