import psycopg2
class Conexion:

    conn = 0
    cur = 0

    def connect(self):
        try:
            conn = psycopg2.connect("dbname='mamelines' user='mamelines' password='mame'")
        except:
            print "No se puede conectar"
            
    def consulta(sql):
        cur = conn.cursor()
        try:
            cur.execute(sql)
        except:
            print "no puedo hacer la consulta"
        rows = cur.fetchall()
        return rows
