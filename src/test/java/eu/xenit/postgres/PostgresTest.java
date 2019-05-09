package eu.xenit.postgres;

import org.junit.Test;

import java.sql.*;
import static org.junit.Assert.*;

public class PostgresTest {

    private Connection getConnection() throws SQLException {
        String host = System.getProperty("postgresql.host");
        String port = System.getProperty("postgresql.tcp.5432");
        String connectionString = "jdbc:postgresql://"+host+":"+port+"/test";
        String user = "test";
        String password = "test";

        Connection connection = DriverManager.getConnection(connectionString, user, password);
        return connection;
    }

    @Test
    public void testConnection() throws SQLException {
        Connection connection = getConnection();
        Statement stm = connection.createStatement();
        stm.executeUpdate("CREATE TABLE IF NOT EXISTS test(id INT , name TEXT)");
        stm.executeUpdate("INSERT INTO test VALUES (12, 'hello')");
        ResultSet resultSet = stm.executeQuery("SELECT * FROM test");
        assertTrue(resultSet.next());
        assertTrue("Id is not correct", resultSet.getInt("id") == 12);
        assertEquals("hello", resultSet.getString("name"));
        assertFalse(resultSet.next());
        connection.close();
    }

    @Test
    public void testTableFunc() throws SQLException {
        Connection connection = getConnection();
        Statement stm = connection.createStatement();
        stm.executeUpdate("CREATE EXTENSION tablefunc");
        connection.close();
    }
}
