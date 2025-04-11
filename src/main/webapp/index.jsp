<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Coded Pad - Access Notes</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <style>
        .hero-section {
            min-height: 100vh;
            background: linear-gradient(135deg, #6B73FF 0%, #000DFF 100%);
            position: relative;
            overflow: hidden;
        }
        
        .card {
            background: rgba(255, 255, 255, 0.9);
            border: none;
        }
        
        .btn-primary {
            background: linear-gradient(45deg, #6B73FF, #000DFF);
            border: none;
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            box-shadow: 0 5px 15px rgba(0, 13, 255, 0.4);
        }
    </style>
</head>
<body>
    <div class="hero-section d-flex align-items-center">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-8 col-lg-6 text-center text-white mb-5">
                    <h1 class="display-5 fw-bold mb-4">Welcome to CodedNotes</h1>
                    <p class="lead mb-0">Secure. Private. Simple.</p>
                </div>
            </div>
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card shadow">
                        <div class="card-body p-5">
                            <h2 class="text-center mb-4">Enter Your Access Code</h2>
                            <form action="access" method="post">
                                <div class="mb-4">
                                    <input 
                                        type="password" 
                                        class="form-control form-control-lg"
                                        name="access_code" 
                                        placeholder="Enter your unique access code" 
                                        required>
                                </div>
                                <div class="d-grid gap-2">
                                    <button class="btn btn-primary btn-lg" type="submit">Access Note</button>
                                </div>
                            </form>
                            <div class="text-center mt-4">
                                <p class="text-muted">Keep your access code unique to ensure no one else can use it.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
