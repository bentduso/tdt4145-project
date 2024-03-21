(Åpne filen i preview for et finere format)

# Oppskrift for å kjøring av prosjektet i DB2

Alle kommandoer skal kjøres fra mappen "TDT4145-PROJECT"

Start med å opprette databasen, med navn "theater.db"
```bash
    $ sqlite3 database/theater.db
```

For å konstruere databasen i sqlite3 skriv 

```bash
    .read scripts/theater_schema.sql
```

## Usecase 1:

Nå må du fylle databasen med predefinert data med

```bash
    .read scripts/theater_data_insert.sql
```
Avslutt sqlite3 med
```bash
    .q
```

## Usecase 2:

Denne kommandoen fyller inn alle seter basert på txt-filene og tilgjengelighet på datoen som er definert i txt-filene
```bash
    python3 project/sold_seats.py
```

## Usecase 3:

Denne kommandoen kjøper 9 ordinære billetter den 3. februar, hvor alle setter er på samme rad. Gjerne kjør den flere ganger for å se at det er reproduserbart.
```bash
    python3 project/purchase_tickets.py
```

## Usecase 4:

Denne kommandoen skriver ut hvilke forestillinger som finnes på en gitt dato og hvor mange billetter som er solgt til de
```bash
    python3 project/sold_tickets_date.py "2024-02-03"
```

## Usecase 5:

Denne kommandoen finner skuespillere som har spilt i teaterstykker
```bash
    sqlite3 database/theater.db < ../project/actors_in_play.sql
```

## Usecase 6:

Denne kommandoen finner forestillinger som har solgt flest billetter, i synkende rekkefølge
```bash
    sqlite3 database/theater.db < ../project/retrieve_top_selling_shows.sql
```

## Usecase 7:

Denne kommandoen finner hvilke skuespillere som har spilt sammen i samme akt, og hvilket skuespill det skjedde i. Kommandoen tar inn et navn som argument, for eksempel "Arturo Scrotti".

```bash
    python3 project/print_co_actors_in_same_act.py "Arturo Scotti"
```



