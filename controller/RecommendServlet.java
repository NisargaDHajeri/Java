package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import dao.DBConnection;

@WebServlet("/RecommendServlet")
public class RecommendServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String mood = request.getParameter("mood");

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM songs WHERE mood = ? LIMIT 5"
            );

            ps.setString(1, mood);

            ResultSet rs = ps.executeQuery();

            response.setContentType("text/html");

            while (rs.next()) {
                response.getWriter().println(
                    "<div style='margin:5px;padding:8px;background:#222;border-radius:10px'>" +
                    rs.getString("title") + " - " + rs.getString("artist") +
                    "</div>"
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}