const socket = io();

const form = document.getElementById("form");
const input = document.getElementById("input");
const messages = document.getElementById("messages");

form.addEventListener("submit", (e) => {
    e.preventDefault();
    if (input.value) {
        const messageObj = {
            sender: "browser",
            message: input.value,
            timestamp: new Date().toISOString(),
        };

        const messageJson = JSON.stringify(messageObj);

        socket.emit("chat message", messageJson);
        input.value = "";
    }
});

socket.on("chat message", (msg) => {
    const item = document.createElement("p");
    const item1 = document.createElement("p");
    const item2 = document.createElement("li");

    const msgObj = JSON.parse(msg);
    item.textContent = `From ${msgObj.sender}`;
    item1.textContent = `${msgObj.message}`;
    item2.textContent = `${msgObj.timestamp}`;

    messages.appendChild(item);
    messages.appendChild(item1);
    messages.appendChild(item2);
    window.scrollTo(0, document.body.scrollHeight);
});