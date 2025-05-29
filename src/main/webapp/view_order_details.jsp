<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="dao.*, model.*,java.sql.*"%>
<%
System.out.println(request.getParameter("order_id"));
CustomerDAO customerDAO = new CustomerDAO();
Customer customer = customerDAO.get(Integer.parseInt((String)request.getParameter("id")));
EnterpriseDAO enterpriseDAO = new EnterpriseDAO();
System.out.println();
ResultSet miniorders = enterpriseDAO.getMiniorders(request.getParameter("order_id"));
ResultSet orderInfo = enterpriseDAO.getBriefOrderDetail(request.getParameter("order_id"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Item Details</title>
    <link rel="stylesheet" href="//cdn.datatables.net/2.1.3/css/dataTables.dataTables.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <script src="//code.jquery.com/jquery-3.7.1.js"></script>
    <script src="//cdn.datatables.net/2.1.3/js/dataTables.min.js"></script>
    <style>
		/* General Page Styles */
		*{
			font-family: 'Poppins', sans-serif;
		}
		
		body {
			 background: linear-gradient(
			     to bottom,
			     #ffa1e4 1%,
			     #ffcbf1,
			     #fffff055 30%,         
			     #fffff0 50%, 
			     ivory 80%,      
			     #e0ffff          
			 );
			color: #333;
			background-color: #f9f9f9;
			margin: 0;
			padding: 0;
		}
		
		h1 {
			font-size: 2em;
			font-weight: 500;
			color: #ff66b2; /* Pink color */
			text-align: center;
			padding: 20px 0;
		    text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.2);
		}
		
		.noticeable{
			margin: 25px auto;
			width: 25%;
			padding: 12px;
			border-radius: 10px;
			border: 3px solid #ff4dbe99;
			box-shadow: 0 4px 8px #ff4dbe55;
			color: #fa3a94;
			font-size: 2.1em;
			font-weight: 600;
			background-color: #fffff088;
		}
		
		.profile-header {
		    display: flex;
		    align-items: center;
		    margin-bottom: 20px;
		}
		
		.profile-image {
		    width: 100px;
		    height: 100px;
		    border-radius: 50%;
		    margin-right: 20px;
		}
		
		.profile-header span {
		    font-size: 2rem; /* Adjust as needed */
		    color: #00383d; 	
		    font-weight: 600;
		    
		}
		
		/* Profile Image Container */
		.profile-container {
		    max-width: 1200px; /* Increase width to utilize space */
		    padding: 20px 40px;
			margin: 20px auto;
			width: 65%;
			background: #fff; /* White background */
			border-radius: 10px;
	        border: 2px solid #ff4dbe88;
			box-shadow: 0 4px 8px #ff4dbe44;
		}
		
		.profile-container img {
		    border-radius: 50%;
		    width: 100px; /* Increased size */
		    height: 100px;
		    object-fit: cover;
	        border: 2px solid #ff4dbe;
			box-shadow: 0 4px 8px #ff4dbe88;
		    margin-right: 20px; /* Increased spacing */
		}
		
		.profile-info {
			display: flex;
			flex-direction: column;
			width: 100%;
		    margin-bottom: 20px;
		}
		
		/* Info Section Styling */
		.info-section {
		    display: flex;
		    flex-direction: column;
		    gap: 20px;
		    margin-top: 20px;
		}
		
		.info-row {
		    display: flex;
		    flex-wrap: wrap;
		    gap: 10px;
		}
		
		.info-item {
		    flex: 1 1 30%; /* Allows items to take up 30% of the row, adjusting based on content */
		    background-color: #fee5f7;
		    padding: 23px 13px;
		    border-left: 4px solid #ff4dbe;
		    border-radius: 6px;
		    box-sizing: border-box;
		}
		
		.info-item strong {
		    font-size: 1.25rem;
		    font-weight: 600;
		    color: #1f2c2c;
		    padding-right: 5px;	
		}
		
		.info-item span {
		    font-size: 1.15rem;
		    color: #00383d;
		}
		
		/* Table Styles */
		table.dataTable {
			width: 100%;
			border-collapse: collapse;
			background: #fff; /* White background */
			border-radius: 10px;
			overflow: hidden;
			margin-bottom: 20px;
		}
		
		table.dataTable thead {
			background: #ff66b2; /* Pink color */
			color: #fff;
		}
		
		table.dataTable th, table.dataTable td {
			padding: 10px;
			text-align: left;
			border-bottom: 1px solid #ddd;
		}
		
		table.dataTable tbody tr {
    		transition: background-color 0.3s ease;
    	}
		
		table.dataTable tbody tr:hover {
			background: #f2f2f2;
		}
		
		.status-container {
			width: 87%;
			margin: 20px auto;
			max-width: none;
		    padding: 20px;
		    border-radius: 10px;
		    background: #fff;
		    display: flex;
		    flex-direction: row; /* Row direction for status items */
		    justify-content: space-between;
		    flex-wrap: wrap;
		    align-items: center;
		    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
		}
		
		.status-container .status-item {
			padding: 10px;
			margin-bottom: 10px;
			font-size: 1rem;
			color: #555;
			margin-bottom: 10px;
		}
		
		.status-container .status-item p {
			margin: 0;
		}
		
		.status-container .status-item .status-text {
			color: #4caf50; /* Green color for statuses */
			font-weight: bold;
		}
		
		.status-container .status-item .status-text.not-active {
			color: #ccc; /* Grey color for inactive statuses */
		}
		
		#myTable {
		    width: 90% !important;
		    margin: 0 auto;
		    border-radius: 10px;
		    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
		}
		
		.align-left {
		    text-align: left !important;
		}

		.align-left:first-child {
		    padding-left: 100px !important;
		}
		
		tr td:nth-child(3).align-left {
		    padding-left: 200px !important;
		}
		
		tr td:nth-child(4).align-left {
		    padding-left: 280px !important;
		}
		
		.map-container {
			display: flex;
			justify-content: center;
		}
		
		.map-container #map {
			margin-top: 4vh;
			margin-bottom: 8vh;
			height: 60vh;
			width: 80vw;
			border-radius: 4vh;
		    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
		}
		
		@media ( max-width : 800px) {
			.status-container {
				justify-content: flex-start !important;
			}
			.status-item:nth-child(-n+3) {
				width: 100% !important; /* Corrected */
			}
			.status-item:nth-child(n+4) {
				width: 50% !important; /* Corrected */
			}
		}
