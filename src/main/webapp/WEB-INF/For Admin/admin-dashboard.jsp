<%@ page import="com.example.demo2.AdminDAO.DashboardData" %>
<%@ page import="com.example.demo2.AdminDAO.DashboardStats" %>
<%
    DashboardStats stats = DashboardData.getDashboardStats();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css">
    <title>Admin Dashboard</title>
</head>
<body>
<!-- Sidebar Navigation -->
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

<!-- Main Container -->
<div class="container">
    <div class="header">
        <div class="nav">
            <div class="search">
                <h1>Admin Dashboard</h1>
            </div>
            <div class="user">
                <img src="${pageContext.request.contextPath}/assets/png/notifications.png" alt="">
                <div class="img-case">
                    <img src="${pageContext.request.contextPath}/assets/png/user.png" alt="">
                </div>
            </div>
        </div>
    </div>

    <!-- Dashboard Statistics Cards -->
    <div class="content">
        <div class="cards">
            <div class="card">
                <div class="box">
                    <h1><%= stats.getStudentCount() %></h1>
                    <h3>Students</h3>
                </div>
            </div>
            <div class="card">
                <div class="box">
                    <h1><%= stats.getStaffCount() %></h1>
                    <h3>Staffs</h3>
                </div>
            </div>
            <div class="card">
                <div class="box">
                    <h1><%= stats.getAdminCount() %></h1>
                    <h3>Admins</h3>
                </div>
            </div>
            <div class="card">
                <div class="box">
                    <h1><%= stats.getTotalCopies() %></h1>
                    <h3>Books</h3>
                </div>
            </div>
        </div>

        <!-- Recent Books Section -->
        <div class="content-2">
            <div class="recent-payments">
                <div class="title">
                    <h2>Recent Books</h2>
                </div>
                <table>
                    <tr>
                        <th>Title</th>
                        <th>Author</th>
                        <th>Price</th>
                        <th>Added Date</th>
                    </tr>
                    <%
                        for (String[] book : stats.getRecentBooks()) {
                    %>
                    <tr>
                        <td><%= book[0] %></td>
                        <td><%= book[1] %></td>
                        <td>$<%= book[2] %></td>
                        <td><%= book[3] %></td>
                    </tr>
                    <%
                        }
                    %>
                </table>
            </div>

            <!-- New Students Section -->
            <div class="new-students">
                <div class="title">
                    <h2>New Students</h2>
                </div>
                <table>
                    <tr>
                        <th>Profile</th>
                        <th>User Name</th>
                    </tr>
                    <%
                        for (String student : stats.getStudentNames()) {
                    %>
                    <tr>
                        <td><img src="${pageContext.request.contextPath}/assets/png/user.png" alt="Profile"></td>
                        <td><%= student %></td>
                    </tr>
                    <%
                        }
                    %>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>
