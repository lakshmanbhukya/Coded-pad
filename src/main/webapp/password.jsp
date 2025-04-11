<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enter Password</title>

    <!-- Include SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f2f2f2;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .container {
            background-color: #fff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
        }

        .input-field {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 16px;
        }

        .submit-btn {
            width: 100%;
            padding: 12px;
            background-color: #28a745;
            color: white;
            font-size: 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .submit-btn:hover {
            background-color: #218838;
        }

        .error-message {
            color: #e74c3c;
            text-align: center;
            font-size: 14px;
        }

        .success-message {
            color: #2ecc71;
            text-align: center;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Enter Password</h2>
        
        <!-- Display error message if any -->
        <c:if test="${not empty errorMessage}">
            <div class="error-message">${errorMessage}</div>
        </c:if>

        <!-- Password form -->
        <form action="validatePassword" method="post">
            <input type="hidden" name="accessCode" value="${accessCode}" />
            <input type="password" class="input-field" name="password" placeholder="Enter your password" required />
            <button type="submit" class="submit-btn">Submit</button>
        </form>
    </div>

    <script>
        // If there's an error message from the server, display SweetAlert popup
        <c:if test="${not empty errorMessage}">
            Swal.fire({
                title: 'Error',
                text: '${errorMessage}',
                icon: 'error',
                confirmButtonText: 'Try Again'
            });
        </c:if>
    </script>
</body>
</html>
