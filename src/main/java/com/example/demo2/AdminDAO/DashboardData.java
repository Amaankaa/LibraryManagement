package com.example.demo2.AdminDAO;

import com.example.demo2.dao.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DashboardData {

    public static DashboardStats getDashboardStats() {
        DashboardStats stats = new DashboardStats();
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps;

            // Count students
            ps = conn.prepareStatement("SELECT COUNT(*) AS count FROM stakeholders WHERE role = ?");
            ps.setString(1, "Student");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                stats.setStudentCount(rs.getInt("count"));
            }
            rs.close();

            // Count staffs
            ps.setString(1, "Staff");
            rs = ps.executeQuery();
            if (rs.next()) {
                stats.setStaffCount(rs.getInt("count"));
            }
            rs.close();

            // Count admins
            ps.setString(1, "Admin");
            rs = ps.executeQuery();
            if (rs.next()) {
                stats.setAdminCount(rs.getInt("count"));
            }
            rs.close();

            // Fetch recent books
            ps = conn.prepareStatement("SELECT Title, Author, Price, AddedDate FROM books ORDER BY AddedDate DESC LIMIT 5");
            rs = ps.executeQuery();
            List<String[]> books = new ArrayList<>();
            while (rs.next()) {
                books.add(new String[]{
                        rs.getString("Title"),
                        rs.getString("Author"),
                        rs.getString("Price"),
                        rs.getString("AddedDate")
                });
            }
            stats.setRecentBooks(books);
            rs.close();

            // Fetch new students
            ps = conn.prepareStatement("SELECT username FROM stakeholders WHERE role = 'student' ORDER BY AddedDate DESC LIMIT 5");
            rs = ps.executeQuery();
            List<String> studentNames = new ArrayList<>();
            while (rs.next()) {
                studentNames.add(rs.getString("username"));
            }
            stats.setStudentNames(studentNames);
            rs.close();

            // Calculate total book copies
            ps = conn.prepareStatement("SELECT SUM(copies) AS totalCopies FROM books");
            rs = ps.executeQuery();
            if (rs.next()) {
                stats.setTotalCopies(rs.getInt("totalCopies"));
            }
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }
}
