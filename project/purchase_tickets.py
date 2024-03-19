from datetime import datetime

from utils import create_connection


def buy_tickets(conn, name, show_date):
    cursor = conn.cursor()
    current_date = datetime.now().strftime("%Y-%m-%d")
    current_time = datetime.now().strftime("%H:%M:%S")
    global total_price    
    cursor.execute(
        """
        SELECT chair_row, area
        FROM chair
                INNER JOIN theater_play ON chair.hall_id = theater_play.hall_id
                INNER JOIN show ON theater_play.theater_play_id = show.theater_play_id
        WHERE is_available = 1
            AND theater_play.name = ?
            AND show.show_date = ?
        GROUP BY area, chair_row
        HAVING COUNT(*) >= 9
        LIMIT 1
        """,
        (name, show_date))
    row = cursor.fetchone()

    if row:
        chair_row = row[0]
        cursor.execute(
            """
            SELECT chair_number, area, chair_row
            FROM chair
            WHERE is_available = 1 AND chair_row = ? AND area = ?
            LIMIT 9
            """,
            (chair_row, row[1]))
        chairs = cursor.fetchall()
        for chair in chairs:
            create_seat_transaction(cursor, chair, chair_row, name, show_date, current_date, current_time)
        
        print("Tickets bought for chairs:", chairs, "Total price:", total_price, "NOK")
    else:
        print("There are no rows with 9 or more available chairs.")
    conn.close()

    return True


def create_seat_transaction(cursor, chair, chair_row, name, show_date, current_date, current_time):
    chair_number = chair[0]
    area = chair[1]
    global total_price
    cursor.execute(
        """
        SELECT transaction_id
        FROM ticket_transaction
        ORDER BY transaction_id
                DESC
        LIMIT 1
        """)
    transaction_id = cursor.fetchone()[0] + 1

    cursor.execute(
        """
        SELECT theater_play_id
        FROM theater_play
        WHERE name = ?
        """,
        (name,))
    theater_play_id = cursor.fetchone()[0]

    cursor.execute(
        """
        INSERT INTO ticket_transaction (transaction_id, theater_play_id, customer_id, show_date, transaction_date,
                                        transaction_time)
        VALUES (?, ?, ?, ?, ?, ?)
        """,
        (transaction_id, theater_play_id, 1, show_date, current_date, current_time))

    cursor.execute(
        """
        INSERT INTO ticket (show_date, theater_play_id, transaction_id, ticket_group_name, chair_number, chair_row,
                            area) 
        VALUES (?, ?, ?, 'Voksen', ?, ?, ?)
        """,
        (show_date, theater_play_id, transaction_id, chair_number, chair_row, area))

    cursor.execute(
        """
        UPDATE chair
        SET is_available = 0
        WHERE chair_row = ?
            AND chair_number = ?
            AND area = ?
        """,
        (chair_row, chair_number, area))
    
    cursor.execute(
        """
        SELECT price
        FROM ticket_group
        WHERE ticket_group_name = "Ordinary" AND theater_play_id = ?
        GROUP BY ticket_group_name
        """,
        (theater_play_id,))
    total_price += cursor.fetchone()[0]

    cursor.connection.commit()

def main():
    conn = create_connection('../database/theater.db')

    if conn is not None:
        buy_tickets(conn, 'Størst av alt er kjærligheten', '2024-02-03')
        
        conn.close()
    else:
        print('Error! Cannot establish a database connection.')

if __name__ == '__main__':
    total_price = 0
    main()
    