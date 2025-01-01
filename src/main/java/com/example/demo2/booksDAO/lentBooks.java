package com.example.demo2.booksDAO;

public class lentBooks {
    // Instance variables
    private String title;
    private int copies;
    private String username; // Added field for the student's username

    // Default constructor
    public lentBooks() {
    }

    // Getter for title
    public String getTitle() {
        return title;
    }

    // Setter for title
    public void setTitle(String title) {
        this.title = title;
    }

    // Getter for copies
    public int getCopies() {
        return copies;
    }

    // Setter for copies
    public void setCopies(int copies) {
        this.copies = copies;
    }

    // Getter for username
    public String getUsername() {
        return username;
    }

    // Setter for username
    public void setUsername(String username) {
        this.username = username;
    }
}
