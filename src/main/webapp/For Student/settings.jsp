settings: <%@ page import="java.sql.*" %>
<%@ page import ="org.mindrot.jbcrypt.BCrypt"%>
<%@ page import="java.util.regex.Pattern" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link href="../assets/css/admin-dashboard.css" rel="stylesheet">
    <title>Student Dashboard</title>
    <link href="../assets/css/students.css" rel="stylesheet">
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


    <div style="margin-top: 50px">
        <h1>Manage Students</h1>
        <select id="actionSelector" onchange="showForm()">
            <option value="update">Update Info</option>
            <option value="fetch" selected>Fetch Students</option>
        </select>
    </div>

    <!-- Update Students Form -->
    <div id="updateForm" class="form-container">
        <form method="post">
            <h3>Update Student</h3>
            <input type="text" name="username" placeholder="Username" required>
            <input type="text" name="updatedUsername" placeholder="Updated Username" required>
            <input type="text" name="email" placeholder="Email" required>
            <input type="text" name="updatedEmail" placeholder="Updated Email" required>
            <input type="password" name="currentPassword" placeholder="Current Password" required>
            <input type="password" name="newPassword" placeholder="New Password" required>
            <input type="password" name="confirmNewPassword" placeholder="Confirm New Password" required>
            <select name="role" required>
                <option value="Student" selected>Student</option>
            </select>
            <button type="submit" name="action" value="update">Update Student</button>
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
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/mydb", "root", "root123");
                if ("update".equals(action)) {
                    String username = request.getParameter("username");
                    String updatedUsername = request.getParameter("updatedUsername");
                    String updatedEmail = request.getParameter("updatedEmail");
                    String email = request.getParameter("email");
                    String password = request.getParameter("currentPassword");
                    String newPassword = request.getParameter("newPassword");
                    String confirmNewPassword = request.getParameter("confirmNewPassword");
                    String role = request.getParameter("role");

                    if (!newPassword.equals(confirmNewPassword)) {
                        response.getWriter().println(
                                "<script type=\"text/javascript\">"
                                        + "alert('New password doesn't match');"
                                        + "window.location = 'settings.jsp';"
                                        + "</script>"
                        );
                        return;
                    }

                    String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
                    Pattern emailPattern = Pattern.compile(emailRegex);
                    if (!emailPattern.matcher(updatedEmail).matches()) {
                        response.getWriter().println(
                                "<script type=\"text/javascript\">"
                                        + "alert('Invalid email format! Please try again.');"
                                        + "window.location = 'settings.jsp';"
                                        + "</script>"
                        );
                        return;
                    }

                    String pattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$";

                    if (!newPassword.matches(pattern)) {
                        response.getWriter().println(
                                "<script type=\"text/javascript\">"
                                        + "alert('Your password is too weak. It must:\\n- Be at least 8 characters long.\\n- Include at least one uppercase letter.\\n- Include at least one lowercase letter.\\n- Include at least one number.\\n- Include at least one special character (e.g., @, $, %, &).');"
                                        + "window.location = 'settings.jsp';"
                                        + "</script>"
                        );
                        return;
                    }
                    // Get current admin password from the DB
                    PreparedStatement stmt = con.prepareStatement("SELECT password FROM stakeholders WHERE username = ?");
                    stmt.setString(1, username);
                    ResultSet rs = stmt.executeQuery();

                    if (rs.next()) {
                        String storedPassword = rs.getString("password");

                        // Check if the entered current password matches the stored one
                        if (BCrypt.checkpw(password, storedPassword)) {
                            // Hash the new password and update it in the DB
                            PreparedStatement updateStmt = con.prepareStatement(
                                    "UPDATE stakeholders SET email = ?, password = ?, role = ?, username = ? WHERE username = ?");

                            String hashCurrent = BCrypt.hashpw(newPassword, BCrypt.gensalt());
                            updateStmt.setString(1, email);
                            updateStmt.setString(2, hashCurrent);
                            updateStmt.setString(3, role);
                            updateStmt.setString(4, updatedUsername);
                            updateStmt.setString(5, username);
                            updateStmt.executeUpdate();

                            response.getWriter().println(
                                    "<script type=\"text/javascript\">"
                                            + "alert('Info updated successfully!');"
                                            + "window.location = 'settings.jsp';"
                                            + "</script>"
                            );
                        } else {
                            response.getWriter().println(
                                    "<script type=\"text/javascript\">"
                                            + "alert('Incorrect password');"
                                            + "window.location = 'settings.jsp';"
                                            + "</script>"
                            );
                        }
                    } else {
                        response.getWriter().println(
                                "<script type=\"text/javascript\">"
                                        + "alert('Username not found');"
                                        + "window.location = 'settings.jsp';"
                                        + "</script>"
                        );
                    }
                }
                con.close();
            } catch (Exception e) {
                response.getWriter().println(
                        "<script type=\"text/javascript\">"
                                + "alert('Error: " + e.getMessage() + "');"
                                + "window.location = 'settings.jsp';"
                                + "</script>"
                );

            }
        }
%>
</div>
</body>
</html>