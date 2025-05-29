<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Base64" %>

<html>
<head>
    <title>Success</title>
</head>
<body>
    <h1>Registration Successful!</h1>
    <%
        if (session != null) {
            String name = (String) session.getAttribute("retrievedName");
            String city = (String) session.getAttribute("retrievedCity");
            byte[] profilePic = (byte[]) session.getAttribute("retrievedProfilePic");
            Long phone = (Long) session.getAttribute("retrievedPhone");

            // Display the data
            out.println("<p>Name: " + name + "</p>");
            out.println("<p>City: " + city + "</p>");
            out.println("<p>Phone: " + phone + "</p>");

            // Display the profile picture if it exists
            if (profilePic != null) {
                String base64Image = Base64.getEncoder().encodeToString(profilePic);
                out.println("<img src='data:image/jpeg;base64," + base64Image + "' alt='Profile Picture' />");
            } else {
                out.println("<p>No profile picture uploaded.</p>");
            }
        } else {
            out.println("<p>Session data not found.</p>");
        }
    %>
</body>
</html>
