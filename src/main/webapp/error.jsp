<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Oops! | BingeIt</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Judson:ital,wght@0,400;0,700;1,400&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --clr-primary:      #A23E3E;
            --clr-primary-dark: #7A2E2E;
            --clr-primary-deep: #5C1F1F;
            --clr-primary-pale: #FDF0F0;
            --clr-primary-bg:   #F9E8E8;
            --clr-white:        #FFFFFF;
            --clr-off-white:    #FDF6F6;
            --clr-text:         #1A1A1A;
            --clr-text-muted:   #6B6B6B;
            --clr-border-light: #F0E4E4;
            --font-main:        'Judson', Georgia, serif;
        }

        html, body {
            height: 100%;
            font-family: var(--font-main);
            background: var(--clr-off-white);
            color: var(--clr-text);
        }

        /* ---- Minimal header ---- */
        .err-header {
            background: var(--clr-primary);
            padding: 0 1.5rem;
            height: 68px;
            display: flex;
            align-items: center;
        }

        .err-logo {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
        }

        .err-logo__icon {
            font-size: 1.3rem;
            color: #fff;
            opacity: 0.9;
        }

        .err-logo__text {
            font-size: 1.3rem;
            font-weight: 700;
            color: #fff;
        }

        /* ---- Main ---- */
        .err-main {
            min-height: calc(100vh - 68px - 60px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 3rem 1.5rem;
        }

        .err-box {
            text-align: center;
            max-width: 520px;
            width: 100%;
        }

        /* Film reel illustration */
        .err-illustration {
            width: 140px;
            height: 140px;
            margin: 0 auto 2rem;
            position: relative;
        }

        .err-reel {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            background: var(--clr-primary-bg);
            border: 3px solid var(--clr-border-light);
            display: flex;
            align-items: center;
            justify-content: center;
            animation: errSpin 8s linear infinite;
        }

        .err-reel__inner {
            width: 52px;
            height: 52px;
            border-radius: 50%;
            background: var(--clr-white);
            border: 3px solid var(--clr-border-light);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
        }

        /* sprocket holes */
        .err-reel::before,
        .err-reel::after {
            content: '';
            position: absolute;
            width: 18px;
            height: 18px;
            border-radius: 50%;
            background: var(--clr-white);
            border: 2px solid var(--clr-border-light);
        }

        .err-reel::before { top: 14px; left: 50%; transform: translateX(-50%); }
        .err-reel::after  { bottom: 14px; left: 50%; transform: translateX(-50%); }

        @keyframes errSpin {
            to { transform: rotate(360deg); }
        }

        /* Code & heading */
        .err-code {
            font-size: 5rem;
            font-weight: 700;
            color: var(--clr-primary);
            line-height: 1;
            margin-bottom: 0.5rem;
            letter-spacing: -0.03em;
        }

        .err-title {
            font-size: 1.6rem;
            font-weight: 700;
            color: var(--clr-text);
            margin-bottom: 0.75rem;
        }

        .err-message {
            font-size: 1rem;
            color: var(--clr-text-muted);
            line-height: 1.7;
            margin-bottom: 2rem;
            font-style: italic;
        }

        /* Buttons */
        .err-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }

        .err-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            font-family: var(--font-main);
            font-size: 1rem;
            font-weight: 700;
            padding: 0.65rem 1.75rem;
            border-radius: 999px;
            cursor: pointer;
            border: 2px solid transparent;
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .err-btn--primary {
            background: var(--clr-primary);
            color: #fff;
            border-color: var(--clr-primary);
        }

        .err-btn--primary:hover {
            background: var(--clr-primary-dark);
            border-color: var(--clr-primary-dark);
        }

        .err-btn--outline {
            background: transparent;
            color: var(--clr-primary);
            border-color: var(--clr-primary);
        }

        .err-btn--outline:hover {
            background: var(--clr-primary-pale);
        }

        /* ---- Footer ---- */
        .err-footer {
            background: var(--clr-primary-deep);
            text-align: center;
            padding: 1rem 1.5rem;
            font-size: 0.8rem;
            color: rgba(255,255,255,0.35);
            font-family: var(--font-main);
        }
    </style>
</head>
<body>

    <header class="err-header">
        <a href="${pageContext.request.contextPath}/home" class="err-logo">
            <span class="err-logo__icon">&#9654;</span>
            <span class="err-logo__text">Binge It!!!</span>
        </a>
    </header>

    <main class="err-main">
        <div class="err-box">

            <div class="err-illustration">
                <div class="err-reel">
                    <div class="err-reel__inner">&#9888;</div>
                </div>
            </div>

            <div class="err-code">Oops!</div>
            <h1 class="err-title">Something went wrong</h1>
            <p class="err-message">
                Looks like the reel got tangled.<br>
                We couldn't load what you were looking for.<br>
                Try going back or heading home.
            </p>

            <div class="err-actions">
                <a href="javascript:history.back()" class="err-btn err-btn--outline">
                    &#8592; Go Back
                </a>
                <a href="${pageContext.request.contextPath}/home" class="err-btn err-btn--primary">
                    &#9654; Back to Home
                </a>
            </div>

        </div>
    </main>

    <footer class="err-footer">
        &copy; Bing It. All Rights Reserved.
    </footer>

</body>
</html>
