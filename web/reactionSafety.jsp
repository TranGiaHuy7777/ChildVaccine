<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Anaphylactic Shock Management Guidelines</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* Global Styles */
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #fff3e0, #ffebee);
            color: #333;
            padding: 20px;
            margin: 0;
        }
        
        /* Container */
        .container {
            max-width: 600px;
            margin: 40px auto;
            background: #ffffff;
            padding: 30px;
            border-radius: 12px;
            border: 1px solid #ffcc80;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
            animation: fadeIn 0.8s ease-out;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        h1 {
            text-align: center;
            color: #d32f2f;
            margin-bottom: 20px;
        }
        
        p {
            line-height: 1.6;
            margin-bottom: 15px;
        }
        
        ul {
            margin-left: 20px;
            margin-bottom: 15px;
        }
        
        li {
            margin-bottom: 8px;
        }
        
        /* Back Button Styles */
        .back-button {
            display: inline-block;
            padding: 12px 24px;
            background: linear-gradient(135deg, #1e88e5, #1565c0);
            color: #fff;
            text-decoration: none;
            border-radius: 50px;
            font-size: 16px;
            font-weight: 600;
            margin-top: 20px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .back-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.2);
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Anaphylactic Shock Management Guidelines</h1>
    <p><strong>Important Note:</strong> If the child shows signs of anaphylactic shock (e.g., difficulty breathing, facial swelling, sneezing, loss of consciousness), you should:</p>
    <ul>
        <li>Call emergency services immediately (emergency phone: 115 or your local emergency number).</li>
        <li>Take the child to the nearest medical facility.</li>
        <li>If an epinephrine auto-injector is available, use it as directed by a physician.</li>
        <li>Monitor the symptoms closely and inform the medical staff immediately upon arrival.</li>
    </ul>
    <p>If the reaction is mild (such as a fever or rash), please consult a doctor for further advice.</p>
    <a href="recordReaction.jsp" class="back-button">
        <i class="fas fa-arrow-left"></i> Back to Record Reaction
    </a>
</div>
</body>
</html>
