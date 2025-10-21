
import java.io.FileInputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.PreparedStatement;
import java.util.Properties;
import java.util.Scanner;


public class SQLTest4 {

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
      
      // get a pet id, make sure it is valid
      System.out.print("Please enter a pet id: ");
      Scanner reader = new Scanner(System.in);
      int id = Integer.parseInt(reader.nextLine());
      String q = "SELECT * FROM pet WHERE id = ?";
      PreparedStatement st = cn.prepareStatement(q);
      st.setInt(1, id);
      ResultSet rs = st.executeQuery();
      if (!rs.next()) {
        System.out.println("This pet id is invalid");
        rs.close();
        st.close();
        cn.close();
        System.exit(1);
      }
      rs.close();

      // create and execute a prepared statement 
      q = "DELETE FROM pet WHERE id = ?";
      st = cn.prepareStatement(q);
      st.setInt(1, id);
      st.execute();
      
      // print exit program message
      System.out.println("Pet " + id + " has been removed from the database!");
      
      // clean up
      reader.close();
      st.close();
      cn.close();
    }
    catch(Exception e) {
      e.printStackTrace();
    }
  }
  
}
