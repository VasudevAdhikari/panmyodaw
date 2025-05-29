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
import dao.AdminDAO;
import dao.CustomerDAO;
import model.Admin;
import model.Customer;
import util.DBConnection;

@WebServlet("/AdminController")
@MultipartConfig
public class AdminController extends HttpServlet {

	private static final long serialVersionUID = 1L;
	AdminDAO adminDAO = null;

	public AdminController() {
		adminDAO = new AdminDAO();
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
			listAdmin(request, response);
			break;

		case "EDIT":
			getAdmin(request, response);
			break;

		case "delete":
			System.out.println("delete case");
			deleteAdmin(request, response);
			break;

		case "approve":
			try {
				System.out.println("got into the approve section.");
				approveAdmin(request, response);
			} catch (ServletException | IOException | SQLException e) {
				e.printStackTrace();
			}
			break;
			
		case "logout":
			logout(request, response);
			break;

		default:
			listAdmin(request, response);
			break;
		}
	}
	
	private void logout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Cookie[] cookies = request.getCookies();
		if (cookies != null) {
			for (Cookie cookie: cookies) {
				if ("admin".equals(cookie.getName())) {
					cookie.setValue("-1");
					response.addCookie(cookie);
					break;
				}
			}
		}
		request.getRequestDispatcher("/home.jsp").forward(request, response);
	}

	private void listAdmin(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		List<Admin> adminList = adminDAO.get();
		request.setAttribute("adminlist", adminList);
		// Forwarding to JSP instead of redirect
		request.getRequestDispatcher("/admindent-list.jsp").forward(request, response);
	}

	private void getAdmin(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String id = request.getParameter("id");
		Admin admin = adminDAO.get(Integer.parseInt(id));
		request.setAttribute("admin", admin);
		// Forwarding to JSP instead of redirect
		request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
	}

	private void deleteAdmin(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("Got into delete admin method");
		String id = request.getParameter("id");
		if (adminDAO.delete(Integer.parseInt(id))) {
			request.setAttribute("MSG", "Successfully Deleted");
			Cookie[] cookies = request.getCookies();
			for (Cookie cookie: cookies) {
				if ("admin".equals(cookie.getName())) {
					cookie.setValue("-1");
					response.addCookie(cookie);
					break;
				}
			}
			request.getRequestDispatcher("/home.jsp").forward(request, response);
		}
	}

	private void approveAdmin(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException, SQLException {
		System.out.println("this is approveAdmin() method");
		String id = request.getParameter("id");
		if (adminDAO.approve(id)) {
			System.out.println("Successfully approved");
		}
		// Redirect after approval
		response.sendRedirect(request.getContextPath() + "/approval_noti.jsp");
	}

	public static void saveIdAsCookie(HttpServletRequest request, HttpServletResponse response) throws SQLException {
		System.out.println("got into the saveIdAsCookie() method");
		String sql = "SELECT MAX(admin_id) AS id FROM admins";
		Connection connection = DBConnection.openConnection();
		Statement statement = connection.createStatement();
		ResultSet resultSet = statement.executeQuery(sql);
		if (resultSet.next()) {
			String id = resultSet.getString("id");
			System.out.println("the id to save as cookie is " + id);
			Cookie cookie = new Cookie("admin", id);
			cookie.setMaxAge(60 * 60 * 24 * 60);
			response.addCookie(cookie);
			System.out.println("successfully saved as cookie.");
		}
	}

	protected boolean doesExist(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, ServletException, IOException {
		if (adminDAO.doesExist(request.getParameter("adminEmail"))) {
			HttpSession session = request.getSession();
			session.setAttribute("userExist", true);
			// Redirecting after setting session attribute
			response.sendRedirect(request.getContextPath() + "/admin_register.jsp");
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

		Admin admin = new Admin();
		admin.setName(request.getParameter("adminName"));

		PasswordEncryptor enc = new PasswordEncryptor();
		admin.setPassword(enc.encrypt(request.getParameter("password")));
		admin.setEmail(request.getParameter("adminEmail"));
		admin.setPhone(Long.parseLong(request.getParameter("phone")));

		Part file = request.getPart("profilePic");
		ImageControl imageControl = new ImageControl(request.getServletContext());
		String profile = imageControl.saveImage(admin.getName(), file);

		admin.setProfile_pic(profile);
		admin.setVerified(false);

		if (id.isEmpty()) {
			if (adminDAO.save(admin)) {
				try {
					saveIdAsCookie(request, response);
				} catch (SQLException e) {
					e.printStackTrace();
				}
				// Redirecting and returning to avoid further code execution
				response.sendRedirect(request.getContextPath() + "/waitingAdmin.jsp");
				return;
			}
		} else {
			admin.setId(Integer.parseInt(id));
			if (adminDAO.update(admin)) {
				request.setAttribute("MSG", "Successfully Updated!");
				// Redirecting after update
				response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
				return;
			}
		}

		// Ensure this redirect happens only if the earlier conditions aren't met
		response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
	}

	protected void login(HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("Got into the login method");
		String email = (String) request.getParameter("email");
		String password = (String) request.getParameter("password");
		CheckEmailPassword checker = new CheckEmailPassword();
		if (!adminDAO.doesExist(email)) {
			HttpSession session = request.getSession();
			session.setAttribute("userExist", false);
			response.sendRedirect(request.getContextPath() + "/admin_login.jsp");
		} else if (!checker.isPasswordTrue(email, password)) {
			HttpSession session = request.getSession();
			session.setAttribute("checkPassword", false);
			response.sendRedirect(request.getContextPath() + "/admin_login.jsp");
		} else {
			System.out.println("admin exits and password is correct");
			int id = adminDAO.get(email);
			Admin admin = adminDAO.get(id);
			System.out.println("admin verification in controller: " + admin.isVerified());
			if (admin.isVerified()) {
				System.out.println("admin is verified");
				Cookie cookie = new Cookie("admin", id + "");
				cookie.setMaxAge(60 * 60 * 24 * 60);
				response.addCookie(cookie);
				response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
			} else {
				System.out.println("admin is not verified");
				response.sendRedirect(request.getContextPath() + "/waitingAdmin.jsp");
			}
		}

	}
	
	protected void update(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
		String name = request.getParameter("name");
		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
		String id = request.getParameter("id");
		if (adminDAO.update(id, name, email, phone)) {
			HttpSession session = request.getSession();
			session.setAttribute("MSGupdate", "update");
			request.getRequestDispatcher("/view_profile.jsp").forward(request, response);
		}
	}
	
	protected void changePassword(HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("got into the change password method");
		String id = request.getParameter("id");
		String oldPassword = request.getParameter("old-password");
		String newPassword = request.getParameter("new-password");
		System.out.println("old password: " + oldPassword + "\tnew password: " + newPassword);
		
		Admin admin = adminDAO.get(Integer.parseInt(id));
		String passwordFromDB = admin.getPassword();
		
		PasswordEncryptor e = new PasswordEncryptor();
		String realPassword = e.decrypt(passwordFromDB);
		System.out.println("real password: " + realPassword);
		
		if (realPassword.equalsIgnoreCase(oldPassword)) {
			admin.setPassword(e.encrypt(newPassword));
			System.out.println("admin.getpassword before updating " + e.decrypt(admin.getPassword()));
			adminDAO.update(admin);
			
			admin = adminDAO.get(Integer.parseInt(id));
			System.out.println("password changed to " + e.decrypt(admin.getPassword()));
			HttpSession session = request.getSession();
			session.setAttribute("MSG", "passwordchange");
			request.getRequestDispatcher("/view_profile.jsp").forward(request, response);
		} else {
			System.out.println("password is incorrect");
			HttpSession session = request.getSession();
			session.setAttribute("MSGwrong", "wrongpassword");
			System.out.println("MSG session stores: " + (String)session.getAttribute("MSGwrong"));
			request.getRequestDispatcher("/view_profile.jsp").forward(request, response);
		}
	}
	private void updateProfileImage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    System.out.println("got into update profile image method");  
	        Part filePart = request.getPart("profileImage");
	        
	        ImageControl imageController = new ImageControl(request.getServletContext());
	        String profilePic = imageController.saveImage("something", filePart);

	        String id = request.getParameter("id");
	        adminDAO = new AdminDAO();
	        Admin admin = adminDAO.get(Integer.parseInt(id));
	        admin.setProfile_pic(profilePic);
	        
	        adminDAO.update(admin);
	        
	        HttpSession session = request.getSession();
	        session.setAttribute("profileChange", "success");

	        // Redirect to the profile page
	        response.sendRedirect(request.getContextPath() + "/view_profile.jsp");
	    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {
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
	            }else if(action.equals("updateProfileImage")) {
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
