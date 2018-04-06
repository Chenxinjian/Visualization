package utility;
import java.io.IOException;
import java.sql.*;
import java.util.Properties;

public class DBUtility {

    private static Properties properties = new Properties();

    static {
        try {
            properties.load(DBUtility.class.getClassLoader().getResourceAsStream("db.properties"));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public Connection getConn() {
        String url = properties.getProperty("url");
        String user = properties.getProperty("user");
        String password = properties.getProperty("password");
        Connection conn = null;
        try {
            Class.forName(properties.getProperty("driver"));
            conn = DriverManager.getConnection(url, user, password);

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return conn;
    }

    public static void release(Connection connection, Statement statement, ResultSet resultSet) {
        if(resultSet!=null)
        {
            try
            {
                resultSet.close();
            }
            catch (SQLException e)
            {
                e.printStackTrace();
            }
        }

        if(statement!=null)
        {
            try
            {
                statement.close();
            }
            catch (SQLException e)
            {
                e.printStackTrace();
            }
        }

        if(connection!=null)
        {
            try
            {
                connection.close();
            }
            catch (SQLException e)
            {
                e.printStackTrace();
            }
        }


    }
}
