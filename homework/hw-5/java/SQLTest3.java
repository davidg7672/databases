
import java.io.FileInputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.PreparedStatement;
import java.util.Properties;
import java.util.Scanner;
import java.util.Date;
import java.text.SimpleDateFormat;


public class SQLTest3 {

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
      
      // get a pet id
      System.out.print("Please enter a pet id: ");
      Scanner reader = new Scanner(System.in);
      int id = Integer.parseInt(reader.nextLine());
      
      // make sure the pet id is unique
      String q = "SELECT * FROM pet WHERE id = ?";
      PreparedStatement st = cn.prepareStatement(q);
      st.setInt(1, id);
      ResultSet rs = st.executeQuery();
      if (rs.next()) {
        System.out.println("This pet id is already taken");
        rs.close();
        st.close();
        cn.close();
        System.exit(1);
      }
      rs.close();

      // get pet name, breed, type, bday, and size
      System.out.print("Please enter the pet's name: ");
      String name = reader.nextLine();
      System.out.print("Please enter the pet's type (dog, cat, etc): ");
      String type = reader.nextLine();
      System.out.print("Please enter the pet's birthdate ('MM/DD/YYYY'): ");
      Date bday = new SimpleDateFormat("MM/DD/YYYY").parse(reader.nextLine());
      
      // create and execute a prepared statement 
      q = "INSERT INTO pet VALUES (?,?,?,?)";
      st = cn.prepareStatement(q);
      st.setInt(1, id);
      st.setString(2, name);
      st.setString(3, type);
      st.setDate(4, new java.sql.Date(bday.getTime()));
      st.execute();
      
      // print a message
      System.out.println("Pet " + id + " was added to the database!");
      
      // release resources
      reader.close();
      st.close();
      cn.close();
    }
    catch(Exception e) {
      e.printStackTrace();
    }
  }
  
}
