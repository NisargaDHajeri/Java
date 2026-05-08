package controller;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import dao.DBConnection;

@WebServlet("/AddToPlaylistServlet")
public class AddToPlaylistServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int songId = Integer.parseInt(request.getParameter("song_id"));
        int playlistId = Integer.parseInt(request.getParameter("playlist_id"));

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO playlist_songs(playlist_id, song_id) VALUES(?,?)"
            );

            ps.setInt(1, playlistId);
            ps.setInt(2, songId);
            ps.executeUpdate();

            response.sendRedirect("jsp/viewPlaylist.jsp?id=" + playlistId);

        } catch(Exception e) {
            e.printStackTrace();
        }
    }
}