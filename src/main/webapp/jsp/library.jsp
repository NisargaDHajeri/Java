<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, dao.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Library</title>
<link rel="stylesheet" href="../css/dashboard.css">

<style>
.card {
    cursor: pointer;
    transition: 0.3s;
}
.card:hover {
    background: #282828;
    transform: scale(1.02);
}
</style>

</head>

<body>

<div class="main">

<!-- SIDEBAR -->
<div class="sidebar">
    <h2>🎧 Musicify</h2>
    <a href="dashboard.jsp">Home</a>
    <a href="upload.jsp">Upload</a>
    <a href="library.jsp">Library ❤️</a>
</div>

<!-- CONTENT -->
<div class="content">

<h2>❤️ Your Favorites</h2>

<div class="songs">

<%
Connection con = DBConnection.getConnection();
Statement st = con.createStatement();
ResultSet rs = st.executeQuery("SELECT * FROM songs WHERE favorite=TRUE");

while(rs.next()) {
%>

<!-- 🎵 CLICKABLE CARD -->
<div class="card"
onclick="playSong(
    '<%= request.getContextPath() + "/" + rs.getString("file_path") %>',
    '<%= rs.getString("title") %>',
    '<%= rs.getString("artist") %>'
)">

    <h3><%= rs.getString("title") %></h3>
    <p><%= rs.getString("artist") %></p>

</div>

<%
}
%>

</div>
</div>

</div>

<!-- 🎧 PLAYER -->
<div class="player">
    <div class="song-info">
        <span id="currentSong">No song selected</span><br>
        <small id="currentArtist"></small>
    </div>

    <audio id="player" controls></audio>
</div>

<!-- 🔥 SCRIPT -->
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