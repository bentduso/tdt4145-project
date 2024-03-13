import sqlite3
from sqlite3 import Error


def create_connection(database_filepath):
    """
    Create an SQLite connection to the specified database file.

    :param database_filepath: The file path of the database.
    :return: The connection object or None if an error occurs.
    """
    conn = None
    try:
        conn = sqlite3.connect(database_filepath)
    except Error as e:
        print(e)
    finally:
        if conn:
            conn.close()

    return conn
