<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    // Step 1: Initialize variables for the counts
    int studentCount = 0;
    int staffCount = 0;
    int adminCount = 0; // Assuming you track books differently
    List<String[]> recentBooks = new ArrayList<>();
    // Step 2: Database connection (Replace with your DB details)
    String dbURL = "jdbc:mysql://localhost:3306/mydb";
    String dbUser = "root";
    String dbPass = "root123";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        // Step 3: Query the database for counts based on the 'role' column
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

        String query = "SELECT Title, Author, Price, AddedDate FROM books LIMIT 5";
        ps = conn.prepareStatement(query);
        rs = ps.executeQuery();

        rs.close();

        // Close resources
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
        <h1>Brand</h1>
    </div>
    <ul>
        <li><img src="${pageContext.request.contextPath}/assets/png/dashboard%20(2).png">&nbsp; Dashboard</li>
        <li><img src="${pageContext.request.contextPath}/assets/png/reading-book (1).png">&nbsp; Students</li>
        <li><img src="${pageContext.request.contextPath}/assets/png/teacher2.png">&nbsp; Staffs</li>
        <li><img src="${pageContext.request.contextPath}/assets/png/school.png">&nbsp; Books</li>
        <li><img src="${pageContext.request.contextPath}/assets/png/help-web-button.png">&nbsp; Help</li>
        <li><img src="${pageContext.request.contextPath}/assets/png/settings.png">&nbsp; Settings</li>
    </ul>
</div>

<div class="container">
    <div class="header">
        <div class="nav">
            <div class="search">
                <input type="text" placeholder="Search...">
                <button type="submit"><img src="${pageContext.request.contextPath}/assets/png/search.png" ></button>
            </div>
            <div class="user">
                <a href="#" class="btn">Add New</a>
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
                    <h1><%= studentCount %></h1>
                    <h3>Students</h3>
                </div>

            </div>
            <div class="card">
                <div class="box">
                    <h1><%= staffCount %></h1>
                    <h3>Staffs</h3>
                </div>

            </div>
            <div class="card">
                <div class="box">
                    <h1><%= adminCount %></h1>
                    <h3>Admin</h3>
                </div>

            </div>
            <div class="card">
                <div class="box">
                    <h1>102500</h1>
                    <h3>Income</h3>
                </div>

            </div>
        </div>
        <div class="content-2">
            <div class="recent-payments">
                <div class="title">
                    <h2>Recent Books</h2>
                    <a href="" class="btn">View All</a>
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
                    <a href="" class="btn">View All</a>
                </div>
                <table>
                    <tr>
                        <th>Profile</th>
                        <th>Name</th>
                        <th>Option</th>
                    </tr>
                    <tr>
                        <td><img src="${pageContext.request.contextPath}/assets/png/user.png" alt=""></td>
                        <td>John Steve Bulaa</td>
                        <td><img src="${pageContext.request.contextPath}/assets/png/info.png" alt=""></td>
                    </tr>
                    <tr>
                        <td><img src="${pageContext.request.contextPath}/assets/png/user.png" alt=""></td>
                        <td>John Steve Bulaa</td>
                        <td><img src="${pageContext.request.contextPath}/assets/png/info.png" alt=""></td>
                    </tr>
                    <tr>
                        <td><img src="${pageContext.request.contextPath}/assets/png/user.png" alt=""></td>
                        <td>John Steve Bulaa</td>
                        <td><img src="${pageContext.request.contextPath}/assets/png/info.png" alt=""></td>
                    </tr>
                    <tr>
                        <td><img src="${pageContext.request.contextPath}/assets/png/user.png" alt=""></td>
                        <td>John Steve Bulaa</td>
                        <td><img src="${pageContext.request.contextPath}/assets/png/info.png" alt=""></td>
                    </tr>
                    <tr>
                        <td><img src="${pageContext.request.contextPath}/assets/png/user.png" alt=""></td>
                        <td>John Steve Bulaa</td>
                        <td><img src="${pageContext.request.contextPath}/assets/png/info.png" alt=""></td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</div>

</body>

</html>