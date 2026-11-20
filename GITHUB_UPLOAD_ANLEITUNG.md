# Schritt für Schritt: GitHub-Upload

## 1. Repository erstellen

1. Öffne https://github.com/new und melde dich an.
2. **Repository name:** `databricks-electronica-big-data`.
3. **Description:** `Databricks Big Data case study: Medallion Architecture, SQL ETL, IoT analytics and production-cost KPIs.`
4. **Visibility:** zunächst `Private`, bis Team- und Rechtefreigabe vorliegen.
5. Die Optionen **Add a README file**, **Add .gitignore** und **Choose a license** nicht aktivieren. README und `.gitignore` sind schon im Paket enthalten; eine Lizenz benötigt Teamabstimmung.
6. Klicke auf **Create repository**.

## 2. Dateien hochladen

1. ZIP-Paket unter Windows mit **Alle extrahieren** entpacken.
2. Neues Repository öffnen und auf **uploading an existing file** klicken (oder **Add file → Upload files**).
3. **Inhalt** des entpackten Projektordners hochladen, nicht die ZIP-Datei selbst.
4. Kontrolliere, dass `README.md` im **obersten Verzeichnis** liegt und `sql/`, `docs/`, `screenshots/` sichtbar sind.
5. Als Commit-Nachricht: `Add Databricks Big Data Electronica case study`.
6. Auf **Commit changes** klicken.

## 3. Ergebnis prüfen

- Die README sollte automatisch unter den Dateien angezeigt werden.
- Die acht Diagramm-Bilder sollten in der README erscheinen.
- Unter `sql/` sollten vier `.sql`-Dateien verfügbar sein.
- Vor dem Wechsel zu `Public` alle Punkte aus `docs/vor-veroeffentlichung.md` erledigen.
