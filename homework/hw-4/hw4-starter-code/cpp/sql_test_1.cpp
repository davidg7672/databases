
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
    work tx{cx};

    // execute a query
    string q = "SELECT id, name FROM pet ORDER BY name";
    result r{tx.exec(q)};
    for (auto row: r) {
      cout << row["id"].as<int>() << ", " << row["name"].c_str() << endl;
    }

    // not needed here, but good habit if updates
    tx.commit();
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
