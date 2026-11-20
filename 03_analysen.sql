-- Databricks SQL | Eigenständig ausführbare Analyse-Abfragen
-- Quelle: eigene SQL-Dokumentation (databricks_befehle.pdf), Seite 6
-- Voraussetzung: Gold- und Silver-Tabellen existieren.

-- 1. Versteckte Kosten: Veränderung der Marge durch Produktionsfehler
SELECT
    produktname,
    marke,
    umsatz_gesamt,
    marge_prozent AS marge_ohne_fehler,
    marge_bereinigt_prozent AS marge_mit_fehler,
    ROUND(marge_prozent - marge_bereinigt_prozent, 2) AS versteckte_kosten_pct,
    fehlerkosten
FROM gruppe5.gold_layer.kpi_produkt_gesamt
WHERE umsatz_gesamt > 0
ORDER BY versteckte_kosten_pct DESC
LIMIT 10;

-- 2. Produktionslinien nach kritischen Meldungen
SELECT
    linie_nr,
    SUM(anzahl_meldungen) AS meldungen_gesamt,
    SUM(CASE WHEN meldung_art = 'C' THEN anzahl_meldungen ELSE 0 END) AS critical,
    SUM(CASE WHEN meldung_art = 'E' THEN anzahl_meldungen ELSE 0 END) AS errors,
    SUM(fehlerkosten_gesamt) AS fehlerkosten
FROM gruppe5.gold_layer.kpi_linie_fehler
GROUP BY linie_nr
ORDER BY critical DESC;

-- 3. Top-Produkte nach bereinigtem Gewinn
SELECT
    produktname,
    marke,
    umsatz_gesamt,
    gewinn,
    gewinn_bereinigt,
    marge_bereinigt_prozent
FROM gruppe5.gold_layer.kpi_produkt_gesamt
WHERE umsatz_gesamt > 0
ORDER BY gewinn_bereinigt DESC
LIMIT 10;

-- 4. Kundenklassifikation und durchschnittlicher Rabatt
SELECT
    k.klassifikation,
    COUNT(DISTINCT k.kunden_id) AS anzahl_kunden,
    ROUND(AVG(v.rabatt_prozent) * 100, 2) AS durchschnitt_rabatt_pct,
    SUM(v.umsatz_netto) AS umsatz_gesamt
FROM gruppe5.silver_layer.dim_kunde k
JOIN gruppe5.silver_layer.fact_verkauf v ON k.kunden_id = v.kunden_id
GROUP BY k.klassifikation
ORDER BY k.klassifikation;
