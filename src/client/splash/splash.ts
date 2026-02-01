import { navigateTo, context, requestExpandedMode } from "@devvit/web/client";

const startButton = document.getElementById(
	"start-button"
) as HTMLButtonElement;

startButton.addEventListener("click", (e) => {
	requestExpandedMode(e, "game");
});

const greetUserElement = document.getElementById("greetUser") as HTMLHeadingElement;

function init() {
	greetUserElement.textContent = `Hey ${context.username ?? "Player"}!`;
}

init();