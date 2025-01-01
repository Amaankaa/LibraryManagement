package com.example.demo2.booksDAO;

import com.example.demo2.dao.DBConnection;
import com.example.demo2.booksDAO.books;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/books")
public class BooksServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try (Connection connection = DBConnection.getConnection()) {
            switch (action) {
                case "add":
                    handleAddBook(request, connection, response);
                    break;
                case "remove":
                    handleRemoveBook(request, connection, response);
                    break;
                case "fetch":
                    handleFetchBooks(request, connection, response);
                    break;
                default:
                    response.getWriter().write("Invalid action");
                    break;
            }
        } catch (SQLException e) {
            response.getWriter().write("Database error: " + e.getMessage());
        }
    }

    private void handleAddBook(HttpServletRequest request, Connection connection, HttpServletResponse response) throws SQLException, IOException, ServletException {
        books book = new books(
                request.getParameter("title"),
                request.getParameter("author"),
                Double.parseDouble(request.getParameter("price")),
                Integer.parseInt(request.getParameter("copies")),
                Integer.parseInt(request.getParameter("rating")),
                request.getParameter("image_url")
        );

        String query = "INSERT INTO books (title, author, price, copies, rating, image_url) " +
                "VALUES (?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE copies = copies + ?";
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setString(1, book.getTitle());
            pstmt.setString(2, book.getAuthor());
            pstmt.setDouble(3, book.getPrice());
            pstmt.setInt(4, book.getCopies());
            pstmt.setInt(5, book.getRating());
            pstmt.setString(6, book.getImageUrl());
            pstmt.setInt(7, book.getCopies());
            pstmt.executeUpdate();
            request.setAttribute("message", "Book added successfully!");
        }
        String target = request.getParameter("target");
        request.getRequestDispatcher(target).forward(request, response);
    }

    private void handleRemoveBook(HttpServletRequest request, Connection connection, HttpServletResponse response) throws SQLException, IOException, ServletException {
        String title = request.getParameter("title");
        String query = "DELETE FROM books WHERE title = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setString(1, title);
            pstmt.executeUpdate();
            request.setAttribute("message", "Book removed successfully!");
        }
        String target = request.getParameter("target");
        request.getRequestDispatcher(target).forward(request, response);
    }

    private void handleFetchBooks(HttpServletRequest request, Connection connection, HttpServletResponse response) throws SQLException, IOException, ServletException {
        String query = "SELECT * FROM books";
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            ResultSet rs = pstmt.executeQuery();
            List<books> booksList = new ArrayList<>();
            while (rs.next()) {
                books book = new books();
                book.setTitle(rs.getString("title"));
                book.setAuthor(rs.getString("author"));
                book.setPrice(rs.getDouble("price"));
                book.setCopies(rs.getInt("copies"));
                book.setRating(rs.getInt("rating"));
                book.setImageUrl(rs.getString("image_url"));
                booksList.add(book);
            }
            request.setAttribute("booksList", booksList);

            // Retrieve the target path from the hidden input
            String target = request.getParameter("target");

            // Ensure that the target is not null and forward to the target JSP
            if (target != null && !target.isEmpty()) {
                request.getRequestDispatcher(target).forward(request, response);
            } else {
                // Handle the case when the target is not provided (fallback to a default page)
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Target page not found.");
            }
        }
    }
}
