package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.DBConnection;

@WebServlet("/RemoveFromPlaylistServlet")
public class RemoveFromPlaylistServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int songId = Integer.parseInt(request.getParameter("song_id"));
        int playlistId = Integer.parseInt(request.getParameter("playlist_id"));

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps = con.prepareStatement(
                "DELETE FROM playlist_songs WHERE song_id=? AND playlist_id=?"
            );

            ps.setInt(1, songId);
            ps.setInt(2, playlistId);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        // redirect back to same playlist
        response.sendRedirect("viewPlaylist.jsp?id=" + playlistId);
    }
}