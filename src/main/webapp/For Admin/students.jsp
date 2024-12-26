<%@ page import="java.sql.*" %>
<%@ page import ="org.mindrot.jbcrypt.BCrypt"%>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="com.example.demo2.dao.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css" rel="stylesheet">
    <title>Manage Students</title>
    <link href="${pageContext.request.contextPath}/assets/css/student.css" rel="stylesheet">
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
        <li><a style="color: white" href="${pageContext.request.contextPath}/For%20Admin/admin-dashboard.jsp"><img src="${pageContext.request.contextPath}/assets/png/dashboard%20(2).png">&nbsp; Dashboard</a></li>
        <li><a style="color: white" href="${pageContext.request.contextPath}/For%20Admin/students.jsp"><img src="${pageContext.request.contextPath}/assets/png/reading-book (1).png">&nbsp; Students</a></li>
        <li><a style="color: white" href="${pageContext.request.contextPath}/For%20Admin/staffs.jsp"><img src="${pageContext.request.contextPath}/assets/png/teacher2.png">&nbsp; Staffs</a></li>
        <li><a style="color: white" href="${pageContext.request.contextPath}/For%20Admin/books.jsp"><img src="${pageContext.request.contextPath}/assets/png/school.png">&nbsp; Books</a></li>
        <li><a style="color: white" href="${pageContext.request.contextPath}/For%20Admin/settings.jsp"><img src="${pageContext.request.contextPath}/assets/png/settings.png">&nbsp; Settings</a></li>
        <li><a style="color: white" href="${pageContext.request.contextPath}/index.jsp"><img src="${pageContext.request.contextPath}/assets/png/logout.png">&nbsp; Logout</a></li>
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
        <h1>Manage Students</h1>
        <select id="actionSelector" onchange="showForm()">
            <option value="add">Add Students</option>
            <option value="remove">Remove Students</option>
            <option value="fetch" selected>Fetch Students</option>
        </select>
    </div>
    <!-- Add Students Form -->
    <div id="addForm" class="form-container">
        <form method="post">
            <h3>Add Student</h3>
            <input type="text" name="username" placeholder="Username" required>
            <input type="text" name="email" placeholder="Email" required>
            <input type="password" name="password" placeholder="Password" required>
            <input type="text" name="role" placeholder="Role" required>
            <button type="submit" name="action" value="add">Add Student</button>
        </form>
    </div>

    <!-- Remove Students Form -->
    <div id="removeForm" class="form-container">
        <form method="post">
            <h3>Remove Student</h3>
            <input type="text" name="username" placeholder="Student username to Remove" required>
            <button type="submit" name="action" value="remove">Remove Student</button>
        </form>
    </div>
    <!-- Fetch Students Form -->
    <div id="fetchForm" class="form-container active">
        <form method="post">
            <h3>Fetch Students</h3>
            <button type="submit" name="action" value="fetch">Fetch All Students</button>
        </form>
        <%
            if ("fetch".equals(request.getParameter("action"))) {
                try {
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/mydb", "root", "root123");
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT * FROM stakeholders where role = 'student'");
        %>
        <table border="1">
            <tr>
                <th>Username</th>
                <th>email</th>
            </tr>
            <% while (rs.next()) { %>
            <tr>
                <td><%= rs.getString("username") %></td>
                <td><%= rs.getString("email") %></td>
            </tr>
            <% } %>
        </table>
        <%
                    con.close();
                } catch (Exception e) {
                    response.getWriter().println("<p>Error: " + e.getMessage() + "</p>");
                }
            }
        %>
    </div>

<%
        String action = request.getParameter("action");
        if (action != null) {
            try {
                Connection con = DBConnection.getConnection();
                if ("add".equals(action)) {
                    String username = request.getParameter("username");
                    String email = request.getParameter("email");
                    String password = request.getParameter("password");
                    String role = request.getParameter("role");

                    String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
                    Pattern emailPattern = Pattern.compile(emailRegex);
                    if (!emailPattern.matcher(email).matches()) {
                        response.getWriter().println(
                                "<script type=\"text/javascript\">"
                                        + "alert('Invalid email format! Please try again.');"
                                        + "window.location = 'students.jsp';"
                                        + "</script>"
                        );
                        return;
                    }

                    String pattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$";

                    if (!password.matches(pattern)) {
                        response.getWriter().println(
                                "<script type=\"text/javascript\">"
                                        + "alert('Your password is too weak. It must:\\n- Be at least 8 characters long.\\n- Include at least one uppercase letter.\\n- Include at least one lowercase letter.\\n- Include at least one number.\\n- Include at least one special character (e.g., @, $, %, &).');"
                                        + "window.location = 'students.jsp';"
                                        + "</script>"
                        );
                        return;
                    }
                    PreparedStatement pstmt = con.prepareStatement("INSERT INTO stakeholders (username, email, password, role) VALUES (?, ?, ?, ?)");
                    pstmt.setString(1, username);
                    pstmt.setString(2, email);
                    String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
                    pstmt.setString(3, hashedPassword);
                    pstmt.setString(4, role);
                    pstmt.executeUpdate();
                } else if ("remove".equals(action)) {
                    String username = request.getParameter("username");
                    PreparedStatement pstmt = con.prepareStatement("DELETE FROM stakeholders WHERE username = ?");
                    pstmt.setString(1, username);
                    pstmt.executeUpdate();
                }
                con.close();
            } catch (Exception e) {
                response.getWriter().println("<p>Error: " + e.getMessage() + "</p>");
            }
        }
%>
</div>
</body>
</html>