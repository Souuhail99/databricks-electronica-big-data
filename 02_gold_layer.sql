-- Databricks SQL | Electronica-Fallstudie, Gruppe 5
-- Quelle: eigene SQL-Dokumentation (databricks_befehle.pdf), Seiten 4-5
-- Voraussetzung: sql/01_silver_layer.sql wurde erfolgreich ausgeführt.
-- ACHTUNG: CREATE OR REPLACE TABLE überschreibt vorhandene Tabellen.

CREATE SCHEMA IF NOT EXISTS gruppe5.gold_layer;

-- Produkt-Performance: Netto-Umsatz, Kosten, Gewinn und Marge
CREATE OR REPLACE TABLE gruppe5.gold_layer.kpi_produkt_performance AS
SELECT
    p.produkt_nr,
    p.produktname,
    p.marke,
    p.produktgruppe,
    SUM(v.menge) AS verkaufte_menge,
    SUM(v.umsatz_netto) AS umsatz_gesamt,
    ROUND(AVG(v.rabatt_prozent) * 100, 2) AS durchschnitt_rabatt_pct,
    p.herstellkosten,
    p.markenkosten,
    p.gesamtkosten,
    SUM(v.menge) * p.gesamtkosten AS kosten_gesamt,
    SUM(v.umsatz_netto) - (SUM(v.menge) * p.gesamtkosten) AS gewinn,
    ROUND(
        (SUM(v.umsatz_netto) - (SUM(v.menge) * p.gesamtkosten)) /
        NULLIF(SUM(v.umsatz_netto), 0) * 100
    , 2) AS marge_prozent
FROM gruppe5.silver_layer.dim_produkt p
LEFT JOIN gruppe5.silver_layer.fact_verkauf v
    ON p.produkt_nr = v.produkt_nr
GROUP BY ALL;

-- Fehlermeldungen und Fehlerkosten nach Produktionslinie
CREATE OR REPLACE TABLE gruppe5.gold_layer.kpi_linie_fehler AS
SELECT
    a.linie_nr,
    m.meldung_art,
    m.meldung_art_text,
    COUNT(*) AS anzahl_meldungen,
    SUM(pr.fehlerkosten) AS fehlerkosten_gesamt,
    ROUND(AVG(pr.fehlerkosten), 2) AS kosten_pro_fehler
FROM gruppe5.silver_layer.fact_produktion pr
JOIN gruppe5.silver_layer.dim_meldung m
    ON pr.meldung_nr = m.meldung_nr
JOIN gruppe5.silver_layer.dim_anlage a
    ON pr.SYS_ID = a.sps_nr
GROUP BY a.linie_nr, m.meldung_art, m.meldung_art_text
ORDER BY a.linie_nr, m.meldung_art;

-- Verbindet Vertriebszahlen mit Fehlerkosten aus der Produktion
CREATE OR REPLACE TABLE gruppe5.gold_layer.kpi_produkt_gesamt AS
WITH produkt_fehler AS (
    SELECT
        produkt_nr,
        COUNT(*) AS anzahl_fehler,
        SUM(CASE WHEN m.meldung_art = 'C' THEN 1 ELSE 0 END) AS critical_errors,
        SUM(CASE WHEN m.meldung_art = 'E' THEN 1 ELSE 0 END) AS errors,
        SUM(pr.fehlerkosten) AS produktions_fehlerkosten
    FROM gruppe5.silver_layer.fact_produktion pr
    JOIN gruppe5.silver_layer.dim_meldung m ON pr.meldung_nr = m.meldung_nr
    GROUP BY produkt_nr
)
SELECT
    kp.*,
    COALESCE(pf.anzahl_fehler, 0) AS produktionsfehler,
    COALESCE(pf.critical_errors, 0) AS kritische_fehler,
    COALESCE(pf.errors, 0) AS fehler,
    COALESCE(pf.produktions_fehlerkosten, 0) AS fehlerkosten,
    kp.gewinn - COALESCE(pf.produktions_fehlerkosten, 0) AS gewinn_bereinigt,
    ROUND(
        (kp.gewinn - COALESCE(pf.produktions_fehlerkosten, 0)) /
        NULLIF(kp.umsatz_gesamt, 0) * 100
    , 2) AS marge_bereinigt_prozent
FROM gruppe5.gold_layer.kpi_produkt_performance kp
LEFT JOIN produkt_fehler pf ON kp.produkt_nr = pf.produkt_nr;
