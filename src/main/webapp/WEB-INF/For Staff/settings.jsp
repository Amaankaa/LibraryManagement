<%@ page import="java.sql.*" %>
<%@ page import ="org.mindrot.jbcrypt.BCrypt"%>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="com.example.demo2.dao.DBConnection" %>
<%@ page import="com.example.demo2.staffsDAO.Staff" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/student.css" rel="stylesheet">
    <title>Staff Dashboard</title>
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
            <div class="user">
                <img src="${pageContext.request.contextPath}/assets/png/notifications.png" alt="">
                <div class="img-case">
                    <img src="${pageContext.request.contextPath}/assets/png/user.png" alt="">
                </div>
            </div>
        </div>
    </div>


    <div style="margin-top: 50px">
        <h1>Manage Staffs</h1>
        <select id="actionSelector" onchange="showForm()">
            <option value="update">Update Info</option>
            <option value="fetch" selected>Fetch Staffs</option>
        </select>
    </div>

    <!-- Update Staffs Form -->
    <div id="updateForm" class="form-container">
        <form method="post" action = "StaffServlet">
            <h3>Update Staff</h3>
            <input type="text" name="username" placeholder="Username" required>
            <input type="hidden" name="target" value="/WEB-INF/For Staff/settings.jsp">
            <input type="text" name="updatedUsername" placeholder="Updated Username" required>
            <input type="text" name="email" placeholder="Email" required>
            <input type="text" name="updatedEmail" placeholder="Updated Email" required>
            <input type="password" name="currentPassword" placeholder="Current Password" required>
            <input type="password" name="newPassword" placeholder="New Password" required>
            <input type="password" name="confirmNewPassword" placeholder="Confirm New Password" required>
            <select name="role" required>
                <option value="Staff" selected>Staff</option>
            </select>
            <button type="submit" name="action" value="update">Update Staff</button>
        </form>
    </div>


    <!-- Fetch Staffs Form -->
    <div id="fetchForm" class="form-container active">
        <form method="post" action="StaffServlet">
            <h3>Fetch Staffs</h3>
            <input type="hidden" name="target" value="/WEB-INF/For Staff/settings.jsp">
            <button type="submit" name="action" value="fetch">Fetch All Staffs</button>
        </form>

        <%-- Check if the "staffs" attribute exists and is not empty --%>
        <%
            List<Staff> staffs = (List<Staff>) request.getAttribute("staffs");
            if (staffs != null && !staffs.isEmpty()) {
        %>
        <table border="1">
            <tr>
                <th>Username</th>
                <th>Email</th>
            </tr>
            <% for (Staff staff : staffs) { %>
            <tr>
                <td><%= staff.getUsername() %></td>
                <td><%= staff.getEmail() %></td>
            </tr>
            <% }} %>
        </table>
    </div>
</div>
</body>
</html>