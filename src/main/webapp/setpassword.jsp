<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    String noteId = request.getParameter("noteId");
    String errorMessage = "";
    if (noteId == null || noteId.isEmpty()) {
        errorMessage = "Note ID is missing.";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Set Password</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- SweetAlert2 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">

    <style>
        .form-container {
            max-width: 400px;
            margin: auto;
            margin-top: 80px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="form-container card shadow p-4 rounded">
            <h3 class="mb-4 text-center">Set Password for Note</h3>

            <form method="post" action="setPasswordServlet">
                <input type="hidden" name="noteId" value="<%= noteId %>">
                
                <div class="mb-3">
                    <label for="password" class="form-label">New Password:</label>
                    <input type="password" class="form-control" id="password" name="password" required>
                </div>

                <div class="d-grid">
                    <button type="submit" class="btn btn-primary">Set Password</button>
                </div>
            </form>

            <% if (!errorMessage.isEmpty()) { %>
                <div class="alert alert-danger mt-3 text-center">
                    <%= errorMessage %>
                </div>
            <% } %>
        </div>
    </div>

    <!-- Bootstrap JS (with Popper) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- SweetAlert2 JS -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</body>
</html>
