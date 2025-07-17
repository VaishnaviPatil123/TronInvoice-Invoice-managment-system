<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Invoice Item List</title>
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
            min-width: 1200px;
        }

        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: center;
        }

        th {
            background-color: #0074cc;
            color: white;
        }

        td {
            background-color: #f4f8fa;
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
        <h2>Invoice Item List</h2>
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>ProductId</th>
                        <th>Name</th>
                        <th>Quantity</th>
                        <th>Cost</th>
                        <th>GST (%)</th>
                        <th>Net Total</th>
                        <th>Customer Name</th>
                        <th>Phone Number</th>
                        <th>Invoice Number</th>
                        <th>Total Amount</th>
                        <th>Paid Amount</th>
                        <th>Balance Amount</th>
                        <th>Date & Time</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="invoice" items="${invoices}">
                        <tr>
                            <td>${invoice.id}</td>
                            <td>
                                <c:forEach var="item" items="${invoice.items}">
                                    <p>${item.barcode}</p>
                                </c:forEach>
                            </td>
                            <td>
                                <c:forEach var="item" items="${invoice.items}">
                                    <p>${item.name}</p>
                                </c:forEach>
                            </td>
                            <td>
                                <c:forEach var="item" items="${invoice.items}">
                                    <p>${item.quantity}</p>
                                </c:forEach>
                            </td>
                            <td>
                                <c:forEach var="item" items="${invoice.items}">
                                    <p>${item.cost}</p>
                                </c:forEach>
                            </td>
                            <td>
                                <c:forEach var="item" items="${invoice.items}">
                                    <p>${item.gst}</p>
                                </c:forEach>
                            </td>
                            <td>
                                <c:forEach var="item" items="${invoice.items}">
                                    <p>${item.netTotal}</p>
                                </c:forEach>
                            </td>
                            <td>${invoice.customerName}</td>
                            <td>${invoice.customerPhoneNumber}</td>
                            <td>${invoice.invoiceNumber}</td>
                            <td>${invoice.totalAmount}</td>
                            <td>${invoice.paidAmount}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${invoice.balanceAmount > 0}">
                                        <span style="color: green;">Excess: ₹${invoice.balanceAmount}</span>
                                    </c:when>
                                    <c:when test="${invoice.balanceAmount < 0}">
                                        <span style="color: red;">Remaining: ₹${-invoice.balanceAmount}</span>
                                    </c:when>
                                    <c:otherwise>
                                        Paid in full
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${invoice.creationDateTime}</td>
                            <td class="actions">
                                <a href="/invoice/detail/${invoice.id}">View Details</a>
                                <a href="/invoice/delete/${invoice.id}">Delete</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

       
    </div>
</div>

</body>
</html>
