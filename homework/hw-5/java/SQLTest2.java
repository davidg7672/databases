
import java.io.FileInputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.PreparedStatement;
import java.util.Properties;
import java.util.Scanner;


public class SQLTest2 {

  public static void main(String[] args) {
    try {
      // connection info
      Properties props = new Properties();
      FileInputStream in = new FileInputStream("config.properties");
      props.load(in);
      in.close();
      
      // connect to the DBMS
      String url = "jdbc:postgresql://" + props.get("host") + "/" + props.get("database");
      Connection cn = DriverManager.getConnection(url, props);
      
      // get a category from the user
      System.out.print("Please enter a pet type (dog, cat, etc): ");
      Scanner reader = new Scanner(System.in);
      String userInput1 = reader.nextLine();
      System.out.print("Please enter a pet name keyword: ");
      String userInput2 = reader.nextLine();
      reader.close();
      
      // create and execute query
      String q = """
        SELECT id, name, type 
        FROM pet 
        WHERE type = ? AND strpos(name, ?) != 0
        """;
      PreparedStatement st = cn.prepareStatement(q);
      st.setString(1, userInput1);
      st.setString(2, userInput2);

      // uncomment to see the generated prepared statement:
      // System.out.println("\nPrepared Statement: " + st.toString());

      ResultSet rs = st.executeQuery();
      
      // print results
      while(rs.next()) {
        int id = rs.getInt("id");
        String name = rs.getString("name");
        String type = rs.getString("type");
        System.out.println(id + ", " + name + ", " + type);
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
