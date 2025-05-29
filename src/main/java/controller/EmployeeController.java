package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import additional.CheckEmailPassword;
import additional.ImageControl;
import additional.PasswordEncryptor;
import dao.CustomerDAO;
import dao.EmployeeDAO;
import model.Customer;
import model.Employee;
import util.DBConnection;

@WebServlet("/EmployeeController")
@MultipartConfig
public class EmployeeController extends HttpServlet {

	private static final long serialVersionUID = 1L;
	EmployeeDAO employeeDAO = null;

	public EmployeeController() {
		employeeDAO = new EmployeeDAO();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("this is doGet method");
		String action = request.getParameter("action");
		if (action == null) {
			action = "LIST";
		}
		switch (action) {
		case "LIST":
			listEmployee(request, response);
			break;

		case "EDIT":
			getEmployee(request, response);
			break;

		case "delete":
			try {
				fireemp(request, response);
			} catch (NumberFormatException | SQLException | ServletException | IOException e) {
				e.printStackTrace();
			}
			break;

		case "approve":
			try {
				approveEmployee(request, response);
			} catch (ServletException | IOException | SQLException e) {
				e.printStackTrace();
			}
			break;
			
		case "logout":
			logout(request, response);
			break;
			
		
		case "updateSalary":
			try {
				updateSalary(request, response);
			} catch (NumberFormatException | SQLException e) {
				System.out.println("sql erro catch block");
				e.printStackTrace();
			}
			request.getRequestDispatcher("/employeeList.jsp").forward(request, response);
			break;
			
		case "fire":
			try {
				fire(request, response);
			} catch (NumberFormatException | SQLException e) {
				e.printStackTrace();
			}
			break;
		default:
			listEmployee(request, response);
			break;
		}
	}
	
