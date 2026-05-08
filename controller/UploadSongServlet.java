package controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import dao.DBConnection;

@WebServlet("/UploadSongServlet")

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,   // 2MB
    maxFileSize = 1024 * 1024 * 10,        // 10MB
    maxRequestSize = 1024 * 1024 * 50      // 50MB
)
public class UploadSongServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ✅ GET FORM DATA
        String title = request.getParameter("title");
        String artist = request.getParameter("artist");
        String mood = request.getParameter("mood");

        // 🎵 AUDIO FILE
        Part filePart = request.getPart("file");
        String fileName = Paths.get(filePart.getSubmittedFileName())
                               .getFileName()
                               .toString();

        // 🔥 Prevent overwrite (IMPORTANT)
        fileName = System.currentTimeMillis() + "_" + fileName;

        // 🖼 COVER IMAGE
        Part coverPart = request.getPart("cover");
        String coverName = null;

        if (coverPart != null && coverPart.getSize() > 0) {
            coverName = Paths.get(coverPart.getSubmittedFileName())
                             .getFileName()
                             .toString();

            coverName = System.currentTimeMillis() + "_" + coverName;
        }

        // 📁 SONGS FOLDER (FIXED PATH)
        String songPath = getServletContext().getRealPath("/songs");
        File songDir = new File(songPath);
        if (!songDir.exists()) songDir.mkdirs();

        // SAVE AUDIO FILE
        filePart.write(songPath + File.separator + fileName);

        // 📁 COVER FOLDER (FIXED PATH)
        String coverPath = getServletContext().getRealPath("/covers");
        File coverDir = new File(coverPath);
        if (!coverDir.exists()) coverDir.mkdirs();

        String dbCoverPath = null;

        // SAVE COVER FILE
        if (coverName != null) {
            coverPart.write(coverPath + File.separator + coverName);
            dbCoverPath = "covers/" + coverName;
        }

        // DB FILE PATH
        String dbFilePath = "songs/" + fileName;

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO songs(title, artist, file_path, mood, cover_path) VALUES (?, ?, ?, ?, ?)"
            );

            ps.setString(1, title);
            ps.setString(2, artist);
            ps.setString(3, dbFilePath);
            ps.setString(4, mood);
            ps.setString(5, dbCoverPath);

            ps.executeUpdate();

            // ✅ SUCCESS REDIRECT
            response.sendRedirect("jsp/dashboard.jsp?uploaded=true");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}