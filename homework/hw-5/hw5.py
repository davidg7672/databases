"""
 * 
 *  NAME:    David Sosa
 *  ASSIGN:  HW-5
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    Dynamic SQL demonstrated with Python.
 *           CRUD, functions supported via database
"""

import psycopg as pg
import config

"""
Function: list_countries()
Description: Queries database and prints out all countries
"""
def list_countries(cn):
    q = 'SELECT * FROM country;'
    with cn.cursor() as rs:
        rs.execute(q)
        print()
        for row in rs:
            print(f'{row[1]} ({row[0]}), per capita gdp ${row[2]}, inflation rate {row[3]}%')
        print()
        rs.close()

"""
Function: add_country()
Description: Prompts user for country details and inserts new country into database
"""
def add_country(cn):
    country_code = input("Country code..................: ").upper()
    country_name = input("Country name..................: ")
    country_gdp = int(input("Country per capita gdp (USD)..: "))
    country_inflation = float(input("Country inflation (pct).......: "))
    
    q1 = 'SELECT * FROM country WHERE country_code = %s'
    q2 = 'INSERT INTO country VALUES (%s, %s, %s, %s);'
    
    with cn.cursor() as rs:
        rs.execute(q1, (country_code,))
        country = rs.fetchone()
        
        if country:
            print("Country already in DB!\n")
            rs.close()
            return
        
        rs.execute(q2, (country_code, country_name, country_gdp, country_inflation))
        cn.commit()
        print("Successfully Added Country\n")
        rs.close()

"""
Function: add_border()
Description: Prompts user for two country codes and border length, then adds border to database
"""
def add_border(cn):
    country_code_1 = input("Country code 1..: ").upper()
    country_code_2 = input("Country code 2..: ").upper()
    border_length = int(input("Border length...: "))
    
    # Check if border already exists (in either direction)
    q1 = 'SELECT * FROM border WHERE (country_code_1 = %s AND country_code_2 = %s) OR (country_code_1 = %s AND country_code_2 = %s)'
    # Check if both countries exist
    q2 = 'SELECT * FROM country WHERE country_code = %s'
    q3 = 'INSERT INTO border VALUES (%s, %s, %s);'
    
    with cn.cursor() as rs:
        # Check if border already exists
        rs.execute(q1, (country_code_1, country_code_2, country_code_2, country_code_1))
        if rs.fetchone():
            print("Border already exists!\n")
            rs.close()
            return
        
        # Check if both countries exist
        rs.execute(q2, (country_code_1,))
        if not rs.fetchone():
            print(f"Country {country_code_1} does not exist!\n")
            rs.close()
            return
        
        rs.execute(q2, (country_code_2,))
        if not rs.fetchone():
            print(f"Country {country_code_2} does not exist!\n")
            rs.close()
            return
        
        rs.execute(q3, (country_code_1, country_code_2, border_length))
        cn.commit()
        print("Successfully Added Border\n")
        rs.close()


"""
Function: find_countries()
Description: Searches and displays countries within specified GDP and inflation ranges
"""
def find_countries(cn):
    min_gdp = int(input("Minimum per capita gdp (USD)..: "))
    max_gdp = int(input("Maximum per capita gdp (USD)..: "))
    min_inflation = float(input("Minimum inflation (pct).......: "))
    max_inflation = float(input("Maximum inflation (pct).......: "))
    
    q = 'SELECT * FROM country c WHERE (c.gdp >= %s AND c.gdp <= %s) AND (c.inflation >= %s AND c.inflation <= %s) ORDER BY c.gdp DESC, c.inflation ASC'
    with cn.cursor() as rs:
        rs.execute(q, (min_gdp, max_gdp, min_inflation, max_inflation))
        results = rs.fetchall()
        
        # checking if there are any results
        if not results:
            print("No countries found matching those criteria.\n")
        else:
            print()
            for row in results:
                print(f"{row[1]} {row[0]}, per capita gdp ${row[2]}, inflation rate {row[3]}%")
            print()
        rs.close()

"""
Function: update_country()
Description: Updates a country's GDP and inflation values in database
"""
def update_country(cn):
    country_code = input("Country code..................: ").upper()
    country_gdp = int(input("Country per capita gdp (USD)..: "))
    country_inflation = float(input("Country inflation (pct).......: "))
    
    q1 = 'SELECT * FROM country WHERE country_code = %s'
    q2 = 'UPDATE country SET gdp = %s, inflation = %s WHERE country_code = %s'
    
    with cn.cursor() as rs:
        rs.execute(q1, (country_code,))
        country = rs.fetchone()
        
        # checking if country exists
        if not country:
            print("Country does not exist!\n")
            rs.close()
            return
        
        rs.execute(q2, (country_gdp, country_inflation, country_code))
        cn.commit()
        print("Successfully Updated Country\n")
        rs.close()

"""
Function: remove_border()
Description: Removes a border between two countries from database
"""
def remove_border(cn):
    country_code_1 = input("Country code 1..: ").upper()
    country_code_2 = input("Country code 2..: ").upper()
    
    q1 = 'SELECT * FROM border WHERE (country_code_1 = %s AND country_code_2 = %s) OR (country_code_1 = %s AND country_code_2 = %s)'
    q2 = 'DELETE FROM border WHERE (country_code_1 = %s AND country_code_2 = %s) OR (country_code_1 = %s AND country_code_2 = %s)'
    
    with cn.cursor() as rs:
        rs.execute(q1, (country_code_1, country_code_2, country_code_2, country_code_1))
        border = rs.fetchone()
        
        # if nothing is there, we can't delete it
        # therefore, we say it doesn't exist.
        if not border:
            print("Border doesn't exist!\n")
            rs.close()
            return
        
        rs.execute(q2, (country_code_1, country_code_2, country_code_2, country_code_1))
        cn.commit()
        print("Successfully Removed Border\n")
        rs.close()

"""
Function: print_menu()
Description: Displays menu options and returns user's choice
"""
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
    
    print()
    for i, item in enumerate(menu, start=1):
        print(f"{i}. {item}")
    
    return input("\nEnter your choice (1-7): ")

"""
Function: connect_db()
Description: Establishes and returns connection to PostgreSQL database using config settings
"""
def connect_db():
    hst=config.HOST
    usr=config.USER
    pwd=config.PASSWORD
    dat=config.DATABASE
    
    return pg.connect(host=hst, user=usr, password=pwd, dbname=dat)

"""
Function: main()
Description: Main program loop that connects to database and processes user menu choices
"""
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
