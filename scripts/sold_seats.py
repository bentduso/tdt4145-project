import sqlite3
from datetime import datetime
conn = sqlite3.connect('db.sqlite3')
cursor = conn.cursor()
transaction_id = 1  
def process_sold_seats(file_path, hall_id, theater_play_id):
    global transaction_id
    with open(file_path, 'r') as file:
        lines = file.readlines()
    
    show_date = '0000-00-00'
    for line in lines:
        if "Dato" in line:
            words = line.split()
            for word in words:
                if len(word) == 10 and word[4] == "-" and word[7] == "-":
                    show_date = word
                    break
        

    current_area = ""
    current_row = 0
    current_date = datetime.now().strftime("%Y-%m-%d")
    current_time = datetime.now().strftime("%H:%M:%S")
    for line in lines[1:]:  # Hopper over dato
        line = line.strip()
        if line in ["Galleri", "Balkong", "Parkett"]:
            current_area = line
            current_row = 0
        elif line:
            current_row += 1
            for chair_number, seat in enumerate(line, start=1):
               if seat in ['1', '0']:
                    is_available = 1 if seat == '0' else 0

                    cursor.execute("SELECT * FROM chair WHERE hall_id = ? AND area = ? AND chair_row = ? AND chair_number = ?", (hall_id, current_area, current_row, chair_number))
                    result = cursor.fetchone()
                    if result:
                        cursor.execute("UPDATE chair SET is_available = ? WHERE hall_id = ? AND area = ? AND chair_row = ? AND chair_number = ?", (is_available, hall_id, current_area, current_row, chair_number))
                    else:
                        cursor.execute("INSERT INTO chair (hall_id, area, chair_row, chair_number, is_available) VALUES (?, ?, ?, ?, ?)", (hall_id, current_area, current_row, chair_number, is_available))
                    conn.commit()

                    if seat == '1':
                        cursor.execute("INSERT INTO ticket (show_date, theater_play_id, transaction_id, ticket_group_name, chair_number, chair_row, area) VALUES (?, ?, ?, 'Voksen', ?, ?, ?)", (show_date, theater_play_id, transaction_id, chair_number, current_row, current_area))
                        conn.commit()
                        cursor.execute("INSERT INTO ticket_transaction (transaction_id, theater_play_id, customer_id, show_date, transaction_date, transaction_time) VALUES (?, ?, ?, ?, ?, ?)", (transaction_id, theater_play_id, 1, show_date, current_date, current_time))
                        conn.commit()
                        transaction_id += 1


    
process_sold_seats('../project/hovedscenen.txt', 1, 1)
process_sold_seats('../project/gamle-scene.txt', 2, 2)
conn.close()
