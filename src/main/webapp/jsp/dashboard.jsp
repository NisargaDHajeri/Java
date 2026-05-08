<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, dao.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MusicPlayer</title>

<script src="https://unpkg.com/@tailwindcss/browser@4"></script>

<style>
body { background:#050505; color:white; font-family:Inter, sans-serif; }

.hidden-section { display:none; }
.active-tab { border-bottom:2px solid #22c55e; color:#22c55e; }

.filter-btn {
    padding:8px 16px;
    border-radius:999px;
    border:1px solid #444;
    color:#ccc;
}
.filter-btn.active {
    background:#22c55e;
    color:black;
    border:none;
}

.custom-select {
    background:#1a1a1a;
    border:2px solid #333;
    padding:10px 16px;
    border-radius:8px;
    color:white;
}
.custom-select:focus {
    border-color:#22c55e;
    box-shadow:0 0 0 2px #22c55e44;
}
</style>

</head>



<body>

<!-- ===== NAVBAR ===== -->
<header class="border-b border-zinc-800">
<div class="max-w-7xl mx-auto flex justify-between items-center px-6 py-4">

<h1 class="text-xl font-bold text-green-400">🎵 MusicPlayer</h1>

<nav class="flex gap-8 text-sm">
<a href="#" onclick="showSection('home')" id="homeTab" class="active-tab">HOME</a>
<a href="#" onclick="showSection('search')" id="searchTab">SEARCH</a>
<a href="#" onclick="openPlaylistModal()">PLAYLISTS</a>
<a href="#" onclick="showSection('liked')">LIKED SONGS</a>
<a href="#">RECENT</a>
</nav>

<div class="flex gap-4 items-center">
<a href="upload.jsp" class="bg-green-500 px-5 py-2 rounded-full font-semibold">UPLOAD</a>
<div class="border px-4 py-2 rounded-full">👤 ${sessionScope.username}</div>
</div>

</div>
</header>


<div class="max-w-7xl mx-auto px-6">

<!-- ================= HOME ================= -->
<section id="home" class="py-12">

<h1 class="text-5xl font-bold text-green-400 mb-4">
Welcome to MusicPlayer
</h1>

<p class="text-zinc-400 text-lg mb-10">
Your personal music library with unlimited possibilities
</p>

<div class="grid grid-cols-3 gap-8">

<!-- SEARCH -->
<div onclick="showSection('search')" 
     class="bg-zinc-900 border border-zinc-800 p-10 rounded-xl text-center cursor-pointer hover:bg-zinc-800">
    <div class="text-5xl text-green-400 mb-4">🔍</div>
    <h3>Search Music</h3>
    <p class="text-zinc-400 text-sm">Find songs, artists, albums</p>
</div>

<!-- UPLOAD -->
<a href="upload.jsp" 
   class="bg-zinc-900 border border-zinc-800 p-10 rounded-xl text-center hover:bg-zinc-800 block">
    <div class="text-5xl text-green-400 mb-4">⬆</div>
    <h3>Upload Music</h3>
    <p class="text-zinc-400 text-sm">Add your songs</p>
</a>

<!-- PLAYLIST -->
<div onclick="openPlaylistModal()" 
     class="bg-zinc-900 border border-zinc-800 p-10 rounded-xl text-center cursor-pointer hover:bg-zinc-800">
    <div class="text-5xl text-green-400 mb-4">📂</div>
    <h3>Create Playlists</h3>
    <p class="text-zinc-400 text-sm">Organize music</p>
</div>

</div>


<!-- SONG LIST -->
<h2 class="mt-10 text-xl mb-6">All Songs</h2>

<%
Connection con = DBConnection.getConnection();
Statement st = con.createStatement();
ResultSet rs = st.executeQuery("SELECT * FROM songs");
%>

<div class="space-y-4">

<% while(rs.next()){ %>

<div class="flex justify-between items-center bg-zinc-900 p-4 rounded-lg hover:bg-zinc-800">

<!-- LEFT -->
<div class="flex gap-4 items-center">
    <img src="<%= request.getContextPath()+"/"+rs.getString("cover_path") %>" 
         class="w-14 h-14 rounded">

    <div>
        <h3 class="font-semibold"><%= rs.getString("title") %></h3>
        <p class="text-sm text-zinc-400">

<%= rs.getString("artist") %> | 🎭 
<%= rs.getString("mood") != null ? rs.getString("mood") : "No Mood" %>

</p>
    </div>
</div>

<!-- RIGHT ACTIONS -->
<div class="flex items-center gap-4">

    <!-- ▶ PLAY -->
    <button onclick="playSong(
    '<%= request.getContextPath()+"/"+rs.getString("file_path") %>',
    '<%= rs.getString("title") %>',
    '<%= rs.getString("artist") %>'
    )" 
    class="text-lg hover:text-green-400">
    ▶
    </button>

    <!-- ❤️ LIKE -->
    <form action="<%= request.getContextPath() %>/FavoriteServlet" method="post">
        <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
        <button class="text-lg">
            <%= rs.getBoolean("favorite") ? "❤️" : "🤍" %>
        </button>
    </form>

    <!-- ➕ ADD -->
    <button onclick="openAddToPlaylist(<%= rs.getInt("id") %>)"
        class="text-lg hover:text-green-400">
    ➕
</button>

    <!-- 🗑 DELETE -->
    <form action="<%= request.getContextPath() %>/DeleteSongServlet" method="post">

    <input type="hidden" name="id" value="<%= rs.getInt("id") %>">

    <button 
        type="submit"
        onclick="return confirm('⚠️ Are you sure you want to delete this song?')"
        class="text-lg text-red-400 hover:text-red-500">
        🗑
    </button>

</form>

</div>

</div>


<% } %>

</div>

</section>

<!-- ================= LIKED SONGS ================= -->
<section id="liked" class="py-12 hidden-section">

<h1 class="text-3xl text-green-400 mb-6">❤️ Liked Songs</h1>

<%
Statement likedSt = con.createStatement();
ResultSet likedRs = likedSt.executeQuery("SELECT * FROM songs WHERE favorite = true");

boolean hasLiked = false;

while(likedRs.next()){
    hasLiked = true;
%>

<div class="flex justify-between items-center bg-zinc-900 p-4 rounded-lg mb-4">

<div>
    <h3><%= likedRs.getString("title") %></h3>
    <p class="text-sm text-zinc-400">
        <%= likedRs.getString("artist") %> | 🎭 <%= likedRs.getString("mood") %>
    </p>
</div>

<button onclick="playSong(
'<%= request.getContextPath()+"/"+likedRs.getString("file_path") %>',
'<%= likedRs.getString("title") %>',
'<%= likedRs.getString("artist") %>'
)">▶</button>

</div>

<% } %>

