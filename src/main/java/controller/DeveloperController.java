package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.DeveloperDAO;
import model.Developer;

public class DeveloperController extends HttpServlet {

	RequestDispatcher dispatcher = null;
	DeveloperDAO developerDAO = null;

	public DeveloperController() {
		developerDAO = new DeveloperDAO();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		if (action == null) {
			action = "LIST";
		}
		switch (action) {
		case "LIST":
			listDeveloper(request, response);
			break;

		case "EDIT":
			getDeveloper(request, response);
			break;

		case "DELETE":
			deleteDeveloper(request, response);
			break;

		default:
			listDeveloper(request, response);
			break;
		}
	}

	private void listDeveloper(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		List<Developer> developerList = developerDAO.get();
		request.setAttribute("developerlist", developerList);
		dispatcher = request.getRequestDispatcher("/developerdent-list.jsp");
		dispatcher.forward(request, response);
	}

	private void getDeveloper(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String id = request.getParameter("id");
		Developer developer = developerDAO.get(Integer.parseInt(id));
		request.setAttribute("developer", developer);
		dispatcher = request.getRequestDispatcher("/dashboard.jsp");
		dispatcher.forward(request, response);
	}

	private void deleteDeveloper(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String id = request.getParameter("id");
		if (developerDAO.delete(Integer.parseInt(id))) {
			request.setAttribute("MSG", "Successfully Deleted");
		}
		listDeveloper(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String id = request.getParameter("id");
		Developer developer = new Developer();
		developer.setName(request.getParameter("name"));
		developer.setPassword(request.getParameter("password"));
		developer.setEmail(request.getParameter("email"));
		developer.setPhone(Long.parseLong((String)request.getParameter("phone")));
		developer.setProfile_pic(request.getParameter("profile_pic"));
		if (id.isEmpty() || id == null) {
			if (developerDAO.save(developer)) {
				request.setAttribute("MSG", "Successfully Saved!");
			}
		} else {
			developer.setId(Integer.parseInt(id));
			if (developerDAO.update(developer)) {
				request.setAttribute("MSG", "Successfully Updated!");
			}
		}
		listDeveloper(request, response);
	}
}
