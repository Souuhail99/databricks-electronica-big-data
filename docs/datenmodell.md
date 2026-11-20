# Datenmodell und Mapping

## Bronze / `gruppe5.raw_layer`

Im Projekt wurden sechs Quelltabellen beschrieben: `dl_iot`, `dl_meldungen`, `dl_sps`, `dwh_kunde`, `dwh_produkt`, `dwh_verkauf`.

Die Rohdaten wurden nach Angaben der Gruppenpräsentation in Databricks Volumes bereitgestellt und in Tabellen übernommen. **Ein SQL- oder Python-Skript für diesen Importschritt wurde nicht mitgeliefert.**

## Silver / `gruppe5.silver_layer`

| Zieltabelle | Quelltabelle | Relevante Verarbeitung |
|---|---|---|
| `fact_produktion` | `dl_iot` | `CAST` Zeitstempel, `SUBSTRING(HERST_NR,1,6)` Produktnummer, `COALESCE(COST,0)` |
| `fact_verkauf` | `dwh_verkauf` | Datumsformat, Netto-Umsatz, Rabatt als Prozent / 100 |
| `dim_meldung` | `dl_meldungen` | Meldungsarten I/W/E/C, bereinigte Texte |
| `dim_anlage` | `dl_sps` | Produktionslinie, Anlage und SPS |
| `dim_kunde` | `dwh_kunde` | Kundendaten bereinigt, Länderkennung in Großschrift |
| `dim_produkt` | `dwh_produkt` | Produktattribute sowie Herstell- und Markenkosten |

## Gold / `gruppe5.gold_layer`

| Zieltabelle | Beschreibung |
|---|---|
| `kpi_produkt_performance` | Umsatz, verkaufte Menge, Herstellkosten, Markenkosten, Gewinn, Marge |
| `kpi_linie_fehler` | Meldungsanzahl und Fehlerkosten je Produktionslinie/Meldungsart |
| `kpi_produkt_gesamt` | Kombination aus Vertriebsergebnis und Produktfehlerkosten |

### Fachlicher Zusammenhang

- Vertrieb: Fakt **Verkauf** mit den Dimensionen **Kunde** und **Produkt**.
- Fertigung: Fakt **Produktion/IoT-Meldung** mit den Dimensionen **Anlage/SPS** und **Meldung**.
- In `kpi_produkt_gesamt` werden Produktperformance und produktbezogene Fehlerkosten zusammengeführt.

Die genauen technischen Bezeichner und SQL-Berechnungen stehen in den vier Skripten unter `sql/`.
