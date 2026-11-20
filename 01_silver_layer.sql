-- Databricks SQL | Electronica-Fallstudie, Gruppe 5
-- Quelle: eigene SQL-Dokumentation (databricks_befehle.pdf), Seiten 2-3
-- Voraussetzung: gruppe5.raw_layer mit sechs bereits importierten Quelltabellen.
-- ACHTUNG: CREATE OR REPLACE TABLE überschreibt vorhandene Tabellen.

CREATE SCHEMA IF NOT EXISTS gruppe5.silver_layer;

-- IoT-Produktionsereignisse inkl. Produktnummer aus der Herstellnummer
CREATE OR REPLACE TABLE gruppe5.silver_layer.fact_produktion AS
SELECT
    SYS_ID,
    CAST(TIMESTAMP AS TIMESTAMP) AS meldung_zeit,
    CAST(TIMESTAMP AS DATE) AS meldung_datum,
    SUBSTRING(HERST_NR, 1, 6) AS produkt_nr,
    HERST_NR AS herstellnummer,
    MESSAGE_NR AS meldung_nr,
    COALESCE(COST, 0) AS fehlerkosten
FROM gruppe5.raw_layer.dl_iot;

-- Meldungstypen für das Reporting beschreiben
CREATE OR REPLACE TABLE gruppe5.silver_layer.dim_meldung AS
SELECT
    MELDUNG_NR AS meldung_nr,
    TRIM(MELDUNG_TXT) AS meldung_text,
    MELDUNG_ART AS meldung_art,
    CASE MELDUNG_ART
        WHEN 'I' THEN 'Information'
        WHEN 'W' THEN 'Warnung'
        WHEN 'E' THEN 'Fehler'
        WHEN 'C' THEN 'Kritisch'
        ELSE 'Unbekannt'
    END AS meldung_art_text
FROM gruppe5.raw_layer.dl_meldungen;

CREATE OR REPLACE TABLE gruppe5.silver_layer.dim_anlage AS
SELECT
    LINIE_NR AS linie_nr,
    ANLAGE_NR AS anlage_nr,
    SPS_NR AS sps_nr
FROM gruppe5.raw_layer.dl_sps;

CREATE OR REPLACE TABLE gruppe5.silver_layer.dim_kunde AS
SELECT
    KUNNR AS kunden_id,
    TRIM(NAME1) AS kundenname,
    UPPER(LAND1) AS land,
    TRIM(ORT01) AS ort,
    PSTLZ AS plz,
    TRIM(STRAS) AS strasse,
    KUKLA AS klassifikation
FROM gruppe5.raw_layer.dwh_kunde;

CREATE OR REPLACE TABLE gruppe5.silver_layer.dim_produkt AS
SELECT
    MATNR AS produkt_nr,
    EAN,
    TRIM(MAKTX) AS produktname,
    TRIM(MARKE) AS marke,
    COALESCE(BGRGEW, 0) AS bruttogewicht,
    GEWEI AS gewichtseinheit,
    MATKL AS produktgruppe,
    COALESCE(HKST, 0) AS herstellkosten,
    COALESCE(MKST, 0) AS markenkosten,
    COALESCE(HKST, 0) + COALESCE(MKST, 0) AS gesamtkosten,
    COALESCE(UVP, 0) AS uvp,
    CURR AS waehrung
FROM gruppe5.raw_layer.dwh_produkt;

-- In den Quelldaten bedeutet RABATT = 5 einen Rabatt von 5 Prozent.
CREATE OR REPLACE TABLE gruppe5.silver_layer.fact_verkauf AS
SELECT
    BELNR AS beleg_nr,
    POSNR AS position_nr,
    KUNNR AS kunden_id,
    MATNR AS produkt_nr,
    CAST(ERDAT AS DATE) AS verkaufsdatum,
    COALESCE(MENGE, 0) AS menge,
    MEINS AS mengeneinheit,
    COALESCE(EVKP, 0) AS einzelpreis,
    COALESCE(RABATT, 0) / 100 AS rabatt_prozent,
    ROUND(COALESCE(MENGE, 0) * COALESCE(EVKP, 0) * (1 - COALESCE(RABATT, 0) / 100), 2) AS umsatz_netto
FROM gruppe5.raw_layer.dwh_verkauf;
