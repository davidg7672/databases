
import psycopg as pg
import config

def main():
    # connection info
    hst = config.HOST
    usr = config.USER
    pwd = config.PASSWORD
    dat = config.DATABASE

    # make a connection
    with pg.connect(host=hst, user=usr, password=pwd, dbname=dat) as cn:
        # get a category from the user
        user_input_1 = input('Please enter a pet type (dog, cat, etc): ')
        user_input_2 = input('Please enter a pet name keyword: ') 

        # result set
        with cn.cursor() as rs:
            # parameterized query (must use old python format strings)
            q = ('SELECT id, name, type '
                 'FROM pet '
                 'WHERE type = %s AND strpos(name, %s) != 0')

            # execute the query (note, second param must be tuple)
            rs.execute(q, (user_input_1, user_input_2))
        
            # display results
            for row in rs:
                print(f'{row[0]}, {row[1]}, {row[2]}') 
            
        
if __name__ == '__main__':
    main()
