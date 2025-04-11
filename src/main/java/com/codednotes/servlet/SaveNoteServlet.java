package com.codednotes.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/saveNote")
public class SaveNoteServlet extends HttpServlet {
   private static final String DB_URL = "jdbc:mysql://your_database_url";
    private static final String DB_USER = "your_username";
    private static final String DB_PASSWORD = "db_password";


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve the content and noteId from the form
        String content = request.getParameter("content");
        int noteId = Integer.parseInt(request.getParameter("noteId"));

        Connection connection = null;
        PreparedStatement statement = null;
        String message = "Failed to save the note"; // Default message in case of failure
        boolean isSuccess = false;

        try {
            // Connect to the database
            connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Update the note content in the database
            String updateQuery = "UPDATE notes SET content = ? WHERE id = ?";
            statement = connection.prepareStatement(updateQuery);
            statement.setString(1, content);
            statement.setInt(2, noteId);
            int rowsUpdated = statement.executeUpdate();

            // Check if the update was successful
            if (rowsUpdated > 0) {
                message = "Note saved successfully!";
                isSuccess = true;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            message = "Database error: " + e.getMessage();
        } finally {
            // Close all resources
            try {
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        // Send the response with JavaScript for SweetAlert
        response.setContentType("text/html");
        response.getWriter().write("<!DOCTYPE html><html><head><script src='https://cdn.jsdelivr.net/npm/sweetalert2@11'></script></head><body>");
        
        if (isSuccess) {
            response.getWriter().write("<script>");
            response.getWriter().write("Swal.fire({ icon: 'success', title: 'Success', text: '" + message + "' });");
            response.getWriter().write("</script>");
        } else {
            response.getWriter().write("<script>");
            response.getWriter().write("Swal.fire({ icon: 'error', title: 'Error', text: '" + message + "' });");
            response.getWriter().write("</script>");
        }

        // Redirect back to the editor page
        response.getWriter().write("<script>setTimeout(function(){ window.location.href = 'editor.jsp'; }, 2000);</script>");
        
        response.getWriter().write("</body></html>");
    }
}
