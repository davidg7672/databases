import psycopg as pg
import config

def list_countries(cn):
    q = 'SELECT * FROM countries;'
    with cn.cursor() as rs:
        rs.execute(q)
        rs.close()

def add_country(cn):
    pass

def add_border(cn):
    pass

def find_countries(cn):
    pass

def update_country(cn):
    pass

def remove_border(cn):
    pass

def print_menu():
    menu = [
        "List countries",
        "Add country",
        "Add border",
        "Find countries based on gdp and inflation",
        "Update country's gdp and inflation",
        "Remove Border",
        "Exit"
    ]

    for i, item in enumerate(menu, start=1):
        print(f"{i}. {item}")
    
    return input("Enter your choice (1-7): ")

def connect_db():
    hst=config.HOST
    usr=config.USER
    pwd=config.PASSWORD
    dat=config.DATABASE
    
    return pg.connect(host=hst, user=usr, password=pwd, dbname=dat)

def main():
    # establishing a connection
    cn = connect_db()
    
    while True:
        choice_str = print_menu()

        # not a number
        if not choice_str.isnumeric():
            print("❌ Please enter a number between 1 and 7.\n")
            continue

        choice = int(choice_str)

        match choice:
            case 1:
                list_countries(cn)
            case 2:
                add_country(cn)
            case 3:
                add_border(cn)
            case 4:
                find_countries(cn)
            case 5:
                update_country(cn)
            case 6:
                remove_border(cn)
            case 7:
                cn.close()
                break
            case _:
                print("❌ Invalid choice. Please try again.\n")

if __name__ == "__main__":
    main()
