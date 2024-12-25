<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link href="../assets/css/admin-dashboard.css" rel="stylesheet">
    <title>Manage Books</title>
    <link href="../assets/css/students.css" rel="stylesheet">
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            overflow-x: auto;
        }

        table th, table td {
            text-align: left;
            padding: 8px;
        }

        table tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        .table-container {
            overflow-x: auto;
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
        <h1>STAFF</h1>
    </div>
    <ul>
        <li><a style="color: white" href="${pageContext.request.contextPath}/For%20Staff/staff-dashboard.jsp"><img src="${pageContext.request.contextPath}/assets/png/dashboard%20(2).png">&nbsp; Dashboard</a></li>
        <li><a style="color: white" href="${pageContext.request.contextPath}/For%20Staff/students.jsp"><img src="${pageContext.request.contextPath}/assets/png/reading-book (1).png">&nbsp; Students</a></li>
        <li><a style="color: white" href="${pageContext.request.contextPath}/For%20Staff/books.jsp"><img src="${pageContext.request.contextPath}/assets/png/school.png">&nbsp; Books</a></li>
        <li><a style="color: white" href="${pageContext.request.contextPath}/For%20Staff/settings.jsp"><img src="${pageContext.request.contextPath}/assets/png/settings.png">&nbsp; Settings</a></li>
        <li><a style="color: white" href="${pageContext.request.contextPath}/index.jsp"><img src="${pageContext.request.contextPath}/assets/png/logout.png">&nbsp; Logout</a></li>
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

    <div style="margin-top: 50px;">
        <h1>Manage Library Books</h1>
        <select id="actionSelector" onchange="showForm()">
            <option value="searchBooks" selected>Search Books</option>
            <option value="addBooks">Add Books</option>
            <option value="removeBooks">Remove Books</option>
            <option value="lendBooks">Lend Books</option>
        </select>
    </div>

    <div id="addBooksForm" class="form-container">
        <form method="post">
            <h3>Add Book</h3>
            <input type="text" name="title" placeholder="Book Title" required>
            <input type="text" name="author" placeholder="Author" required>
            <input type="number" name="price" placeholder="Price" required>
            <input type="number" name="copies" placeholder="Copies" required>
            <input type="number" name="rating" placeholder="Rating (1 - 5)" required>
            <input type="text" name="image_url" placeholder="Image URL" required>
            <button type="submit" name="action" value="addBooks">Add</button>
        </form>
    </div>

    <div id="removeBooksForm" class="form-container">
        <form method="post">
            <h3>Remove Book</h3>
            <input type="text" name="title" placeholder="Book Title" required>
            <button type="submit" name="action" value="removeBooks">Remove</button>
        </form>
    </div>
    <div id="lendBooksForm" class="form-container">
        <form method="post">
            <h3>Lend Book</h3>
            <input type="text" name="username" placeholder="Student Username" required>
            <input type="text" name="title" placeholder="Book Title" required>
            <input type="number" name="copies" placeholder="Copies" required>
            <button type="submit" name="action" value="lendBooks">Lend</button>
        </form>
    </div>

    <div id="searchBooksForm" class="form-container active">
        <form method="post">
            <h3>Search Books</h3>
            <input type="text" name="title" placeholder="Book Title" required>
            <button type="submit" name="action" value="searchBooks">Search</button>
        </form>
        <%
            if ("searchBooks".equals(request.getParameter("action"))) {
                try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/mydb", "root", "root123")) {
                    String searchTitle = request.getParameter("title");
                    PreparedStatement ps = con.prepareStatement("SELECT * FROM books WHERE title LIKE ?");
                    ps.setString(1, "%" + searchTitle + "%");
                    ResultSet rs = ps.executeQuery();
        %>
        <div class="table-container">
            <table border="1">
                <tr>
                    <th>Title</th>
                    <th>Author</th>
                    <th>Price</th>
                    <th>Rating</th>
                    <th>Copies</th>
                </tr>
                <% while (rs.next()) { %>
                <tr>
                    <td><%= rs.getString("title") %></td>
                    <td><%= rs.getString("author") %></td>
                    <td>$<%= rs.getString("price") %></td>
                    <td><%= rs.getString("rating") %></td>
                    <td><%= rs.getInt("copies") %></td>
                </tr>
                <% } %>
            </table>
        </div>
        <%
                }
            }
        %>
    </div>

<%
        String action = request.getParameter("action");
        if (action != null && !"searchBooks".equals(action)) {
            try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/mydb", "root", "root123")) {
                String message = "";
                switch (action) {
                    case "addBooks":
                        String addTitle = request.getParameter("title");
                        String addAuthor = request.getParameter("author");
                        String rating = request.getParameter("rating");
                        String image_url = request.getParameter("image_url");
                        int addPrice = Integer.parseInt(request.getParameter("price"));
                        int addCopies = Integer.parseInt(request.getParameter("copies"));
                        PreparedStatement addPs = con.prepareStatement("INSERT INTO books (title, author, price, copies, rating, image_url) VALUES (?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE copies = copies + ?");
                        addPs.setString(1, addTitle);
                        addPs.setString(2, addAuthor);
                        addPs.setInt(3, addPrice);
                        addPs.setInt(4, addCopies);
                        addPs.setInt(5, Integer.parseInt(rating));
                        addPs.setString(6, image_url);
                        addPs.setInt(7, addCopies);
                        addPs.executeUpdate();
                        message = "Book added successfully!";
                        break;
                    case "removeBooks":
                        String removeTitle = request.getParameter("title");
                        PreparedStatement removePs = con.prepareStatement("DELETE FROM books WHERE title = ?");
                        removePs.setString(1, removeTitle);
                        removePs.executeUpdate();
                        message = "Book removed successfully!";
                        break;
                    case "lendBooks":
                        String username = request.getParameter("username");
                        String lendTitle = request.getParameter("title");
                        int lendCopies = Integer.parseInt(request.getParameter("copies"));
                        PreparedStatement userCheckPs = con.prepareStatement("SELECT * FROM stakeholders WHERE username = ?");
                        userCheckPs.setString(1, username);
                        ResultSet userCheckRs = userCheckPs.executeQuery();
                        if (userCheckRs.next()) {
                            PreparedStatement lendPs = con.prepareStatement("UPDATE books SET copies = copies - ? WHERE title = ?");
                            lendPs.setInt(1, lendCopies);
                            lendPs.setString(2, lendTitle);
                            lendPs.executeUpdate();
                            lendPs = con.prepareStatement("INSERT INTO lent_books (username, Book_title, copies_lent) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE copies_lent = copies_lent + ?");
                            lendPs.setString(1, username);
                            lendPs.setString(2, lendTitle);
                            lendPs.setInt(3, lendCopies);
                            lendPs.setInt(4, lendCopies);
                            lendPs.executeUpdate();
                            message = "Book lent successfully!";
                        } else {
                            message = "Student username not found!";
                        }
                        break;
                }
%>
    <script>showMessage("<%= message %>");</script>
    <%
    } catch (Exception e) {
    %>
    <script>showMessage("An error occurred: <%= e.getMessage() %>");</script>
    <%
            }
        }
    %>
</div>
</body>
</html>