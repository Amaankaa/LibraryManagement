Library Management System - README

Library Management System

Introduction
The Library Management System is a web-based application designed to manage books, borrowing,
and returning of books, while also maintaining a list of stakeholders (users). The system is
implemented using JSP for front-end, MySQL for database management, and Java Servlets for
back-end logic.
Prerequisites

1. Install JDK 8 or later.
2. Install Apache Tomcat Server.
3. Install MySQL Server and MySQL Workbench.
4. Add the MySQL Connector JAR file to your project.
5. Ensure the database is properly configured as per the details below.
Database Structure

1. Books Table
The 'books' table stores information about all available books in the library.
Columns:
- title (VARCHAR): The title of the book.
- author (VARCHAR): The author of the book.
- price (DOUBLE): The price of the book.
- copies (INT): The number of copies available.
- rating (INT): The rating given to the book by the book adder.

2. Lent Books Table
The 'lent_books' table tracks which books are borrowed by which users.
Columns:
- username (VARCHAR): The username of the stakeholder who borrowed the book.
- Book_title (VARCHAR): The title of the book borrowed.
- copies_lent (INT): The number of copies borrowed.

3. Stakeholders Table
The 'stakeholders' table stores information about all users and their roles in the system.
Columns:
- username (VARCHAR): Unique username of the user.
- email (VARCHAR): Email address of the user.
- password (VARCHAR): Encrypted password of the user.
- role (VARCHAR): Role of the user (e.g., 'Admin', 'Student').
- added_date (DATE): The date the user was added to the system.

All the necessary codes to setup the database is as follows. Copy and paste the following code in your MySQL workbench:
/*
create database mydb;
use mydb;

CREATE TABLE `books` (
  `Title` varchar(50) NOT NULL,
  `Author` varchar(255) NOT NULL,
  `AddedDate` date NOT NULL DEFAULT (curdate()),
  `Price` decimal(10,2) NOT NULL,
  `copies` int DEFAULT '100',
  `rating` int DEFAULT NULL,
  `image_url` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`Title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `lent_books` (
  `username` varchar(60) NOT NULL,
  `Book_title` varchar(50) DEFAULT NULL,
  `copies_lent` int DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `stakeholders` (
  `username` varchar(50) NOT NULL,
  `email` varchar(50) DEFAULT NULL,
  `password` varchar(60) DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  `AddedDate` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

*/

Usage Instructions
1. Clone the project repository.
2. Set up the database using the structure provided above.
3. Add the JAR files in the "Necessary JAR file" directory to the "lib" folder of your installed tomcat directory.
4. Deploy the project on Apache Tomcat Server.
5. Access the application through the localhost URL.
6. Sign up as an "Admin", "Stakeholder", or "Student".
7. Log in using a valid stakeholder username and password.
8. Enjoy.

**Future Project Improvements**

Code Modularity
Problem: The JSP files contain both presentation logic and back-end database operations.
Improvement: Use Servlets or a back-end framework (like Spring) to handle business logic and
database operations. JSP should primarily handle UI.

Session Management: Implement session-based authentication for user roles (e.g., admin vs.
student). Avoid hardcoding role checks.

Input Validation
Frontend Validation: Add JavaScript to validate forms before submitting (e.g., non-empty inputs,
valid numbers for copies).
Backend Validation: Ensure server-side input validation to prevent malicious inputs.

Error Handling
Problem: Right now, errors are being handled with rollback and alert() messages, which can be
uninformative.
Improvement: Log errors to a server-side log file and display user-friendly error pages or messages.

Data Relationships
Improvement: Implement proper foreign key constraints between tables like Stakeholders, Books,
and LentBooks to maintain data integrity.

Scalability
Pagination: For the Fetch All Books and Check Borrowed Books sections, implement pagination if
the dataset grows large.
Search Functionality: Add search by title, author, or username.

Design/UI
Enhancement: Improve responsiveness using CSS frameworks like Bootstrap or Tailwind CSS.
Dynamic Table Updates: Use AJAX for real-time updates without refreshing the page.

Code Duplication
Problem: Some SQL logic is repeated (e.g., checking books and lent_books).
Improvement: Refactor common database operations into reusable methods or DAO classes.

Testing
Write unit tests for all core functionalities (e.g., borrowing books, returning books, user
authentication).
Simulate edge cases like borrowing more copies than available or returning invalid data.

Documentation
Improvement: Include API or database schema diagrams in the README.
Instructions: Add step-by-step setup instructions for different environments (e.g., Windows, Linux).

Future Features
Notifications: Email or SMS notifications for due dates or confirmations.
Analytics Dashboard: Show insights like most borrowed books, frequent users, etc.
Book Reservation: Allow users to reserve books if copies aren't available.

Conclusion
This Library Management System is done in a very limited time and that's its hard to include most features.
But still the system provides a robust and efficient way to manage books and users.
Ensure that the database structure matches the provided schema for smooth operation. Feel free to
modify and enhance the project as needed.
