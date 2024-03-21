from utils import create_connection
import sys

def sold_tickets_date(date):
    conn = create_connection('database/theater.db')
    cursor = conn.cursor()

    query = """
        SELECT tp.name AS performance_name, 
            COUNT(t.ticket_id) AS sold_tickets
        FROM theater_play tp
        LEFT JOIN show s
            ON tp.theater_play_id = s.theater_play_id
        LEFT JOIN ticket_transaction tt
            ON s.show_date = tt.show_date AND tp.theater_play_id = tt.theater_play_id
        LEFT JOIN ticket t
            ON tt.transaction_id = t.transaction_id
        WHERE s.show_date = ?
        GROUP BY tp.theater_play_id, tp.name
    """

    cursor.execute(query, (date,))

    results = cursor.fetchall()

    if len(results) == 0:
        print("Ingen solgte billetter for den angitte datoen.")
    else:
        for row in results:
            performance_name, sold_tickets = row
            print(f"Stykke: {performance_name}, Antall solgte billetter: {sold_tickets} stk.")

    conn.close()

if __name__ == "__main__":
    if len(sys.argv) == 2:
        sold_tickets_date(sys.argv[1])
    else:
        print("Feil i format, forventer (YYYY-MM-DD) som argument.")