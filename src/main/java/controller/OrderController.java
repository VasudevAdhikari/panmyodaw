package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import additional.PasswordEncryptor;
import dao.OrderDAO;
import dao.ProductDAO;
import dao.CustomerDAO;
import dao.EnterpriseDAO;
import dao.MiniorderDAO;
import model.Order;
import model.Customer;
import model.Miniorder;
@WebServlet("/OrderController")
public class OrderController extends HttpServlet {

	private static final long serialVersionUID = 1L;
	OrderDAO orderDAO = null;
	MiniorderDAO miniorderDAO = null;
	ProductDAO productDAO = null;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("Got into the do get method()");
        String action = request. getParameter("action");
        if ("verify".equals(action)) {
        	try {
				verify(request, response);
			} catch (Exception e) {
				e.printStackTrace();
			}
        }
        else if("ongoing".equals(action)) {
        	try {
				ongoing(request, response);
			} catch (Exception e) {
				e.printStackTrace();
			}
        }
    }
    
    protected void verify (HttpServletRequest request, HttpServletResponse response) throws Exception {
    	System.out.println("got into the verify method");
    	String deliverer = request.getParameter("deliverer");
    	String order = request.getParameter("c_id");
    	String cus = request.getParameter("customer_id");
    	String password = request.getParameter("password");
    	EnterpriseDAO enterprise = new EnterpriseDAO();
    	
    	CustomerDAO customerDAO = new CustomerDAO();
    	Customer customer = customerDAO.get(Integer.parseInt(cus));
    	String passwordfromdb = customer.getPassword();
    	
    	PasswordEncryptor enc = new PasswordEncryptor();
    	String realpassword = enc.decrypt(passwordfromdb);
    	HttpSession session = request.getSession();
    	if (realpassword.equalsIgnoreCase(password)) {
        	if (enterprise.verify(order, deliverer)) {
        		session.setAttribute("checkpassword", "right");
        		request.getRequestDispatcher("/employeehomepage.jsp").forward(request, response);
        	}
    	}
    	else {
    		session.setAttribute("checkpassword", "wrong");
    		request.getRequestDispatcher("/employeehomepage.jsp").forward(request, response);
    	}
    }
    
    protected void ongoing (HttpServletRequest request, HttpServletResponse response) throws Exception {
    	System.out.println("got into the ongoing method");
    	String deliverer = request.getParameter("deliverer");
    	String order = request.getParameter("c_id");
    	EnterpriseDAO enterprise = new EnterpriseDAO();
    	enterprise.startDelivery(deliverer, order);
    	HttpSession session = request.getSession();
    	session.setAttribute("ongoing", "success");
    	request.getRequestDispatcher("/emphomeorder.jsp").forward(request, response);
    }
    

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	System.out.println("got into the do post method of order controller");
        String action = request.getParameter("action");
        if ("save".equals(action)) {
        	System.out.println("The action is equal to save");
        	try {
				if (saveOrder(request, response)) {
					request.getRequestDispatcher("/order.jsp").forward(request, response);
				}
			} catch (ServletException | IOException | SQLException e) {
				e.printStackTrace();
			}
        }
    }
    
    protected boolean saveOrder(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
    	
    	System.out.println("Got into the save order method");
    	
    	//save the order first
    	System.out.println("customer_id is " + request.getParameter("customer_id"));
    	int id = Integer.parseInt(request.getParameter("customer_id"));
    	orderDAO = new OrderDAO();
    	if (orderDAO.saveCustomerId(id)) {
    		System.out.println("Inserted the customer successfully");
    	}
    	
    	HttpSession session = request.getSession();
    	
    	Map<String, Integer> miniorders = (Map<String, Integer>) session.getAttribute("cartmap");
    	for (Map.Entry<String, Integer> entry : miniorders.entrySet()) {
            String productName = entry.getKey();
            productDAO = new ProductDAO();
            int productId = productDAO.getProductId(productName);
            
            int quantity = entry.getValue();
            
            Miniorder miniorder = new Miniorder();
            miniorder.setProduct_id(productId);
            miniorder.setOrder_id(orderDAO.getLatestId());
            miniorder.setQuantity(quantity);
            
            miniorderDAO = new MiniorderDAO();
            miniorderDAO.save(miniorder);
        }

    	return true;
    }

}