<% if(!hasLiked){ %>
<p class="text-zinc-400">No liked songs yet 😢</p>
<% } %>

</section>

<!-- ================= SEARCH ================= -->
<section id="search" class="py-12 hidden-section flex justify-center">

<div class="w-full max-w-4xl text-center">

<h1 class="text-5xl text-green-400 mb-4">Search Music</h1>
<p class="text-zinc-400 mb-6">Find songs by mood 🎧</p>

<!-- SEARCH + MOOD -->
<form method="get" action="dashboard.jsp" class="flex gap-4 justify-center mb-8">

<input type="text" name="search" placeholder="Search song..." 
       class="w-full max-w-md bg-zinc-800 p-4 rounded-full text-center">

<select name="mood" class="custom-select">
<option value="">All Moods</option>
<option value="Happy">😊 Happy</option>
<option value="Sad">😢 Sad</option>
<option value="Party">🎉 Party</option>
<option value="Romantic">❤️ Romantic</option>
<option value="Chill">😌 Chill</option>
</select>

<button class="bg-green-500 px-6 rounded-full">Search</button>

</form>

<!-- 🔥 FILTER BUTTONS -->
<div class="flex gap-3 mb-6 justify-center">
<button class="filter-btn active" onclick="showSearchType('songs', event)">Songs</button>
<button class="filter-btn" onclick="showSearchType('playlists', event)">Playlists</button>
</div>

<!-- ================= SONG RESULTS ================= -->
<div id="songResults" class="space-y-4">

<%
String search = request.getParameter("search");
String mood = request.getParameter("mood");

String query = "SELECT * FROM songs WHERE 1=1";

if(search != null && !search.trim().isEmpty()){
    query += " AND title LIKE '%" + search + "%'";
}

