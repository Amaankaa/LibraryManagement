package com.example.demo2.studentsDAO;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/student-navigator")
public class StudentNavigator extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String page = request.getParameter("page");

        if (page == null || page.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/For Student/student-dashboard.jsp");
            return;
        }

        switch (page) {
            case "books":
                request.getRequestDispatcher("/WEB-INF/For Student/books.jsp").forward(request, response);
                break;
            case "settings":
                request.getRequestDispatcher("/WEB-INF/For Student/settings.jsp").forward(request, response);
                break;
            case "logout":
                request.getRequestDispatcher("/index.jsp").forward(request, response);
                break;
            default:
                request.getRequestDispatcher("/WEB-INF/For Student/student-dashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
