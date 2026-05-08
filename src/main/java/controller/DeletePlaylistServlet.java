package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.*;
import java.sql.*;
import dao.DBConnection;

@WebServlet("/DeletePlaylistServlet")
public class DeletePlaylistServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int playlistId = Integer.parseInt(request.getParameter("playlist_id"));

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps1 = con.prepareStatement(
                "DELETE FROM playlist_songs WHERE playlist_id=?");
            ps1.setInt(1, playlistId);
            ps1.executeUpdate();

            PreparedStatement ps2 = con.prepareStatement(
                "DELETE FROM playlist WHERE id=?");
            ps2.setInt(1, playlistId);
            ps2.executeUpdate();

            con.close();

            response.sendRedirect("jsp/dashboard.jsp?show=playlists");

        } catch(Exception e){
            e.printStackTrace();
        }
    }
}