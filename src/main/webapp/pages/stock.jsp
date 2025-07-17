<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Stock - Pharmacy Management</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: url('/pages/pp.jpg') no-repeat center center fixed;
            background-size: cover;
            margin: 0;
            padding: 0;
            color: #333;
        }

        header {
            background: linear-gradient(to right, #004466, #006080);
            padding: 15px 30px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
        }

        header img {
            height: 45px;
        }

        nav a {
            margin-left: 25px;
            color: white;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s;
        }

        nav a:hover {
            color: #ffcc00;
        }

        .container {
            padding: 30px;
            max-width: 1200px;
            margin: auto;
        }

        .section {
            background: #ffffffee;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.15);
        }

        h2 {
            color: #0074cc;
            border-bottom: 2px solid #0074cc;
            padding-bottom: 8px;
            margin-bottom: 25px;
            font-size: 24px;
        }

        form {
            margin-bottom: 20px;
        }

        .search-input, select, .btn {
            padding: 10px;
            margin-right: 10px;
            font-size: 14px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        .btn {
            background-color: #0074cc;
            color: white;
            font-weight: bold;
            cursor: pointer;
            border: none;
            transition: background 0.3s ease;
        }

        .btn:hover {
            background-color: #005fa3;
        }

        .action-btn {
            background-color: #28a745;
        }

        .action-btn:hover {
            background-color: #218838;
        }

        .table-container {
            overflow-x: auto;
            max-height: 500px;
            border-radius: 10px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
            font-size: 15px;
            min-width: 1000px;
        }

        th, td {
            padding: 12px;
            border: 1px solid #e2e2e2;
            text-align: center;
        }

        th {
            background-color: #0074cc;
            color: white;
            position: sticky;
            top: 0;
            z-index: 2;
        }

        tr {
            background-color: white;
        }

       

        @media (max-width: 768px) {
            .search-input, select, .btn {
                width: 100%;
                margin-bottom: 10px;
            }
        }
		.project-name {
		    font-family: 'Fredoka One', cursive;
		    font-size: 36px;
		    color: #ffffff; /* Bright white */
		    letter-spacing: 1px;
		    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.4); /* Adds depth */
		    margin-left: 15px;
		}

    </style>
	<link href="https://fonts.googleapis.com/css2?family=Fredoka+One&display=swap" rel="stylesheet">

</head>
<body>
<header>
    <!--  <div><img src="/pages/plogo.jpg" alt="Pharmacy Logo"></div>-->
	<div><span class="project-name">TronInvoice</span></div>
	
    <nav>
		<a href="/dashboard">Dashboard</a>
        <a href="/stock">Stocks</a>
        <a href="/invoice">Create Invoice</a>
         <a href="/invoice-list">Invoice List</a>
        <a href="/product#productList">Product List</a>
       <a href="/register">Logout</a>
    </nav>
</header>

<div class="container">
    <form action="/stock" method="get">
        <input type="text" name="barcode" placeholder="🔍 Search by:ProductId" class="search-input">
        <select name="filterType">
            <option value="">-- Filter by Type --</option>
            <option value="In Stock">In Stock</option>
            <option value="Out of Stock">Out of Stock</option>
        </select>
        <button class="btn" type="submit">Search</button>
        <a href="/product"><button type="button" class="btn action-btn">➕ Add Product</button></a>
    </form>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>ProductId</th>
                    <th>Name</th>
                    <th>Quantity</th>
                    <th>Cost</th>
                    <th>GST%</th>
                    <th>Net Total</th>
                    <th>Type</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="product" items="${stockList}">
                    <tr class="${product.quantity < 10 ? 'low-stock' : ''}">
                        <td>${product.barcode}</td>
                        <td>${product.name}</td>
                        <td>${product.quantity}</td>
                        <td>${product.cost}</td>
                        <td>${product.gstPercentage}</td>
                        <td>${product.netTotal}</td>
                        <td>${product.type}</td>
                        <td>
                            <a href="/product?id=${product.id}">Update</a> |
                            <a href="/delete/${product.id}" onclick="return confirm('Are you sure you want to delete this product?');">Delete</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
