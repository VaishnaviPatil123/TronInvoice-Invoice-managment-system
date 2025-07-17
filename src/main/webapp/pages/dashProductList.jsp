<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Filtered Product List</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: url('/pages/pp.jpg') no-repeat center center fixed;
            background-size: cover;
            margin: 0;
            padding: 0;
            color: #333;
        }

        h2 {
            color: white;
            background-color: rgba(0, 68, 102, 0.8);
            padding: 10px 20px;
            border-radius: 10px;
            text-align: center;
            font-size: 26px;
            margin-bottom: 25px;
            font-weight: 600;
        }

        .container {
            padding: 30px;
            max-width: 1100px;
            margin: auto;
        }

        .quick-actions {
            display: flex;
            justify-content: center;
            margin-bottom: 20px;
        }

        .back-link {
            background-color: white;
            color: #006080;
            padding: 10px 20px;
            text-decoration: none;
            font-weight: bold;
            border-radius: 5px;
            transition: background-color 0.3s, color 0.3s;
            border: 2px solid #006080;
        }

        .back-link:hover {
            background-color: #006080;
            color: white;
        }

        table {
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
            background-color: rgba(255, 255, 255, 0.8);
        }

        table th, table td {
            padding: 10px;
            text-align: center;
            border: 1px solid #ddd;
        }

        table th {
            background-color: #004466;
            color: white;
        }

        table tr:hover {
            background-color: #f1f1f1;
        }

        footer {
            background: linear-gradient(to right, #004466, #006080);
            color: white;
            padding: 10px;
            text-align: center;
            margin-top: 30px;
        }

        footer a {
            color: white;
            text-decoration: none;
            margin-left: 10px;
        }

        footer a:hover {
            color: #ffcc00;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Filtered Products</h2>

    <!-- Quick Action Button -->
    <div class="quick-actions">
        <a href="/dashboard" class="back-link">Back to Dashboard</a>
    </div>

    <table>
        <thead>
            <tr>
                <th>ProductId</th>
                <th>Name</th>
                <th>Type</th>
                <th>Quantity</th>
                <th>Cost</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="product" items="${filteredProducts}">
                <tr>
                    <td>${product.barcode}</td>
                    <td>${product.name}</td>
                    <td>${product.type}</td>
                    <td>${product.quantity}</td>
                    <td>${product.cost}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>


</body>
</html>
