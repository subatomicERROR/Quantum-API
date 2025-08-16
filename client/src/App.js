import React, { useEffect } from "react";
import "./App.css";

function App() {
  useEffect(() => {
    const canvas = document.getElementById("neural-bg");
    const ctx = canvas.getContext("2d");
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;

    const particles = [];
    const particleCount = 100;

    // Initialize particles
    for (let i = 0; i < particleCount; i++) {
      particles.push({
        x: Math.random() * canvas.width,
        y: Math.random() * canvas.height,
        r: Math.random() * 2 + 1,
        dx: (Math.random() - 0.5) * 1,
        dy: (Math.random() - 0.5) * 1,
      });
    }

    function connectParticles() {
      for (let a = 0; a < particleCount; a++) {
        for (let b = a + 1; b < particleCount; b++) {
          let dx = particles[a].x - particles[b].x;
          let dy = particles[a].y - particles[b].y;
          let dist = Math.sqrt(dx*dx + dy*dy);
          if (dist < 120) {
            ctx.strokeStyle = `rgba(0,255,255,${1 - dist/120})`;
            ctx.lineWidth = 0.5;
            ctx.beginPath();
            ctx.moveTo(particles[a].x, particles[a].y);
            ctx.lineTo(particles[b].x, particles[b].y);
            ctx.stroke();
          }
        }
      }
    }

    function animate() {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      particles.forEach(p => {
        ctx.beginPath();
        ctx.arc(p.x, p.y, p.r, 0, Math.PI*2);
        ctx.fillStyle = "#00ffff";
        ctx.fill();

        p.x += p.dx;
        p.y += p.dy;

        if (p.x < 0 || p.x > canvas.width) p.dx *= -1;
        if (p.y < 0 || p.y > canvas.height) p.dy *= -1;
      });

      connectParticles();
      requestAnimationFrame(animate);
    }

    animate();

    window.addEventListener("resize", () => {
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight;
    });

    window.addEventListener("mousemove", (e) => {
      particles.forEach(p => {
        const dx = e.clientX - p.x;
        const dy = e.clientY - p.y;
        const dist = Math.sqrt(dx*dx + dy*dy);
        if (dist < 100) {
          p.x -= dx * 0.02;
          p.y -= dy * 0.02;
        }
      });
    });
  }, []);

  return (
    <div className="App">
      <canvas id="neural-bg"></canvas>
      <header className="App-header">
        <h1>Quantum-API</h1>
        <p>Professional UI/UX with live bio-neural-network background</p>
      </header>
    </div>
  );
}

export default App;
