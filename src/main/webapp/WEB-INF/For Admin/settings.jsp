<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.demo2.AdminDAO.Admin" %>

<html>
<head>
    <link href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/student.css" rel="stylesheet">
    <title>Manage Admins</title>
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
        <h1>ADMIN</h1>
    </div>
    <ul>
        <li><a style="color: white" href="${pageContext.request.contextPath}/admin-navigator?page=dashboard">
            <img src="${pageContext.request.contextPath}/assets/png/dashboard%20(2).png">&nbsp; Dashboard</a></li>
        <li><a style="color: white" href="${pageContext.request.contextPath}/admin-navigator?page=students">
            <img src="${pageContext.request.contextPath}/assets/png/reading-book%20(1).png">&nbsp; Students</a></li>
        <li><a style="color: white" href="${pageContext.request.contextPath}/admin-navigator?page=staffs">
            <img src="${pageContext.request.contextPath}/assets/png/teacher2.png">&nbsp; Staffs</a></li>
        <li><a style="color: white" href="${pageContext.request.contextPath}/admin-navigator?page=books">
            <img src="${pageContext.request.contextPath}/assets/png/school.png">&nbsp; Books</a></li>
        <li><a style="color: white" href="${pageContext.request.contextPath}/admin-navigator?page=settings">
            <img src="${pageContext.request.contextPath}/assets/png/settings.png">&nbsp; Settings</a></li>
        <li><a style="color: white" href="${pageContext.request.contextPath}/admin-navigator?page=logout">
            <img src="${pageContext.request.contextPath}/assets/png/logout.png">&nbsp; Logout</a></li>
    </ul>

</div>
<div class="container">
    <div class="header">
        <div class="nav">
            <div class="search">
                <h1>Admin-Dashboard</h1>
            </div>
            <div class="user">
                <img src="${pageContext.request.contextPath}/assets/png/notifications.png" alt="">
                <div class="img-case">
                    <img src="${pageContext.request.contextPath}/assets/png/user.png" alt="">
                </div>
            </div>
        </div>
    </div>

    <div style="margin-top: 50px">
        <h1>Manage Admins</h1>
        <select id="actionSelector" onchange="showForm()">
            <option value="add">Add Admins</option>
            <option value="update">Update Info</option>
            <option value="remove">Remove Admins</option>
            <option value="fetch" selected>Fetch Admins</option>
        </select>
    </div>
    <!-- Add Admins Form -->
    <div id="addForm" class="form-container">
        <form method="post" action="${pageContext.request.contextPath}/AdminServlet">
            <h3>Add Admin</h3>
            <input type="text" name="username" placeholder="Username" required>
            <input type="email" name="email" placeholder="Email" required>
            <input type="password" name="password" placeholder="Password" required>
            <input type="text" name="role" placeholder="Role" required>
            <button type="submit" name="action" value="add">Add Admin</button>
        </form>
    </div>

    <!-- Update Admins Form -->
    <div id="updateForm" class="form-container">
        <form method="post" action="${pageContext.request.contextPath}/AdminServlet">
            <h3>Update Admin</h3>
            <input type="text" name="username" placeholder="Username" required>
            <input type="text" name="updatedUsername" placeholder="Updated Username" required>
            <input type="email" name="updatedEmail" placeholder="Updated Email" required>
            <input type="password" name="currentPassword" placeholder="Current Password" required>
            <input type="password" name="newPassword" placeholder="New Password" required>
            <input type="password" name="confirmNewPassword" placeholder="Confirm New Password" required>
            <select name="role" required>
                <option value="Admin" selected>Admin</option>
            </select>
            <button type="submit" name="action" value="update">Update Admin</button>
        </form>
    </div>

    <!-- Remove Admins Form -->
    <div id="removeForm" class="form-container">
        <form method="post" action="${pageContext.request.contextPath}/AdminServlet">
            <h3>Remove Admin</h3>
            <input type="text" name="username" placeholder="Admin username to Remove" required>
            <button type="submit" name="action" value="remove">Remove Admin</button>
        </form>
    </div>

    <!-- Fetch Admins Form -->
    <div id="fetchForm" class="form-container active">
        <form method="post" action="${pageContext.request.contextPath}/AdminServlet">
            <h3>Fetch Admins</h3>
            <button type="submit" name="action" value="fetch">Fetch All Admins</button>
        </form>

        <%-- Check if the 'admins' attribute is set by the servlet --%>
        <%
            List<Admin> admins = (List<Admin>) request.getAttribute("admins");
            if (admins != null && !admins.isEmpty()) {
        %>
        <table border="1">
            <tr>
                <th>Username</th>
                <th>Email</th>
            </tr>
            <% for (Admin admin : admins) { %>
            <tr>
                <td><%= admin.getUsername() %></td>
                <td><%= admin.getEmail() %></td>
            </tr>
            <% } %>
        </table>
        <%
        } else {
            }
        %>
    </div>


    <% if (request.getAttribute("message") != null) { %>
    <script>
        showMessage("<%= request.getAttribute("message") %>");
    </script>
    <% } %>

</div>
</body>
</html>
