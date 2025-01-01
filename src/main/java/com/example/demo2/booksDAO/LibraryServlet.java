package com.example.demo2.booksDAO;

import com.example.demo2.dao.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/LibraryServlet")
public class LibraryServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String message = null;

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);

            switch (action) {
                case "returnBooks":
                    handleReturnBooks(request, con, response);
                    break;
                case "borrowBooks":
                    handleBorrowBooks(request, con, response);
                    break;
                case "borrowedBooks":
                    handleBorrowedBooks(request, con, response);
                    break;
                default:
                    message = "Invalid action!";
            }

            con.commit();
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }

        if (message != null) {
            request.setAttribute("message", message);
        }
        request.getRequestDispatcher("/WEB-INF/For Student/books.jsp").forward(request, response);
    }

    private void handleReturnBooks(HttpServletRequest request, Connection con, HttpServletResponse response) throws SQLException, ServletException, IOException {
        String username = request.getParameter("username");
        String title = request.getParameter("title");
        int copiesToReturn = Integer.parseInt(request.getParameter("copies"));

        PreparedStatement updateLentBooks = con.prepareStatement(
                "UPDATE lent_books SET copies_lent = copies_lent - ? WHERE username = ? AND Book_title = ?"
        );
        updateLentBooks.setInt(1, copiesToReturn);
        updateLentBooks.setString(2, username);
        updateLentBooks.setString(3, title);
        updateLentBooks.executeUpdate();

        PreparedStatement updateBooks = con.prepareStatement(
                "UPDATE books SET copies = copies + ? WHERE title = ?"
        );
        updateBooks.setInt(1, copiesToReturn);
        updateBooks.setString(2, title);
        updateBooks.executeUpdate();

        PreparedStatement checkCopiesLent = con.prepareStatement(
                "SELECT copies_lent FROM lent_books WHERE username = ? AND Book_title = ?"
        );
        checkCopiesLent.setString(1, username);
        checkCopiesLent.setString(2, title);
        ResultSet rs = checkCopiesLent.executeQuery();

        if (rs.next() && rs.getInt("copies_lent") == 0) {
            PreparedStatement deleteLentBook = con.prepareStatement(
                    "DELETE FROM lent_books WHERE username = ? AND Book_title = ?"
            );
            deleteLentBook.setString(1, username);
            deleteLentBook.setString(2, title);
            deleteLentBook.executeUpdate();
        }
        request.getRequestDispatcher("/WEB-INF/For Student/books.jsp").forward(request, response);
    }

    private void handleBorrowBooks(HttpServletRequest request, Connection con, HttpServletResponse response) throws SQLException, ServletException, IOException {
        String username = request.getParameter("username");
        String title = request.getParameter("title");
        int copiesToBorrow = Integer.parseInt(request.getParameter("copies"));

        PreparedStatement checkBook = con.prepareStatement(
                "SELECT copies FROM books WHERE title = ?"
        );
        checkBook.setString(1, title);
        ResultSet bookResult = checkBook.executeQuery();

        if (bookResult.next()) {
            int availableCopies = bookResult.getInt("copies");
            if (availableCopies >= copiesToBorrow) {
                PreparedStatement updateBooks = con.prepareStatement(
                        "UPDATE books SET copies = copies - ? WHERE title = ?"
                );
                updateBooks.setInt(1, copiesToBorrow);
                updateBooks.setString(2, title);
                updateBooks.executeUpdate();

                PreparedStatement checkLentBooks = con.prepareStatement(
                        "SELECT copies_lent FROM lent_books WHERE username = ? AND Book_title = ?"
                );
                checkLentBooks.setString(1, username);
                checkLentBooks.setString(2, title);
                ResultSet lentBooksResult = checkLentBooks.executeQuery();

                if (lentBooksResult.next()) {
                    PreparedStatement updateLentBooks = con.prepareStatement(
                            "UPDATE lent_books SET copies_lent = copies_lent + ? WHERE username = ? AND Book_title = ?"
                    );
                    updateLentBooks.setInt(1, copiesToBorrow);
                    updateLentBooks.setString(2, username);
                    updateLentBooks.setString(3, title);
                    updateLentBooks.executeUpdate();
                } else {
                    PreparedStatement insertLentBooks = con.prepareStatement(
                            "INSERT INTO lent_books (username, Book_title, copies_lent) VALUES (?, ?, ?)"
                    );
                    insertLentBooks.setString(1, username);
                    insertLentBooks.setString(2, title);
                    insertLentBooks.setInt(3, copiesToBorrow);
                    insertLentBooks.executeUpdate();
                }
            } else {
            }
        } else {
        }
        request.getRequestDispatcher("/WEB-INF/For Student/books.jsp").forward(request, response);
    }

    private void handleBorrowedBooks(HttpServletRequest request, Connection con, HttpServletResponse response) throws SQLException, ServletException, IOException {
        String username = request.getParameter("username");
        PreparedStatement ps = con.prepareStatement("SELECT username, Book_title, copies_lent FROM lent_books WHERE username = ?");
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();

        List<lentBooks> borrowedBooks = new ArrayList<>();
        while (rs.next()) {
            lentBooks book = new lentBooks();
            book.setUsername(rs.getString("username"));
            book.setTitle(rs.getString("Book_title"));
            book.setCopies(rs.getInt("copies_lent"));
            borrowedBooks.add(book);
        }

        request.setAttribute("borrowedBooksList", borrowedBooks); // Updated to match the correct attribute
        request.getRequestDispatcher("/WEB-INF/For Student/books.jsp").forward(request, response);
    }

}
