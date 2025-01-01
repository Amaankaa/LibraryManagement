package com.example.demo2.AdminDAO;

import com.example.demo2.InputValidator;
import com.example.demo2.dao.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle the action
        String action = request.getParameter("action");
        try (Connection con = DBConnection.getConnection()) {
            if ("add".equals(action)) {
                addAdmin(request, response, con);
            } else if ("update".equals(action)) {
                updateAdmin(request, response, con);
            } else if ("remove".equals(action)) {
                removeAdmin(request, response, con);
            } else if ("fetch".equals(action)) {
                fetchAdmins(request, response, con);
            }
        } catch (Exception e) {
            request.setAttribute("message", "Error : '" + e.getMessage() + "'");
            request.getRequestDispatcher("/WEB-INF/For Admin/settings.jsp").forward(request, response);
        }
    }

    private void addAdmin(HttpServletRequest request, HttpServletResponse response, Connection con) throws Exception {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // Validate email and password
        if (!InputValidator.isValidEmail(email)) {
            request.setAttribute("message", "Invalid email format!");
            request.getRequestDispatcher("/WEB-INF/For Admin/settings.jsp").forward(request, response);
            return;
        }

        if (!InputValidator.isValidPassword(password)) {
            request.setAttribute("message", "Weak password. Ensure it meets all the criteria!");
            request.getRequestDispatcher("/WEB-INF/For Admin/settings.jsp").forward(request, response);
            return;
        }

        // Insert new admin into the database
        try (PreparedStatement pstmt = con.prepareStatement("INSERT INTO stakeholders (username, email, password, role) VALUES (?, ?, ?, ?)")) {
            pstmt.setString(1, username);
            pstmt.setString(2, email);
            pstmt.setString(3, BCrypt.hashpw(password, BCrypt.gensalt()));
            pstmt.setString(4, role);
            pstmt.executeUpdate();
        }

        request.setAttribute("message", "Admin added successfully!");
        request.getRequestDispatcher("/WEB-INF/For Admin/settings.jsp").forward(request, response);
    }

    private void updateAdmin(HttpServletRequest request, HttpServletResponse response, Connection con) throws Exception {
        String updatedUsername = request.getParameter("updatedUsername");
        String updatedEmail = request.getParameter("updatedEmail");
        String newPassword = request.getParameter("newPassword");
        String confirmNewPassword = request.getParameter("confirmNewPassword");
        String loggedInUsername = request.getParameter("username");
        String loggedInRole = request.getParameter("role");

        if (!newPassword.equals(confirmNewPassword)) {
            request.setAttribute("message", "Passwords do not match!");
            request.getRequestDispatcher("/WEB-INF/For Admin/settings.jsp").forward(request, response);
            return;
        }

        // Validate email and password
        if (!InputValidator.isValidEmail(updatedEmail)) {
            request.setAttribute("message", "Invalid email format!");
            request.getRequestDispatcher("/WEB-INF/For Admin/settings.jsp").forward(request, response);
            return;
        }

        if (!InputValidator.isValidPassword(newPassword)) {
            request.setAttribute("message", "Weak password. Ensure it meets all the criteria!");
            request.getRequestDispatcher("/WEB-INF/For Admin/settings.jsp").forward(request, response);
            return;
        }

        PreparedStatement updateStmt = con.prepareStatement(
                "UPDATE stakeholders SET username = ?, email = ?, password = ?, role = ? WHERE username = ?");
        updateStmt.setString(1, updatedUsername);
        updateStmt.setString(2, updatedEmail);
        updateStmt.setString(3, BCrypt.hashpw(newPassword, BCrypt.gensalt()));
        updateStmt.setString(4, loggedInRole); // Use the role from cookies (not allowing the user to change their role)
        updateStmt.setString(5, loggedInUsername);
        updateStmt.executeUpdate();

        request.setAttribute("message", "Admin updated successfully!");
        request.getRequestDispatcher("/WEB-INF/For Admin/settings.jsp").forward(request, response);
    }

    private void removeAdmin(HttpServletRequest request, HttpServletResponse response, Connection con) throws Exception {
        String username = request.getParameter("username");
        PreparedStatement pstmt = con.prepareStatement("DELETE FROM stakeholders WHERE username = ?");
        pstmt.setString(1, username);
        pstmt.executeUpdate();

        request.setAttribute("message", "Admin removed successfully!");
        request.getRequestDispatcher("/WEB-INF/For Admin/settings.jsp").forward(request, response);
    }

    private void fetchAdmins(HttpServletRequest request, HttpServletResponse response, Connection con) throws Exception {
        List<Admin> admins = new ArrayList<>();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT username, email FROM stakeholders WHERE role = 'admin'");

        while (rs.next()) {
            Admin admin = new Admin(rs.getString("username"), rs.getString("email"));
            admins.add(admin);
        }

        request.setAttribute("admins", admins);
        request.getRequestDispatcher("/WEB-INF/For Admin/settings.jsp").forward(request, response);
    }
}
