package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.ProductRatingDAO;
import model.ProductRating;

@WebServlet("/ProductRatingController")
public class ProductRatingController extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	RequestDispatcher dispatcher = null;
	ProductRatingDAO productRatingDAO = null;

	public ProductRatingController() {
		productRatingDAO = new ProductRatingDAO();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		if (action == null) {
			action = "LIST";
		}
		switch (action) {
		case "LIST":
			listProductRating(request, response);
			break;

		case "EDIT":
			getProductRating(request, response);
			break;

		case "DELETE":
			deleteProductRating(request, response);
			break;

		default:
			listProductRating(request, response);
			break;
		}
	}

	private void listProductRating(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		List<ProductRating> productRatingList = productRatingDAO.get();
		request.setAttribute("productRatinglist", productRatingList);
		dispatcher = request.getRequestDispatcher("/admindent-list.jsp");
		dispatcher.forward(request, response);
	}

	private void getProductRating(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String id = request.getParameter("id");
		ProductRating productRating = productRatingDAO.get(Integer.parseInt(id));
		request.setAttribute("productRating", productRating);
		dispatcher = request.getRequestDispatcher("/dashboard.jsp");
		dispatcher.forward(request, response);
	}

	private void deleteProductRating(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String id = request.getParameter("id");
		if (productRatingDAO.delete(Integer.parseInt(id))) {
			request.setAttribute("MSG", "Successfully Deleted");
		}
		listProductRating(request, response);
	}
	
	protected void save(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String customer_id = request.getParameter("customer_id");
		String product_id = request.getParameter("product_id");
		String stars = request.getParameter("rating");
		String description = request.getParameter("rating-description");
		
		ProductRating productRating = new ProductRating();
		productRating.setCustomer_id(Integer.parseInt(customer_id));
		productRating.setProduct_id(Integer.parseInt(product_id));
		productRating.setStars(Integer.parseInt(stars));
		productRating.setDescription(description);
		
		ProductRatingDAO ratingDAO = new ProductRatingDAO();
		if (ratingDAO.save(productRating)) {
			request.getRequestDispatcher("/order.jsp").forward(request, response);
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		if ("save".equals(action)) {
			save(request, response);
		}
	}
}
