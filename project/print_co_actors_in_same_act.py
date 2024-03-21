import sys

from utils import create_connection, list_to_string


def print_co_actors_in_same_act(performer_name):
    conn = create_connection('database/theater.db')

    if conn is None:
        print("Error! Cannot create a connection to database.")

    cursor = conn.cursor()

    cursor.execute(
        """
        SELECT *
        FROM performer
        WHERE name = ?
        """,
        (performer_name,))
    performer = cursor.fetchone()

    if performer is None:
        print(f"No performer named {performer_name} found in the database.")
        return

    cursor.execute(
        """
        SELECT DISTINCT p1.name AS actor,
                        p2.name AS collaborate,
                        tp.name AS play_name
        FROM plays_act pa1
                INNER JOIN plays_act pa2
                           ON pa1.theater_play_id = pa2.theater_play_id
                               AND pa1.act_number = pa2.act_number
                               AND pa1.role_id != pa2.role_id
                INNER JOIN theater_play tp
                           ON tp.theater_play_id = pa1.theater_play_id
                INNER JOIN played_by pb1
                           ON pb1.role_id = pa1.role_id
                INNER JOIN played_by pb2
                           ON pb2.role_id = pa2.role_id
                INNER JOIN performer p1
                           ON p1.performer_id = pb1.performer_id
                INNER JOIN performer p2 
                           ON p2.performer_id = pb2.performer_id
        WHERE p1.name = ?
            AND p2.name != ?
        """,
        (performer_name, performer_name))

    rows = cursor.fetchall()

    co_actors = set()
    plays = set()

    for row in rows:
        co_actors.add(row[1])
        plays.add(row[2])

    if len(co_actors) == 0:
        print(f"The actor {performer_name} has not played in any common acts with other actors.")
    else:
        co_actors_list = "\n* ".join(sorted(list(co_actors)))
        plays_str = list_to_string(list(plays))
        print(f"The actor {performer_name} has played in the same act(s) as the other actors:\n\n"
              f"* {co_actors_list}"
              f"\n\nin {plays_str}.")

    conn.close()


if __name__ == '__main__':
    if len(sys.argv) == 2:
        print_co_actors_in_same_act(sys.argv[1])
    else:
        print("Please provide the name of a performer as an argument.")