if(mood != null && !mood.trim().isEmpty()){
    query += " AND mood = '" + mood + "'";
}

Statement searchSt = con.createStatement();
ResultSet searchRs = searchSt.executeQuery(query);

boolean hasData = false;

while(searchRs.next()){
    hasData = true;
%>

<div class="flex justify-between items-center bg-zinc-900 p-4 rounded-lg">

<div>
<h3><%= searchRs.getString("title") %></h3>
<p class="text-sm text-zinc-400">
<%= searchRs.getString("artist") %> | 🎭 <%= searchRs.getString("mood") %>
</p>
</div>

<button onclick="playSong(
'<%= request.getContextPath()+"/"+searchRs.getString("file_path") %>',
'<%= searchRs.getString("title") %>',
'<%= searchRs.getString("artist") %>'
)">▶</button>

</div>

<% } %>

<% if(!hasData){ %>
<div class="text-center text-zinc-400 mt-10">
❌ No songs found for this mood
</div>
<% } %>

</div>

<!-- ================= PLAYLIST RESULTS ================= -->
<div id="playlistResults" class="space-y-4 hidden">

<%
Statement pst2 = con.createStatement();
ResultSet prs2 = pst2.executeQuery("SELECT * FROM playlist");

boolean hasPlaylist = false;

while(prs2.next()){
    hasPlaylist = true;
%>


<div class="bg-zinc-900 p-4 rounded-lg hover:bg-zinc-800 flex justify-between items-center">

    <!-- LEFT (CLICKABLE PLAYLIST) -->
    <a href="viewPlaylist.jsp?id=<%= prs2.getInt("id") %>" class="flex-1">
        <h3 class="text-lg font-semibold">
            <%= prs2.getString("name") %>
        </h3>

        <p class="text-sm text-zinc-400">
            No description
        </p>

        <p class="text-xs text-green-400">
            Private
        </p>
    </a>

    <!-- RIGHT (DELETE BUTTON) -->
    <form action="<%= request.getContextPath() %>/DeletePlaylistServlet" method="post">
        <input type="hidden" name="playlist_id" value="<%= prs2.getInt("id") %>">

        <button 
         onclick="return confirm('⚠️ Are you sure you want to delete this playlist?')" 
         class="text-red-400 hover:text-red-500 text-lg">
            🗑
        </button>
    </form>

</div>

<% } %>

<% if(!hasPlaylist){ %>
<div class="text-center text-zinc-400">
No playlists found
</div>
<% } %>

</div>

</div>

</section>
</div>


<!-- ===== PLAYER ===== -->
<footer class="fixed bottom-0 w-full bg-black border-t border-zinc-800 p-4">
<div class="max-w-7xl mx-auto flex justify-between items-center px-6">

<div>
<p id="currentTitle">No song</p>
<small id="currentArtist"></small>
</div>

<audio id="player" controls></audio>

</div>
</footer>


<!-- ===== PLAYLIST MODAL ===== -->
<div id="playlistModal" class="hidden fixed inset-0 bg-black/80 flex items-center justify-center z-50">

<div class="bg-zinc-900 p-8 rounded-2xl w-[420px] relative shadow-xl">

<!-- CLOSE -->
<button onclick="closePlaylistModal()" 
        class="absolute top-4 right-5 text-xl text-zinc-400 hover:text-white">
    ✕
</button>

<h2 class="text-2xl font-semibold mb-6">Create Playlist</h2>

<form action="<%= request.getContextPath() %>/CreatePlaylistServlet" 
      method="post"
      class="flex flex-col gap-5">

    <!-- NAME -->
    <div>
        <label class="block text-sm text-zinc-400 mb-2">Playlist Name</label>
        <input type="text" name="name" required
               class="w-full bg-black px-4 py-3 rounded-lg border border-zinc-700 focus:border-green-500 outline-none">
    </div>

    <!-- DESCRIPTION -->
    <div>
        <label class="block text-sm text-zinc-400 mb-2">Description</label>
        <textarea name="description"
                  class="w-full bg-black px-4 py-3 rounded-lg border border-zinc-700 focus:border-green-500 outline-none h-24 resize-none"></textarea>
    </div>

    <!-- PUBLIC -->
    <div class="flex items-center gap-2">
        <input type="checkbox" name="isPublic">
        <label class="text-sm text-zinc-400">Make playlist public</label>
    </div>

    <!-- BUTTONS -->
    <div class="flex justify-between items-center mt-4">

        <button type="button"
                onclick="closePlaylistModal()"
                class="border border-zinc-400 px-6 py-2 rounded-full text-zinc-300 hover:bg-zinc-800">
            Cancel
        </button>

        <button type="submit"
                class="bg-green-500 px-6 py-2 rounded-full font-semibold hover:bg-green-400">
            Create Playlist
        </button>

    </div>

