<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login | Musicify</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>

<div class="container">

    <!-- App Logo -->
    <h1 class="logo">Musicify 🎧</h1>

    <!-- Heading -->
    <h2>Welcome Back</h2>

    <!-- Login Form -->
    <form action="/MusicPlayerAppjava/LoginServlet" method="post">
        <input type="text" name="email" placeholder="Enter Email" required>
        <input type="password" name="password" placeholder="Enter Password" required>

        <button type="submit">Login</button>
    </form>

    <!-- Navigation -->
    <p class="switch">
        Don’t have an account? 
        <a href="register.jsp">Register</a>
    </p>

</div>

</body>
</html>