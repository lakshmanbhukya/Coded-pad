package com.codednotes.servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/setPasswordServlet")
public class SetPasswordServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/codedpad";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the noteId and the new password from the form
        String noteId = request.getParameter("noteId");
        String newPassword = request.getParameter("password");

        // Check if the noteId and password are provided
        if (noteId == null || noteId.isEmpty() || newPassword == null || newPassword.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Note ID and password are required.");
            return;
        }

        Connection connection = null;
        PreparedStatement statement = null;

        try {
            // Establish a connection to the database
            connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // SQL query to update the password for the specified note
            String sql = "UPDATE notes SET password = ? WHERE id = ?";
            statement = connection.prepareStatement(sql);
            statement.setString(1, newPassword); // Store the password as-is (plaintext)
            statement.setInt(2, Integer.parseInt(noteId));

            int rowsUpdated = statement.executeUpdate();

            if (rowsUpdated > 0) {
                // Password updated successfully, show success message
                response.sendRedirect("editor.jsp?noteId=" + noteId); // Redirect to editor.jsp
            } else {
                // If no rows were updated (e.g., invalid noteId), show error
                request.setAttribute("errorMessage", "Failed to update password. Note not found.");
                request.getRequestDispatcher("setpassword.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            // Log the error for debugging (e.g., to a log file or monitoring system)
            e.printStackTrace();
            // Show a generic error message to the user
            request.setAttribute("errorMessage", "Database error: Unable to update password.");
            request.getRequestDispatcher("setpassword.jsp").forward(request, response);
        } catch (Exception e) {
            // Catch any other exceptions (e.g., unexpected exceptions)
            e.printStackTrace();
            // Show a generic error message to the user
            request.setAttribute("errorMessage", "Unexpected error occurred.");
            request.getRequestDispatcher("setpassword.jsp").forward(request, response);
        } finally {
            // Close resources
            try {
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
