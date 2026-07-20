<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>AI Gift Assistant — HerjaHub</title>

    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link href="https://fonts.googleapis.com/css2?family=Newsreader:wght@400;500;600&family=Inter:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <style>
        :root {
            --white: #ffffff;
            --light-gray: #f8f9fa;
            --charcoal: #1f2937;
            --gray: #6b7280;
            --green: #198754;
            --green-dark: #146c43;
            --red: #c62828;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: "Inter", sans-serif;
            background: var(--light-gray);
            color: var(--charcoal);
        }

        .topbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 18px 32px;
            background: var(--white);
            border-bottom: 1px solid rgba(31, 41, 55, 0.08);
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 700;
            font-size: 18px;
        }

        .logo-mark {
            width: 32px;
            height: 32px;
            border-radius: 9px;
            background: linear-gradient(
                    135deg,
                    var(--green),
                    var(--green-dark)
            );
            color: var(--white);
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: "Newsreader", serif;
            font-weight: 600;
        }

        .home-link {
            color: var(--charcoal);
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            padding: 8px 16px;
            border: 1px solid rgba(31, 41, 55, 0.15);
            border-radius: 10px;
        }

        .home-link:hover {
            background: var(--light-gray);
        }

        .page-container {
            max-width: 1050px;
            margin: 0 auto;
            padding: 35px 20px;
        }

        .page-heading {
            margin-bottom: 22px;
        }

        .page-heading h1 {
            margin: 0 0 8px;
            font-family: "Newsreader", serif;
            font-size: 34px;
            font-weight: 500;
        }

        .page-heading p {
            margin: 0;
            color: var(--gray);
            line-height: 1.6;
        }

        .chat-card {
            background: var(--white);
            border-radius: 20px;
            overflow: hidden;
            box-shadow:
                    0 20px 40px -30px
                    rgba(17, 17, 17, 0.3);
        }

        .chat-header {
            padding: 18px 22px;
            color: var(--white);
            background: linear-gradient(
                    135deg,
                    var(--green),
                    var(--green-dark)
            );
        }

        .chat-header h2 {
            margin: 0 0 4px;
            font-size: 19px;
        }

        .chat-header p {
            margin: 0;
            font-size: 13px;
            opacity: 0.9;
        }

        .messages {
            height: 380px;
            padding: 22px;
            overflow-y: auto;
            background: #fbfcfb;
        }

        .message-row {
            display: flex;
            margin-bottom: 14px;
        }

        .message-row.user {
            justify-content: flex-end;
        }

        .message {
            max-width: 75%;
            padding: 12px 15px;
            border-radius: 15px;
            line-height: 1.5;
            font-size: 14px;
            white-space: pre-wrap;
        }

        .assistant-message {
            background: #e8f5ec;
            border-bottom-left-radius: 4px;
        }

        .user-message {
            color: var(--white);
            background: var(--green);
            border-bottom-right-radius: 4px;
        }

        .chat-form {
            display: flex;
            gap: 10px;
            padding: 18px;
            border-top: 1px solid #e5e7eb;
            background: var(--white);
        }

        .chat-input {
            flex: 1;
            padding: 13px 15px;
            border: 1px solid #d1d5db;
            border-radius: 12px;
            font: inherit;
            outline: none;
        }

        .chat-input:focus {
            border-color: var(--green);
            box-shadow: 0 0 0 3px rgba(25, 135, 84, 0.12);
        }

        .send-button {
            border: none;
            border-radius: 12px;
            padding: 0 22px;
            background: var(--green);
            color: var(--white);
            font-weight: 700;
            cursor: pointer;
        }

        .send-button:hover {
            background: var(--green-dark);
        }

        .send-button:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }

        .recommendations-section {
            margin-top: 28px;
        }

        .recommendations-section h2 {
            font-family: "Newsreader", serif;
            font-weight: 500;
            margin-bottom: 15px;
        }

        .product-grid {
            display: grid;
            grid-template-columns:
                    repeat(auto-fit, minmax(220px, 1fr));
            gap: 18px;
        }

        .product-card {
            background: var(--white);
            border-radius: 16px;
            overflow: hidden;
            box-shadow:
                    0 15px 35px -28px
                    rgba(17, 17, 17, 0.45);
            border: 1px solid rgba(31, 41, 55, 0.08);
        }

        .product-image {
            width: 100%;
            height: 170px;
            object-fit: cover;
            background: #e5e7eb;
        }

        .product-placeholder {
            height: 170px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #e8f5ec;
            color: var(--green-dark);
            font-weight: 700;
        }

        .product-info {
            padding: 16px;
        }

        .product-name {
            margin: 0 0 8px;
            font-size: 17px;
        }

        .product-description {
            margin: 0 0 12px;
            color: var(--gray);
            font-size: 13px;
            line-height: 1.5;
        }

        .product-price {
            color: var(--green-dark);
            font-size: 16px;
            font-weight: 700;
        }

        .error-message {
            background: #fee2e2;
            color: var(--red);
        }

        @media (max-width: 650px) {
            .topbar {
                padding: 15px 18px;
            }

            .message {
                max-width: 88%;
            }

            .chat-form {
                flex-direction: column;
            }

            .send-button {
                min-height: 45px;
            }
        }
    </style>
