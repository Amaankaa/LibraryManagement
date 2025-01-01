<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.demo2.booksDAO.books" %>
<%@ page import="com.example.demo2.booksDAO.lentBooks" %>
<html>
<head>
    <link href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/student.css" rel="stylesheet">
    <title>Manage Books</title>
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
        <li><a style="color: white" href="${pageContext.request.contextPath}/student-navigator?page=dashboard">
            <img src="${pageContext.request.contextPath}/assets/png/dashboard%20(2).png">&nbsp; Dashboard</a></li>
        <li><a style="color: white" href="${pageContext.request.contextPath}/student-navigator?page=books">
            <img src="${pageContext.request.contextPath}/assets/png/school.png">&nbsp; Books</a></li>
        <li><a style="color: white" href="${pageContext.request.contextPath}/student-navigator?page=settings">
            <img src="${pageContext.request.contextPath}/assets/png/settings.png">&nbsp; Settings</a></li>
        <li><a style="color: white" href="${pageContext.request.contextPath}/student-navigator?page=logout">
            <img src="${pageContext.request.contextPath}/assets/png/logout.png">&nbsp; Logout</a></li>
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
            <option value="borrowBooks">Borrow Book</option>
            <option value="returnBooks">Return Book</option>
            <option value="borrowedBooks">Check Borrowed Books</option>
        </select>
    </div>

    <!-- Return Books Form -->
    <div id="returnBooksForm" class="form-container">
        <form method="post" action="${pageContext.request.contextPath}/LibraryServlet">
            <h3>Return Book</h3>
            <input type="text" name="username" placeholder="Student Username" required>
            <input type="text" name="title" placeholder="Book Title" required>
            <input type="number" name="copies" placeholder="Copies to Return" required>
            <button type="submit" name="action" value="returnBooks">Return</button>
        </form>
    </div>

    <!-- Check Borrowed Books Form -->
    <div id="borrowedBooksForm" class="form-container">
        <h3>Borrowed Books</h3>
        <form method="post" action="${pageContext.request.contextPath}/LibraryServlet">
            <input type="text" name="username" placeholder="Student Username" required>
            <button type="submit" name = "action" value="borrowedBooks">Submit</button>
        </form>
        <div class="table-container">
            <table>
                <tr>
                    <th>Book Title</th>
                    <th>Copies Borrowed</th>
                </tr>
                <%
                    List<lentBooks> borrowedBooksList = (List<lentBooks>) request.getAttribute("borrowedBooksList");
                    if (borrowedBooksList != null) {
                        for (lentBooks borrowedBook : borrowedBooksList) {
                %>
                <tr>
                    <td><%= borrowedBook.getTitle() %></td>
                    <td><%= borrowedBook.getCopies() %></td>
                </tr>
                <%
                        }
                    }
                %>
            </table>
        </div>
    </div>

    <!-- Fetch All Books Form -->
    <div id="fetchForm" class="form-container active">
        <form method="post" action="${pageContext.request.contextPath}/books">
            <h3>Fetch Books</h3>
            <input type="hidden" name="target" value="/WEB-INF/For Student/books.jsp">
            <button type="submit" name = "action" value="fetch">Fetch All Books</button>
        </form>
        <%
            String message = (String) request.getAttribute("message");
            if (message != null) {
        %>
        <script>showMessage("<%= message %>");</script>
        <%
            }

            List<books> bookList = (List<books>) request.getAttribute("booksList");
            if (bookList != null && !bookList.isEmpty()) {
        %>
        <div class="table-container">
            <table>
                <tr>
                    <th>Title</th>
                    <th>Author</th>
                    <th>Price</th>
                    <th>Rating</th>
                    <th>Copies</th>
                </tr>
                <%
                    for (books book : bookList) {
                %>
                <tr>
                    <td><%= book.getTitle() %></td>
                    <td><%= book.getAuthor() %></td>
                    <td>$<%= book.getPrice() %></td>
                    <td><%= book.getRating() %></td>
                    <td><%= book.getCopies() %></td>
                </tr>
                <%
                    }
                %>
            </table>
        </div>
        <%
            }
        %>
    </div>

    <!-- Borrow Books Form -->
    <div id="borrowBooksForm" class="form-container">
        <form method="post" action="${pageContext.request.contextPath}/LibraryServlet">
            <h3>Borrow Book</h3>
            <input type="text" name="username" placeholder="Student Username" required>
            <input type="text" name="title" placeholder="Book Title" required>
            <input type="number" name="copies" placeholder="Copies to Borrow" required>
            <button type="submit" name = "action" value="borrowBooks">Borrow</button>
        </form>
    </div>
</div>
</body>
</html>
