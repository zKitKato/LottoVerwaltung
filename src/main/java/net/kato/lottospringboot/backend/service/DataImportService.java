package net.kato.lottospringboot.backend.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import net.kato.lottospringboot.backend.dao.GameDrawEuroRepository;
import net.kato.lottospringboot.backend.dao.GameDrawLottoRepository;
import net.kato.lottospringboot.backend.model.GameDrawEuro;
import net.kato.lottospringboot.backend.model.GameDrawLotto;
import org.springframework.stereotype.Service;

import java.io.File;
import java.math.BigDecimal;

@Service
public class DataImportService {

    private final GameDrawLottoRepository lottoRepo;
    private final GameDrawEuroRepository euroRepo;

    public DataImportService(GameDrawLottoRepository lottoRepo,
                             GameDrawEuroRepository euroRepo) {
        this.lottoRepo = lottoRepo;
        this.euroRepo = euroRepo;
    }

    public void importJsonData(String filePath) throws Exception {

        ObjectMapper mapper = new ObjectMapper();
        JsonNode root = mapper.readTree(new File(filePath));

        /* ==========================
           🔵 LOTTO
        ========================== */

        JsonNode lottoGewinn = root.get("lotto_gewinnzahlen");
        JsonNode lottoJackpot = root.get("lotto_jackpot");
        JsonNode lottoZiehung = root.get("lotto_ziehung");

        String lottoDate = lottoGewinn.get("Datum").asText();

        if (lottoRepo.findByGameDate(lottoDate).isEmpty()) {

            GameDrawLotto lotto = new GameDrawLotto();

            lotto.setGameDate(lottoDate);
            lotto.setDrawDay(lottoGewinn.get("Ziehung").asText());
            lotto.setNumbers(lottoGewinn.get("Zahl").toString());
            lotto.setExtraNumbers("[" + lottoGewinn.get("Superzahl").asText() + "]");

            lotto.setJackpot(new BigDecimal(
                    lottoJackpot.get("ErwarteterJackpot1").asText()
            ));

            lotto.setNextDeadlineDate(
                    lottoZiehung.get("AnnahmeschlussDatum").asText()
            );

            lotto.setNextDeadlineTime(
                    lottoZiehung.get("AnnahmeschlussUhrzeit").asText()
            );

            lottoRepo.save(lotto);
        }

        /* ==========================
           🟡 EUROJACKPOT
        ========================== */

        JsonNode euroGewinn = root.get("eurojackpot_gewinnzahlen");
        JsonNode euroJackpot = root.get("eurojackpot_jackpot");
        JsonNode euroZiehung = root.get("eurojackpot_ziehung");

        String euroDate = euroGewinn.get("Datum").asText();

        if (euroRepo.findByGameDate(euroDate).isEmpty()) {

            GameDrawEuro euro = new GameDrawEuro();

            euro.setGameDate(euroDate);
            euro.setDrawDay(euroGewinn.get("Ziehung").asText());
            euro.setNumbers(euroGewinn.get("Zahl").toString());
            euro.setExtraNumbers(euroGewinn.get("Eurozahl").toString());

            euro.setJackpot(new BigDecimal(
                    euroJackpot.get("ErwarteterJackpot1").asText()
            ));

            euro.setNextDeadlineDate(
                    euroZiehung.get("AnnahmeschlussDatum").asText()
            );

            euro.setNextDeadlineTime(
                    euroZiehung.get("AnnahmeschlussUhrzeit").asText()
            );

            euroRepo.save(euro);
        }

        System.out.println("✔ Lotto & Eurojackpot erfolgreich importiert.");
    }
}