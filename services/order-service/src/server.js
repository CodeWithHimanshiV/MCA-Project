const express = require('express');

const app = express();
const port = process.env.PORT || 8080;

app.use(express.json());

app.get('/health', (request, response) => {
  response.status(200).json({ status: 'UP', service: 'order-service' });
});

app.get('/api/orders', (request, response) => {
  response.json({
    service: 'order-service',
    data: [
      { id: 'ORD-5001', customerId: 'CUST-1001', status: 'CONFIRMED', amount: 2499 },
      { id: 'ORD-5002', customerId: 'CUST-1002', status: 'PROCESSING', amount: 1299 }
    ]
  });
});

app.get('/internal/info', (request, response) => {
  response.json({ service: 'order-service', version: '1.0.0' });
});

app.listen(port, () => {
  console.log(`order-service listening on port ${port}`);
});
