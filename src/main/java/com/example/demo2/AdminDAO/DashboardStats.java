package com.example.demo2.AdminDAO;

import java.util.List;

public class DashboardStats {
    private int studentCount;
    private int staffCount;
    private int adminCount;
    private int totalCopies;
    private List<String[]> recentBooks;
    private List<String> studentNames;

    public int getStudentCount() {
        return studentCount;
    }

    public void setStudentCount(int studentCount) {
        this.studentCount = studentCount;
    }

    public int getStaffCount() {
        return staffCount;
    }

    public void setStaffCount(int staffCount) {
        this.staffCount = staffCount;
    }

    public int getAdminCount() {
        return adminCount;
    }

    public void setAdminCount(int adminCount) {
        this.adminCount = adminCount;
    }

    public int getTotalCopies() {
        return totalCopies;
    }

    public void setTotalCopies(int totalCopies) {
        this.totalCopies = totalCopies;
    }

    public List<String[]> getRecentBooks() {
        return recentBooks;
    }

    public void setRecentBooks(List<String[]> recentBooks) {
        this.recentBooks = recentBooks;
    }

    public List<String> getStudentNames() {
        return studentNames;
    }

    public void setStudentNames(List<String> studentNames) {
        this.studentNames = studentNames;
    }
}
