package controller;

import java.io.IOException;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import additional.ImageControl;
import additional.PasswordEncryptor;
import dao.CustomerDAO;
import model.Admin;
import model.Customer;

@WebServlet("/CustomerController")
@MultipartConfig
public class CustomerController extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	RequestDispatcher dispatcher = null;
	CustomerDAO customerDAO = null;

	public CustomerController() {
		customerDAO = new CustomerDAO();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		if (action == null) {
			action = "LIST";
		}
		switch (action) {
		case "LIST":
			listCustomer(request, response);
			break;

		case "EDIT":
			getCustomer(request, response);
			break;

		case "delete":
			System.out.println("delete case");
			deleteCustomer(request, response);
			break;

		case "logout":
			logout(request, response);
			break;

		default:
			listCustomer(request, response);
			break;
		}
	}

	private void logout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Cookie[] cookies = request.getCookies();
		if (cookies != null) {
			for (Cookie cookie : cookies) {
				if ("user_id".equals(cookie.getName())) {
					cookie.setValue("-1");
					response.addCookie(cookie);
					break;
				}
			}
		}
		request.getRequestDispatcher("/home.jsp").forward(request, response);
	}

	private void listCustomer(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		List<Customer> customerList = customerDAO.get();
		request.setAttribute("customerlist", customerList);
		dispatcher = request.getRequestDispatcher("/customerdent-list.jsp");
		dispatcher.forward(request, response);
	}

	private void getCustomer(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String id = request.getParameter("id");
		Customer customer = customerDAO.get(Integer.parseInt(id));
		request.setAttribute("customer", customer);
		dispatcher = request.getRequestDispatcher("/dashboard.jsp");
		dispatcher.forward(request, response);
	}

	private void deleteCustomer(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("Got into delete admin method");
		String id = request.getParameter("id");
		if (customerDAO.delete(Integer.parseInt(id))) {
			request.setAttribute("MSG", "Successfully Deleted");
			Cookie[] cookies = request.getCookies();
			for (Cookie cookie : cookies) {
				if ("user_id".equals(cookie.getName())) {
					cookie.setValue("-1");
					response.addCookie(cookie);
					break;
				}
			}
			request.getRequestDispatcher("/home.jsp").forward(request, response);
		}
	}

	protected void update(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, ServletException, IOException {
		String name = request.getParameter("name");
		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
		String id = request.getParameter("id");
		String shop = request.getParameter("shop");
		String city = request.getParameter("city");
		if (customerDAO.update(id, name, email, phone, shop, city)) {
			HttpSession session = request.getSession();
			session.setAttribute("MSGupdate", "update");
			request.getRequestDispatcher("/customer_profile_view.jsp").forward(request, response);
		}
	}

	protected void changePassword(HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("got into the change password method");
		String id = request.getParameter("id");
		String oldPassword = request.getParameter("old-password");
		String newPassword = request.getParameter("new-password");
		System.out.println("old password: " + oldPassword + "\tnew password: " + newPassword);

		Customer customer = customerDAO.get(Integer.parseInt(id));
		String passwordFromDB = customer.getPassword();

		PasswordEncryptor e = new PasswordEncryptor();
		String realPassword = e.decrypt(passwordFromDB);
		System.out.println("real password: " + realPassword);

		if (realPassword.equalsIgnoreCase(oldPassword)) {
			customer.setPassword(e.encrypt(newPassword));
			System.out.println("admin.getpassword before updating " + e.decrypt(customer.getPassword()));
			customerDAO.update(customer);

			customer = customerDAO.get(Integer.parseInt(id));
			System.out.println("password changed to " + e.decrypt(customer.getPassword()));
			HttpSession session = request.getSession();
			session.setAttribute("MSG", "passwordchange");
			request.getRequestDispatcher("/customer_profile_view.jsp").forward(request, response);
		} else {
			System.out.println("password is incorrect");
			HttpSession session = request.getSession();
			String attempt = (String) session.getAttribute("attempt");
			// Set the MSGwrong attribute based on the current attempt
			if (attempt == null) {
				session.setAttribute("MSGwrong", "wrongpassword");
			} else if ("one".equals(attempt)) {
				session.setAttribute("MSGwrong", "wrongpassword1");
			} else if ("two".equals(attempt)) {
				session.setAttribute("MSGwrong", "wrongpassword2");
			} else {
				System.out.println(attempt);
				session.removeAttribute("attempt");
				String userId = (String) session.getAttribute("userId");
				String userType = (String) session.getAttribute("userType");
				response.sendRedirect(request.getContextPath() + "/LoginFailureController?action=save&userId=" + userId
						+ "&userType=" + userType);

			}
			System.out.println("MSG session stores: " + (String) session.getAttribute("MSGwrong"));
			response.sendRedirect(request.getContextPath() + "/customer_profile_view.jsp");
		}
	}

	private void updateProfileImage(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("got into update profile image method");
		Part filePart = request.getPart("profileImage");

		ImageControl imageController = new ImageControl(request.getServletContext());
		String profilePic = imageController.saveImage("something", filePart);

		String id = request.getParameter("id");
		customerDAO = new CustomerDAO();
		Customer customer = customerDAO.get(Integer.parseInt(id));
		customer.setProfile_pic(profilePic);

		customerDAO.update(customer);

		HttpSession session = request.getSession();
		session.setAttribute("profileChange", "success");

		// Redirect to the profile page
		response.sendRedirect(request.getContextPath() + "/customer_profile_view.jsp");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");

		if (action != null) {
			try {
				if (action.equals("update")) {
					update(request, response);
				} else if (action.equals("passwordChange")) {
					changePassword(request, response);
				} else if (action.equals("updateProfileImage")) {
					updateProfileImage(request, response);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else {
			String id = request.getParameter("id");
			Customer customer = new Customer();
			customer.setName(request.getParameter("name"));
			customer.setPassword(request.getParameter("password"));
			customer.setEmail(request.getParameter("email"));
			customer.setPhone(Long.parseLong((String) request.getParameter("phone")));
			customer.setProfile_pic(request.getParameter("profile_pic"));
			customer.setShop_name(request.getParameter("shop_name"));
			customer.setAddress(request.getParameter("address"));

			if (id.isEmpty() || id == null) {
				if (customerDAO.save(customer)) {
					request.setAttribute("MSG", "Successfully Saved!");
				}
			} else {
				customer.setId(Integer.parseInt(id));
				if (customerDAO.update(customer)) {
					request.setAttribute("MSG", "Successfully Updated!");
				}
			}
			listCustomer(request, response);
		}
	}
}
