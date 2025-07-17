<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Today's Invoices</title>
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
            margin: 20px auto;
            max-width: 600px;
            font-weight: 600;
        }

        .container {
            padding: 30px;
            max-width: 95%;
            margin: auto;
            background-color: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            box-shadow: 0 0 15px rgba(0,0,0,0.3);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
            overflow-x: auto;
        }

        th, td {
            padding: 10px 8px;
            border: 1px solid #ccc;
            text-align: center;
            font-size: 14px;
            vertical-align: top;
        }

        th {
            background-color: #004466;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tr:hover {
            background-color: #e0f0ff;
        }

        .back-button {
            display: inline-block;
            padding: 10px 20px;
            background-color: #004466;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
            transition: background-color 0.3s;
        }

        .back-button:hover {
            background-color: #006080;
        }
    </style>
</head>
<body>

<h2>Today's Invoice List</h2>

<div class="container">
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
                
            </tr>
        </thead>
        <tbody>
            <c:forEach var="invoice" items="${todaysInvoices}">
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
                   
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <a href="/dashboard" class="back-button">Back to Dashboard</a>
</div>

</body>
</html>
