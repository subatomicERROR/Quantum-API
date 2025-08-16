import React from 'react';
import './Navbar.css';

function Navbar() {
  return (
    <nav className="navbar">
      <div className="logo">Quantum-API</div>
      <ul className="nav-links">
        <li><a href="#features">Features</a></li>
        <li><a href="#docs">Docs</a></li>
        <li><a href="#about">About</a></li>
        <li><a href="#contact">Contact</a></li>
      </ul>
    </nav>
  );
}

export default Navbar;
