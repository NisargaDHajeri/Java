package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import dao.DBConnection;

@WebServlet("/DeleteSongServlet")
public class DeleteSongServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("DELETE FROM songs WHERE id=?");
            ps.setInt(1, id);
            ps.executeUpdate();

            response.sendRedirect("jsp/dashboard.jsp?deleted=true");

        } catch(Exception e) {
            e.printStackTrace();
        }
    }
}