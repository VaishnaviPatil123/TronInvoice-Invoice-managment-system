<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Invoice Detail</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: url('/pages/pp.jpg') no-repeat center center fixed;
            background-size: cover;
            margin: 0;
            padding: 0;
        }

        header {
            background: linear-gradient(to right, #004466, #006080);
            padding: 15px 30px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        nav a {
            margin-left: 25px;
            color: white;
            text-decoration: none;
        }

        .container {
            padding: 30px;
        }

        .section {
            background: #ffffffdd;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 20px;
        }

        h2 {
            color: #004466;
            margin-bottom: 20px;
        }

        .table-wrapper {
            overflow-x: auto;
        }

		table {
		    width: 100%;
		    border-collapse: collapse;
		    font-size: 14px;
		    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
		    table-layout: fixed; /* Ensures the table adjusts its columns to fit */
		}

		th, td {
		    padding: 10px;
		    border: 1px solid #ddd;
		    text-align: center;
		    word-wrap: break-word; /* Ensures content that overflows will break onto the next line */
		}

		th {
		    background-color: #0074cc;
		    color: white;
		}

		td {
		    background-color: #f4f8fa;
		}

		@media (max-width: 768px) {
		    table {
		        font-size: 12px; /* Adjust font size for smaller screens */
		    }

		    th, td {
		        padding: 8px; /* Reduce padding on smaller screens */
		    }
		}

        .actions {
            display: flex;
            justify-content: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .actions a {
            text-decoration: none;
            color: #006080;
            font-weight: 600;
            padding: 6px 10px;
            border-radius: 4px;
            border: 1px solid #006080;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .actions a:hover {
            background-color: #006080;
            color: white;
        }

        .buttons {
            margin-top: 10px;
            text-align: center;
        }

        .customer-info, .invoice-info {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
        }

        .customer-info p, .invoice-info p {
            margin: 0;
            padding: 5px 10px;
        }

        .customer-info {
            gap: 20px;
        }

        .balance-info {
            font-size: 18px;
        }

        .remaining {
            color: red;
        }

        .excess {
            color: green;
        }

        /* Fix alignment of customer and invoice info */
        .customer-info p, .invoice-info p {
            flex: 1; /* Ensures both parts are equally spaced */
            white-space: nowrap;
        }
		.btn-print {
		    background-color: #006080;
		    color: white;
		    font-size: 16px;
		    padding: 10px 20px;
		    border: none;
		    border-radius: 6px;
		    cursor: pointer;
		    transition: background-color 0.3s ease, transform 0.3s ease;
		    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
		}

		.btn-print:hover {
		    background-color: #005060;
		    transform: scale(1.05);
		}

		.btn-print:focus {
		    outline: none;
		    box-shadow: 0 0 0 3px rgba(0, 96, 128, 0.5);
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

    <script>
        function printInvoice() {
            // Hide unnecessary elements before printing
            document.querySelector('header').style.display = 'none';
            document.querySelector('.buttons').style.display = 'none';

            // Print the content of the page
            window.print();

            // Show the hidden elements again after printing
            document.querySelector('header').style.display = 'block';
            document.querySelector('.buttons').style.display = 'block';
        }
    </script>
</head>
<link href="https://fonts.googleapis.com/css2?family=Fredoka+One&display=swap" rel="stylesheet">

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
        <h2>Invoice Detail</h2>

        <!-- Customer Info Section -->
        <div class="customer-info">
            <p><strong>Customer Name:</strong> ${customerName}</p>
            <p><strong>Customer Mobile:</strong> ${customerPhoneNumber}</p>
        </div>

        <!-- Invoice Info Section -->
        <div class="invoice-info">
            <p><strong>Invoice ID:</strong> ${invoice.id}</p>
            <p><strong>Invoice Number:</strong> ${invoice.invoiceNumber}</p>
        </div>

        <!-- Table for Invoice Items -->
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>ProductId</th>
                        <th>Name</th>
                        <th>Quantity</th>
                        <th>Cost</th>
                        <th>GST (%)</th>
                        <th>Net Total</th>
                        <th>Date & Time</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Loop through invoice items -->
                    <c:forEach var="item" items="${invoiceItems}">
                        <tr>
                            <td>${item.barcode}</td>
                            <td>${item.name}</td>
                            <td>${item.quantity}</td>
                            <td>${item.cost}</td>
                            <td>${item.gst}</td>
                            <td>${item.netTotal}</td>
                            <td>${item.creationDateTime}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Amount Details Section -->
        <div class="balance-info">
            <h3>Total: ₹<span id="totalAmount">${total}</span></h3>
            <h3>Paid Amount: ₹<span id="paidAmountDisplay">${paidAmount}</span></h3>
            <h3 id="balanceAmountDisplay">
                <c:choose>
                    <c:when test="${balanceAmount < 0}">
                        <span class="remaining">Remaining Amount: ₹${-balanceAmount}</span>
                    </c:when>
                    <c:when test="${balanceAmount > 0}">
                        <span class="excess">Excess Amount: ₹${balanceAmount}</span>
                    </c:when>
                    <c:otherwise>
                        Paid in full
                    </c:otherwise>
                </c:choose>
            </h3>
        </div>

        <!-- Print Button -->
        <div class="buttons">
            <button class="btn-print" onclick="printInvoice()">Print</button>
        </div>
    </div>
</div>

</body>
</html>
