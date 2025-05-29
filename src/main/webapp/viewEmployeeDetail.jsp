<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="dao.*, model.*,java.sql.*"%>
<%
String id = request.getParameter("id");
EmployeeDAO employeeDAO = new EmployeeDAO();
Employee employee = employeeDAO.get(Integer.parseInt(id));
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
		    background-size: 100% 100vh; 
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
			width: 90%;
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
		    padding: 25px 15px;
		    border-left: 4px solid #ff4dbe;
		    border-radius: 6px;
		    box-sizing: border-box;
		}
		
		.info-item strong {
		    font-size: 1.3rem;
		    font-weight: 600;
		    color: #1f2c2c;
		    padding-right: 5px;	
		}
		
		.info-item span {
		    font-size: 1.2rem;
		    color: #00383d;
		}
		
		.button-row {
		    display: flex;
		    justify-content: flex-end;
		    margin-top: 40px;
		}
		
		.button-row button {
		    border: none;
		    padding: 13px 20px;
		    border-radius: 2em;
		    margin-left: 20px;
		    cursor: pointer;
		    font-size: 0.9rem;
		    font-weight: bold;
    		transition: background-color 0.3s ease, transform 0.2s ease;
    		box-shadow: rgba(0, 0, 0, 0.1);
		}
		
		.btn-confirm {
			color: #fff !important;
		    background-color: #ff4dbe;
		}
		
		.btn-confirm:hover {
		    background-color: #f01294;
    		transform: scale(1.05);
		}
		
		.btn-confirm:active {
		    transform: scale(0.95);
		}
		
		.btn-danger {
			color: #fff !important;
		    background-color: #ff4d4d;
		}
		
		.btn-danger:hover {
		    background-color: #e60000;
    		transform: scale(1.05);
		}
		
		.btn-danger:active {
		    transform: scale(0.95);
		}
		
		.btn-cancel {
			color: #1f2c2c !important;
			background-color: #e0e0e0 !important;
		}
		
		.btn-cancel:hover {
			background-color: #c9c9c9 !important;
		}
		
		.updateSalary, .fire {
		    display: none;
		    position: fixed;
		    top: 50%;
		    left: 50%;
		    transform: translate(-50%, -50%);
		    background-color: #ffffff;
		    padding: 30px;
		    border-radius: 12px;
		    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
		    z-index: 11;
		    width: 90%; /* Make it responsive */
		    max-width: 500px; /* Ensure a max width */
		    animation: fadeIn 0.3s forwards;
		}
		
		.updateSalary.show, .fire.show {
		    display: block;
		    animation: boxFadeIn 0.3s forwards;
		}
		
		.updateSalary.hide, .fire.hide {
		    animation: boxFadeOut 0.3s forwards;
		}
		
		.updateSalary p, .fire p {
			margin-top: -10px;
		    margin-bottom: 20px;
		    font-size: 1.3rem; /* Slightly larger font */
		    color: #1f2c2c;
		    font-weight: bold;
		}
		
		.fire p {
			text-align: center;
		}
		
		.updateSalary form, .fire form {
		    display: flex;
		    flex-direction: column;
		}
		
		.updateSalary input, .fire input{
			width: 92%;
		    margin-bottom: 10px;
		    padding: 10px;
		    font-size: 0.9rem;
		    border: 1px solid #ccc;
		    border-radius: 5px;
		}
		
		.row {
			display: flex;	
			justify-content: center;
			margin-top: 5px;
			gap: 80px;
					
		}
		.updateSalary button, .fire button {
			font-size: 0.9em;
			font-weight: bold;
		    border: none;
		    cursor: pointer;
		    width: 140px;
		    padding: 10px 15px !important; /* Adjust padding */
		    border-radius: 20px !important;
    		transition: background-color 0.3s ease, transform 0.2s ease;
    		box-shadow: rgba(0, 0, 0, 0.1);
		}

		/* Overlay styles remain the same */
		.overlay {
		    position: fixed;
		    top: 0;
		    left: 0;
		    width: 100%;
		    height: 100%;
		    background-color: rgba(0, 0, 0, 0.5);
		    z-index: 10;
		    display: none;
		}
		
		.overlay.show {
		    display: block;
		    animation: overlayFadeIn 0.3s forwards;
		}
		
		.overlay.hide {
		    animation: overlayFadeOut 0.3s forwards;
		}
		
		/* Custom Dropdown Styles */
		.custom-select-wrapper {
		    position: relative;
		    user-select: none;
		    margin-bottom: 10px;
		    width: 90%;
		}
		
		.custom-select {
		    position: relative;
		    display: flex;
		    align-items: center;
		    cursor: pointer;
		    border: 1px solid #ccc;
		    border-radius: 5px;
		    padding: 10px 15px;
		    background-color: #fff;
		    transition: border-color 0.3s ease;
		    width: 100%;
		}
		
		.custom-select:hover {
		    border-color: #888;
		}
		
		.custom-select__trigger {
		    display: flex;
		    justify-content: space-between;
		    align-items: center;
		    width: 100%;
		}
		
		.custom-select__trigger span {
		    font-size: 1rem;
		    color: #333;
		}
		
		.arrow {
		    width: 0;
		    height: 0;
		    margin-left: 10px;
		    border-left: 6px solid transparent;
		    border-right: 6px solid transparent;
		    border-top: 6px solid #333;
		    transition: transform 0.3s ease;
		}
		
		.custom-select.open .arrow {
		    transform: rotate(180deg);
		}
		
		.custom-options {
			display: flex;
			flex-direction: column;
		    position: absolute;
		    top: calc(100% + 5px);
		    left: 0;
		    width: 100%;
		    background: #fff;
		    border: 1px solid #ccc;
		    border-radius: 5px;
		    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
		    max-height: 0;
		    overflow: hidden;
		    opacity: 0;
		    transition: all 0.3s ease;
		    z-index: 100;
		}
		
		.custom-select.open .custom-options {
		    max-height: 150px;
		    opacity: 1;
		    overflow: auto;
		}
		
		.custom-option {
		    padding: 10px 15px;
		    cursor: pointer;
		    transition: background-color 0.2s ease;
		    font-size: 1rem;
		    color: #333;
		}
		
		.custom-option:hover {
		    background-color: #f2f2f2;
		}
		
		.custom-option.selected {
		    background-color: #e6e6e6;
		    font-weight: bold;
		}
		
		/* Keyframes for falling down animation */
		@keyframes dropDown {
		    0% {
		        transform: translateY(-20px);
		        opacity: 0;
		    }
		    100% {
		        transform: translateY(0);
		        opacity: 1;
		    }
		}
		
		@keyframes overlayFadeIn {
		    from { opacity: 0; }
		    to { opacity: 1; }
		}
		
		@keyframes overlayFadeOut {
		    from { opacity: 1; }
		    to { opacity: 0; }
		}
		
		/* Box animations */
		@keyframes boxFadeIn {
		    from { opacity: 0; transform: translate(-50%, -60%); }
		    to { opacity: 1; transform: translate(-50%, -50%); }
		}
		
		@keyframes boxFadeOut {
		    from { opacity: 1; transform: translate(-50%, -50%); }
		    to { opacity: 0; transform: translate(-50%, -60%); }
		}
		
		/* Keyframes for fade in and fade out */
		@keyframes fadeIn {
		    from { opacity: 0; transform: translate(-50%, -60%); }
		    to { opacity: 1; transform: translate(-50%, -50%); }
		}
		
		@keyframes fadeOut {
		    from { opacity: 1; transform: translate(-50%, -50%); }
		    to { opacity: 0; transform: translate(-50%, -60%); }
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
		
		/* Status Section */
		.status-container {
			margin-left: 15vw;
			margin-right: 15vw;
			margin-top: -3vh;
			max-width: 800px;
			display: flex;
			justify-content: space-between;
			flax-wrap: wrap;
			align-items: flex-end;
			background: #fff; /* White background */
			padding: 20px;
			border-radius: 10px;
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
			
		}
		.updateSalary {
			display: none;
		}
		.fire {
			display: none;
		}
	</style>
</head>
<body>
    <h1 class = "noticeable">View Detail Page</h1>
    <!-- Profile Image Section -->
    <section class="profile-container">
    	<div class="profile-header">
	        <img src="<%=request.getContextPath() + "/userProfile/" + employee.getProfile_pic()%>" alt="Profile Image" class = "profile-image"/>
			<span> <%=employee.getName()%></span>
		</div>
		<div class="profile-info">
		    <div class="info-section">
		        <div class="info-row">
		            <div class="info-item">
		                <strong>ID :</strong>
		                <span><%=employee.getId()%></span>
		            </div>
		            <div class="info-item">
		                <strong>Role :</strong>
		                <span><%=employee.getRole()%></span>
		            </div>
		            <div class="info-item">
		                <strong>Salary :</strong>
		                <span><%=employee.getSalary()%></span>
		            </div>
		        </div>
		        
		        <div class = "info-row">
		            <div class="info-item">
		                <strong>Email :</strong>
		                <span><%=employee.getEmail()%></span>
		            </div>
		            <div class="info-item">
		                <strong>Phone Number :</strong>
		                <span><%=employee.getPhone() %></span>
		            </div>
		        </div>
		    </div>
		    <div class="button-row">
		        <button class = "btn-confirm" onclick="showUpdate()">Update Salary</button>
		        <button class = "btn-danger" onclick="showFire()">Remove <%=employee.getName()%></button>
		    </div>
		</div>
    </section>
    <div class="overlay" id="overlay"></div>

	<div class="updateSalary" id="updateSalary">
	    <form method="get" action="EmployeeController">
	        <input type="hidden" name="action" value="updateSalary">
	        <input type="hidden" name="id" value="<%=employee.getId()%>">
	        <p>Update salary for <%=employee.getName()%></p>
	        <input type="number" required name="salary">
	        <br>
			<div class="custom-select-wrapper">
                <div class="custom-select" tabindex="0">
                    <div class="custom-select__trigger">
                        <span>Update for <%=employee.getName()%> only</span>
                        <div class="arrow"></div>
                    </div>
                    <div class="custom-options">
                        <span class="custom-option selected" data-value="one">Update for <%=employee.getName()%> only</span>
                        <span class="custom-option" data-value="all">Update for all employees</span>
                    </div>
                </div>
                <input type="hidden" name="forwhom" value="one">
            </div>
	        <br>
	        <div class = "row">
	        	<button class = "btn-confirm" type="submit">Update</button>
	        	<button class = "btn-cancel" type="button" class="btn-cancel" onclick="cancelUpdate()">Cancel</button>
	        </div>
	    </form>
	</div>
	
	<div class="fire" id="fire">
	    <form method="get" action="EmployeeController">
	        <input type="hidden" name="action" value="fire">
	        <input type="hidden" name="id" value="<%=employee.getId()%>">
	        <p>Do you really want to remove this employee?</p>
	        <div class = "row">
		        <button class = "btn-danger" type="submit">Remove</button>
		        <button class = "btn-cancel" type="button" onclick="cancelFire()">Cancel</button>
		    </div>
	    </form>
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
        
        document.addEventListener('DOMContentLoaded', function() {
            const customSelectWrapper = document.querySelector('.custom-select-wrapper');
            const customSelect = customSelectWrapper.querySelector('.custom-select');
            const trigger = customSelect.querySelector('.custom-select__trigger');
            const optionsContainer = customSelect.querySelector('.custom-options');
            const optionsList = optionsContainer.querySelectorAll('.custom-option');
            const hiddenInput = customSelectWrapper.querySelector('input[name="forwhom"]');

            // Toggle dropdown open/close
            trigger.addEventListener('click', function(e) {
                e.stopPropagation();
                customSelect.classList.toggle('open');
            });

            // Option selection
            optionsList.forEach(option => {
                option.addEventListener('click', function(e) {
                    e.stopPropagation();
                    // Update selected class
                    optionsList.forEach(o => o.classList.remove('selected'));
                    this.classList.add('selected');
                    // Update trigger text
                    trigger.querySelector('span').textContent = this.textContent;
                    // Update hidden input value
                    hiddenInput.value = this.getAttribute('data-value');
                    // Close dropdown
                    customSelect.classList.remove('open');
                });
            });

            // Close dropdown when clicking outside
            document.addEventListener('click', function(e) {
                if (customSelect.classList.contains('open')) {
                    customSelect.classList.remove('open');
                }
            });

            // Close dropdown with Escape key
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape' && customSelect.classList.contains('open')) {
                    customSelect.classList.remove('open');
                }
            });
        });

        
        function showUpdate() {
            const overlay = document.getElementById('overlay');
            const updateBox = document.getElementById('updateSalary');

            overlay.style.display = "block";
            updateBox.style.display = "block";
            
            overlay.classList.add('show');
            updateBox.classList.add('show');
        }

        function showFire() {
            const overlay = document.getElementById('overlay');
            const fireBox = document.getElementById('fire');

            overlay.style.display = "block";
            fireBox.style.display = "block";
            
            overlay.classList.add('show');
            fireBox.classList.add('show');
        }

        function cancelUpdate() {
            const overlay = document.getElementById('overlay');
            const updateBox = document.getElementById('updateSalary');

            updateBox.classList.remove('show');
            overlay.classList.remove('show');

            updateBox.classList.add('hide');
            overlay.classList.add('hide');

            updateBox.addEventListener('animationend', () => {
                updateBox.style.display = "none";
                overlay.style.display = "none";
                updateBox.classList.remove('hide');
                overlay.classList.remove('hide');
            }, { once: true });
        }

        function cancelFire() {
            const overlay = document.getElementById('overlay');
            const fireBox = document.getElementById('fire');

            fireBox.classList.remove('show');
            overlay.classList.remove('show');

            fireBox.classList.add('hide');
            overlay.classList.add('hide');

            fireBox.addEventListener('animationend', () => {
                fireBox.style.display = "none";
                overlay.style.display = "none";
                fireBox.classList.remove('hide');
                overlay.classList.remove('hide');
            }, { once: true });
        }

        document.getElementById('overlay').addEventListener('click', function() {
            cancelUpdate();
            cancelFire();
        });

    </script>
</body>
</html>
