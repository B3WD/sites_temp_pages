(() => {
  const yearNode = document.getElementById("year");
  if (yearNode) {
    yearNode.textContent = String(new Date().getFullYear());
  }

  const prefersReducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  const hasCoarsePointer = window.matchMedia("(pointer: coarse)").matches;

  if (prefersReducedMotion || hasCoarsePointer) {
    return;
  }

  const root = document.documentElement;
  const spring = 0.14;
  let targetX = window.innerWidth * 0.5;
  let targetY = window.innerHeight * 0.5;
  let targetAlpha = 0.16;
  let currentX = targetX;
  let currentY = targetY;
  let currentAlpha = targetAlpha;

  const applyPointer = () => {
    currentX += (targetX - currentX) * spring;
    currentY += (targetY - currentY) * spring;
    currentAlpha += (targetAlpha - currentAlpha) * spring;

    const width = Math.max(window.innerWidth, 1);
    const height = Math.max(window.innerHeight, 1);
    const xPct = (currentX / width) * 100;
    const yPct = (currentY / height) * 100;

    root.style.setProperty("--pointer-x", `${xPct.toFixed(2)}%`);
    root.style.setProperty("--pointer-y", `${yPct.toFixed(2)}%`);
    root.style.setProperty("--pointer-alpha", currentAlpha.toFixed(3));

    window.requestAnimationFrame(applyPointer);
  };

  const centerPointer = () => {
    targetX = window.innerWidth * 0.5;
    targetY = window.innerHeight * 0.5;
    targetAlpha = 0.16;
  };

  window.addEventListener("pointermove", (event) => {
    if (event.pointerType === "touch") {
      return;
    }

    targetX = event.clientX;
    targetY = event.clientY;
    targetAlpha = 0.3;
  });

  window.addEventListener("mouseout", (event) => {
    if (!event.relatedTarget) {
      centerPointer();
    }
  });

  window.addEventListener("blur", centerPointer);
  window.addEventListener("resize", centerPointer);

  applyPointer();
})();