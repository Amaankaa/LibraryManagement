<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Welcome - Library Management System</title>
  <style>
    /* General reset and body styling */
    body {
      margin: 0;
      padding: 0;
      font-family: 'Arial', sans-serif;
      background: linear-gradient(135deg, #6e8efb, #a777e3);
      color: #fff;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      height: 100vh;
    }

    /* Welcome container */
    .welcome-container {
      text-align: center;
      max-width: 800px;
    }

    .welcome-container h1 {
      font-size: 3em;
      margin-bottom: 20px;
      text-transform: uppercase;
      letter-spacing: 2px;
    }

    .welcome-container p {
      font-size: 1.2em;
      margin-bottom: 30px;
      line-height: 1.6;
    }

    /* Button styling */
    .btn-container {
      display: flex;
      justify-content: center;
      gap: 20px;
    }

    .btn {
      text-decoration: none;
      padding: 15px 25px;
      border-radius: 30px;
      background-color: #fff;
      color: #6e8efb;
      font-size: 1em;
      font-weight: bold;
      border: none;
      cursor: pointer;
      transition: all 0.3s ease-in-out;
    }

    .btn:hover {
      background-color: #a777e3;
      color: #fff;
      transform: scale(1.1);
    }

    /* Footer */
    footer {
      position: absolute;
      bottom: 10px;
      font-size: 0.9em;
    }
  </style>
</head>
<body>
<div class="welcome-container">
  <h1>Welcome to Our Library Management System</h1>
  <p>
    Discover the smarter way to manage your library. Our system is designed to streamline
    book borrowing, manage member records, and provide insights into library operations
    with ease and efficiency. Whether you're a librarian or a student, our system has you covered!
  </p>
  <div class="btn-container">
    <a class="btn" href="index.jsp">Get Started</a>
  </div>
</div>
<footer>
  &copy; 2024 Library Management System | All Rights Reserved
</footer>
<script>
  // Optional: Add some interactive effects
  document.addEventListener('DOMContentLoaded', () => {
    const buttons = document.querySelectorAll('.btn');
    buttons.forEach(button => {
      button.addEventListener('mouseenter', () => button.style.transform = 'scale(1.1)');
      button.addEventListener('mouseleave', () => button.style.transform = 'scale(1)');
    });
  });
</script>
</body>
</html>
