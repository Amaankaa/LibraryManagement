package com.example.demo2;

import java.sql.*;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.regex.Pattern;
@WebServlet("/action")
public class login extends HttpServlet {
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.setContentType("text/html");
        String url = "jdbc:mysql://localhost:3306/mydb";
        String user = "root";
        String password = "root123";
        String query = "SELECT password, role FROM stakeholders WHERE username = ?";
        try {
            Connection con = DriverManager.getConnection(url, user, password);
            PreparedStatement ps = con.prepareStatement(query);

            ps.setString(1, request.getParameter("username"));
            ResultSet rs = ps.executeQuery();

            if (rs.next()){
                // Get the hashed password from the database
                String storedHash = rs.getString("password");
                String role = rs.getString("role");


                // Compare input password with the stored hash
                if (BCrypt.checkpw(request.getParameter("password"), storedHash)) {
                    if ("admin".equalsIgnoreCase(role)) {
                        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/admin-dashboard.html");
                        rd.forward(request,response);
                    } else if ("staff".equalsIgnoreCase(role)) {
                        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/staff-dashboard.html");
                        rd.forward(request,response);
                    } else {
                        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/student-dashboard.html");
                        rd.forward(request,response);
                    }
                } else {
                    response.getWriter().println(
                            "<script type=\"text/javascript\">"
                                    + "alert('Your password is incorrect!');"
                                    + "window.location = 'index.jsp';"
                                    + "</script>"
                    );
                }


            } else {
                response.getWriter().println(
                        "<script type=\"text/javascript\">"
                                + "alert('Invalid Username!');"
                                + "window.location = 'index.jsp';"
                                + "</script>"
                );
            }

        }catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
