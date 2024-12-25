<%@ page language="java" import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link href="assets/css/admin-dashboard.css" rel="stylesheet">
    <title>Dashboard</title>
    <link href="assets/css/students.css" rel="stylesheet">
    <style>
        .content {
            width: 100%; /* Ensure the container spans the full width */
            margin: 0 auto; /* Center the container */
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
    <script>
        function showForm() {
            const selectedAction = document.getElementById("actionSelector").value;
            const forms = document.querySelectorAll('.form-container');
            forms.forEach(form => form.classList.remove('active'));
            if (selectedAction) {
                document.getElementById(selectedAction + "Form").classList.add('active');
            }
        }

        function showMessage(message) {
            alert(message);
        }
    </script>
</head>
<body>
<div class="side-menu">
    <div class="brand-name">
        <h1>STUDENT</h1>
    </div>
    <ul>
        <li><a style="color: white" href="student-dashboard.jsp"><img src="${pageContext.request.contextPath}/assets/png/dashboard%20(2).png">&nbsp; Dashboard</a></li>
        <li><a style="color: white" href="books.jsp"><img src="${pageContext.request.contextPath}/assets/png/school.png">&nbsp; Books</a></li>
        <li><a style="color: white" href="settings.jsp"><img src="${pageContext.request.contextPath}/assets/png/settings.png">&nbsp; Settings</a></li>
    </ul>
</div>
<div class="container">
    <div class="header">
        <div class="nav">
            <div class="search">
                <h1>Student-Dashboard</h1>
            </div>
            <div class="user">
                <img src="${pageContext.request.contextPath}/assets/png/notifications.png" alt="">
                <div class="img-case">
                    <img src="${pageContext.request.contextPath}/assets/png/user.png" alt="">
                </div>
            </div>
        </div>
    </div>
    <div class="content">
        <h2 style="text-align: center; margin-top: 20px;">Available Books</h2>
        <div class="book-grid">
            <%
                try {
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/mydb", "root", "root123");
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
                <img src="<%= imageUrl != null ? imageUrl : "assets/img/Not found.jpg" %>" alt="<%= title %>">
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
                window.location = 'staff-dashboard.jsp';
            </script>
            <%
                }
            %>
        </div>
    </div>
</div>
</body>
</html>