</head>

<body>

<header class="topbar">

    <div class="brand">

        <div class="logo-mark">ه</div>

        HerjaHub

    </div>

    <a class="home-link"
       href="${pageContext.request.contextPath}/customer/dashboard">

        Home

    </a>

</header>

<main class="page-container">

    <section class="page-heading">

        <h1>AI Gift Assistant</h1>

        <p>
            Tell me the occasion, recipient, interests and budget.
            I will search HerjaHub's available products for suitable gifts.
        </p>

    </section>

    <section class="chat-card">

        <div class="chat-header">

            <h2>Chat with Herja Assistant</h2>

            <p>
                Example: I need a birthday gift for my mother under 100 shekels.
            </p>

        </div>

        <div class="messages"
             id="messages">

            <div class="message-row">

                <div class="message assistant-message">
                    Hello! Tell me what kind of gift or product you need.
                </div>

            </div>

        </div>

        <form class="chat-form"
              id="chatForm">

            <input
                    class="chat-input"
                    id="messageInput"
                    type="text"
                    placeholder="Type your message..."
                    autocomplete="off"
                    required
            >

            <button
                    class="send-button"
                    id="sendButton"
                    type="submit">

                Send

            </button>

        </form>

    </section>

    <section
            class="recommendations-section"
            id="recommendationsSection"
            hidden>

        <h2>Recommended Products</h2>

        <div
                class="product-grid"
                id="productGrid">
        </div>

    </section>

</main>

<script>
    const contextPath = "${pageContext.request.contextPath}";

    const chatForm =
        document.getElementById("chatForm");

    const messageInput =
        document.getElementById("messageInput");

    const messages =
        document.getElementById("messages");

    const sendButton =
        document.getElementById("sendButton");

    const recommendationsSection =
        document.getElementById("recommendationsSection");

    const productGrid =
        document.getElementById("productGrid");


    chatForm.addEventListener("submit", async function (event) {

        event.preventDefault();

        const message = messageInput.value.trim();

        if (message === "") {
            return;
        }

        addMessage(message, "user");

        messageInput.value = "";
        sendButton.disabled = true;
        sendButton.textContent = "Thinking...";

        try {

            const response = await fetch(
                contextPath + "/api/ai/chat",
                {
                    method: "POST",

                    headers: {
                        "Content-Type": "application/json"
                    },

                    body: JSON.stringify({
                        message: message
                    })
                }
            );

            if (response.status === 401) {

                window.location.href =
                    contextPath + "/auth";

                return;
            }

            const data = await response.json();

            if (!response.ok) {

                addMessage(
                    data.reply || "Something went wrong.",
                    "error"
                );

                return;
            }

            addMessage(data.reply, "assistant");

            showRecommendations(
                data.recommendations || []
            );

        } catch (error) {

            addMessage(
                "The server could not be reached. Please try again.",
                "error"
            );

        } finally {

            sendButton.disabled = false;
            sendButton.textContent = "Send";
            messageInput.focus();
        }
    });


    function addMessage(text, type) {

        const row = document.createElement("div");
        row.className = "message-row";

        const messageBox = document.createElement("div");
        messageBox.className = "message";

        if (type === "user") {

            row.classList.add("user");
            messageBox.classList.add("user-message");

        } else if (type === "error") {

            messageBox.classList.add("error-message");

        } else {

            messageBox.classList.add("assistant-message");
        }

        messageBox.textContent = text;

        row.appendChild(messageBox);
        messages.appendChild(row);

        messages.scrollTop = messages.scrollHeight;
    }


    function showRecommendations(products) {

        productGrid.replaceChildren();

        if (products.length === 0) {

            recommendationsSection.hidden = true;
            return;
        }

        products.forEach(function (product) {

            const card =
                document.createElement("article");

            card.className = "product-card";


            if (product.image) {

                const image =
                    document.createElement("img");

                image.className = "product-image";
                image.src = product.image;
                image.alt = product.productName || "Product";

                image.addEventListener("error", function () {

                    const placeholder =
                        createImagePlaceholder();

                    image.replaceWith(placeholder);
                });

                card.appendChild(image);

            } else {

                card.appendChild(
                    createImagePlaceholder()
                );
            }


            const info =
                document.createElement("div");

            info.className = "product-info";


            const name =
                document.createElement("h3");

            name.className = "product-name";
            name.textContent =
                product.productName || "Unnamed Product";


            const description =
                document.createElement("p");

            description.className =
                "product-description";

            description.textContent =
                product.description ||
                "No description is available.";


            const price =
                document.createElement("div");

            price.className = "product-price";

            price.textContent =
                product.price + " ₪";


            info.appendChild(name);
            info.appendChild(description);
            info.appendChild(price);

            card.appendChild(info);
            productGrid.appendChild(card);
        });

        recommendationsSection.hidden = false;
    }


    function createImagePlaceholder() {

        const placeholder =
            document.createElement("div");

        placeholder.className =
            "product-placeholder";

        placeholder.textContent =
            "HerjaHub Product";

        return placeholder;
    }
</script>

</body>
</html>