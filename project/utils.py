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
    return conn


def read_file_data(file_path):
    """
    Read and process the data from a file. Intended to be
    used with ".txt" files, specifically
    "hovedscenen.txt" and "gamlescenen.txt".

    :param file_path: The path to the file to read.
    :type file_path: str
    :return: A tuple containing the lines from the file and the extracted date.
    :rtype: tuple
    """
    with open(file_path, 'r') as file:
        file_lines = file.readlines()

    show_date = '0000-00-00'
    for line in file_lines:
        if "Dato" in line:
            words = line.split()
            for word in words:
                if len(word) == 10 and word[4] == "-" and word[7] == "-":
                    show_date = word
                    break
    return file_lines, show_date


def execute_query(conn, query, params):
    """
    Execute a database query using the given connection object.

    :param conn: The database connection object.
    :param query: The SQL query to be executed.
    :param params: Optional parameters to be passed to the query (as a tuple).

    :return: None
    """
    cursor = conn.cursor()
    cursor.execute(query, params)
    conn.commit()
