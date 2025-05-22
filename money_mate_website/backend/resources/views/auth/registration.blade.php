<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            padding-top: 50px;
            background-color: #f8f9fa;
        }
        .registration-form {
            max-width: 500px;
            margin: 0 auto;
            padding: 30px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
            font-weight: 600;
        }
        .error-message {
            color: red;
            margin-top: 5px;
        }
        .form-label {
            font-weight: 500;
            color: #555;
        }
        .info-text {
            font-size: 0.875rem;
            color: #6c757d;
            margin-top: 2px;
        }
        .btn-success {
            background-color: #198754;
            border-color: #198754;
            padding: 12px;
            font-weight: 500;
        }
        .btn-success:hover {
            background-color: #157347;
            border-color: #146c43;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="registration-form">
            <h1>Registration</h1>
            
            @if ($errors->any())
                <div class="alert alert-danger">
                    <ul class="mb-0">
                        @foreach ($errors->all() as $error)
                            <li>{{ $error }}</li>
                        @endforeach
                    </ul>
                </div>
            @endif
            
            @if (session('success'))
                <div class="alert alert-success">
                    {{ session('success') }}
                </div>
            @endif
            
            <form action="{{ route('register') }}" method="POST">
                @csrf
                
                <!-- Email Field -->
                <div class="mb-3">
                    <label for="email" class="form-label">Email Address</label>
                    <input type="email" class="form-control" id="email" name="email" 
                           value="{{ old('email') }}" required>
                    <div class="info-text">We'll use this email for your account verification</div>
                    @error('email')
                        <div class="error-message">{{ $message }}</div>
                    @enderror
                </div>

                <!-- Name Field -->
                <div class="mb-3">
                    <label for="name" class="form-label">Full Name</label>
                    <input type="text" class="form-control" id="name" name="name" 
                           value="{{ old('name') }}" required>
                    @error('name')
                        <div class="error-message">{{ $message }}</div>
                    @enderror
                </div>

                <!-- Password Field -->
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" id="password" name="password" required>
                    <div class="info-text">Password must be at least 8 characters long</div>
                    @error('password')
                        <div class="error-message">{{ $message }}</div>
                    @enderror
                </div>

                <!-- Password Confirmation Field -->
                <div class="mb-3">
                    <label for="password_confirmation" class="form-label">Confirm Password</label>
                    <input type="password" class="form-control" id="password_confirmation" 
                           name="password_confirmation" required>
                    <div class="info-text">Please re-enter your password</div>
                </div>

                <!-- Spending Limit Field (Optional) -->
                <div class="mb-3">
                    <label for="limit" class="form-label">Monthly Spending Limit (Optional)</label>
                    <div class="input-group">
                        <span class="input-group-text">Rp</span>
                        <input type="number" class="form-control" id="limit" name="limit" 
                               value="{{ old('limit') }}" min="0" step="1000" placeholder="Enter your spending limit">
                    </div>
                    <div class="info-text">Set your monthly spending limit (optional - can be set later)</div>
                    @error('limit')
                        <div class="error-message">{{ $message }}</div>
                    @enderror
                </div>

                <!-- Email Verification (Optional checkbox) -->
                <div class="mb-3 form-check">
                    <input type="checkbox" class="form-check-input" id="send_verification" 
                           name="send_verification" value="1" {{ old('send_verification') ? 'checked' : '' }}>
                    <label class="form-check-label" for="send_verification">
                        Send email verification immediately
                    </label>
                    <div class="info-text">Check this to receive verification email right after registration</div>
                </div>

                <!-- Terms and Conditions -->
                <div class="mb-3 form-check">
                    <input type="checkbox" class="form-check-input" id="terms" name="terms" 
                           value="1" required {{ old('terms') ? 'checked' : '' }}>
                    <label class="form-check-label" for="terms">
                        I agree to the <a href="#" target="_blank">Terms and Conditions</a>
                    </label>
                    @error('terms')
                        <div class="error-message">{{ $message }}</div>
                    @enderror
                </div>

                <!-- Submit Button -->
                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-success">Create Account</button>
                </div>
            </form>
            
            <div class="mt-4 text-center">
                <p class="mb-0">Already have an account? 
                    <a href="{{ route('login') }}" class="text-decoration-none">Sign In</a>
                </p>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Add some client-side validation
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.querySelector('form');
            const password = document.getElementById('password');
            const confirmPassword = document.getElementById('password_confirmation');
            
            function validatePassword() {
                if (password.value !== confirmPassword.value) {
                    confirmPassword.setCustomValidity("Passwords don't match");
                } else {
                    confirmPassword.setCustomValidity('');
                }
            }
            
            password.addEventListener('change', validatePassword);
            confirmPassword.addEventListener('keyup', validatePassword);
            
            // Format number inputs
            const numberInputs = document.querySelectorAll('input[type="number"]');
            numberInputs.forEach(input => {
                input.addEventListener('input', function() {
                    // Remove any non-digit characters except for the decimal point
                    this.value = this.value.replace(/[^0-9]/g, '');
                });
            });
        });
    </script>
</body>
</html>