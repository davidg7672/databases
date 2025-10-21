
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

        # check that id isn't already taken
        with cn.cursor() as rs:
            rs.execute(q, (pet_id,))
            if rs.fetchone(): 
                print('This pet id is already taken')
                rs.close()
                cn.close()
                return

        # get new pet info
        name = input("Please enter the pet's name: ")
        pet_type = input("Please enter the pet's type (dog, cat, etc): ")
        bday = input("Please enter the pet's birthdate ('YYYY/MM/DD'): ")

        # run update
        q = "INSERT INTO pet VALUES (%s, %s, %s, %s)"
        with cn.cursor() as rs:
            # execute the insert
            rs.execute(q, (pet_id, name, pet_type, bday))
            # make it stick!
            cn.commit()

        
if __name__ == '__main__':
    main()
