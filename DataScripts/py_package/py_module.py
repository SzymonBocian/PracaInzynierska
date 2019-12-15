#-*- coding: utf-8 -*-

import psycopg2 as psy
import os

"""
    Data Scripts module
"""

"""
    Common parameters and connection setup
"""

class DbConn:
    "PostgresSQL connection parameters and methods to connect to database"

    __slots__ = ["user", "password", "host", "port", "database"]


    # def __init__(self, user, password, host, port, database):
    #     "Setup base connection parameters"

        # self.user = user
        # self.password = password
        # self.host = host
        # self.port = port
        # self.database = database

    def __init__(self, dict):

        self.user     = dict["user"]
        self.password = dict["password"]
        self.host     = dict["host"]
        self.port     = dict["port"]
        self.database = dict["database"]


    def run_sql(self, query):

        try:
            connection = psy.connect( user     = self.user,
                                      password = self.password,
                                      host     = self.host,
                                      port     = self.port,
                                      database = self.database)

            cursor = connection.cursor()

            cursor.execute(query)
            column_list = cursor.fetchall()
            
            return column_list

        except (Exception, psy.Error) as error :
            print ("Error while connecting to PostgreSQL", error)
        finally:
                if(connection):
                    cursor.close()
                    connection.close()


class PathMaker:
    """
    Create path to file, validate if path exists.
    """

    __slots__ = ["main_path"]

    def __init__(self, main_path):

        self.main_path = main_path


    def create_path(self, dir_path, file_name):

        if file_name is None:
            path = os.path.join(os.path.expanduser("~"), self.main_path, dir_path)
        else:
            path = os.path.join(os.path.expanduser("~"), self.main_path, dir_path, file_name)
        return path


    def is_path_not_correct(self, path):
    
        return not(os.path.exists(path))

    
    def is_path_correct(self, path):
    
        return os.path.exists(path)


if __name__ == "__main__":

    # print(";".join(["%s = %s" % (k, v) for k, v in connection_dict.items()]))
    
    conn_dict = { "user" : "szymonbocian", \
                    "password" : "", \
                    "host" : "localhost", \
                    "port" : "5432", \
                    "database" : "dwh_call_center"
                  }

    # a = DbConn( conn_dict["user"], conn_dict["password"], conn_dict["host"], conn_dict["port"], conn_dict["database"] )

    a = DbConn(conn_dict)

    print(a.run_sql("select * from stg.client_dim;"))

    b = PathMaker("Documents/CallCenterStaffing")

    # c = b.create_path("Input", "consultant_work_calendar_fact.csv")
    c = b.create_path("Arch/calendar",None)
    print(c)


    