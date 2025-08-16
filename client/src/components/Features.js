import React from 'react';
import './Features.css';

function Features() {
  return (
    <section className="features" id="features">
      <div className="feature-card">
        <h3>Quantum Computation</h3>
        <p>Run hybrid quantum-classical ML models seamlessly.</p>
      </div>
      <div className="feature-card">
        <h3>Real-time API</h3>
        <p>Access quantum models instantly through REST endpoints.</p>
      </div>
      <div className="feature-card">
        <h3>Secure & Lightweight</h3>
        <p>Optimized for minimal footprint and maximum speed.</p>
      </div>
    </section>
  );
}

export default Features;
