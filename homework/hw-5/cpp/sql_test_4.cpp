
#include <iostream>
#include <pqxx/pqxx>
#include "config.h"

using namespace std;
using namespace pqxx;

int main()
{
  try {
    // connection info
    string usr = config::USER;
    string pwd = config::PASSWORD;
    string hst = config::HOST;
    string dat = config::DATABASE;
    string url = "postgresql://" + usr + ":" + pwd + "@" + hst + "/" + dat;
    
    // create a connection
    connection cx{url};
    work tx(cx);

    // get a pet id, make sure it is valid
    cout << "Please enter a pet id: ";
    int id;
    cin >> id;
    cin.ignore();
    string q = "SELECT * FROM pet WHERE id = $1";
    cx.prepare("q1", q);
    result r{tx.exec_prepared("q1", id)};
    if (r.empty()) {
      cout << "This pet id is invalid" << endl;
      return 1;
    }

    q = "DELETE FROM pet WHERE id = $1";
    cx.prepare("d1", q);
    tx.exec_prepared("d1", id);

    // needed here to make the insert (database update) stick!
    tx.commit();

    cout << "Pet id " << id << " has been removed from the database" << endl;

  }    
  catch (sql_error const &e) {
    cerr << "SQL error: " << e.what() << endl;
    return 1;
  }
  catch (exception const &e) {
    cerr << "Error: " << e.what() << endl;
    return 1;
  }
  
}
