package com.example.demo2;  // Use the appropriate package name

public class InputValidator {

    // Regular expression for email validation
    private static final String EMAIL_REGEX = "^[A-Za-z0-9+_.-]+@(.+)$";

    // Regular expression for password validation
    private static final String PASSWORD_REGEX = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$";

    // Validate Email
    public static boolean isValidEmail(String email) {
        if (email == null) {
            return false;
        }
        return email.matches(EMAIL_REGEX);
    }

    // Validate Password
    public static boolean isValidPassword(String password) {
        if (password == null) {
            return false;
        }
        return password.matches(PASSWORD_REGEX);
    }
}
