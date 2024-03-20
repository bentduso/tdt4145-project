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


def list_to_string(lst):
    """
    Converts a list to a string representation.
    Each element in the list is separated using a comma and
    the word 'and' is used before the last element.

    :param lst: The list to be converted to a string.
    :return: The string representation of the list.
    """
    if len(lst) == 0:
        return ""
    elif len(lst) == 1:
        return lst[0]
    else:
        return ', '.join(lst[:-1]) + " and " + lst[-1]