</style>
</head>
<body>
    <h1 class = "noticeable">View Detail Page</h1>
    
    <%
    if (orderInfo.next()) {
    %>
    <!-- Profile Image Section -->
    <section class="profile-container">
    	<div class = "profile-header">
            <img src="<%=request.getContextPath() + "/userProfile/" + customer.getProfile_pic() %>" alt="Profile Image" class = "profile-image"/>
            <span><%=customer.getName()%></span>
    	</div>
        <div class="profile-info">
		    <div class="info-section">
	            <div class="info-row">
	            	<div class = "info-item">
						<strong>Date :</strong>
		                <span><%=orderInfo.getString("order_date")%></span>
	            	</div>
	            	<div class = "info-item">
	            		<strong>Shop :</strong>
						<span><%=customer.getShop_name()%></span>
	            	</div>
	            </div>
	            <div class="info-row">
	            	<div class = "info-item">
	            		<strong>City :</strong>
	            		<span><%=orderInfo.getString("customer_city")%></span>
	            	</div>
	            	<div class = "info-item">
	            		<strong>Phone number :</strong>
	            		<span><%=customer.getPhone()%></span>
	            	</div>
	            </div>
	        </div>
        </div>
    </section>
    <%
    }
    %>

    <section>
        <h1>Product Details</h1>
        <table id="myTable" class="display" style="width:100%">
            <thead>
                <tr>
                    <th>No.</th>
                    <th>Name</th>
                    <th>Quantity</th>
                    <th>Price per piece</th>
                    <th>Amount</th>
                </tr>
            </thead>
            <tbody>
            <%
            double total = 0;
            int i = 1;
            while (miniorders.next()) {
            %>
                <tr data-id="<%=i%>">
                    <td class = "align-left"><%=i%></td>
                    <td><%=miniorders.getString("product_name") %></td>
                    <td class = "align-left"><%=miniorders.getString("quantity") %></td>
                    <td class = "align-left"><%=miniorders.getString("product_price") %></td>
                    <td><%=miniorders.getString("total_price") %></td>
                </tr>
            <%
            total += miniorders.getDouble("total_price");
            i++;
            }
            %>
            </tbody>
            <tfoot>
            	<tr>
            		<td colspan='4'></td>
            		<td><strong style="font-weight: 600;">Total :</strong> <%=total%>0</td>
            	</tr>
            </tfoot>
        </table>
    </section>
	<%
	orderInfo = enterpriseDAO.getOrderDetail(request.getParameter("order_id"));
	if (orderInfo.next()) {
	%>
    <!-- Status Section -->
    <section class="status-container">
        <div class="status-item">
            <p>Delivery Status:</p>
            <p class="status-text" id="deliveryStatus"><%=orderInfo.getString("delivery_status")%></p>
        </div>
        <div class="status-item">
            <p>Verification:</p>
            <%
            String verified = "not verified";
            if (orderInfo.getString("delivery_status").equals("delivered")) {
            	verified = "verified";
            }
            %>
            <p class="status-text" id="verificationStatus"><%=verified%></p>
        </div>
        <div class="status-item">
            <p>Paid:</p>
            <%
            String paid = "not paid";
            if (orderInfo.getBoolean("is_paid")) {
            	paid = "paid";
            }
            %>
            <p class="status-text" id="paidStatus"><%=paid%></p>
        </div>
        <div class="status-item">
            <p>Deliverer:</p>
            <p class="status-text" id="deliverer"><%=orderInfo.getString("deliverer") %></p>
        </div>
        <div class="status-item">
            <p>Delivery Date:</p>
            <p class="status-text" id="deliveryDate"><%=orderInfo.getString("delivery_date") %></p>
        </div>
    </section>
    <%} %>
    
        <div class="map-container">
		<iframe id="map" frameborder="1"
			style="border: 0"
			src="https://www.google.com/maps?q=<%= customer.getLatitude() %>,<%= customer.getLongitude() %>&hl=es;z=14&output=embed"
			allowfullscreen> </iframe>
		</div>

    <script>
        $(document).ready(function() {
            // Initialize DataTable
            $('#myTable').DataTable({
                "ordering": false, // Disable sorting
                "paging": false, // Disable pagination
                "info": false, // Disable information display
                "searching": false // Disable search function
            });
        });
    </script>
</body>
</html>
