document.getElementById('submit-button').addEventListener('click', async () => {
    const query = document.getElementById('query-input').value;
    const responseOutput = document.getElementById('response-output');
    
    if (!query) {
        responseOutput.textContent = 'Please enter a query.';
        return;
    }

    try {
        const response = await fetch('/api/generate-circuit', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ query })
        });

        if (!response.ok) {
            throw new Error('Network response was not ok');
        }

        const data = await response.json();
        responseOutput.textContent = JSON.stringify(data, null, 2);
    } catch (error) {
        responseOutput.textContent = `Error: ${error.message}`;
    }
});