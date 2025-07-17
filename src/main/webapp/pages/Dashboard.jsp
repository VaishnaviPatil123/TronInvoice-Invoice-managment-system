<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Pharmacy Management</title>
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
            max-width: 1100px;
            margin: auto;
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

        .quick-actions {
            display: flex;
            justify-content: center;
            margin-bottom: 20px;
        }

        .quick-actions button {
            padding: 10px 20px;
            background-color: #006080;
            color: white;
            font-weight: bold;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .quick-actions button:hover {
            background-color: #004466;
        }

        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .card {
            background-color: #ffffffee;
            border-radius: 12px;
            padding: 18px 15px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            text-align: center;
            transition: transform 0.3s ease-in-out;
            min-height: 120px;
        }

        .card:hover {
            transform: translateY(-8px);
        }

        .card h3, .card h2 {
            font-size: 18px;
            margin-bottom: 10px;
            color: #004466;
            font-weight: 600;
        }

        .card p {
            font-size: 22px;
            font-weight: bold;
            color: #222;
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
       <!-- <a href="/dashboard">Dashboard</a>-->
        <a href="/stock">Stocks</a>
		<a href="/invoice">Create Invoice</a>
        <a href="/invoice-list">Invoice List</a>
        <a href="/product#productList">Product List</a>
        <a href="/register">Logout</a>
    </nav>
</header>

<div class="container">
    <h2>Admin Dashboard</h2>

    <!-- Quick Actions Section with Add Product button -->
    <div class="quick-actions">
        <button onclick="window.location.href='/product'">Add Product</button>
    </div>

    <!-- Dashboard Cards Section -->
    <div class="cards">
        <div class="card">
            <h3>Total Products</h3>
            <p>${totalProducts}</p>
        </div>

        <div class="card" onclick="location.href='/product/filter?type=inStock'" style="cursor:pointer;">
            <h3>In Stock</h3>
            <p>${inStockCount}</p>
        </div>

        <div class="card" onclick="location.href='/product/filter?type=outOfStock'" style="cursor:pointer;">
            <h3>Out of Stock</h3>
            <p>${outOfStockCount}</p>
        </div>


		<div class="card" onclick="location.href='/product/filter?type=lowStock'" style="cursor:pointer;">
            <h3>Low Stock (&lt; 10)</h3>
            <p>${lowStockCount}</p>
        </div>

        <div class="card">
            <h3>Total Invoices</h3>
            <p>${totalInvoices}</p>
        </div>

        <div class="card">
            <h3>Total Sales</h3>
            <p>₹${totalSales}</p>
        </div>
		<div class="card" onclick="location.href='/todaysInvoices'" style="cursor: pointer;">
		    <h3>Today's Invoices</h3>
		    <p>${todayInvoices}</p>
		</div>

		<div class="card">
		    <h3>Today's Sales</h3>
		    <p>₹<c:out value="${todaySales != null ? todaySales : 0.0}" /></p>
		</div>
		<div class="card" onclick="location.href='/product/filter?type=inStock'" style="cursor:pointer;">
		            <h3>Custemer List</h3>
		            <p>${customerName}</p>
		        </div>

    </div>
</div>

<!-- Footer Section 
<footer>
    <p>&copy; 2025 Pharmacy Management. All Rights Reserved.</p>
    <a href="#">Privacy Policy</a>
    <a href="#">Terms & Conditions</a>
    <a href="#">Contact Support</a>
</footer>-->

</body>
</html>
