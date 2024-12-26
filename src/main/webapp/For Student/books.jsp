<%@ page language="java" import="java.sql.*" %>
<%@ page import="com.example.demo2.dao.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link href="../assets/css/admin-dashboard.css" rel="stylesheet">
    <title>Manage Books</title>
    <link href="../assets/css/student.css" rel="stylesheet">
    <style>
        .table-container {
            max-width: 100%;
            max-height: 300px;
            overflow-y: auto;
            border: 1px solid #ccc;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid black;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
        .form-container {
            margin-top: 20px;
        }
        .form-container.active {
            display: block;
        }
        .form-container:not(.active) {
            display: none;
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
            alert(message); // Use JavaScript alert to display messages
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
        <li><a style="color: white" href="${pageContext.request.contextPath}/index.jsp"><img src="${pageContext.request.contextPath}/assets/png/logout.png">&nbsp; Logout</a></li>
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

    <div style="margin-top: 50px;">
        <h1>Library Actions</h1>
        <select id="actionSelector" onchange="showForm()">
            <option value="fetchBooks" selected>Fetch All Books</option>
            <option value="borrowBooks">Borrow Books</option>
            <option value="returnBooks">Return Books</option>
            <option value="borrowedBooks">Check Borrowed Books</option>
        </select>
    </div>

    <!-- Return Books Form -->
    <div id="returnBooksForm" class="form-container">
        <form method="post">
            <h3>Return Book</h3>
            <input type="text" name="username" placeholder="Student Username" required>
            <input type="text" name="title" placeholder="Book Title" required>
            <input type="number" name="copies" placeholder="Copies to Return" required>
            <button type="submit" name="action" value="returnBooks">Return</button>
        </form>
        <%
            if ("returnBooks".equals(request.getParameter("action"))) {
                String username = request.getParameter("username");
                String title = request.getParameter("title");
                int copiesToReturn = Integer.parseInt(request.getParameter("copies"));

                try (Connection con = DBConnection.getConnection()) {
                    con.setAutoCommit(false);

                    PreparedStatement updateLentBooks = con.prepareStatement(
                            "UPDATE lent_books SET copies_lent = copies_lent - ? WHERE username = ? AND Book_title = ?"
                    );
                    updateLentBooks.setInt(1, copiesToReturn);
                    updateLentBooks.setString(2, username);
                    updateLentBooks.setString(3, title);
                    int lentBooksUpdated = updateLentBooks.executeUpdate();

                    PreparedStatement updateBooks = con.prepareStatement(
                            "UPDATE books SET copies = copies + ? WHERE title = ?"
                    );
                    updateBooks.setInt(1, copiesToReturn);
                    updateBooks.setString(2, title);
                    int booksUpdated = updateBooks.executeUpdate();

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

                    if (lentBooksUpdated > 0 && booksUpdated > 0) {
                        con.commit();
        %>
        <script>showMessage("Book returned successfully!");</script>
        <%
        } else {
            con.rollback();
        %>
        <script>showMessage("Failed to return book. Please check the details.");</script>
        <%
            }
        } catch (SQLException e) {
        %>
        <script>showMessage("Error while returning book: <%= e.getMessage() %>");</script>
        <%
                }
            }
        %>
    </div>

    <!-- Borrowed Books Form -->
    <div id="borrowedBooksForm" class="form-container">
        <h3>Borrowed Books</h3>
        <form method="post">
            <input type="text" name="username" placeholder="Student Username" required>
            <button type="submit" name="action" value="borrowedBooks">Submit</button>
        </form>
        <div class="table-container">
            <table>
                <tr>
                    <th>Book Title</th>
                    <th>Copies Borrowed</th>
                </tr>
                <%
                    String borrowedUsername = request.getParameter("username");
                    if (borrowedUsername != null && !borrowedUsername.isEmpty()) {
                        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/mydb", "root", "root123")) {
                            PreparedStatement ps = con.prepareStatement("SELECT Book_title, copies_lent FROM lent_books WHERE username = ?");
                            ps.setString(1, borrowedUsername);
                            ResultSet rs = ps.executeQuery();
                            while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("Book_title") %></td>
                    <td><%= rs.getInt("copies_lent") %></td>
                </tr>
                <%
                    }
                } catch (SQLException e) {
                %>
                <script>showMessage("Error fetching borrowed books: <%= e.getMessage() %>");</script>
                <%
                        }
                    }
                %>
            </table>
        </div>
    </div>

    <!-- Fetch All Books Form -->
    <div id="fetchBooksForm" class="form-container active">
        <form method="post">
            <h3>Fetch All Books</h3>
            <button type="submit" name="action" value="fetchBooks">Fetch All Books</button>
        </form>
        <%
            if ("fetchBooks".equals(request.getParameter("action"))) {
                try (Connection con = DBConnection.getConnection();
                     Statement stmt = con.createStatement();
                     ResultSet rs = stmt.executeQuery("SELECT * FROM books")) {
        %>
        <div class="table-container">
            <table>
                <tr>
                    <th>Title</th>
                    <th>Author</th>
                    <th>Price</th>
                    <th>Copies</th>
                </tr>
                <% while (rs.next()) { %>
                <tr>
                    <td><%= rs.getString("title") %></td>
                    <td><%= rs.getString("author") %></td>
                    <td>$<%= rs.getDouble("price") %></td>
                    <td><%= rs.getInt("copies") %></td>
                </tr>
                <% } %>
            </table>
        </div>
        <%
        } catch (SQLException e) {
        %>
        <script>showMessage("Error fetching books: <%= e.getMessage() %>");</script>
        <%
                }
            }
        %>
    </div>

    <!-- Borrow Books Form -->
    <div id="borrowBooksForm" class="form-container">
        <form method="post">
            <h3>Borrow Book</h3>
            <input type="text" name="username" placeholder="Student Username" required>
            <input type="text" name="title" placeholder="Book Title" required>
            <input type="number" name="copies" placeholder="Copies to Borrow" required>
            <button type="submit" name="action" value="borrowBooks">Borrow</button>
        </form>
        <%
            if ("borrowBooks".equals(request.getParameter("action"))) {
                String username = request.getParameter("username");
                String title = request.getParameter("title");
                int copiesToBorrow = Integer.parseInt(request.getParameter("copies"));

                try (Connection con = DBConnection.getConnection()) {
                    con.setAutoCommit(false);

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

                            con.commit();
        %>
        <script>showMessage("Book borrowed successfully!");</script>
        <%
        } else {
        %>
        <script>showMessage("Not enough copies available to borrow.");</script>
        <%
            }
        } else {
        %>
        <script>showMessage("Book not found.");</script>
        <%
            }
        } catch (SQLException e) {
        %>
        <script>showMessage("Error while borrowing book: <%= e.getMessage() %>");</script>
        <%
                }
            }
        %>
    </div>
</div>
</body>
</html>
