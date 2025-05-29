<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="dao.*, model.*,java.sql.*"%>
<%
String id = request.getParameter("id");
CustomerDAO customerDAO = new CustomerDAO();
Customer customer = customerDAO.get(Integer.parseInt(id));
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
			font-family: 'Poppins', sans-serif !important;
		}
		
		body {
			color: #333;
			background: linear-gradient(
			    to bottom,
			    #ffa1e4 1%,
			    #ffcbf1,        
			    #fffff0 50%, 
			    ivory       
			);
			margin: 0;
			padding: 0;
		}

		h1 {
			font-size: 2.1em;
			color: #ff66b2; /* Pink color */
			text-align: center;
			padding: 20px 0;
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
		
		table.dataTable tbody tr:hover {
			background: #f2f2f2;
		}
		
		#myTable {
			width: 80vw !important;
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
</style>
</head>
<body>
    <h1 class = "noticeable">View Detail Page</h1>
    <!-- Profile Image Section -->
    <section class="profile-container">
    	<div class = "profile-header">
            <img src="<%=request.getContextPath() + "/userProfile/" + customer.getProfile_pic()%>" alt="Profile Image">
            <span><%=customer.getName()%> </span>
			<span> (<%=customer.getShop_name()%>)</span>
    	</div>
        <div class="profile-info">
        	<div class = "info-section">
	            <div class="info-row">
	            	<div class = "info-item">
	            		<strong>ID : </strong>
	                	<span><%=customer.getId()%></span>
	            	</div>
	            	<div class = "info-item">
	            		<strong>Email : </strong>
		                <span><%=customer.getEmail()%></span>
		            </div>
	            </div>
	            <div class="info-row">
	            	<div class = "info-item">
	            		<strong>City : </strong>
		                <span><%=customer.getAddress()%></span>
		            </div>
	            	<div class = "info-item">
	            		<strong>Phone number : </strong>
		                <span><%=customer.getPhone() %></span>
		            </div>
	            </div>
        	</div>
        </div>
    </section>
    
        <div class="map-container">
		<iframe id="map" frameborder="1"
			style="border: 0"
			src="https://www.google.com/maps?q=<%=customer.getLatitude()%>,<%=customer.getLongitude()%>&hl=es;z=14&output=embed"
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
