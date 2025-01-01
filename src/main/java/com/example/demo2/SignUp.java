package com.example.demo2;

import java.sql.*;

import com.example.demo2.dao.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;
import java.util.regex.*;

import java.io.IOException;

@WebServlet("/signup")
public class SignUp extends HttpServlet {
    public boolean isStrongPassword(String password) {
        String pattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$";
        return password.matches(pattern);
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.setContentType("text/html");


        // SQL query to insert a new user
        String sql = "INSERT INTO stakeholders (username, email, password, role) VALUES (?, ?, ?, ?)";


        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            // Get form data
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String role = request.getParameter("role");

            // Example usage
            if (!isStrongPassword(password)) {
                response.getWriter().println(
                        "<script type=\"text/javascript\">"
                                + "alert('Your password is too weak. It must:\\n- Be at least 8 characters long.\\n- Include at least one uppercase letter.\\n- Include at least one lowercase letter.\\n- Include at least one number.\\n- Include at least one special character (e.g., @, $, %, &).');"
                                + "window.location = 'index.jsp';"
                                + "</script>"
                );
                return;
            }

            String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
            Pattern emailPattern = Pattern.compile(emailRegex);
            if (!emailPattern.matcher(email).matches()) {
                response.getWriter().println(
                        "<script type=\"text/javascript\">"
                                + "alert('Invalid email format! Please try again.');"
                                + "window.location = 'index.jsp';"
                                + "</script>"
                );
                return;
            }

            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());


            // Set the parameters in the query
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, hashedPassword); // Optional: Hash this before storing for better security.
            ps.setString(4, role);

            // Execute the query
            int result = ps.executeUpdate();

            if (result > 0) {
                // Successfully added user
                response.getWriter().println(
                        "<script type=\"text/javascript\">"
                                + "alert('Signup successful! You can now log in.');"
                                + "window.location = 'index.jsp';"
                                + "</script>"
                );
            } else {
                // Insert failed (shouldn't happen unless there's an issue)
                response.getWriter().println("Signup failed. Please try again.");
            }

        } catch (SQLIntegrityConstraintViolationException e) {
            // Handle unique constraint violation (e.g., username already exists)
            response.getWriter().println(
                    "<script type=\"text/javascript\">"
                            + "alert('Username already exists! Please choose a different username.');"
                            + "window.location = 'index.jsp';"
                            + "</script>"
            );
            return;
        } catch (Exception e) {
            // Handle other errors
            response.getWriter().println("Error: " + e.getMessage());
            response.getWriter().println(
                    "<script type=\"text/javascript\">"
                            + "alert('"+ e.getMessage()+"');"
                            + "window.location = 'index.jsp';"
                            + "</script>"
            );
        }
    }
}
