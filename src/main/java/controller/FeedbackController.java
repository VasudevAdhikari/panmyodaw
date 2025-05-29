package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.FeedbackDAO;
import model.Feedback;

@WebServlet("/FeedbackController")
public class FeedbackController extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	RequestDispatcher dispatcher = null;
	FeedbackDAO feedbackDAO = null;

	public FeedbackController() {
		feedbackDAO = new FeedbackDAO();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		if (action == null) {
			action = "LIST";
		}
		switch (action) {
		case "LIST":
			listFeedback(request, response);
			break;

		case "EDIT":
			getFeedback(request, response);
			break;

		case "DELETE":
			deleteFeedback(request, response);
			break;

		default:
			listFeedback(request, response);
			break;
		}
	}

	private void listFeedback(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		List<Feedback> feedbackList = feedbackDAO.getNotResponded();
		request.setAttribute("feedbacklist", feedbackList);
		dispatcher = request.getRequestDispatcher("/admindent-list.jsp");
		dispatcher.forward(request, response);
	}

	private void getFeedback(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String id = request.getParameter("id");
		Feedback feedback = feedbackDAO.get(Integer.parseInt(id));
		request.setAttribute("feedback", feedback);
		dispatcher = request.getRequestDispatcher("/dashboard.jsp");
		dispatcher.forward(request, response);
	}

	private void deleteFeedback(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String id = request.getParameter("id");
		if (feedbackDAO.delete(Integer.parseInt(id))) {
			request.setAttribute("MSG", "Successfully Deleted");
		}
		listFeedback(request, response);
	}

	protected void setReply(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
		String id = request.getParameter("feedback");
		String replyText = request.getParameter("reply-input");

		if (feedbackDAO.setReply(id, replyText)) {
			response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		if (request.getParameter("action") != null) {
			if (request.getParameter("action").equals("reply")) {
				try {
					setReply(request, response);
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		} else {
			Feedback feedback = new Feedback();
			feedback.setDescription(request.getParameter("description"));
			feedback.setCustomer_id(Integer.parseInt((String) request.getParameter("customer")));
			feedbackDAO.save(feedback);

			HttpSession session = request.getSession();
			session.setAttribute("feedback", "successful");

			response.sendRedirect(request.getContextPath() + "/customer_home_page.jsp");
		}
	}
}
