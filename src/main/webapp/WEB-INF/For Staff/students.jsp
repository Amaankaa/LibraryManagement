<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/student.css" rel="stylesheet">
    <title>Manage Students</title>
    <script>
        function showForm() {
            const selectedAction = document.getElementById("actionSelector").value;
            const forms = document.querySelectorAll('.form-container');
            forms.forEach(form => form.classList.remove('active'));
            document.getElementById(selectedAction + "Form").classList.add('active');
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
        <div class="nav">
            <div class="search">
                <h1>Staff-Dashboard</h1>
            </div>
        </div>
    </div>

    <div style="margin-top: 50px">
        <h1>Manage Students</h1>
        <select id="actionSelector" onchange="showForm()">
            <option value="add">Add Students</option>
            <option value="remove">Remove Students</option>
            <option value="fetch" selected>Fetch Students</option>
        </select>
    </div>

    <!-- Add Student Form -->
    <div id="addForm" class="form-container">
        <form method="post" action="StudentServlet">
            <h3>Add Student</h3>
            <input type="text" name="username" placeholder="Username" required>
            <input type="hidden" name="target" value="/WEB-INF/For Staff/students.jsp">
            <input type="text" name="email" placeholder="Email" required>
            <input type="password" name="password" placeholder="Password" required>
            <input type="text" name="role" placeholder="Role" required>
            <button type="submit" name="action" value="add">Add Student</button>
        </form>
    </div>

    <!-- Remove Student Form -->
    <div id="removeForm" class="form-container">
        <form method="post" action="StudentServlet">
            <h3>Remove Student</h3>
            <input type="hidden" name="target" value="/WEB-INF/For Staff/students.jsp">
            <input type="text" name="username" placeholder="Student username to Remove" required>
            <button type="submit" name="action" value="remove">Remove Student</button>
        </form>
    </div>

    <!-- Fetch Students -->
    <div id="fetchForm" class="form-container active">
        <form method="post" action="StudentServlet">
            <h3>Fetch Students</h3>
            <input type="hidden" name="target" value="/WEB-INF/For Staff/students.jsp">
            <button type="submit" name="action" value="fetch">Fetch All Students</button>
        </form>
        <%
            ResultSet students = (ResultSet) request.getAttribute("students");
            if (students != null) {
        %>
        <table border="1">
            <tr>
                <th>Username</th>
                <th>Email</th>
            </tr>
            <%
                while (students.next()) {
            %>
            <tr>
                <td><%= students.getString("username") %></td>
                <td><%= students.getString("email") %></td>
            </tr>
            <% } %>
        </table>
        <% } %>
    </div>
</div>
</body>
</html>
