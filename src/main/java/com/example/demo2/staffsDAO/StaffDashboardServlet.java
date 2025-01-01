package com.example.demo2.staffsDAO;

import com.example.demo2.dao.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.example.demo2.booksDAO.books;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/staff-dashboard")
public class StaffDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<books> books = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT title, author, price, rating, image_url FROM books")) {

            while (rs.next()) {
                books book = new books();
                book.setTitle(rs.getString("title"));
                book.setAuthor(rs.getString("author"));
                book.setPrice(rs.getDouble("price"));
                book.setRating(rs.getInt("rating"));
                book.setImageUrl(rs.getString("image_url"));
                books.add(book);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error fetching books: " + e.getMessage());
        }

        // Pass the books list to the JSP
        request.setAttribute("books", books);
        request.getRequestDispatcher("/WEB-INF/staff-dashboard.jsp").forward(request, response);
    }
}
