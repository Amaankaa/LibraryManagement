<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css">
    <title>Admin Dashboard</title>
</head>
<body>
<div class="side-menu">
    <div class="brand-name">
        <h1>ADMIN</h1>
    </div>
    <ul>
        <li><a style="color: white" href="students.jsp">Dashboard</a></li>
        <li><a style="color: white" href="students.jsp">Students</a></li>
        <li><a style="color: white" href="staffs.jsp">Staffs</a></li>
        <li><a style="color: white" href="books.jsp">Books</a></li>
        <li><a style="color: white" href="help.jsp">Help</a></li>
        <li><a style="color: white" href="settings.jsp">Settings</a></li>
    </ul>
</div>

<div class="container">
    <div class="header">
        <div class="nav">
            <h1>Admin-Dashboard</h1>
        </div>
    </div>

    <div class="content">
        <div class="cards">
            <div class="card">
                <h1>${studentCount}</h1>
                <h3>Students</h3>
            </div>
            <div class="card">
                <h1>${staffCount}</h1>
                <h3>Staffs</h3>
            </div>
            <div class="card">
                <h1>${adminCount}</h1>
                <h3>Admin</h3>
            </div>
            <div class="card">
                <h1>102500</h1>
                <h3>Income</h3>
            </div>
        </div>

        <div class="content-2">
            <div class="recent-payments">
                <h2>Recent Books</h2>
                <table>
                    <tr>
                        <th>Title</th>
                        <th>Author</th>
                        <th>Price</th>
                        <th>Added Date</th>
                    </tr>
                    <c:forEach var="book" items="${recentBooks}">
                        <tr>
                            <td>${book[0]}</td>
                            <td>${book[1]}</td>
                            <td>$${book[2]}</td>
                            <td>${book[3]}</td>
                        </tr>
                    </c:forEach>
                </table>
            </div>

            <div class="new-students">
                <h2>New Students</h2>
                <table>
                    <tr>
                        <th>Profile</th>
                        <th>User Name</th>
                    </tr>
                    <c:forEach var="student" items="${studentName}">
                        <tr>
                            <td><img src="${pageContext.request.contextPath}/assets/png/user.png" alt="Profile"></td>
                            <td>${student}</td>
                        </tr>
                    </c:forEach>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>
