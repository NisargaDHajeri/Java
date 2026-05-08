<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, dao.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
    <title>Playlists</title>
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

<!-- 🔥 HEADER WITH BACK BUTTON -->
<div style="display:flex; align-items:center; gap:10px; margin-bottom:20px;">
    <a href="dashboard.jsp" style="color:#1db954; font-size:20px; text-decoration:none;">
        ⬅
    </a>
    <h2>Create Playlist</h2>
</div>

<!-- CREATE PLAYLIST -->
<form action="/MusicPlayerAppjava/CreatePlaylistServlet" method="post" style="margin-bottom:30px;">
    <input type="text" name="name" placeholder="Playlist name" required>
    <button>Create</button>
</form>

<!-- PLAYLIST LIST -->
<h2>Your Playlists 📂</h2>

<div class="songs">

<%
Connection con = null;
Statement st = null;
ResultSet rs = null;

try {
    con = DBConnection.getConnection();
    st = con.createStatement();
    rs = st.executeQuery("SELECT * FROM playlist");

    if(!rs.isBeforeFirst()) {
%>
        <p>No playlists yet 😢</p>
<%
    }

    while(rs.next()) {
%>

    <div class="card">

        <h3><%= rs.getString("name") %></h3>

        <a href="viewPlaylist.jsp?id=<%= rs.getInt("id") %>" 
           style="display:inline-block; margin-top:10px; color:#1db954; text-decoration:none;">
            ▶ Open Playlist
        </a>

    </div>

<%
    }

} catch(Exception e) {
    e.printStackTrace();
} finally {
    if(rs!=null) rs.close();
    if(st!=null) st.close();
    if(con!=null) con.close();
}
%>

</div>

</div>
</div>

</body>
</html>