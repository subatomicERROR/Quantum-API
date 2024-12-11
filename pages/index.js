import { useCallback, useEffect, useState } from 'react';
import Head from 'next/head'; // For adding meta tags for SEO
import Button from '../components/Button';
import ClickCount from '../components/ClickCount';
import styles from '../styles/home.module.css';

function throwError() {
  console.error(
    "Error simulated for testing purposes by .ERROR: Debugging initiated..."
  );
  try {
    // Simulate an error
    document.body();
  } catch (err) {
    console.error("Caught error:", err);
  }
}

function Home() {
  const [count, setCount] = useState(0);
  const increment = useCallback(() => {
    setCount((v) => v + 1);
  }, [setCount]);

  useEffect(() => {
    const r = setInterval(() => {
      increment();
    }, 1000);

    return () => {
      clearInterval(r);
    };
  }, [increment]);

  return (
    <>
      {/* Advanced SEO Meta Tags */}
      <Head>
        <title>Quantum-API | Powered by .ERROR</title>
        <meta
          name="description"
          content="Quantum-API is a cutting-edge RESTful API by .ERROR that bridges quantum and classical computing. Created by subatomicERROR, it offers seamless integration for quantum computations."
        />
        <meta
          name="keywords"
          content="Quantum-API, quantum computing API, quantum machine learning, RESTful API, subatomicERROR, .ERROR, quantum models, data analysis"
        />
        <meta name="author" content="subatomicERROR" />
        <meta name="robots" content="index, follow" />
        <meta property="og:title" content="Quantum-API | Powered by .ERROR" />
        <meta
          property="og:description"
          content="Experience the future with Quantum-API, created by subatomicERROR. Harness quantum machine learning for advanced data solutions."
        />
        <meta property="og:type" content="website" />
        <meta property="og:url" content="https://github.com/subatomicERROR/Quantum-API" />
        <meta property="og:image" content="/static/favicon.ico" />
        <meta property="og:site_name" content=".ERROR | Quantum-API" />
      </Head>

      <main className={styles.main}>
        <h1>
          Welcome to Quantum-API <span className={styles.brand}>.ERROR</span>
        </h1>
        <p>
          Quantum-API is a powerful RESTful API designed to expose quantum machine learning capabilities. It enables
          seamless interaction with quantum models for tasks like model training, data analysis, and predictions,
          providing advanced solutions using quantum computing integrated with classical machine learning.
        </p>
        <p>
          Whether you are integrating quantum models into your application or leveraging quantum computation for data
          analysis, Quantum-API offers a simple interface for complex quantum tasks.
        </p>
        <p className={styles.signature}>
          Created with 💻 by{' '}
          <a href="https://github.com/subatomicERROR" target="_blank" rel="noopener noreferrer">
            subatomicERROR
          </a>
        </p>
        <hr className={styles.hr} />
        <div>
          <p>
            Auto incrementing value. The counter won't reset after edits or if there are errors.
          </p>
          <p>Current value: {count}</p>
        </div>
        <hr className={styles.hr} />
        <div>
          <p>Component with state.</p>
          <ClickCount />
        </div>
        <hr className={styles.hr} />
        <div>
          <p>
            The button below will throw 2 errors. You'll see the error overlay to let you know about the errors but it
            won't break the page or reset your state.
          </p>
          <Button
            onClick={(e) => {
              setTimeout(() => document.parentNode(), 0);
              throwError();
            }}
          >
            Throw an Error
          </Button>
        </div>
        <hr className={styles.hr} />
      </main>
    </>
  );
}

export default Home;
