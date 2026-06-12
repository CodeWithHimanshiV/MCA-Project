const express = require('express');

const app = express();
const port = process.env.PORT || 8080;

app.use(express.json());

app.get('/health', (request, response) => {
  response.status(200).json({ status: 'UP', service: 'payment-service' });
});

app.get('/api/payments', (request, response) => {
  response.json({
    service: 'payment-service',
    data: [
      { id: 'PAY-9001', orderId: 'ORD-5001', status: 'CAPTURED', amount: 2499 },
      { id: 'PAY-9002', orderId: 'ORD-5002', status: 'PENDING', amount: 1299 }
    ]
  });
});

app.get('/internal/info', (request, response) => {
  response.json({ service: 'payment-service', version: '1.0.0' });
});

app.listen(port, () => {
  console.log(`payment-service listening on port ${port}`);
});
