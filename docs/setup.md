# Anleitung: SQL in Databricks ausführen

## Voraussetzungen

1. Zugriff auf einen **Databricks SQL**-Workspace mit Berechtigungen zum Anlegen/Ersetzen von Tabellen.
2. Existierender Katalog `gruppe5` bzw. eine eigene, berechtigte Anpassung der vollqualifizierten Tabellennamen.
3. Schema `gruppe5.raw_layer` mit den Tabellen: `dl_iot`, `dl_meldungen`, `dl_sps`, `dwh_kunde`, `dwh_produkt`, `dwh_verkauf`.
4. Datenfelder und -typen gemäß der SQL-Dokumentation (siehe `docs/datenmodell.md`).

**Wichtig:** Die ursprünglichen Quelldateien und ausführbaren Bronze-Ladeskripte wurden nicht bereitgestellt. Aus dem GitHub-Paket allein lässt sich deshalb keine identische Datenbasis erzeugen.

## Reihenfolge

1. `sql/01_silver_layer.sql` in einen Databricks SQL Editor kopieren, prüfen und ausführen.
2. `sql/02_gold_layer.sql` ausführen.
3. Optional `sql/04_pruefungen.sql` ausführen, um Tabelleninhalte und Schlüsselverknüpfungen zu prüfen.
4. `sql/03_analysen.sql` ausführen und die Ergebnisse untersuchen.

> **Achtung:** Die enthaltenen SQL-Skripte verwenden `CREATE OR REPLACE TABLE`. Diese Anweisungen **ersetzen** bereits vorhandene Tabellen. Nur in einer dafür vorgesehenen Testumgebung ausführen. `gruppe5` bei Bedarf durch deinen eigenen Katalog ersetzen.

## Debugging aus der Projektdokumentation

- *Falscher Netto-Umsatz*: `RABATT` wird im Quellbestand als ganze Prozentzahl angegeben, beispielsweise `5` für `5 %`; die SQL-Berechnung dividiert durch `100`.
- *Keine zugeordneten Fehlerkosten*: Produktnummernformat vergleichen; in der IoT-Tabelle wird die Produktnummer mit `SUBSTRING(HERST_NR,1,6)` extrahiert.
- *Leere JOIN-Ergebnisse*: Datentypen, führende Nullen und Längen der Produktnummern prüfen.
- *Keine Analysezeilen*: Bedingungen wie `umsatz_gesamt > 0` für die Fehlersuche isoliert prüfen.

Die SQL-Dateien sind aus der überlassenen Projektdokumentation strukturiert übernommen. Sie wurden **nicht** gegen ein aktives Databricks-System ausgeführt oder mit Originalrohdaten validiert.
