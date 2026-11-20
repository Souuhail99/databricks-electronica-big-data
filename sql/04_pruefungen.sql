-- Databricks SQL | Prüf- und Debugging-Abfragen
-- Quelle: eigene SQL-Dokumentation (databricks_befehle.pdf), Seite 7

-- Prüfung von Netto-Umsatz und Rabattskalierung
SELECT produkt_nr, menge, einzelpreis, rabatt_prozent, umsatz_netto
FROM gruppe5.silver_layer.fact_verkauf LIMIT 10;

-- Prüfung Produkt-Performance
SELECT produktname, umsatz_gesamt, gewinn, marge_prozent
FROM gruppe5.gold_layer.kpi_produkt_performance LIMIT 10;

-- Anzahl und Summe der Produktionsfehlerkosten
SELECT SUM(fehlerkosten) AS total, COUNT(*) AS zeilen
FROM gruppe5.silver_layer.fact_produktion;

-- Formatvergleich der Produktnummern vor dem JOIN
SELECT 'Produktion' AS quelle, produkt_nr FROM gruppe5.silver_layer.fact_produktion LIMIT 5
UNION ALL
SELECT 'Produkt' AS quelle, produkt_nr FROM gruppe5.silver_layer.dim_produkt LIMIT 5;
