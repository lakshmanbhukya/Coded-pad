package com.codednotes.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/validatePassword")
public class ValidatePasswordServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/codedpad";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve the access code and password entered by the user
        String accessCode = request.getParameter("accessCode");
        String enteredPassword = request.getParameter("password");

        // Check if the access code or password is missing
        if (accessCode == null || enteredPassword == null || accessCode.trim().isEmpty() || enteredPassword.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Access code and password are required.");
            return;
        }

        // Initialize database connection and statement objects
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        try {
            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Connect to the database
            connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Query to check if the access code exists in the database and fetch the note details including the password
            String query = "SELECT * FROM notes WHERE access_code = ?";
            statement = connection.prepareStatement(query);
            statement.setString(1, accessCode);
            resultSet = statement.executeQuery();

            // If a note with the given access code is found
            if (resultSet.next()) {
                String storedPassword = resultSet.getString("password");

                // If a password exists for this note, validate the entered password
                if (storedPassword != null && storedPassword.equals(enteredPassword)) {
                    // Password matches, store note details in the session
                    HttpSession session = request.getSession();
                    session.setAttribute("noteId", resultSet.getInt("id"));
                    session.setAttribute("accessCode", accessCode);
                    session.setAttribute("content", resultSet.getString("content"));

                    // Redirect to the editor page
                    response.sendRedirect("editor.jsp");
                } else {
                    // Password is incorrect, redirect back to password.jsp with error message
                    request.setAttribute("errorMessage", "Incorrect password. Please try again.");
                    request.getRequestDispatcher("password.jsp").forward(request, response);
                }
            } else {
                // No note found with this access code, return an error
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Note not found.");
            }

        } catch (ClassNotFoundException | SQLException e) {
            // Log any exceptions that occur during the process
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        } finally {
            // Close the database resources in reverse order to avoid memory leaks
            try {
                if (resultSet != null) resultSet.close();
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
