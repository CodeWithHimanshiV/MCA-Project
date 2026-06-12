const express = require('express');

const app = express();
const port = process.env.PORT || 8080;

app.use(express.json());

app.get('/health', (request, response) => {
  response.status(200).json({ status: 'UP', service: 'customer-service' });
});

app.get('/api/customers', (request, response) => {
  response.json({
    service: 'customer-service',
    data: [
      { id: 'CUST-1001', name: 'Aarav Sharma', tier: 'Gold' },
      { id: 'CUST-1002', name: 'Priya Mehta', tier: 'Silver' }
    ]
  });
});

app.get('/internal/info', (request, response) => {
  response.json({ service: 'customer-service', version: '1.0.0' });
});

app.listen(port, () => {
  console.log(`customer-service listening on port ${port}`);
});
