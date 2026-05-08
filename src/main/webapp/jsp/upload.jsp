<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Upload Song</title>

<script src="https://unpkg.com/@tailwindcss/browser@4"></script>

<style>
body { background:#050505; color:white; font-family:Inter, sans-serif; }

/* CUSTOM FILE INPUT */
.file-box {
    border:2px solid #333;
    padding:12px;
    border-radius:10px;
    cursor:pointer;
    display:flex;
    align-items:center;
    gap:10px;
}
.file-box:hover { border-color:#22c55e; }

/* INPUT STYLE */
.input-box {
    background:#0f0f0f;
    border:2px solid #333;
    padding:12px;
    border-radius:10px;
    width:100%;
}
.input-box:focus {
    border-color:#22c55e;
    outline:none;
}

/* DROPDOWN */
.select-box {
    background:#0f0f0f;
    border:2px solid #333;
    padding:12px;
    border-radius:10px;
    width:100%;
}
.select-box:focus {
    border-color:#22c55e;
}
</style>

</head>

<body class="flex items-center justify-center h-screen">

<!-- ===== MODAL ===== -->
<div class="bg-zinc-900 p-8 rounded-2xl w-[420px] shadow-xl relative">

<!-- CLOSE -->
<button onclick="window.history.back()" class="absolute top-4 right-5 text-xl text-zinc-400 hover:text-white">✕</button>

<h2 class="text-2xl font-semibold mb-6">Upload Song</h2>

<form action="/MusicPlayerAppjava/UploadSongServlet"
      method="post"
      enctype="multipart/form-data"
      class="flex flex-col gap-5">

    <!-- AUDIO -->
    <label class="text-sm text-zinc-400">Audio File</label>
    <label class="file-box">
        🎵 Choose Audio
        <input type="file" name="file" accept="audio/*" required hidden>
    </label>

    <!-- COVER -->
    <label class="text-sm text-zinc-400">Cover Image</label>
    <label class="file-box">
        🖼 Choose Cover
        <input type="file" name="cover" accept="image/*" hidden>
    </label>

    <!-- TITLE -->
    <label class="text-sm text-zinc-400">Title</label>
    <input type="text" name="title" required class="input-box">

    <!-- ARTIST -->
    <label class="text-sm text-zinc-400">Artist</label>
    <input type="text" name="artist" required class="input-box">

    <!-- ALBUM -->
    <label class="text-sm text-zinc-400">Album</label>
    <input type="text" name="album" class="input-box">

    <!-- GENRE -->
    <label class="text-sm text-zinc-400">Genre</label>
    <select name="genre" class="select-box">
        <option>Classical</option>
        <option>Pop</option>
        <option>Rock</option>
        <option>Jazz</option>
        <option>Electronic</option>
        <option>Hip Hop</option>
        <option>Country</option>
        <option>R&B</option>
    </select>

    <!-- MOOD -->
    <label class="text-sm text-zinc-400">Mood</label>
    <select name="mood" class="select-box">
        <option>Happy</option>
        <option>Sad</option>
        <option>Energetic</option>
        <option>Relaxing</option>
        <option>Romantic</option>
        <option>Dark</option>
        <option>Nostalgic</option>
    </select>

    <!-- BUTTONS -->
    <div class="flex justify-between mt-4">

        <button type="button"
                onclick="window.history.back()"
                class="border border-zinc-500 px-6 py-2 rounded-full">
            Cancel
        </button>

        <button type="submit"
                class="bg-green-500 px-6 py-2 rounded-full font-semibold">
            Upload Song
        </button>

    </div>

</form>

</div>

</body>
</html>