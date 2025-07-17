<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<link href="https://fonts.googleapis.com/css2?family=Fredoka+One&display=swap" rel="stylesheet">

    <meta charset="UTF-8">
    <title>Pharmacy Product Management</title>
    <style>
		body {
		    font-family: 'Segoe UI', sans-serif;
		    background: #f7fbff;
		    margin: 0;
		    padding: 0;
		    color: #333;
			background: url('/pages/pp.jpg') no-repeat center center fixed;
			  background-size: cover;
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
		
		.project-name {
		    font-family: 'Fredoka One', cursive;
		    font-size: 36px;
		    color: #ffffff; /* Bright white */
		    letter-spacing: 1px;
		    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.4); /* Adds depth */
		    margin-left: 15px;
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
		    max-width: 1000px;
		    margin: auto;
		}

		h2 {
		    color: #0074cc;
		    border-bottom: 2px solid #0074cc;
		    padding-bottom: 8px;
		    margin-bottom: 25px;
		    font-size: 24px;
		}

		.section {
		    background:#f2f2f2;
		    padding: 25px;
		    margin-bottom: 35px;
		    border-radius: 12px;
		   box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
		}

		.form-row {
		    display: flex;
		    justify-content: space-between;
		    flex-wrap: wrap;
		    gap: 40px;
		}

		.form-group {
		    flex: 1;
		    min-width: 250px;
		}

		label {
		    font-weight: 600;
		    margin-bottom: 6px;
		    display: block;
		    color: #222;
		}

		input, select {
		    width: 100%;
		    max-width: 350px;
		    padding: 10px 12px;
		    border-radius: 8px;
		    border: 1px solid #ccc;
		    font-size: 15px;
		    transition: border 0.2s;
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
		    transition: background-color 0.3s ease;
		    margin-top: 10px;
			display: block;          /* Makes it a block-level element */
			    margin: 20px auto 0; 
		}

		button:hover {
		    background-color: #005fa3;
		}

		table {
		    width: 100%;
		    border-collapse: collapse;
		    margin-top: 25px;
		    font-size: 15px;
		    background: white;
		    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
		    border-radius: 10px;
		    overflow: hidden;
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

		td a {
		    color: #0074cc;
		    font-weight: 500;
		    text-decoration: none;
		}

		td a:hover {
		    text-decoration: underline;
		}

    </style>
    <script>
		function calculateGST() {
		    let cost = parseFloat(document.getElementById("cost").value) || 0;
		    let quantity = parseInt(document.getElementById("quantity").value) || 1;
		    let gst = parseFloat(document.getElementById("gst").value) || 0;

		    let totalCost = cost * quantity;
		    let gstAmount = (totalCost * gst) / 100;
		    let sgst = gstAmount / 2;
		    let cgst = gstAmount / 2;
		    let netTotal = totalCost + gstAmount;

		    document.getElementById("sgstAmount").value = sgst.toFixed(2);
		    document.getElementById("cgstAmount").value = cgst.toFixed(2);
		    document.getElementById("totalGst").value = gstAmount.toFixed(2);
		    document.getElementById("netTotal").value = netTotal.toFixed(2);
		}
    </script>
</head>
<body>
    <header>
        <!--  <div><img src="/pages/plogo.jpg" alt="Pharmacy Logo"></div>-->
			<span class="project-name">TronInvoice</span>
		</div>
        <nav>
			<a href="/dashboard">Dashboard</a>
            <a href="/stock">Stocks</a>
            <a href="/invoice">Create Invoice</a>
            <a href="/invoice-list">Invoice List</a>
            <a href="#productList">Product List</a>
           <a href="/register">Logout</a>
        </nav>
    </header>

    <div class="container">
		<form action="/saveProduct" method="post">
		    <input type="hidden" name="id" value="${product.id}" />
		    <div class="section">
		        <h2>Product Details</h2>

		        <div class="form-row">
		            <div class="form-group">
		                <label for="barcode">ProductId</label>
		                <input type="text" id="barcode" name="barcode" value="${product.barcode}" required pattern="^\d{5}$" maxlength="5"title="Please enter exactly 5 digits" />
		            </div>
		            <div class="form-group">
		                <label for="name">Product Name</label>
		                <input type="text" id="name" name="name" value="${product.name}" required>
		            </div>
		        </div>

		        <div class="form-row">
		            <div class="form-group">
		                <label for="quantity">Quantity</label>
		                <input type="number" id="quantity" name="quantity" min="0" value="${product.quantity}" required oninput="calculateGST()">
		            </div>
		            <div class="form-group">
		                <label for="cost">Cost</label>
		                <input type="number" id="cost" name="cost" step="0.01" value="${product.cost}" required oninput="calculateGST()">
		            </div>
		        </div>

		        <div class="form-row">
		            <div class="form-group">
		                <label for="gst">GST Percentage</label>
		                <input type="number" id="gst" name="gstPercentage" step="0.01" value="${product.gstPercentage}" required oninput="calculateGST()">
		            </div>
		        </div>
		    </div>

		    <div class="section">
		        <h2>GST Details</h2>

		        <div class="form-row">
		            <div class="form-group">
		                <label for="sgstAmount">SGST Amount</label>
		                <input type="number" id="sgstAmount" name="sgstAmount" value="${product.sgstAmount}" readonly>
		            </div>
		            <div class="form-group">
		                <label for="cgstAmount">CGST Amount</label>
		                <input type="number" id="cgstAmount" name="cgstAmount" value="${product.cgstAmount}" readonly>
		            </div>
		        </div>

		        <div class="form-row">
		            <div class="form-group">
		                <label for="totalGst">Total GST</label>
		                <input type="number" id="totalGst" name="totalGst" value="${product.totalGst}" readonly>
		            </div>
		            <div class="form-group">
		                <label for="netTotal">Net Total</label>
		                <input type="number" id="netTotal" name="netTotal" value="${product.netTotal}" readonly>
		            </div>
		        </div>

		        <div class="form-row">
		            <div class="form-group">
		                <label for="type">Type</label>
		                <select id="type" name="type" value="${product.type}" required>
		                    <option value="">Select</option>
		                    <option value="In Stock" ${product.type == 'In Stock' ? 'selected' : ''}>In Stock</option>
		                    <option value="Out of Stock" ${product.type == 'Out of Stock' ? 'selected' : ''}>Out of Stock</option>
		                </select>
		            </div>
		        </div>
				<button type="submit">Submit</button>
		    </div>
		</form>

        <div id="productList" class="section">
            <h2>Product List</h2>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>ProductId</th>
                        <th>Product Name</th>
                        <th>Quantity</th>
                        <th>Cost</th>
                        <th>GST %</th>
                        <th>SGST</th>
                        <th>CGST</th>
                        <th>Total GST</th>
                        <th>Net Total</th>
                        <th>Type</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="product" items="${productList}">
                        <tr>
                            <td>${product.id}</td>
                            <td>${product.barcode}</td>
                            <td>${product.name}</td>
                            <td>${product.quantity}</td>
                            <td>${product.cost}</td>
                            <td>${product.gstPercentage}</td>
                            <td>${product.sgstAmount}</td>
                            <td>${product.cgstAmount}</td>
                            <td>${product.totalGst}</td>
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
