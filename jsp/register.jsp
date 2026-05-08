<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register | Musicify</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>

<div class="container">

    <!-- App Logo -->
    <h1 class="logo">Musicify 🎧</h1>

    <!-- Heading -->
    <h2>Create Account</h2>

    <!-- Register Form -->
    <form action="/MusicPlayerAppjava/RegisterServlet" method="post">
        <input type="text" name="name" placeholder="Enter Name" required>
        <input type="text" name="email" placeholder="Enter Email" required>
        <input type="password" name="password" placeholder="Enter Password" required>

        <button type="submit">Register</button>
    </form>

    <!-- Navigation -->
    <p class="switch">
        Already have an account? 
        <a href="login.jsp">Login</a>
    </p>

</div>

</body>
</html>