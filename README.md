# Oppskrift for kjøring av prosjektet i DB2

**NB!** Alle kommandoer skal utføres fra rotmappen `tdt4145-project`.

For å opprette tabellene i den tomme databasen `theater.db`, bruk følgende kommandoer:

```bash
sqlite3 database/theater.db

# Inne i SQLite3-skallet
.read scripts/theater_schema.sql
```

## Brukstilfelle 1

For å fylle databasen med definerte tabeller for teaterstoler, teaterstykker, forestillinger, akter, roller,
skuespillere osv., kjør kommandoen:

```bash
.read scripts/theater_data_insert.sql
```

Avslutt SQLite 3 med:

```bash
.q
```

## Brukstilfelle 2

For å fylle inn alle seter basert på `hovedscenen.txt` og `gamlescenen.txt`, med deres tilgjengelighet og definerte
dato, kjør følgende kommando:

```bash
python3 project/sold_seats.py
```

## Brukstilfelle 3

For å kjøpe 9 ordinære billetter (voksenbilletter) for den 3. februar, hvor alle setene er på samme rad, bruk følgende
kommando:

```bash
python3 project/purchase_tickets.py
```

## Brukstilfelle 4

For å skrive ut hvilke forestillinger som finnes på en gitt dato, hvor mange billetter som er solgt på denne datoen,
samt liste opp hvor mange seter som er solgt, bruk følgende kommando:

```bash
python3 project/sold_tickets_date.py "YYYY-MM-DD"
```

## Brukstilfelle 5

For å finne navnene på skuespillere som opptrer i de forskjellige teaterstykkene, kjør følgende kommando:

```bash
sqlite3 database/theater.db < project/actors_in_play.sql
```

## Brukstilfelle 6

For å finne forestillinger som har solgt flest billetter, i synkende rekkefølge, kjør følgende kommando:

```bash
sqlite3 database/theater.db < project/retrieve_top_selling_shows.sql
```

## Brukstilfelle 7

For å ta et skuespillernavn og finne hvilke skuespillere de har delt scene med i samme akt, kjør følgende kommando:

```bash
python3 project/print_co_actors_in_same_act.py {{skuespillernavn}}
```



