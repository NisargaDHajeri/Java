<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, dao.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
    <title>Playlist Songs</title>
    <link rel="stylesheet" href="../css/dashboard.css">
</head>
<body>

<div class="main">

<!-- SIDEBAR -->
<div class="sidebar">
    <h2>🎧 Musicify</h2>
    <a href="dashboard.jsp">Home</a>
    <a href="upload.jsp">Upload</a>
    <a href="playlist.jsp">Playlists 📂</a>
</div>

<!-- CONTENT -->
<div class="content">

<%
String idParam = request.getParameter("id");
int playlistId = 0;

if(idParam != null){
    playlistId = Integer.parseInt(idParam);
} else {
    out.println("<p style='color:red;'>Invalid Playlist</p>");
    return;
}

Connection con = null;
PreparedStatement ps = null;
PreparedStatement psName = null;
ResultSet rs = null;
ResultSet rsName = null;

try {
    con = DBConnection.getConnection();

    // GET PLAYLIST NAME
    psName = con.prepareStatement("SELECT name FROM playlist WHERE id=?");
    psName.setInt(1, playlistId);
    rsName = psName.executeQuery();

    String playlistName = "Playlist";
    if(rsName.next()){
        playlistName = rsName.getString("name");
    }
%>

<!-- HEADER -->
<div style="display:flex; align-items:center; gap:10px; margin-bottom:20px;">
    <a href="dashboard.jsp" style="color:#1db954; font-size:20px; text-decoration:none;">
        ⬅ Back
    </a>
    <h2>🎵 <%= playlistName %></h2>
</div>

<div class="songs">

<%
    String query = "SELECT songs.* FROM songs " +
                   "INNER JOIN playlist_songs ON songs.id = playlist_songs.song_id " +
                   "WHERE playlist_songs.playlist_id = ?";

    ps = con.prepareStatement(query);
    ps.setInt(1, playlistId);

    rs = ps.executeQuery();

    boolean hasSongs = false;

    while(rs.next()) {
        hasSongs = true;
%>

<!-- SONG CARD -->
<div class="card" style="display:flex; justify-content:space-between; align-items:center;">

    <!-- LEFT -->
    <div>
        <h3><%= rs.getString("title") %></h3>

        <p>
            <%= rs.getString("artist") %> 
            <% if(rs.getString("mood") != null){ %>
                | 🎭 <%= rs.getString("mood") %>
            <% } %>
        </p>
    </div>

    <!-- RIGHT ACTIONS -->
    <div style="display:flex; gap:10px; align-items:center;">

        <!-- ▶ PLAY -->
        <button onclick="playSong(
            '<%= request.getContextPath() + "/" + rs.getString("file_path") %>',
            '<%= rs.getString("title") %>',
            '<%= rs.getString("artist") %>'
        )">
            ▶
        </button>

        <!-- ❌ REMOVE -->
        <form action="RemoveFromPlaylistServlet" method="post">
            <input type="hidden" name="song_id" value="<%= rs.getInt("id") %>">
            <input type="hidden" name="playlist_id" value="<%= playlistId %>">
            <button style="color:red;">❌</button>
        </form>

    </div>

</div>

<%
    }

    if(!hasSongs) {
%>
        <p>No songs in this playlist 😢</p>
<%
    }

} catch(Exception e) {
    out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    e.printStackTrace();
} finally {
    if(rs != null) rs.close();
    if(ps != null) ps.close();
    if(rsName != null) rsName.close();
    if(psName != null) psName.close();
    if(con != null) con.close();
}
%>

</div>

</div>
</div>

<!-- PLAYER -->
<div class="player">
    <div class="song-info">
        <span id="currentSong">No song selected</span><br>
        <small id="currentArtist"></small>
    </div>

    <audio id="player" controls></audio>
</div>

<script>
function playSong(path, title, artist) {
    let player = document.getElementById("player");

    player.src = path;
    player.play();

    document.getElementById("currentSong").innerText = title;
    document.getElementById("currentArtist").innerText = artist;
}
</script>

</body>
</html>