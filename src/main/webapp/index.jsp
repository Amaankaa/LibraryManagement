<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- ===== CSS ===== -->
    <link rel="stylesheet" href="assets/css/styles.css">

    <!-- ===== BOX ICONS ===== -->
    <link href='https://cdn.jsdelivr.net/npm/boxicons@2.0.5/css/boxicons.min.css' rel='stylesheet'>

    <title>Join our library community </title>
</head>
<body>

<div class="login">
    <div class="login__content">
        <div class="login__img">
            <img src="assets/img/img-login.svg" alt="">
        </div>

        <div class="login__forms">

            <div class="login-form">

            <form method="post" action="action" class="login__registre" id="login-in">
                <h1 class="login__title">Sign In</h1>

                <div class="login__box">
                    <i class='bx bx-user login__icon'></i>
                    <input type="text" name="username" placeholder="Username" class="login__input">
                </div>

                <div class="login__box">
                    <i class='bx bx-lock-alt login__icon'></i>
                    <input type="password" name="password" placeholder="Password" class="login__input">
                </div>

                <div>
                    <span class="login__account">Don't have an Account ?</span>
                    <span class="login__signin" id="sign-up">Sign Up</span>
                </div>
                <a class="login__button" onclick="document.getElementById('login-in').submit()">Sign In</a>
            </form>

            <form method="post" action="signup" class="login__create none" id="login-up">
                <h1 class="login__title">Create Account</h1>

                <div class="login__box">
                    <i class='bx bx-user login__icon'></i>
                    <input type="text" name="username" placeholder="Username" class="login__input">
                </div>

                <div class="login__box">
                    <i class='bx bx-at login__icon'></i>
                    <input name="email" type="email" placeholder="Email" class="login__input">
                </div>

                <div class="login__box">
                    <i class='bx bx-lock-alt login__icon'></i>
                    <input id="PWD" type="password" name="password" placeholder="Password" class="login__input">
                    <div id="message"></div>
                </div>

                <div class="login__box">
                    <i class='bx bx-person login__icon'></i>
                    <select id="role" name="role">
                        <option value="admin">Admin</option>
                        <option value="staff">Staff</option>
                        <option value="student">Student</option>
                    </select>
                </div>

                <a class="login__button" onclick="document.getElementById('login-up').submit()">Sign Up</a>

                <div>
                    <span class="login__account">Already have an Account ?</span>
                    <span class="login__signup" id="sign-in">Sign In</span>
                </div>

                <div class="login__social">
                    <a href="#" class="login__social-icon"><i class='bx bxl-facebook' ></i></a>
                    <a href="#" class="login__social-icon"><i class='bx bxl-twitter' ></i></a>
                    <a href="#" class="login__social-icon"><i class='bx bxl-google' ></i></a>
                </div>
            </form>
        </div>
    </div>
</div>
</div>
<!--===== MAIN JS =====-->
<script src="assets/js/main.js"></script>
</body>
</html>