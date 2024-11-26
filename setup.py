from setuptools import setup, find_packages

setup(
    name='quantum-api',
    version='0.1',
    packages=find_packages(),
    install_requires=[
        'fastapi',
        'pennylane',  # Add any other dependencies here
        # Include any other necessary dependencies
    ],
    entry_points={
        'console_scripts': [
            'quantum-api = quantum_api.main:app',  # Adjust to your actual script and entry point
        ]
    },
)
