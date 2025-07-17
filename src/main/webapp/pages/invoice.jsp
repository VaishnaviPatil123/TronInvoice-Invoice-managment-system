<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Invoice - Pharmacy Management</title>
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

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 25px;
            font-size: 15px;
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        }

        th, td {
            padding: 12px;
            border: 1px solid #e2e2e2;
            text-align: center;
        }

        th {
            background-color: #0074cc;
            color: white;
            font-weight: 600;
        }

        td {
            background-color: #f9f9f9;
        }

        input[type="number"], input[type="text"] {
            padding: 6px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        button {
            background-color: #0074cc;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 20px;
        }

        button:hover {
            background-color: #005fa3;
        }

        .search-bar {
            display: flex;
            gap: 10px;
            align-items: center;
            margin-bottom: 20px;
        }

        .invoice-total {
            text-align: right;
            margin-top: 10px;
            font-weight: bold;
        }

        .generate-invoice-button {
            align:center;
            margin-top: 20px;
        }
        .customer-details input {
                   width: 300px;
               }

               .info-display {
                   margin-top: 15px;
                   font-weight: 500;
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
    <div class="section">
        <h2>Create New Invoice</h2>
        <!-- 📝 Customer Info Form -->
        <form action="/submit-customer" method="post" style="margin-bottom: 20px;">
            <!-- Customer Name and Phone Number -->
            <div style="display: flex; align-items: center; gap: 15px;">
                <label for="customerName"><strong>Customer Name:</strong></label>
                <input type="text" id="customerName" name="customerName" value="${customerName}" required />

                <label for="phoneNumber"><strong>Phone Number:</strong></label>
                <input type="text" id="phoneNumber" name="customerPhoneNumber" value="${customerPhoneNumber}" required />

                <!-- Submit Button to submit Customer Details -->
                <button type="submit" class="generate-invoice-button">Submit</button>
            </div>
        </form>

        <!-- 🔍 Barcode Search -->
        <form id="searchForm" action="/create-invoice" method="get" class="search-bar">
            <input type="text" name="barcode" placeholder="Enter Barcode to Search Product" value="${barcode}" required />
            <button type="submit">Search Product</button>
        </form>

        <!-- ✅ Show Searched Product -->
        <c:if test="${not empty searchedProduct}">
            <div id="searchedProductDetails">
                <h3>Product Found:</h3>
                <p><strong>Name:</strong> ${searchedProduct.name}</p>
                <p><strong>ProductId:</strong> ${searchedProduct.barcode}</p>
                <p><strong>Cost:</strong> $${searchedProduct.cost}</p>
                <p><strong>GST %:</strong> ${searchedProduct.gstPercentage}%</p>
                <p><strong>SGST:</strong> $${searchedProduct.sgstAmount}</p>
                <p><strong>CGST:</strong> $${searchedProduct.cgstAmount}</p>
                <p><strong>Total GST Amount:</strong> $${searchedProduct.totalGst}</p>
                <p><strong>Net Total (incl. GST):</strong> $${searchedProduct.netTotal}</p>

                <!-- Check stock availability and handle 'Add to Invoice' -->
                <c:if test="${searchedProduct.quantity == 0}">
                    <p style="color: red; font-weight: bold;">Product is out of stock!</p>
                    <!-- Disable the 'Add to Invoice' button if out of stock -->
                    <button type="submit" disabled>Add to Invoice</button>
                </c:if>
                
                <c:if test="${searchedProduct.quantity > 0}">
                    <form action="/add-to-invoice" method="post" style="margin-top: 10px;">
                        <input type="hidden" name="barcode" value="${searchedProduct.barcode}" />
                        <label for="quantityToAdd">Quantity:</label>
                        <input type="number" name="quantity" id="quantityToAdd" value="1" min="1" max="${searchedProduct.quantity}" required />
                        <button type="submit">Add to Invoice</button>
                    </form>
                </c:if>
            </div>
        </c:if>
        
        <div>
            <h3>Customer Details:</h3>
            <p>Name: ${customerName}</p>
            <p>Phone Number: ${customerPhoneNumber}</p>
        </div>

        <!-- 🧾 Invoice Table -->
        <h3>Invoice Items</h3>
        <form action="/generate-invoice" method="post">
            <table>
                <thead>
                    <tr>
                        <th>ProductId</th>
                        <th>Name</th>
                        <th>Quantity</th>
                        <th>Price</th>
                        <th>GST (%)</th>
                        <th>Total</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${invoiceItems}">
                        <tr>
                            <td>${item.barcode}</td>
                            <td>${item.name}</td>
                            <td>${item.quantity}</td>
                            <td>₹${item.cost}</td>
                            <td>${item.gst}%</td>
                            <td>₹${item.netTotal}</td>
                            <td><a href="/remove-item?barcode=${item.barcode}">Remove</a></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <!-- 💰 Total -->
            <div class="invoice-total">
                Total: ₹<span>${total}</span>
            </div>

            <!-- ✅ Submit -->
            <button type="submit" class="generate-invoice-button">Generate Invoice</button>
        </form>
    </div>
</div>
</body>
</html>
