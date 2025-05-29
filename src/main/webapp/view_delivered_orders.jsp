<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="dao.*, java.util.*, java.sql.*, model.*"%>
<%
    // Retrieve cookies from the request
    Cookie[] cookies = request.getCookies();
    Cookie myCookie = null;
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("user".equals(cookie.getName())) {
                myCookie = cookie;
                break;
            }
        }
    }
    EmployeeDAO employeeDAO = new EmployeeDAO();
    int employee_id = Integer.parseInt(myCookie.getValue());
    Employee admin = employeeDAO.get(Integer.parseInt(myCookie.getValue()));
    System.out.println(String.format("%d\n%s\n%s\n%s", admin.getId(), admin.getEmail(), admin.getPassword(), admin.isVerified()+""));
    if (!admin.isVerified()) {
    	request.getRequestDispatcher("/waitingEmployee.jsp").forward(request, response);
    }
    
	EnterpriseDAO enterprise = new EnterpriseDAO();
	ResultSet resultSet = enterprise.getBriefDeliveredOrderDetail();
%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Customer List</title>
    <link
      rel="stylesheet"
      href="//cdn.datatables.net/2.1.3/css/dataTables.dataTables.min.css"
    />
    <script src="//code.jquery.com/jquery-3.7.1.js"></script>
    <script src="//cdn.datatables.net/2.1.3/js/dataTables.min.js"></script>
    <style>
      /* General Page Styles */
      body {
        font-family: Arial, sans-serif;
        color: #333;
        background-color: #f9f9f9;
        margin: 0;
        padding: 0;
        border-radius: 8vh;
      }

      table {
        border-radius: 8vh;
      }

      h1 {
        color: #ff66b2;
        text-align: center;
        padding: 20px 0;
        background: #fff;
        margin-bottom: 20px;
        border-bottom: 2px solid #ff66b2;
      }

      .circle-photo {
        border-radius: 50%;
        width: 50px;
        height: 50px;
        object-fit: cover;
      }

      /* Table Styles */
      table.dataTable {
        width: 90%;
        margin: 20px auto;
        border-collapse: separate;
        border-spacing: 0;
        background: #fff;
        border-radius: 10px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
      }

      table.dataTable thead {
        background: #ff66b2;
        color: #fff;
      }

      table.dataTable thead th {
        padding: 15px;
        text-align: center;
        border-bottom: 2px solid #fff;
      }

      table.dataTable tbody td {
        padding: 15px;
        text-align: center;
        vertical-align: middle;
        border-bottom: 1px solid #ddd;
      }

      table.dataTable tbody tr:hover {
        background: #f2f2f2;
      }

      table.dataTable tbody td img {
        display: block;
        margin: 0 auto;
      }

      table.dataTable button.view-detail {
        background-color: #ff66b2;
        color: #fff;
        border: none;
        padding: 7px 15px;
        border-radius: 5px;
        cursor: pointer;
      }

      table.dataTable button.view-detail:hover {
        background-color: #e55b9d;
      }

      /* Responsive adjustments */
      @media (max-width: 400px) {
        table.dataTable thead {
          display: none;
        }
        table.dataTable tbody td {
          display: block;
          text-align: right;
          padding-left: 50%;
          position: relative;
        }
        table.dataTable tbody td:before {
          content: attr(data-label);
          position: absolute;
          left: 0;
          width: 50%;
          padding-left: 15px;
          font-weight: bold;
          text-align: left;
        }
        table.dataTable tbody td img {
          margin: 10px auto;
        }
      }

      @media (min-width: 1000px) {
        #mainSection {
          width: 90vw;
          margin: auto;
          border-radius: 8vh;
        }
      }

      /* Password Form Styles */
      #passwordFormDiv {
        display: none;
        border: 1px solid #ccc;
        padding: 20px;
        margin-top: 20px;
        width: 300px;
        height: 170px;
        border-radius: 5vh;
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        background-color: white;
        z-index: 1001;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
      }
      
      input {
      	margin-top: 5%;
      	margin-left: 15%;
      	width: 63%;
      	padding: 5px;
      	height: 20px;
      	border-radius: 3vh;
      }


	  #password-label {
	  	width: 100%;
	  	margin: 37.5%;
	  	color: pink;
	  	font-weight: bold;
	  	font-size: 18px;
	  }
	  .buttons-class {
	  	display: flex;
	  	justify-content: center;
	  	flex-wrap: wrap;
	  }
      .btn {
      	border-radius: 3vh;
        padding: 10px 20px;
        font-size: 16px;
        border: none;
        cursor: pointer;
        margin: 5px;
      }

      .cancel-btn {
        background-color: red;
        color: white;
      }

      .confirm-btn {
        background-color: blue;
        color: white;
      }
      
      .btn:hover {
      	font-size: 17px;
      }

      /* Backdrop Styles */
      #backdrop {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.5);
        z-index: 1000;
        backdrop-filter: blur(5px);
      }
    </style>
  </head>
  <body>
    <div id="backdrop"></div>
    <div class="passworFromDiv" id="passwordFormDiv">
      <form id="passwordForm" action="http://localhost:8080/JavaServerPagesFirst/OrderController" method="get">
        <label id="password-label" for="password">Password</label><br>
        <input type="password" id="password" name="password" required />
        <input type="hidden" id="c_id" name="c_id">
        <input type="hidden" name="action" value="verify">
        <input type="hidden" id="customer_id" name="customer_id">
        <input type="hidden" name="deliverer" value="<%=employee_id%>">
        <br /><br />
        <div class="buttons-class">
        	<button type="button" class="btn cancel-btn" id="cancelBtn" onclick="hidePasswordForm()">Cancel</button>
        	<button type="submit" class="btn confirm-btn">Confirm</button>
        </div>
      </form>
    </div>

    <section id="mainSection">
      <h1>Delivered Order List</h1>
      <table id="myTable" class="display">
        <thead>
          <tr>
            <th>Date</th>
            <th>Shop Name</th>
            <th>Amount</th>
            <th>Status</th>
            <th>View Detail</th>
          </tr>
        </thead>
        <tbody>
          <%
            int i = 1;
            while (resultSet.next()) {
          %>
          <tr data-id="<%= i %>">
            <td data-label="Date"><%= resultSet.getString("order_date") %></td>
            <td>
              <%= resultSet.getString("shop_name") %> (
              <%= resultSet.getString("customer_city") %>)
            </td>
            <td><%= enterprise.getTotalPrice(resultSet.getString("order_id")) %></td>
            <td>
              <button class="view-detail" id="showFormBtn">
				Delivered
			  </button>
            </td>
            <td>
              <a
                href="view_order_details.jsp?order_id=<%= resultSet.getString("order_id") %>&id=<%= resultSet.getString("customer_id") %>"
              >
                <button class="view-detail" id="view-detail">View Detail</button>
              </a>
            </td>
          </tr>
          <%
              i++;
            }
          %>
        </tbody>
      </table>
    </section>

    <script>
      $(document).ready(function () {
        $("#myTable").DataTable({
          columnDefs: [{ orderable: false, targets: [0, 3] }],
        });

        $("#myTable").on("click", "#view-detail", function () {
          let $row = $(this).closest("tr");
          let itemId = $row.data("id");
          window.location.href = `details.html?id=${itemId}`;
        });
      });

     

      function hidePasswordForm() {
        document.getElementById("passwordFormDiv").style.display = "none";
        document.getElementById("backdrop").style.display = "none";
      }
    </script>
  </body>
</html>

