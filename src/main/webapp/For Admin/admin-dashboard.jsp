<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    int studentCount = 0;
    int staffCount = 0;
    int adminCount = 0; // Assuming you track books differently
    List<String[]> recentBooks = new ArrayList<>();
    List<String> studentName = new ArrayList<>();
    int totalCopies = 0;
    String dbURL = "jdbc:mysql://localhost:3306/mydb";
    String dbUser = "root";
    String dbPass = "root123";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        PreparedStatement ps;

        // Count students
        ps = conn.prepareStatement("SELECT COUNT(*) AS count FROM stakeholders WHERE role = ?");
        ps.setString(1, "Student");
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            studentCount = rs.getInt("count");
        }
        rs.close();

        // Count staffs
        ps.setString(1, "Staff");
        rs = ps.executeQuery();
        if (rs.next()) {
            staffCount = rs.getInt("count");
        }
        rs.close();

        // Count admin
        ps.setString(1, "Admin");
        rs = ps.executeQuery();
        if (rs.next()) {
            adminCount = rs.getInt("count");
        }

        String query = "SELECT Title, Author, Price, AddedDate FROM books order by AddedDate desc limit 5";
        ps = conn.prepareStatement(query);
        rs = ps.executeQuery();

        while (rs.next()) {
            String[] book = new String[4];
            book[0] = rs.getString("Title");
            book[1] = rs.getString("Author");
            book[2] = rs.getString("Price");
            book[3] = rs.getString("AddedDate");
            recentBooks.add(book);
        }
        rs.close();

        query = "SELECT username FROM stakeholders WHERE role = 'student' order by AddedDate  desc limit 5";
        Statement stmt = conn.createStatement();
        rs = stmt.executeQuery(query);

        while (rs.next()) {
            studentName.add(rs.getString("username"));
        }

        query = "SELECT SUM(copies) AS totalCopies FROM books";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(query);

        if (rs.next()) {
            totalCopies = rs.getInt("totalCopies");
        }

        ps.close();
        conn.close();
    } catch (Exception e) {
        response.getWriter().println(e.getMessage());
    }
%>


<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css">
    <title>Document</title>
</head>
<body>
<div class="side-menu">
    <div class="brand-name">
        <h1>ADMIN</h1>
    </div>
    <ul>
        <li><a style="color: white" href="dashboard?name=admin"><img src="${pageContext.request.contextPath}/assets/png/dashboard%20(2).png">&nbsp; Dashboard</a></li>
        <li><a style="color: white" href="dashboard?name=student"><img src="${pageContext.request.contextPath}/assets/png/reading-book (1).png">&nbsp; Students</a></li>
        <li><a style="color: white" href="dashboard?name=staff"><img src="${pageContext.request.contextPath}/assets/png/teacher2.png">&nbsp; Staffs</a></li>
        <li><a style="color: white" href="dashboard?name=books"><img src="${pageContext.request.contextPath}/assets/png/school.png">&nbsp; Books</a></li>
        <li><a style="color: white" href="dashboard?name=settings"><img src="${pageContext.request.contextPath}/assets/png/settings.png">&nbsp; Settings</a></li>
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

    <div class="content">
        <div class="cards">
            <div class="card">
                <div class="box">
                    <h1>&nbsp;<%= studentCount %></h1>
                    <h3>Students</h3>
                </div>

            </div>
            <div class="card">
                <div class="box">
                    <h1>&nbsp;<%= staffCount %></h1>
                    <h3>Staffs</h3>
                </div>

            </div>
            <div class="card">
                <div class="box">
                    <h1>&nbsp;<%= adminCount %></h1>
                    <h3>Admin</h3>
                </div>

            </div>
            <div class="card">
                <div class="box">
                    <h1><%= totalCopies %></h1>
                    <h3>Books</h3>
                </div>

            </div>
        </div>
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
                        // Step 5: Populate the table with recent books
                        for (String[] book : recentBooks) {
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
                        for (String stud : studentName) {
                            if (stud.startsWith("Error:")) {
                    %>
                    <tr>
                        <td colspan="3"><%= stud %></td>
                    </tr>
                    <%
                    } else {
                    %>
                    <tr>
                        <td><img src="${pageContext.request.contextPath}/assets/png/user.png" alt="Profile"></td>
                        <td><%= stud %></td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </table>
            </div>
        </div>
    </div>
</div>

</body>

</html>