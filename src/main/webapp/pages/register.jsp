<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: url('/pages/pp.jpg') no-repeat center center fixed;
            background-size: cover;
            margin: 0;
            padding: 0;
            color: #333;
        }

        .container {
            padding: 30px;
            max-width: 500px;
            margin: 60px auto;
            background: #f2f2f2;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        h2 {
            color: #0074cc;
            border-bottom: 2px solid #0074cc;
            padding-bottom: 10px;
            text-align: center;
            margin-bottom: 30px;
        }

        label {
            font-weight: 600;
            display: block;
            margin-top: 15px;
        }

        input, select {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 15px;
        }

        input:focus, select:focus {
            border-color: #0074cc;
            outline: none;
        }

        button {
            background-color: #0074cc;
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 25px;
            width: 100%;
        }

        button:hover {
            background-color: #005fa3;
        }

        .message {
            color: red;
            text-align: center;
            font-weight: bold;
            margin-top: 15px;
        }

        .login-link {
            text-align: center;
            margin-top: 20px;
        }

        .login-link a {
            color: #0074cc;
            text-decoration: none;
            font-weight: bold;
        }

        .login-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Register</h2>
    <form method="post" action="/register">
        <label>Username:</label>
        <input type="text" name="username" required>

        <label>Email:</label>
        <input type="email" name="email" required>

        <label>Gender:</label>
        <select name="gender" required>
            <option value="">-- Select Gender --</option>
            <option>Male</option>
            <option>Female</option>
        </select>

        <label>Password:</label>
        <input type="password" name="password" required>

        <label>Confirm Password:</label>
        <input type="password" name="confirmPassword" required>

        <button type="submit">Register</button>
    </form>
    
    <div class="message">${sessionScope.msg}</div>

    <!-- Link to login page if the user is already registered -->
    <div class="login-link">
        <p>Already have an account? <a href="/login">Login here</a></p>
    </div>
</div>
</body>
</html>
