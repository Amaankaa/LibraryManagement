package com.example.demo2.staffsDAO;

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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/StaffServlet")
public class StaffServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try (Connection con = DBConnection.getConnection()) {
            if ("add".equals(action)) {
                handleAddStaff(request, response, con);
            } else if ("remove".equals(action)) {
                handleRemoveStaff(request, response, con);
            } else if ("fetch".equals(action)) {
                handleFetchStaffs(request, response, con);
            } else if ("update".equals(action)) {
                updateStaff(request, response, con);
            }
        } catch (Exception e) {
            response.getWriter().println("<script>alert('Error: " + e.getMessage() + "'); window.location = 'staffs.jsp';</script>");
        }
    }

    private void handleAddStaff(HttpServletRequest request, HttpServletResponse response, Connection con) throws Exception {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // Email validation
        if (!InputValidator.isValidEmail(email)) {
            response.getWriter().println(
                    "<script>alert('Invalid email format!'); window.location = 'staffs.jsp';</script>");
            return;
        }

        // Password validation
       if (!InputValidator.isValidPassword(password)) {
            response.getWriter().println(
                    "<script>alert('Weak password! It must include: \\n- At least 8 characters.\\n- An uppercase letter.\\n- A lowercase letter.\\n- A number.\\n- A special character.'); window.location = 'staffs.jsp';</script>");
            return;
        }

        // Add staff
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        PreparedStatement pstmt = con.prepareStatement("INSERT INTO stakeholders (username, email, password, role) VALUES (?, ?, ?, ?)");
        pstmt.setString(1, username);
        pstmt.setString(2, email);
        pstmt.setString(3, hashedPassword);
        pstmt.setString(4, role);
        pstmt.executeUpdate();

        request.setAttribute("message", "Staff added successfully!");
        request.getRequestDispatcher("/WEB-INF/For Admin/staffs.jsp").forward(request, response);
    }

    private void handleRemoveStaff(HttpServletRequest request, HttpServletResponse response, Connection con) throws Exception {
        String username = request.getParameter("username");

        PreparedStatement pstmt = con.prepareStatement("DELETE FROM stakeholders WHERE username = ?");
        pstmt.setString(1, username);
        pstmt.executeUpdate();

        request.setAttribute("message", "Staff removed successfully!");
        request.getRequestDispatcher("/WEB-INF/For Admin/staffs.jsp").forward(request, response);
    }

    private void handleFetchStaffs(HttpServletRequest request, HttpServletResponse response, Connection con) throws Exception {
        PreparedStatement pstmt = con.prepareStatement("SELECT username, email FROM stakeholders WHERE role = 'staff'");
        ResultSet rs = pstmt.executeQuery();

        List<Staff> staffList = new ArrayList<>();
        while (rs.next()) {
            String username = rs.getString("username");
            String email = rs.getString("email");
            staffList.add(new Staff(username, email));
        }

        request.setAttribute("staffs", staffList);
        String target = request.getParameter("target");
        request.getRequestDispatcher(target).forward(request, response);
    }

    private void updateStaff(HttpServletRequest request, HttpServletResponse response, Connection con) throws SQLException, IOException, ServletException {
        String username = request.getParameter("username");
        String updatedUsername = request.getParameter("updatedUsername");
        String updatedEmail = request.getParameter("updatedEmail");
        String newPassword = request.getParameter("newPassword");
        String confirmNewPassword = request.getParameter("confirmNewPassword");
        String role = request.getParameter("role");
        String target = request.getParameter("target");

        if (!newPassword.equals(confirmNewPassword)) {
            response.getWriter().println(
                    "<script type=\"text/javascript\">"
                            + "alert('New password doesn't match');"
                            + "</script>"
            );
            request.getRequestDispatcher(target).forward(request, response);
            return;
        }


        if (!InputValidator.isValidEmail(updatedEmail)) {
            response.getWriter().println(
                    "<script type=\"text/javascript\">"
                            + "alert('Invalid email format! Please try again.');"
                            + "</script>"
            );
            request.getRequestDispatcher(target).forward(request, response);
            return;
        }

        if (!InputValidator.isValidPassword(newPassword)) {
            response.getWriter().println(
                    "<script type=\"text/javascript\">"
                            + "alert('Your password is too weak. It must:\\n- Be at least 8 characters long.\\n- Include at least one uppercase letter.\\n- Include at least one lowercase letter.\\n- Include at least one number.\\n- Include at least one special character (e.g., @, $, %, &).');"
                            + "</script>"
            );
            return;
        }

        try (PreparedStatement stmt = con.prepareStatement("SELECT password FROM stakeholders WHERE username = ?")) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String hashedNewPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
                try (PreparedStatement updateStmt = con.prepareStatement(
                        "UPDATE stakeholders SET email = ?, password = ?, role = ?, username = ? WHERE username = ?")) {
                    updateStmt.setString(1, updatedEmail);
                    updateStmt.setString(2, hashedNewPassword);
                    updateStmt.setString(3, role);
                    updateStmt.setString(4, updatedUsername);
                    updateStmt.setString(5, username);
                    updateStmt.executeUpdate();

                    response.getWriter().println(
                            "<script type=\"text/javascript\">"
                                    + "alert('Info updated successfully!');"
                                    + "</script>"
                    );
                    request.getRequestDispatcher(target).forward(request, response);
                }
                } else {
                    response.getWriter().println(
                            "<script type=\"text/javascript\">"
                                    + "alert('Incorrect password');"
                                    + "</script>"
                    );
                    request.getRequestDispatcher(target).forward(request, response);
                }
        }
                request.getRequestDispatcher(target).forward(request, response);
    }
}
