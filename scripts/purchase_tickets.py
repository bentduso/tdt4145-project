import sqlite3
from datetime import datetime

def kjop_billetter(database_path, name, show_date):
    conn = sqlite3.connect(database_path)
    cursor = conn.cursor()

    current_date = datetime.now().strftime("%Y-%m-%d")
    current_time = datetime.now().strftime("%H:%M:%S")

    # Finn en rad med minst 9 ledige stoler
    cursor.execute("""
        SELECT chair_row, area
        FROM chair INNER JOIN theater_play ON chair.hall_id = theater_play.hall_id INNER JOIN show ON theater_play.theater_play_id = show.theater_play_id
        WHERE is_available = 1 AND theater_play.name = ? AND show.show_date = ?
        GROUP BY chair_row
        HAVING COUNT(*) >= 9
        LIMIT 1
    """, (name, show_date))

    row = cursor.fetchone()
    print(row)
    if row:
        chair_row = row[0]
        print(chair_row)

        # Hent ut de første 9 ledige stolene på denne raden
        cursor.execute("""
            SELECT chair_number, area, chair_row
            FROM chair
            WHERE is_available = 1 AND chair_row = ? AND area = ?
            LIMIT 9
        """, (chair_row, row[1]))

        chairs = cursor.fetchall()
        for chair in chairs:
            chair_number = chair[0]
            area = chair[1]

            # Legg til transaksjon for hvert sete
            # Hent transaction_id for å legge til i ticket_transaction
            cursor.execute("SELECT transaction_id FROM ticket_transaction ORDER BY transaction_id DESC LIMIT 1")
            transaction_id = cursor.fetchone()[0] + 1 # Generer ny transaction_id som er én høyere enn den høyeste eksisterende

            # Hent theater_play_id for å legge til i ticket_transaction
            # Antar at navnet er unikt og at vi kan bruke det til å finne theater_play_id
            cursor.execute("SELECT theater_play_id FROM theater_play WHERE name = ?", (name,))
            theater_play_id = cursor.fetchone()[0]

            cursor.execute("""
                INSERT INTO ticket_transaction (transaction_id, theater_play_id, customer_id, show_date, transaction_date, transaction_time) 
                VALUES (?, ?, ?, ?, ?, ?)
            """, (transaction_id, theater_play_id, 1, show_date, current_date, current_time))
            cursor.execute("""
                INSERT INTO ticket (show_date, theater_play_id, transaction_id, ticket_group_name, chair_number, chair_row, area) 
                VALUES (?, ?, ?, 'Voksen', ?, ?, ?)
            """, (show_date, theater_play_id, transaction_id, chair_number, chair_row, area))
            cursor.execute("""
                UPDATE chair SET is_available = 0 WHERE chair_row = ? AND chair_number = ? AND area = ?
            """, (chair_row, chair_number, area))
            cursor.execute("""
                SELECT price
                FROM ticket_group
                WHERE ticket_group_name = 'Ordinary' AND theater_play_id = ?
            """, (theater_play_id,))
            price = cursor.fetchone()[0]*9

                           
            conn.commit()

        print("Billetter kjøpt for stoler:", chairs, "Totalpris:", price, "kr.")
    else:
        print("Ingen rader med 9 eller flere ledige stoler.")

    conn.close()

def generer_transaction_id():
    # Implementer logikk for å generere en unik transaction_id
    pass

# Eksempel på bruk
kjop_billetter('../database/theater.db', "Kongsemnene",  '2024-02-03')
