import React from 'react';
import './Hero.css';

function Hero() {
  return (
    <section className="hero">
      <h1 className="hero-title">Quantum-API</h1>
      <p className="hero-subtitle">Access hyper-intelligent quantum models instantly</p>
      <div className="hero-buttons">
        <a href="#get-api" className="btn">Get API Key</a>
        <a href="#docs" className="btn btn-outline">View Docs</a>
        <a href="https://github.com/subatomicERROR/Quantum-API" className="btn btn-outline">GitHub</a>
      </div>
    </section>
  );
}

export default Hero;
