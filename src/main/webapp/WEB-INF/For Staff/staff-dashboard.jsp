<%@ page import="java.sql.*" %>
<%@ page import="com.example.demo2.dao.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <link href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/student.css" rel="stylesheet">
    <title>Staff Dashboard</title>
    <style>
        .content {
            width: 100%; /* Ensure the container spans the full width */
            margin: 0 auto; /* Center the container */
            height: 100%;
            box-sizing: border-box;
        }

        .book-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin: 20px;
            width: 100%; /* Ensure the grid takes full width */
            box-sizing: border-box;
        }

        .book-card {
            background-color: #f4f4f4;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
            transition: transform 0.2s;
        }

        .book-card:hover {
            transform: scale(1.05);
        }

        .book-card img {
            max-width: 100%;
            max-height: 300px; /* Maximum height for images */
            height: auto;
            border-radius: 4px;
            margin-bottom: 10px;
        }

        .book-card h3 {
            margin: 10px 0;
            font-size: 1.1em;
        }

        .book-card p {
            margin: 5px 0;
            font-size: 0.9em;
            color: #555;
        }

        .book-card .price {
            color: #007BFF;
            font-weight: bold;
        }

        .book-card .rating {
            color: #FFD700;
            font-size: 1.2em;
        }
    </style>
</head>
<body>
<div class="side-menu">
    <div class="brand-name">
        <h1>STAFF</h1>
    </div>
    <ul>
        <li><a style="color: white" href="${pageContext.request.contextPath}/staff-navigator?page=dashboard">
            <img src="${pageContext.request.contextPath}/assets/png/dashboard%20(2).png">&nbsp; Dashboard</a></li>
        <li><a style="color: white" href="${pageContext.request.contextPath}/staff-navigator?page=books">
            <img src="${pageContext.request.contextPath}/assets/png/school.png">&nbsp; Books</a></li>
        <li><a style="color: white" href="${pageContext.request.contextPath}/staff-navigator?page=students">
            <img src="${pageContext.request.contextPath}/assets/png/reading-book%20(1).png">&nbsp; Students</a></li>
        <li><a style="color: white" href="${pageContext.request.contextPath}/staff-navigator?page=settings">
            <img src="${pageContext.request.contextPath}/assets/png/settings.png">&nbsp; Settings</a></li>
        <li><a style="color: white" href="${pageContext.request.contextPath}/staff-navigator?page=logout">
            <img src="${pageContext.request.contextPath}/assets/png/logout.png">&nbsp; Logout</a></li>
    </ul>
</div>
<div class="container">
    <div class="header">
        <div class="nav">
            <div class="search">
                <h1>Staff-Dashboard</h1>
            </div>
            <div class="user">
                <img src="${pageContext.request.contextPath}/assets/png/notifications.png" alt="">
                <div class="img-case">
                    <img src="${pageContext.request.contextPath}/assets/png/user.png" alt="">
                </div>
            </div>
        </div>
    </div>

    <!-- Book Grid -->
    <div class="content">
        <h2 style="text-align: center; margin-top: 20px;">Available Books</h2>
        <div class="book-grid">
            <%
                try {Connection con = DBConnection.getConnection();
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT title, author, price, rating, image_url FROM books");

                    while (rs.next()) {
                        String title = rs.getString("title");
                        String author = rs.getString("author");
                        double price = rs.getDouble("price");
                        int rating = rs.getInt("rating");
                        String imageUrl = rs.getString("image_url");
            %>
            <div class="book-card">
                <img src="<%= imageUrl != null ? request.getContextPath() + imageUrl : request.getContextPath() + "/assets/img/NotFound.jpg" %>" alt="<%= title %>">
                <h3><%= title %></h3>
                <p>by <%= author %></p>
                <p class="price">$<%= String.format("%.2f", price) %></p>
                <p class="rating">
                    <%
                        for (int i = 0; i < 5; i++) {
                            if (i < rating) {
                    %>
                    ⭐
                    <%
                    } else {
                    %>
                    ☆
                    <%
                            }
                        }
                    %>
                </p>
            </div>
            <%
                }
                con.close();
            } catch (Exception e) {
            %>
            <script>
                alert("Error occurred while fetching books: <%= e.getMessage() %>");
            </script>
            <%
                }
            %>
        </div>
    </div>
</div>
</body>
</html>
