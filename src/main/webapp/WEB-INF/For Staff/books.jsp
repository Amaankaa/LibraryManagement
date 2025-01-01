<%@ page import="java.sql.*" %>
<%@ page import="com.example.demo2.booksDAO.books" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/student.css" rel="stylesheet">
    <title>Manage Books</title>
    <style>
        .form-container {
            max-width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 10px;
            text-align: left;
            border: 1px solid #ddd;
        }

        th {
            background-color: #f4f4f4;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
    </style>
    <script>
        function showForm() {
            const selectedAction = document.getElementById("actionSelector").value;
            const forms = document.querySelectorAll('.form-container');
            forms.forEach(form => form.classList.remove('active'));
            document.getElementById(selectedAction + "Form").classList.add('active');
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
        <h1>Staff-Dashboard</h1>
    </div>
    <div style="margin-top: 50px">
        <h1>Manage Books</h1>
        <select id="actionSelector" onchange="showForm()">
            <option value="add">Add Books</option>
            <option value="remove">Remove Books</option>
            <option value="fetch" selected>Fetch Books</option>
        </select>
    </div>

    <!-- Add Books Form -->
    <div id="addForm" class="form-container">
        <form method="post" action="books">
            <h3>Add Book</h3>
            <input type="text" name="title" placeholder="Book Title" required>
            <input type="hidden" name="target" value="/WEB-INF/For Staff/books.jsp">
            <input type="text" name="author" placeholder="Author" required>
            <input type="text" name="price" placeholder="Price" required>
            <input type="text" name="copies" placeholder="Copies" required>
            <input type="number" name="rating" placeholder="Rating (1-5)" required>
            <input type="text" name="image_url" placeholder="Image URL" required>
            <button type="submit" name="action" value="add">Add Book</button>
        </form>
    </div>

    <!-- Remove Books Form -->
    <div id="removeForm" class="form-container">
        <form method="post" action="books">
            <h3>Remove Book</h3>
            <input type="text" name="title" placeholder="Book Title to Remove" required>
            <input type="hidden" name="target" value="/WEB-INF/For Staff/books.jsp">
            <button type="submit" name="action" value="remove">Remove Book</button>
        </form>
    </div>

    <!-- Fetch Books Form -->
    <div id="fetchForm" class="form-container active">
        <form method="post" action="${pageContext.request.contextPath}/books">
            <h3>Fetch Books</h3>
            <input type="hidden" name="target" value="/WEB-INF/For Staff/books.jsp">
            <button type="submit" name="action" value="fetch">Fetch All Books</button>
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
        <%
            }
        %>
    </div>
</div>
</body>
</html>
