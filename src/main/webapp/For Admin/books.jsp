<%@ page import="java.sql.*" %>
<%@ page import="dao.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <link href="../assets/css/admin-dashboard.css" rel="stylesheet">
  <title>Manage Books</title>
  <link href="../assets/css/students.css" rel="stylesheet">
  <script>
    function showForm() {
      const selectedAction = document.getElementById("actionSelector").value;
      const forms = document.querySelectorAll('.form-container');
      forms.forEach(form => form.classList.remove('active'));
      document.getElementById(selectedAction + "Form").classList.add('active');
    }

    function showMessage(message) {
      alert(message);
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
    <h1>Manage Books</h1>
    <select id="actionSelector" onchange="showForm()">
      <option value="add">Add Books</option>
      <option value="remove">Remove Books</option>
      <option value="fetch" selected>Fetch Books</option>
    </select>
  </div>
  <!-- Add Books Form -->
  <div id="addForm" class="form-container">
    <form method="post">
      <h3>Add Book</h3>
      <input type="text" name="title" placeholder="Book Title" required>
      <input type="text" name="author" placeholder="Author" required>
      <input type="text" name="price" placeholder="Price" required>
      <input type="text" name="copies" placeholder="Copies" required>
      <input type="number" name="rating" placeholder="Rating (1-5)" required>
      <input type="text" name="image_url" placeholder="Image url" required>
      <button type="submit" name="action" value="add">Add Book</button>
    </form>
  </div>

  <!-- Remove Books Form -->
  <div id="removeForm" class="form-container">
    <form method="post">
      <h3>Remove Book</h3>
      <input type="text" name="title" placeholder="Book Title to Remove" required>
      <button type="submit" name="action" value="remove">Remove Book</button>
    </form>
  </div>
  <!-- Fetch Books Form -->
  <div id="fetchForm" class="form-container active">
    <form method="post">
      <h3>Fetch Books</h3>
      <button type="submit" name="action" value="fetch">Fetch All Books</button>
    </form>
    <%
      if ("fetch".equals(request.getParameter("action"))) {
        try {
          Connection con = DBConnection.getConnection();
          Statement stmt = con.createStatement();
          ResultSet rs = stmt.executeQuery("SELECT * FROM books");
    %>
    <div style="max-height: 300px; overflow-y: auto;">
      <table border="1" style="width: 100%; border-collapse: collapse;">
        <tr>
          <th>Title</th>
          <th>Author</th>
          <th>Price</th>
          <th>Rating</th>
          <th>Copies</th>
        </tr>
        <% while (rs.next()) { %>
        <tr>
          <td><%= rs.getString("title") %></td>
          <td><%= rs.getString("author") %></td>
          <td>$<%= rs.getString("price") %></td>
          <td><%= rs.getInt("rating") %></td>
          <td><%= rs.getInt("copies") %></td>
        </tr>
        <% } %>
      </table>
    </div>
    <%
      con.close();
    } catch (Exception e) {
    %>
    <script>showMessage("Error: <%= e.getMessage() %>");</script>
    <%
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
          String title = request.getParameter("title");
          String author = request.getParameter("author");
          String price = request.getParameter("price");
          String rating = request.getParameter("rating");
          String image_url = request.getParameter("image_url");
          String copies = request.getParameter("copies");

          // Use ON DUPLICATE KEY UPDATE to handle both insert and update
          PreparedStatement pstmt = con.prepareStatement(
                  "INSERT INTO books (title, author, price, copies, rating, image_url) " +
                          "VALUES (?, ?, ?, ?, ?, ?) " +
                          "ON DUPLICATE KEY UPDATE copies = copies + ?");

          pstmt.setString(1, title);
          pstmt.setString(2, author);
          pstmt.setString(3, price);
          pstmt.setInt(4, Integer.parseInt(copies));
          pstmt.setInt(5, Integer.parseInt(rating));
          pstmt.setString(6, image_url);
          pstmt.setInt(7, Integer.parseInt(copies)); // Add copies if book already exists
          pstmt.executeUpdate();
        } else if ("remove".equals(action)) {
          String title = request.getParameter("title");
          PreparedStatement pstmt = con.prepareStatement("DELETE FROM books WHERE title = ?");
          pstmt.setString(1, title);
          pstmt.executeUpdate();
        }
        con.close();
      } catch (Exception e) {
  %>
  <script>showMessage("Error: <%= e.getMessage() %>");</script>
  <%
      }
    }
  %>
</div>
</body>
</html>