</form>

</div>
</div>

<!-- ===== JS ===== -->
<script>

function playSong(path,title,artist){
let p=document.getElementById("player");
p.src=path;
p.play();

document.getElementById("currentTitle").innerText=title;
document.getElementById("currentArtist").innerText=artist;
}

function showSection(section){
    document.getElementById("home").classList.add("hidden-section");
    document.getElementById("search").classList.add("hidden-section");
    document.getElementById("liked").classList.add("hidden-section");

    document.getElementById(section).classList.remove("hidden-section");

    document.getElementById("homeTab").classList.remove("active-tab");
    document.getElementById("searchTab").classList.remove("active-tab");

    if(section==="home") document.getElementById("homeTab").classList.add("active-tab");
    if(section==="search") document.getElementById("searchTab").classList.add("active-tab");
}
function openPlaylistModal(){
document.getElementById("playlistModal").classList.remove("hidden");
}

function closePlaylistModal(){
document.getElementById("playlistModal").classList.add("hidden");
}

document.querySelectorAll(".filter-btn").forEach(btn => {
btn.addEventListener("click", () => {
document.querySelectorAll(".filter-btn").forEach(b => b.classList.remove("active"));
btn.classList.add("active");
});
});


function openAddToPlaylist(id){
    document.getElementById("addPlaylistModal").classList.remove("hidden");
    document.getElementById("songIdInput").value = id;
}

function closeAddPlaylistModal(){
    document.getElementById("addPlaylistModal").classList.add("hidden");
}

function showSearchType(type, event){

    const songDiv = document.getElementById("songResults");
    const playlistDiv = document.getElementById("playlistResults");

    songDiv.style.display = "none";
    playlistDiv.style.display = "none";

    if(type === "songs"){
        songDiv.style.display = "block";
    }

    if(type === "playlists"){
        playlistDiv.style.display = "block";
    }

    document.querySelectorAll(".filter-btn").forEach(b => b.classList.remove("active"));
    event.target.classList.add("active");
}

window.onload = function(){

    const urlParams = new URLSearchParams(window.location.search);

    const search = urlParams.get("search");
    const mood = urlParams.get("mood");
    const show = urlParams.get("show");

    if(search !== null || mood !== null){
        showSection('search');
    }

    if(show === "playlists"){
        showSection('search');
        document.getElementById("playlistResults").style.display = "block";
        document.getElementById("songResults").style.display = "none";
    }
};
</script>
<!-- ADD TO PLAYLIST MODAL -->
<div id="addPlaylistModal" class="hidden fixed inset-0 bg-black/80 flex items-center justify-center z-50">

<div class="bg-zinc-900 p-6 rounded-xl w-80">

<h3 class="mb-4">Add to Playlist</h3>
<form action="<%= request.getContextPath() %>/AddToPlaylistServlet" method="post">
<input type="hidden" id="songIdInput" name="song_id">

<select name="playlist_id" class="w-full p-3 bg-black mb-4 rounded">

<%
Statement psPlaylist = con.createStatement();
ResultSet pr = psPlaylist.executeQuery("SELECT * FROM playlist");
while(pr.next()){
%>
<option value="<%= pr.getInt("id") %>">
<%= pr.getString("name") %>
</option>
<% } %>

</select>

<button class="bg-green-500 w-full py-2 rounded">Add</button>
</form>

<button onclick="closeAddPlaylistModal()" class="mt-2 text-red-400">Cancel</button>

</div>
</div>
<%
try {
    if(rs != null) rs.close();
    if(st != null) st.close();

    if(searchRs != null) searchRs.close();
    if(searchSt != null) searchSt.close();

    if(prs2 != null) prs2.close();
    if(pst2 != null) pst2.close();

    if(con != null) con.close();
} catch(Exception e){}
%>

</body>
</html>