package controller;

import javax.servlet.RequestDispatcher;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


import java.io.IOException;
import java.sql.Timestamp;
import java.util.Date;
import dao.LoginFailureDAO;
import model.LoginFailure;

@WebServlet("/LoginFailureController")
public class LoginFailureController extends HttpServlet{

	private static final long serialVersionUID = 1L;
	RequestDispatcher dispatcher = null;
	LoginFailureDAO loginFailureDAO = null;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String action = request.getParameter("action");
		
		switch (action) {
		case "save":
			int userId = Integer.parseInt((String) request.getParameter("userId"));
			String userType = (String) request.getParameter("userType");
			String reason = "Multiple wrong password attempts at around " + new Date();
			loginFailureDAO = new LoginFailureDAO();
			LoginFailure lf = new LoginFailure(userId, (String) request.getRemoteAddr(), userType, reason);
			loginFailureDAO.save(lf);
			Cookie[] cookies = request.getCookies();
			HttpSession session = request.getSession();
			session.removeAttribute("MSGwrong");
			session.removeAttribute("attempt");
			if (cookies != null ){
				for (Cookie cookie: cookies) {
					if ("user_id".equals(cookie.getName()) || "user".equals(cookie.getName()) || "admin".equals(cookie.getName())) {
						cookie.setMaxAge(0);
						cookie.setPath("/");
						response.addCookie(cookie);
					}
				}
			}
			response.sendRedirect(request.getContextPath() + "/home.jsp");
		}
	}
}
