package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.google.gson.Gson;

import additional.ImageControl;
import dao.ProductDAO;
import model.Product;

@WebServlet("/ProductController")
@MultipartConfig
public class ProductController extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	RequestDispatcher dispatcher = null;
	ProductDAO productDAO = null;

	public ProductController() {
		productDAO = new ProductDAO();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("Got into the do get method()");
		String action = request.getParameter("action");
		if (action == null) {
			action = "LIST";
		}
		switch (action) {
		case "LIST":
			listProduct(request, response);
			break;

		case "edit":
			getProduct(request, response);
			break;

		case "delete":
			deleteProduct(request, response);
			break;

		default:
			listProduct(request, response);
			break;
		}
	}

	private void listProduct(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		List<Product> productList = productDAO.get();
		request.setAttribute("productlist", productList);
		dispatcher = request.getRequestDispatcher("/view_products.jsp");
		dispatcher.forward(request, response);
	}

	private void getProduct(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("this is get product method");
		String id = request.getParameter("id");
		Product product = productDAO.get(Integer.parseInt(id));
		Gson gson = new Gson();
		String jsonProduct = gson.toJson(product);
		
        // Set content type to application/json
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Write JSON data to response
        PrintWriter out = response.getWriter();
        out.print(jsonProduct);
        System.out.println("now we are gonna return to ajax function");
        out.flush();
	}

	private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String id = request.getParameter("id");
		if (productDAO.delete(Integer.parseInt(id))) {
			request.setAttribute("MSG", "Successfully Deleted");
		}
		request.getRequestDispatcher("/view_products.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String id = request.getParameter("id");
		id= id==null? "": id;
		Product product = new Product();
		product.setName(request.getParameter("name"));
		product.setPrice(Double.parseDouble((String)request.getParameter("price")));
		product.setDiscount(Double.parseDouble((String)request.getParameter("discount")));
		
		Part file = request.getPart("profile_pic");
		ImageControl imageControl = new ImageControl(request.getServletContext());
		String profile = imageControl.saveImage(product.getName(), file);
		
		product.setProfile_pic(profile);
		product.setTheme_color(request.getParameter("themeColor"));
		product.setProfit(Double.parseDouble((String)request.getParameter("profit")));
		product.setInStock(Boolean.parseBoolean((String)request.getParameter("inStock")));
		product.setProduct_description(request.getParameter("description"));
		if (id.isEmpty() || id == null) {
			if (productDAO.save(product)) {
				request.setAttribute("MSG", "Successfully Saved!");
			}
		} else {
			String stockStatus = request.getParameter("stockStatus");
			if (stockStatus.equals("out-of-stock")) {
				product.setInStock(false);
			} else {
				product.setInStock(true);
			}
			product.setId(Integer.parseInt(id));
			if (productDAO.update(product)) {
				request.setAttribute("MSG", "Successfully Updated!");
			}
		}
		listProduct(request, response);
	}
}
