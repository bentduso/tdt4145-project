import sqlite3
def process_hovedscenen(file_path, hall_id, theater_play_id):
    conn = sqlite3.connect('db.sqlite3')
    cursor = conn.cursor()
    with open(file_path, 'r') as file:
        lines = file.readlines()

    show_date = '0000-00-00'
    if "Dato" in lines:
            words = lines.split()
            for word in words:
                if len(word) == 10 and word[4] == "-" and word[7] == "-":
                    show_date =  word

    current_row = 0
    current_area = ""
    transaction_id = 1  

    for line in lines[1:]:  # Hopper over dato
        line = line.strip()
        if line in ["Galleri", "Parkett"]:
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
                        transaction_id += 1
    conn.close()

process_hovedscenen('../project/hovedscenen.txt', 1, 1)

