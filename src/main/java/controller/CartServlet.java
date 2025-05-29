package controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private Map<String, Integer> cartMap;
    
    public void init() {
    	cartMap = new HashMap<String, Integer>();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
    	System.out.println("Got into do post of Cart Servlet");
    	HttpSession session = request.getSession();
    	if (session.getAttribute("cartmap") != null && !session.getAttribute("cartmap").equals("")) {
    		System.out.println(session.getAttribute("cartmap"));
    		cartMap = (Map<String, Integer>) session.getAttribute("cartmap");
    	}
    	
        String action = request.getParameter("action");
        String productName = request.getParameter("productName");

        if ("add".equals(action)) {
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            cartMap.put(productName, quantity);
        } else if ("remove".equals(action)) {
            cartMap.remove(productName);
        } else if ("update".equals(action)) {
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            cartMap.put(productName, quantity);
        }

        for (Map.Entry<String, Integer> entry : cartMap.entrySet()) {
            System.out.println("Key: " + entry.getKey() + ", Value: " + entry.getValue());
        }
        
        session.setAttribute("cartmap", cartMap);
    }
}
