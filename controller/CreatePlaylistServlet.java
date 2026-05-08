package controller;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import dao.DBConnection;

@WebServlet("/CreatePlaylistServlet")
public class CreatePlaylistServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO playlist(name) VALUES(?)"
            );

            ps.setString(1, name);
            ps.executeUpdate();

            response.sendRedirect("jsp/playlist.jsp");

        } catch(Exception e) {
            e.printStackTrace();
        }
    }
}