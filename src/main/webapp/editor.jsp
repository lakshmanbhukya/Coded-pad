<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.sql.*" %>

<%
    // Session attributes and other required logic
    if (session == null || session.getAttribute("noteId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    int noteId = (int) session.getAttribute("noteId");
    String accessCode = (String) session.getAttribute("accessCode");
    String content = ""; // Initialize the content variable

    int maxChars = 65535; // Maximum characters allowed for TEXT field

    // Database connection variables
    String dbURL = "jdbc:mysql://localhost:3306/codedpad"; // Database URL
    String dbUser = "root"; // Database user
    String dbPassword = "root"; // Database password
    Connection connection = null;
    PreparedStatement statement = null;
    ResultSet resultSet = null;

    try {
        // Establish database connection
        connection = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // Query to get the note content from the database
        String sql = "SELECT content FROM notes WHERE id = ?";
        statement = connection.prepareStatement(sql);
        statement.setInt(1, noteId);

        resultSet = statement.executeQuery();

        // Retrieve the content if exists
        if (resultSet.next()) {
            content = resultSet.getString("content");
        }

    } catch (SQLException e) {
        e.printStackTrace();
        content = "Error retrieving note from the database."; // Fallback message
    } finally {
        try {
            if (resultSet != null) resultSet.close();
            if (statement != null) statement.close();
            if (connection != null) connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Note Editor</title>
    <!-- iOS style font and minimal styling -->
    <link href="https://fonts.googleapis.com/css2?family=Helvetica+Neue:wght@400;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/font-awesome/css/font-awesome.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        /* General styles */
        body {
            font-family: 'Helvetica Neue', sans-serif;
            background-color: #f0f2f5;
            margin: 0;
            padding: 20px;
            min-height: 100vh;
            box-sizing: border-box;
        }

        .container {
            width: 100%;
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
        }

        .container:hover {
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.12);
        }

        .card-header {
            background: linear-gradient(135deg, #007aff, #0055b3);
            color: white;
            padding: 20px 25px;
            border-radius: 12px 12px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-header h5 {
            font-size: 1.5rem;
            margin: 0;
            font-weight: 600;
        }

        .card-header span {
            background: rgba(255, 255, 255, 0.2);
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 0.9rem;
        }

        .card-body {
            padding: 25px;
        }

        .form-control {
            width: 100%;
            padding: 15px;
            border-radius: 8px;
            border: 2px solid #e1e4e8;
            font-size: 16px;
            background-color: #ffffff;
            transition: all 0.3s ease;
            resize: vertical;
            min-height: 200px;
        }

        .form-control:focus {
            border-color: #007aff;
            box-shadow: 0 0 0 3px rgba(0, 122, 255, 0.1);
            outline: none;
        }

        .button-group {
            margin-top: 25px;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .button-group button {
            padding: 12px 25px;
            font-size: 16px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            flex: 1;
            justify-content: center;
            min-width: 140px;
        }

        .button-group button.btn-primary {
            background: linear-gradient(135deg, #007aff, #0055b3);
            color: white;
            font-weight: 500;
        }

        .button-group button.btn-primary:hover {
            background: linear-gradient(135deg, #0055b3, #003d80);
            transform: translateY(-1px);
        }

        .button-group button.btn-secondary {
            background-color: #f0f2f5;
            color: #1a1a1a;
            border: 1px solid #e1e4e8;
        }

        .button-group button.btn-secondary:hover {
            background-color: #e1e4e8;
            transform: translateY(-1px);
        }

        .char-counter {
            font-size: 14px;
            color: #666;
            margin-top: 12px;
            padding: 8px;
            border-radius: 6px;
            background: #f8f9fa;
            text-align: right;
            transition: all 0.3s ease;
        }

        .char-counter.warning {
            color: #ff3b30;
            background: rgba(255, 59, 48, 0.1);
        }

        .char-counter.good {
            color: #34c759;
            background: rgba(52, 199, 89, 0.1);
        }

        .footer {
            text-align: center;
            color: #666;
            font-size: 13px;
            margin-top: 20px;
            padding: 15px;
            border-top: 1px solid #e1e4e8;
        }

        .button-icon {
            font-size: 18px;
        }

        @media (max-width: 600px) {
            body {
                padding: 10px;
            }
            
            .button-group {
                flex-direction: column;
            }
            
            .button-group button {
                width: 100%;
            }
            
            .card-header {
                flex-direction: column;
                gap: 10px;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="card">
            <div class="card-header">
                <h5>Note Editor</h5>
                <span>Access Code: <strong><%= accessCode %></strong></span>
            </div>
            <div class="card-body">
                <form method="post" action="saveNote" onsubmit="return validateForm()">
                    <div class="form-group">
                        <textarea 
                            class="form-control" 
                            name="content" 
                            id="content" 
                            rows="12" 
                            onkeyup="updateCharCount(this)" 
                            maxlength="<%= maxChars %>"
                            placeholder="Start typing your note here..."><%= content %></textarea>
                        <div class="char-counter" id="charCount">Characters: 0/<%= maxChars %></div>
                    </div>
                    <input type="hidden" name="noteId" value="<%= noteId %>">
                    <div class="button-group">
                        <button type="submit" class="btn btn-primary">
                            <i class="fa fa-save button-icon"></i> Save Note
                        </button>
                        <button type="button" class="btn btn-secondary" onclick="window.location.href='setpassword.jsp?noteId=<%= noteId %>'">
                            <i class="fa fa-lock button-icon"></i> Set Password
                        </button>
                        <button type="button" class="btn btn-secondary" onclick="window.location.href='index.jsp'">
                            <i class="fa fa-times button-icon"></i> Close
                        </button>
                    </div>
                </form>
            </div>
            <div class="footer">
                &copy; 2025 CodedNotes. All rights reserved.
            </div>
        </div>
    </div>

    <script>
        // Function to dynamically update the character count
        function updateCharCount(textarea) {
            const charCount = textarea.value.length;
            const maxChars = <%= maxChars %>;
            const charCountElement = document.getElementById('charCount');
            const charCounterDiv = document.querySelector('.char-counter');
            
            charCountElement.textContent = "Characters: " + charCount + "/" + maxChars;
            
            if (charCount > maxChars * 0.9) {
                charCounterDiv.classList.add('warning');
                charCounterDiv.classList.remove('good');
            } else if (charCount > maxChars * 0.5) {
                charCounterDiv.classList.remove('warning');
                charCounterDiv.classList.add('good');
            } else {
                charCounterDiv.classList.remove('warning');
                charCounterDiv.classList.remove('good');
            }
        }

        // Initialize character count on page load
        window.onload = function() {
            updateCharCount(document.getElementById('content'));
        };
    </script>
</body>
</html>
