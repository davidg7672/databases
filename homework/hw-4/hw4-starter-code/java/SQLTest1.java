
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

public class SQLTest1 {

  public static void main(String[] args) {
    try {
      // connection info
      String url = "jdbc:postgresql://cps-postgresql.gonzaga.edu/";
      Properties props = new Properties();
      FileInputStream in = new FileInputStream("config.properties");
      props.load(in);
      in.close();
      
      // connect to the DBMS
      Connection cn = DriverManager.getConnection(url, props);

      // create a (non-prepared) statement
      Statement st = cn.createStatement();

      // execute a simple, non-parameterized query 
      String q = "SELECT id, name FROM pet ORDER BY name";
      ResultSet rs = st.executeQuery(q);
      
      // print results
      while(rs.next()) {
        int id = rs.getInt("id");
        String name = rs.getString("name");
        System.out.println(id + ", " + name);
      }

      // release resources
      rs.close();
      st.close();
      cn.close();
    }
    catch(Exception e) {
      e.printStackTrace();
    }
  }
  
}
