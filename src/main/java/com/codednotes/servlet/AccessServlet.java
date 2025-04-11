package com.codednotes.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/access")
public class AccessServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/codedpad";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accessCode = request.getParameter("access_code");

        // Validate access code
        if (accessCode == null || accessCode.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Access code is required");
            return;
        }

        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        PreparedStatement insertStatement = null;

        try {
            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Connect to the database
            connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Check if the access code exists and fetch associated note details
            String query = "SELECT * FROM notes WHERE access_code = ?";
            statement = connection.prepareStatement(query);
            statement.setString(1, accessCode);
            resultSet = statement.executeQuery();

            HttpSession session = request.getSession();

            if (resultSet.next()) {
                // Existing note found
                String password = resultSet.getString("password"); // Assume there's a column named 'password'

                if (password != null && !password.isEmpty()) {
                    // If the note has a password, redirect to password.jsp
                    session.setAttribute("accessCode", accessCode);
                    response.sendRedirect("password.jsp");
                    return;
                }

                // If there's no password, continue to the editor
                session.setAttribute("noteId", resultSet.getInt("id"));
                session.setAttribute("accessCode", accessCode);
                session.setAttribute("content", resultSet.getString("content"));
                response.sendRedirect("editor.jsp");

            } else {
                // Create a new note if the access code doesn't exist in the database
                String insertQuery = "INSERT INTO notes (access_code, content) VALUES (?, '')";
                insertStatement = connection.prepareStatement(insertQuery, Statement.RETURN_GENERATED_KEYS);
                insertStatement.setString(1, accessCode);
                insertStatement.executeUpdate();

                ResultSet generatedKeys = insertStatement.getGeneratedKeys();
                int noteId = 0;
                if (generatedKeys.next()) {
                    noteId = generatedKeys.getInt(1);
                } else {
                    throw new SQLException("Failed to get generated note ID");
                }

                session.setAttribute("noteId", noteId);
                session.setAttribute("accessCode", accessCode);
                session.setAttribute("content", "");

                generatedKeys.close();

                // No password set for the new note, go directly to the editor
                response.sendRedirect("editor.jsp");
            }

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database driver not found");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        } finally {
            // Close resources in reverse order
            try {
                if (resultSet != null) resultSet.close();
                if (statement != null) statement.close();
                if (insertStatement != null) insertStatement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
