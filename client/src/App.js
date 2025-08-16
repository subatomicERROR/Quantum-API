import React from 'react';
import './App.css';
import Navbar from './components/Navbar';
import Hero from './components/Hero';
import Features from './components/Features';
import Footer from './components/Footer';

function App() {
  return (
    <div className="App">
      <canvas id="neural-bg"></canvas>
      <Navbar />
      <Hero />
      <Features />
      <Footer />
    </div>
  );
}

export default App;
