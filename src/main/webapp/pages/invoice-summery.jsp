<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
	<link href="https://fonts.googleapis.com/css2?family=Fredoka+One&display=swap" rel="stylesheet">

    <title>Invoice Summary</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: url('/pages/pp.jpg') no-repeat center center fixed;
            background-size: cover;
            margin: 0;
            padding: 0;
            color: #333;
        }
		.project-name {
		    font-family: 'Fredoka One', cursive;
		    font-size: 36px;
		    color: #ffffff; /* Bright white */
		    letter-spacing: 1px;
		    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.4); /* Adds depth */
		    margin-left: 15px;
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

        p {
            font-size: 16px;
            margin-bottom: 10px;
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

        h3 {
            text-align: right;
            margin-top: 20px;
            font-size: 18px;
            font-weight: bold;
        }

        .success-message {
            background-color: #d4edda;
            color: #155724;
            padding: 5px 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            border: 1px solid #c3e6cb;
            display: none;  /* Initially hidden */
        }

        .success-message.show {
            display: block;  /* Show message when necessary */
        }

        .buttons {
            display: flex;
            gap: 20px;
            margin-top: 30px;
            justify-content: center;
            align-items: center;
        }

        button, input[type="submit"] {
            background-color: #0074cc;
            color: white;
            padding: 10px 25px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            min-width: 100px;  /* Ensure buttons have a fixed width */
            margin: 0; /* Ensure no margin is applied */
            vertical-align: middle;
        }

        button:hover, input[type="submit"]:hover {
            background-color: #005fa3;
        }

    </style>
</head>
<body>
<div class="container">
    <div class="section">
        <h2>Invoice Summary</h2>
        <c:if test="${not empty saveSuccess}">
            <div class="success-message show">
                ✅ ${saveSuccess}
            </div>
        </c:if>

        <p><strong>Customer Name:</strong> ${customerName}</p>
        <p><strong>Customer Mobile:</strong> ${customerPhoneNumber}</p>

        <table>
            <tr>
                <th>ProductId</th>
                <th>Name</th>
                <th>Cost</th>
                <th>GST %</th>
                <th>Net Total</th>
            </tr>
            <c:forEach var="item" items="${invoiceItems}">
                <tr>
                    <td>${item.barcode}</td>
                    <td>${item.name}</td>
                    <td>${item.cost}</td>
                    <td>${item.gst}</td>
                    <td>${item.netTotal}</td>
                </tr>
            </c:forEach>
        </table>
		<h3>Total: ₹<span id="totalAmount">${total}</span></h3>
		<h3>Paid Amount: ₹<span id="paidAmountDisplay">${paidAmount}</span></h3>
		<h3 id="balanceAmountDisplay">Remaining Amount: ₹${balanceAmount}</h3>

        <!-- Amount Paid and Pay Button -->
        <div class="form-group">
            <label for="amountPaid">Amount Paid by Customer:</label>
            <input type="number" id="amountPaid" class="form-control" placeholder="Enter paid amount" rquired oninput="calculateBalance()">
        </div>
       <!-- <button type="button" class="btn btn-success" onclick="calculateBalance()">Pay</button>-->

        <!-- Show Balance -->
        <div id="balanceInfo" class="mt-2" style="font-weight: bold;"></div>

        <div class="buttons">
            <c:choose>
                <c:when test="${not empty saveSuccess}">
                    <button disabled>Saved</button>
                </c:when>
                <c:otherwise>
                    <form action="/save-invoice" method="post" onsubmit="return prepareInvoiceForm()">
                        <input type="hidden" name="customerName" value="${customerName}"/>
                        <input type="hidden" name="customerPhoneNumber" value="${customerPhoneNumber}"/>
                        <input type="hidden" name="invoiceNumber" value="${invoiceNumber}"/>
                        <input type="hidden" id="hiddenPaidAmount" name="paidAmount"/>
                        <input type="hidden" id="hiddenBalanceAmount" name="balanceAmount"/>

                        <input type="submit" value="Save"/>
                    </form>
                </c:otherwise>
            </c:choose>

           
            <p><a href="/invoice-list">View All Invoices</a></p>
        </div>
    </div>
</div>
<script>
	function calculateBalance() {
	    const total = parseFloat("${total}");  // Ensure total is available from the backend
	    const paid = parseFloat(document.getElementById("amountPaid").value) || 0;
	    const balance = paid - total;

	    // Update Paid Amount
	    document.getElementById("paidAmountDisplay").innerText = paid.toFixed(2);

	    // Update Balance Amount
		const balanceDisplay = document.getElementById("balanceAmountDisplay");

		
	    if (balance > 0) {
	        balanceDisplay.innerText = "Excess Amount: ₹" + balance.toFixed(2);
	    } else if (balance < 0) {
	        balanceDisplay.innerText = "Remaining Amount: ₹" + Math.abs(balance).toFixed(2);
	    } else {
	        balanceDisplay.innerText = "Payment complete.";
	    }
	    balanceDisplay.style.display = "block";  // Make sure it is visible

	    // Store hidden values for backend saving
	    document.getElementById("hiddenPaidAmount").value = paid.toFixed(2);
	    document.getElementById("hiddenBalanceAmount").value = balance.toFixed(2);
	}

	function prepareInvoiceForm() {
	    // If the hidden paid amount isn't set, calculate balance and update hidden fields
	    const paidAmount = parseFloat(document.getElementById("hiddenPaidAmount").value) || 0;
	    const total = parseFloat("${total}"); // Ensure total is available
	    const balanceAmount = paidAmount - total;

	    if (paidAmount === 0 || isNaN(paidAmount)) {
	        // If no paid amount, calculate balance
	        calculateBalance();
	    } else {
	        // Otherwise, store calculated balance in hidden input
	        document.getElementById("hiddenBalanceAmount").value = balanceAmount.toFixed(2);
	    }

	    return true; // Continue form submission
	}

</script>

</body>
</html>
