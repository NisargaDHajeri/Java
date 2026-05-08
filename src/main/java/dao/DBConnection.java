package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    public static Connection getConnection() {

        Connection con = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/music_player",
                "root",
                "Mysql@123" // 🔴 change this
            );

        } catch (Exception e) {
            e.printStackTrace();
        }

        return con;
    }

public static void main(String[] args) {

    Connection con = DBConnection.getConnection();

    if(con != null) {
        System.out.println("✅ Database Connected Successfully!");
    } else {
        System.out.println("❌ Connection Failed!");
    }
}
}