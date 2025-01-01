package com.example.demo2.staffsDAO;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/staff-navigator")
public class StaffNavigator extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String page = request.getParameter("page");

        if (page == null || page.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/For%Staff/staff-dashboard.jsp");
            return;
        }

        switch (page) {
            case "students":
                request.getRequestDispatcher("/WEB-INF/For%20Staff/students.jsp").forward(request, response);
                break;
            case "books":
                request.getRequestDispatcher("/WEB-INF/For%20Staff/books.jsp").forward(request, response);
                break;
            case "settings":
                request.getRequestDispatcher("/WEB-INF/For%20Staff/settings.jsp").forward(request, response);
                break;
            case "logout":
                request.getRequestDispatcher("/index.jsp").forward(request, response);
                break;
            default:
                request.getRequestDispatcher("/WEB-INF/For%20Staff/staff-dashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
