
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
    
    // get a category from the user
    string user_input_1;
    string user_input_2;
    cout << "Please enter a pet type (dog, cat, etc): ";
    cin >> user_input_1;
    cout << "Please enter an appearance keyword: ";
    cin >> user_input_2;
    
    // create a (named) prepared statement
    string q =
      "SELECT id, name, type "
      "FROM pet "
      "WHERE type = $1 AND strpos(name, $2) != 0";
    cx.prepare("q1", q);          // can give the query a name
    result r{tx.exec_prepared("q1", user_input_1, user_input_2)};
    
    // print result
    for (auto row: r) {
      cout << row["id"].as<int>() << ", "
           << row["name"].c_str() << ", "
           << row["type"].c_str() << endl;
    }

    // not needed here, but good habit if updates
    tx.commit();
  }
  catch(sql_error const &e) {
    cerr << "SQL error: " << e.what() << endl;
    return 1;
  }
  catch(exception const &e) {
    cerr << "Error: " << e.what() << endl;
    return 1;
  }
}
