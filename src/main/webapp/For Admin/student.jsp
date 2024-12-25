<%@ page import="java.sql.*" %>
<%@ page import ="org.mindrot.jbcrypt.BCrypt"%>
<%@ page import="java.util.regex.Pattern" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link href="../assets/css/admin-dashboard.css" rel="stylesheet">
    <title>Manage Admins</title>
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
        <form method="post">
            <h3>Add Admin</h3>
            <input type="text" name="username" placeholder="Username" required>
            <input type="text" name="email" placeholder="Email" required>
            <input type="password" name="password" placeholder="Password" required>
            <input type="text" name="role" placeholder="Role" required>
            <button type="submit" name="action" value="add">Add Admin</button>
        </form>
    </div>
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
    } else if ("update".equals(action)) {
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
                            + "window.location = 'staffs.jsp';"
                            + "</script>"
    );
    return;
    }

    String pattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$";

    if (!newPassword.matches(pattern)) {
    response.getWriter().println(
    "<script type=\"text/javascript\">"
                            + "alert('Your password is too weak. It must:\\n- Be at least 8 characters long.\\n- Include at least one uppercase letter.\\n- Include at least one lowercase letter.\\n- Include at least one number.\\n- Include at least one special character (e.g., @, $, %, &).');"
                            + "window.location = 'staffs.jsp';"
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