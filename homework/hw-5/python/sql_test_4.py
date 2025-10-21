
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
        # get a pet id, make sure it is unique
        pet_id = int(input('Please enter a pet id: '))
        q = "SELECT * FROM pet WHERE id = %s"

        # check that the id exists
        with cn.cursor() as rs:
            rs.execute(q, (pet_id,))
            if not rs.fetchone(): 
                print('This pet id is invalid')
                rs.close()
                cn.close()
                return

        # execute the update
        q = "DELETE FROM pet WHERE id = %s"
        with cn.cursor() as rs:
            # make the change
            rs.execute(q, (pet_id,))
            # make it stick
            cn.commit()

        # print the exit message
        print('Pet id', pet_id, 'has been removed from the database')

    
if __name__ == '__main__':
    main()
