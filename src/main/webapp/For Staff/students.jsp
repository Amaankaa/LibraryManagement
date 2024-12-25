<%@ page import="java.sql.*" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link href="../assets/css/admin-dashboard.css" rel="stylesheet">
    <title>Staff Dashboard</title>
    <link href="../assets/css/students.css" rel="stylesheet">
    <script>
        function showForm() {
            const selectedAction = document.getElementById("actionSelector").value;
            const forms = document.querySelectorAll('.form-container');
            forms.forEach(form => form.classList.remove('active'));
            if (selectedAction) {
                document.getElementById(selectedAction + "Form").classList.add('active');
            }
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
        <h1>Manage Students</h1>
        <select id="actionSelector" onchange="showForm()">
            <option value="add">Add Students</option>
            <option value="remove">Remove Students</option>
            <option value="fetch" selected>Fetch Student by Username</option>
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
            <input type="text" name="username" placeholder="Student Username to Remove" required>
            <button type="submit" name="action" value="remove">Remove Student</button>
        </form>
    </div>
    <!-- Fetch Student by Username Form -->
    <div id="fetchForm" class="form-container active">
        <form method="post">
            <h3>Fetch Student by Username</h3>
            <input type="text" name="studentUsername" placeholder="Student USERNAME" required>
            <button type="submit" name="action" value="fetch">Fetch Student</button>
        </form>
        <%
            if ("fetch".equals(request.getParameter("action"))) {
                String studentUsername = request.getParameter("studentUsername");
                try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/mydb", "root", "root123")) {
                    PreparedStatement pstmt = con.prepareStatement("SELECT * FROM stakeholders WHERE username = ? AND role = 'student'");
                    pstmt.setString(1, studentUsername);
                    ResultSet rs = pstmt.executeQuery();
                    if (rs.next()) {
        %>
        <table border="1">
            <tr>
                <th>Username</th>
                <th>Email</th>
            </tr>
            <tr>
                <td><%= rs.getString("username") %></td>
                <td><%= rs.getString("email") %></td>
            </tr>
        </table>
        <%
        } else {
        %>
        <script>alert("No student found with Username: <%= studentUsername %>");</script>
        <%
            }
        } catch (Exception e) {
        %>
        <script>alert("Error: <%= e.getMessage() %>");</script>
        <%
                }
            }
        %>
    </div>

    <%
        String action = request.getParameter("action");
        if (action != null) {
            try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/mydb", "root", "root123")) {
                if ("add".equals(action)) {
                    String username = request.getParameter("username");
                    String email = request.getParameter("email");
                    String password = request.getParameter("password");
                    String role = request.getParameter("role");

                    String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
                    Pattern emailPattern = Pattern.compile(emailRegex);
                    if (!emailPattern.matcher(email).matches()) {
    %>
    <script>alert("Invalid email format!");</script>
    <%
            return;
        }

        String passwordPattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$";
        if (!password.matches(passwordPattern)) {
    %>
    <script>alert("Weak password!");</script>
    <%
            return;
        }

        PreparedStatement pstmt = con.prepareStatement("INSERT INTO stakeholders (username, email, password, role) VALUES (?, ?, ?, ?)");
        pstmt.setString(1, username);
        pstmt.setString(2, email);
        pstmt.setString(3, BCrypt.hashpw(password, BCrypt.gensalt()));
        pstmt.setString(4, role);
        pstmt.executeUpdate();
    %>
    <script>alert("Student added successfully!");</script>
    <%
    } else if ("remove".equals(action)) {
        String username = request.getParameter("username");
        PreparedStatement pstmt = con.prepareStatement("DELETE FROM stakeholders WHERE username = ?");
        pstmt.setString(1, username);
        pstmt.executeUpdate();
    %>
    <script>alert("Student removed successfully!");</script>
    <%
        }
    } catch (Exception e) {
    %>
    <script>alert("Error: <%= e.getMessage() %>");</script>
    <%
            }
        }
    %>
</div>
</body>
</html>