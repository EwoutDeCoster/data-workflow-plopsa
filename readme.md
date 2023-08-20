# workflow-automation

Voor deze opdracht moets ik een geautomatiseerde data workflow opzetten. Ik heb voor deze opdracht gekozen om de wachttijden voor de atracties van het pretpark Plopsaland De Panne als dataset te gebruiken. Deze zijn beschikbaar via een API van [queue-times.com](https://queue-times.com/) . De API bevat data van 121 pretparken. Voor deze opdracht heb ik ervoor gekozen om als proof-of-concept enkel de data van Plopsaland te verwerken. De data die ik verzameld heb is van 7/12, 10/12 en 11/12. Doordat het park enkel open is op woensdag en het weekend buiten het zomerseizoen is er niet super veel data om mee te werken.

## Data

De data die ik verzamel bestaat uit:

* **name**: De naam van de attractie.
* **last_update**: De laatste keer dat er een wijziging is aangebracht aan de data van de API.
* **is_open**: Is de attractie open? (true/false)
* **wait_time**: De wachttijd in minuten.

## Scripts

Deze opdracht is onderverdeeld in verschillende scripts. Hieronder ziet u een overzicht van wat de verschillende scripts doen.

### apiscript.sh

Dit script haalt alle ruwe data op van de API service en zet deze in de folder `data/`

### convertToCSV.sh

Dit script convert de data van het laatste .json bestand in `data/` naar csv en plaatst deze onderaan in `data.csv` . Hierbij wordt gebruik gemaakt van *dasel*. Indien dit niet geinstalleerd staad, installeert het script dit automatisch.

### analyse.py

Dit script maakt een rapport van alle data die ter beschikking is in `data.csv`. Het resultaat van dit script is `rapport.html`

### main.sh

Dit script runt alle script in volgorde achter elkaar. Er wordt steeds gewacht tot een script klaar is met runnen voordat het volgende wordt gestart.

## Cronjob

Om deze workflow volledig automatisch te maken moet er een Cronjob aangemaakt worden. Om dit te doen gebruiken we het commando `crontab -e`. Wanneer we dit hebben gedaan, opent er een bestand. Hierin kunnen we omschrijven wanneer en hoe frequent we het bestand willen uitvoeren.

In dit geval willen we het bestand om het kwartier en enkel op de openingsdagen uitvoeren. Een voorbeeld:

```bash
*/15 10-17:30 7 12 * TZ=CET cd /root/IA && /root/IA/main.sh
*/15 10-18 10 12 * TZ=CET cd /root/IA && /root/IA/main.sh    
*/15 10-18 11 12 * TZ=CET cd /root/IA && /root/IA/main.sh
```
