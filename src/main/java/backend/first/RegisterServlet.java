package backend.first;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.IOException;
import additional.ImageControl;
@WebServlet("/RegisterServlet")
@MultipartConfig
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("fullName");
        System.out.println("got name from form");
        String city = request.getParameter("city");
        System.out.println("got city from form");
        Part profilePicPart = request.getPart("profilePic");
        System.out.println("got profile picture from form");
        String latitude = request.getParameter("latitude");
        String longitude = request.getParameter("longitude");
        String shop = request.getParameter("shop");
        String profilePic = null;
        
        ImageControl imageControl = new ImageControl(getServletContext());
        profilePic = imageControl.saveImage(name, profilePicPart);

        HttpSession session = request.getSession(false);
        session.setAttribute("name", name);
        System.out.println("inserted name into session");
        session.setAttribute("city", city);
        System.out.println("inserted city into session");
        session.setAttribute("profilePic", profilePic);
        System.out.println("inserted profile picture into session");
        session.setAttribute("latitude", latitude);
        session.setAttribute("longitude", longitude);
        session.setAttribute("shop", shop);
        System.out.println(shop + " is in " + latitude + " latitude and " + longitude + " longitude.");

        response.sendRedirect(request.getContextPath() + "/InsertIntoDB");
    }
}