	private void logout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Cookie[] cookies = request.getCookies();
		if (cookies != null) {
			for (Cookie cookie: cookies) {
				if ("user".equals(cookie.getName())) {
					cookie.setValue("-1");
					response.addCookie(cookie);
					break;
				}
			}
		}
		request.getRequestDispatcher("/home.jsp").forward(request, response);
	}
	
	private void fire(HttpServletRequest request, HttpServletResponse response) throws NumberFormatException, SQLException, ServletException, IOException {
		String id = request.getParameter("id");
		if (employeeDAO.checkOngoingExist(Integer.parseInt(id))) {
			HttpSession session = request.getSession();
			session.setAttribute("deletion", "fail");
			request.getRequestDispatcher("/employeeList.jsp").forward(request, response);
		}
		else if (employeeDAO.fire(Integer.parseInt(id))) {
			request.getRequestDispatcher("/employeeList.jsp").forward(request, response);
		}
	}
	
	private void fireemp(HttpServletRequest request, HttpServletResponse response) throws NumberFormatException, SQLException, ServletException, IOException {
		String id = request.getParameter("id");
		if (employeeDAO.checkOngoingExist(Integer.parseInt(id))) {
			HttpSession session = request.getSession();
			session.setAttribute("deletionemp", "fail");
			request.getRequestDispatcher("/employeeprofile.jsp").forward(request, response);
		}
		else if (employeeDAO.fire(Integer.parseInt(id))) {
			request.getRequestDispatcher("/employeeprofile.jsp").forward(request, response);
		}
	}
	
	private void updateSalary(HttpServletRequest request, HttpServletResponse response) throws NumberFormatException, SQLException {
		String id = request.getParameter("id");
		String salary = request.getParameter("salary");
		String forwhom = request.getParameter("forwhom");
		if (forwhom.equals("one")) {
			employeeDAO.updateSalary(Integer.parseInt(id), Double.parseDouble(salary));
		} else {
			employeeDAO.updateSalary(Double.parseDouble(salary));
		}
	}

	private void listEmployee(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		List<Employee> employeeList = employeeDAO.get();
		request.setAttribute("employeelist", employeeList);
		// Forwarding to JSP instead of redirect
		request.getRequestDispatcher("/employeedent-list.jsp").forward(request, response);
	}

	private void getEmployee(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String id = request.getParameter("id");
		Employee employee = employeeDAO.get(Integer.parseInt(id));
		request.setAttribute("employee", employee);
		// Forwarding to JSP instead of redirect
		request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
	}

	private void deleteEmployee(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String id = request.getParameter("id");
		if (employeeDAO.delete(Integer.parseInt(id))) {
			request.setAttribute("MSG", "Successfully Deleted");
		}
		// Recalling listEmployee to refresh the list
		listEmployee(request, response);
	}

	private void approveEmployee(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException, SQLException {
		System.out.println("this is approveEmployee() method");
		String id = request.getParameter("id");
		if (employeeDAO.approve(id)) {
			System.out.println("Successfully approved");
		}
		// Redirect after approval
		response.sendRedirect(request.getContextPath() + "/approval_noti.jsp");
	}

	public static void saveIdAsCookie(HttpServletRequest request, HttpServletResponse response) throws SQLException {
		System.out.println("got into the saveIdAsCookie() method");
		String sql = "SELECT MAX(employee_id) AS id FROM employees";
		Connection connection = DBConnection.openConnection();
		Statement statement = connection.createStatement();
		ResultSet resultSet = statement.executeQuery(sql);
		if (resultSet.next()) {
			String id = resultSet.getString("id");
			System.out.println("the id to save as cookie is " + id);
			Cookie cookie = new Cookie("user", id);
			cookie.setMaxAge(60 * 60 * 24 * 60);
			response.addCookie(cookie);
			System.out.println("successfully saved as cookie.");
		}
	}

	protected boolean doesExist(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, ServletException, IOException {
		if (employeeDAO.doesExist(request.getParameter("employeeEmail"))) {
			HttpSession session = request.getSession();
			session.setAttribute("userExist", true);
			// Redirecting after setting session attribute
			response.sendRedirect(request.getContextPath() + "/emp_register.jsp");
			return true; // Return true if the user exists
		}
		return false; // Return false if the user doesn't exist
	}

	protected void register(HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			System.out.println("got into the try block for doesExist() method");
			// If the user exists, stop further execution
			if (doesExist(request, response)) {
				return;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		String id = request.getParameter("id");
		id = id == null ? "" : id;

		Employee employee = new Employee();
		employee.setName(request.getParameter("employeeName"));

		PasswordEncryptor enc = new PasswordEncryptor();
		employee.setPassword(enc.encrypt(request.getParameter("password")));
		employee.setEmail(request.getParameter("employeeEmail"));
		employee.setPhone(Long.parseLong(request.getParameter("phone")));

		Part file = request.getPart("profilePic");
		ImageControl imageControl = new ImageControl(request.getServletContext());
		String profile = imageControl.saveImage(employee.getName(), file);

		employee.setProfile_pic(profile);
		employee.setVerified(false);

		if (id.isEmpty()) {
			if (employeeDAO.save(employee)) {
				try {
					saveIdAsCookie(request, response);
				} catch (SQLException e) {
					e.printStackTrace();
				}
				// Redirecting and returning to avoid further code execution
				response.sendRedirect(request.getContextPath() + "/waitingEmployee.jsp");
				return;
			}
		} else {
			employee.setId(Integer.parseInt(id));
			if (employeeDAO.update(employee)) {
				request.setAttribute("MSG", "Successfully Updated!");
				// Redirecting after update
				response.sendRedirect(request.getContextPath() + "/emphomeorder.jsp");
				return;
			}
		}

		// Ensure this redirect happens only if the earlier conditions aren't met
		response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
	}

	protected void login(HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("got into the login method()");
		String email = (String) request.getParameter("email");
		String password = (String) request.getParameter("password");
		CheckEmailPassword checker = new CheckEmailPassword();
		if (!employeeDAO.doesExist(email)) {
			HttpSession session = request.getSession();
			session.setAttribute("userExist", false);
			response.sendRedirect(request.getContextPath() + "/emp_login.jsp");
		} else if (!employeeDAO.isPasswordTrue(email, password)) {
			HttpSession session = request.getSession();
			session.setAttribute("checkPassword", false);
			response.sendRedirect(request.getContextPath() + "/emp_login.jsp");
		} else {
			int id = employeeDAO.get(email);
			System.out.println("The id to save as cookie while logging in is " + id);
			Employee employee = employeeDAO.get(id);
			if (employee.isVerified()) {
				Cookie cookie = new Cookie("user", id + "");
				cookie.setMaxAge(60 * 60 * 24 * 60);
				response.addCookie(cookie);
				response.sendRedirect(request.getContextPath() + "/emphomeorder.jsp");
			} else {
				response.sendRedirect(request.getContextPath() + "/waitingEmployee.jsp");
			}
		}

	}
	
	protected void update(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
		String name = request.getParameter("name");
		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
		String id = request.getParameter("id");
		if (employeeDAO.update(id, name, email, phone)) {
			HttpSession session = request.getSession();
			session.setAttribute("MSGupdate", "update");
			request.getRequestDispatcher("/employeeprofile.jsp").forward(request, response);
		}
	}
	
	protected void changePassword(HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("got into the change password method");
		String id = request.getParameter("id");
		String oldPassword = request.getParameter("old-password");
		String newPassword = request.getParameter("new-password");
		System.out.println("old password: " + oldPassword + "\tnew password: " + newPassword);
		
		Employee employee = employeeDAO.get(Integer.parseInt(id));
		String passwordFromDB = employee.getPassword();
		
		PasswordEncryptor e = new PasswordEncryptor();
		String realPassword = e.decrypt(passwordFromDB);
		System.out.println("real password: " + realPassword);
		
		if (realPassword.equalsIgnoreCase(oldPassword)) {
			employee.setPassword(e.encrypt(newPassword));
			System.out.println("emp.getpassword before updating " + e.decrypt(employee.getPassword()));
			employeeDAO.update(employee);
			
			employee = employeeDAO.get(Integer.parseInt(id));
			System.out.println("password changed to " + e.decrypt(employee.getPassword()));
			HttpSession session = request.getSession();
			session.setAttribute("MSG", "passwordchange");
			request.getRequestDispatcher("/employeeprofile.jsp").forward(request, response);
		} else {
			System.out.println("password is incorrect");
			HttpSession session = request.getSession();
			session.setAttribute("MSGwrong", "wrongpassword");
			System.out.println("MSG session stores: " + (String)session.getAttribute("MSGwrong"));
			request.getRequestDispatcher("/employeeprofile.jsp").forward(request, response);
		}
	}
	private void updateProfileImage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    System.out.println("got into update profile image method");  
	        Part filePart = request.getPart("profileImage");
	        
	        ImageControl imageController = new ImageControl(request.getServletContext());
	        String profilePic = imageController.saveImage("something", filePart);

	        String id = request.getParameter("id");
	        employeeDAO = new EmployeeDAO();
	        Employee employee = employeeDAO.get(Integer.parseInt(id));
	        employee.setProfile_pic(profilePic);
	        
	        employeeDAO.update(employee);
	        
	        HttpSession session = request.getSession();
	        session.setAttribute("profileChangeEmp", "success");

	        // Redirect to the profile page
	        response.sendRedirect(request.getContextPath() + "/employeeprofile.jsp");
	    }
	

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("Got into the do post method of employee controller");
		String action = request.getParameter("action");

	    if (action != null) {
	        try {
	            if (action.equals("register")) {
	                register(request, response);
	            } else if (action.equals("login")) {
	                login(request, response);
	            } else if (action.equals("update")) {
	            	update(request, response);
	            } else if (action.equals("passwordChange")) {
	            	changePassword(request, response);
	            }
	            else if(action.equals("updateProfileImage")) {
	            	 updateProfileImage(request, response);	
	            }
	            else {
	                // Handle unknown action
	                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action: " + action);
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred: " + e.getMessage());
	        }
	    } else {
	        // Handle missing action parameter
	        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action parameter is missing.");
	    }
	}
}

	

