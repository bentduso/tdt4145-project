from datetime import datetime

from utils import create_connection, read_file_data, execute_query


def handle_seat_availability(conn, hall_id, current_area, current_row, chair_number, seat):
    is_available = 1 if seat == '0' else 0
    cursor = conn.cursor()
    cursor.execute(
        """
        SELECT *
        FROM chair
        WHERE hall_id = ?
            AND area = ?
            AND chair_row = ?
            AND chair_number = ?
        """,
        (hall_id, current_area, current_row, chair_number))
    result = cursor.fetchone()
    if result:
        execute_query(
            conn,
            """
            UPDATE chair
            SET is_available = ?
            WHERE hall_id = ?
                AND area = ?
                AND chair_row = ?
                AND chair_number = ?
            """,
            (is_available, hall_id, current_area, current_row, chair_number))
    else:
        execute_query(
            conn,
            """
            INSERT INTO chair (hall_id, area, chair_row, chair_number, is_available)
            VALUES (?, ?, ?, ?, ?)
            """,
            (hall_id, current_area, current_row, chair_number, is_available))


def handle_ticket_and_transaction(conn, show_date, theater_play_id, transaction_id, chair_number, current_row,
                                  current_area, current_date, current_time):
    execute_query(
        conn,
        """
        INSERT INTO ticket (show_date, theater_play_id, transaction_id, ticket_group_name,
                            chair_number, chair_row, area)
        VALUES (?, ?, ?, 'Ordinary', ?, ?, ?)
        """,
        (show_date, theater_play_id, transaction_id, chair_number, current_row, current_area))

    execute_query(
        conn,
        """
        INSERT INTO ticket_transaction (transaction_id, theater_play_id, customer_id, show_date,
                                        transaction_date, transaction_time)
        VALUES (?, ?, ?, ?, ?, ?)
        """,
        (transaction_id, theater_play_id, 1, show_date, current_date, current_time))


def process_sold_seats(conn, file_path, hall_id, theater_play_id):
    global transaction_id
    file_lines, show_date = read_file_data(file_path)
    current_area = ""
    current_row = 0
    current_date = datetime.now().strftime("%Y-%m-%d")
    current_time = datetime.now().strftime("%H:%M:%S")

    for line in file_lines[1:]:
        line = line.strip()
        if line in ["Galleri", "Balkong", "Parkett"]:
            current_area = line
            current_row = 0
        elif line:
            current_row += 1
            for chair_number, seat in enumerate(line, start=1):
                handle_seat_availability(conn, hall_id, current_area, current_row, chair_number, seat)
                if seat == '1':
                    handle_ticket_and_transaction(conn, show_date, theater_play_id, transaction_id, chair_number,
                                                  current_row, current_area, current_date, current_time)
                    transaction_id += 1

def main():
    conn = create_connection('database/theater.db')

    if conn is not None:
        process_sold_seats(conn, 'data/hovedscenen.txt', 1, 1)
        process_sold_seats(conn, 'data/gamlescenen.txt', 2, 2)
        conn.close()
    else:
        print('Error! Cannot establish a database connection.')


if __name__ == '__main__':
    transaction_id = 1
    main()
