package com.example.demo2.booksDAO;

public class books {
    private String title;
    private String author;
    private double price;
    private int copies;
    private int rating;
    private String imageUrl;

    // Default Constructor
    public books() {
    }

    // Parameterized Constructor
    public books(String title, String author, double price, int copies, int rating, String imageUrl) {
        this.title = title;
        this.author = author;
        this.price = price;
        this.copies = copies;
        this.rating = rating;
        this.imageUrl = imageUrl;
    }

    // Getters and Setters
    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getCopies() {
        return copies;
    }

    public void setCopies(int copies) {
        this.copies = copies;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
}
