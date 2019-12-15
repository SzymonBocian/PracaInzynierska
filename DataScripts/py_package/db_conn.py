import psycopg2 as psy

def clean_result(lists):
    return [''.join(char for char in element if char not in '(),') for element in lists]

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

if __name__ == "__main__":

    conn_dict = { "user"     : "szymonbocian", \
                  "password" : "", \
                  "host"     : "localhost", \
                  "port"     : "5432", \
                  "database" : "dwh_call_center"
                }

    db = DbConn(conn_dict)

    query = "select * from pro.service_dim limit 1;"

    print(db.run_sql(query))