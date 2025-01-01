package com.example.demo2.studentsDAO;

import com.example.demo2.InputValidator;
import com.example.demo2.dao.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

@WebServlet("/StudentServlet")
public class StudentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try (Connection connection = DBConnection.getConnection()) {
            switch (action) {
                case "add":
                    handleAddStudent(request, response, connection);
                    break;
                case "remove":
                    handleRemoveStudent(request, response, connection);
                    break;
                case "fetch":
                    handleFetchStudents(request, response, connection);
                    break;
                case "update":
                    handleUpdate(request, response, connection);
                    break;
                default:
                    response.getWriter().println("Invalid action!");
            }
        } catch (SQLException e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, Connection con)
            throws SQLException, IOException, ServletException {
        String username = request.getParameter("username");
        String updatedUsername = request.getParameter("updatedUsername");
        String updatedEmail = request.getParameter("updatedEmail");
        String email = request.getParameter("email");
        String password = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmNewPassword = request.getParameter("confirmNewPassword");
        String role = request.getParameter("role");

        if (!newPassword.equals(confirmNewPassword)) {
            response.getWriter().println("<script type=\"text/javascript\">"
                    + "alert('New password doesn't match');"
                    + "</script>");
            request.getRequestDispatcher("/WEB-INF/For Student/settings.jsp");
            return;
        }

        if (!InputValidator.isValidEmail(updatedEmail)) {
            response.getWriter().println("<script type=\"text/javascript\">"
                    + "alert('Invalid email format! Please try again.');"
                    + "</script>");
            request.getRequestDispatcher("/WEB-INF/For Student/settings.jsp");
            return;
        }

        if (!InputValidator.isValidPassword(newPassword)) {
            response.getWriter().println("<script type=\"text/javascript\">"
                    + "alert('Your password is too weak.');"
                    + "</script>");
            request.getRequestDispatcher("/WEB-INF/For Student/settings.jsp");
            return;
        }

        PreparedStatement stmt = con.prepareStatement("SELECT password FROM stakeholders WHERE username = ?");
        stmt.setString(1, username);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            String storedPassword = rs.getString("password");

            if (BCrypt.checkpw(password, storedPassword)) {
                PreparedStatement updateStmt = con.prepareStatement(
                        "UPDATE stakeholders SET email = ?, password = ?, role = ?, username = ? WHERE username = ?");

                String hashCurrent = BCrypt.hashpw(newPassword, BCrypt.gensalt());
                updateStmt.setString(1, email);
                updateStmt.setString(2, hashCurrent);
                updateStmt.setString(3, role);
                updateStmt.setString(4, updatedUsername);
                updateStmt.setString(5, username);
                updateStmt.executeUpdate();

                response.getWriter().println("<script type=\"text/javascript\">"
                        + "alert('Info updated successfully!');"
                        + "</script>");
                request.getRequestDispatcher("/WEB-INF/For Student/settings.jsp");
            } else {
                response.getWriter().println("<script type=\"text/javascript\">"
                        + "alert('Incorrect password');"
                        + "</script>");
                request.getRequestDispatcher("/WEB-INF/For Student/settings.jsp").forward(request, response);
            }
        } else {
            response.getWriter().println("<script type=\"text/javascript\">"
                    + "alert('Username not found');"
                    + "</script>");
            request.getRequestDispatcher("/WEB-INF/For Student/settings.jsp");
        }
    }

    private void handleAddStudent(HttpServletRequest request, HttpServletResponse response, Connection connection) throws SQLException, IOException, ServletException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        if (!InputValidator.isValidEmail(email)) {
            response.getWriter().println("<script>alert('Invalid email format!');</script>");
            String target = request.getParameter("target");
        request.getRequestDispatcher(target).forward(request, response);
            return;
        }

        if (!InputValidator.isValidPassword(password)) {
            response.getWriter().println("<script>alert('Weak password! Please try again.');</script>");
            String target = request.getParameter("target");
        request.getRequestDispatcher(target).forward(request, response);
            return;
        }

        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        PreparedStatement pstmt = connection.prepareStatement("INSERT INTO stakeholders (username, email, password, role) VALUES (?, ?, ?, ?)");
        pstmt.setString(1, username);
        pstmt.setString(2, email);
        pstmt.setString(3, hashedPassword);
        pstmt.setString(4, role);
        pstmt.executeUpdate();
        response.getWriter().println("<script>alert('Student added successfully!');</script>");
        String target = request.getParameter("target");
        request.getRequestDispatcher(target).forward(request, response);
    }

    private void handleRemoveStudent(HttpServletRequest request, HttpServletResponse response, Connection connection) throws SQLException, IOException, ServletException {
        String username = request.getParameter("username");

        PreparedStatement pstmt = connection.prepareStatement("DELETE FROM stakeholders WHERE username = ?");
        pstmt.setString(1, username);
        pstmt.executeUpdate();

        response.getWriter().println("<script>alert('Student removed successfully!');</script>");
        String target = request.getParameter("target");
        request.getRequestDispatcher(target).forward(request, response);
    }

    private void handleFetchStudents(HttpServletRequest request, HttpServletResponse response, Connection connection) throws SQLException, ServletException, IOException {
        String query = "SELECT * FROM stakeholders WHERE role = 'student'";
        Statement stmt = connection.createStatement();
        ResultSet rs = stmt.executeQuery(query);

        request.setAttribute("students", rs);
        String target = request.getParameter("target");
        request.getRequestDispatcher(target).forward(request, response);
    }
}
