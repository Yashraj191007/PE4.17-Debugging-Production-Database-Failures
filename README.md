# OrderFlow Order Management API

Welcome to OrderFlow! This is a starter codebase designed to help you practice debugging in production-like database environments. This API handles customers, orders, order items, products, and payments for a busy e-commerce platform.

## Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) (v16.x or newer)
- [PostgreSQL](https://www.postgresql.org/) (v13.x or newer)

### Installation

1.  **Clone the repository** (if you haven't already).
2.  **Install dependencies**:
    ```bash
    npm install
    ```
3.  **Setup Environment Variables**:
    ```bash
    cp .env.example .env
    ```
    Edit `.env` and set your `DATABASE_URL`.
4.  **Initialize Database**:
    Run the schema and seed scripts using the provided `npm` command:
    ```bash
    # Set DATABASE_URL in your terminal before running if not using .env
    # Example: export DATABASE_URL="postgresql://postgres:postgres@localhost:5432/orderflow"
    npm run seed
    ```
    This will create the tables and populate them with sample data for testing.
5.  **Start the Server**:
    ```bash
    npm start
    ```
    The API will be available at `http://localhost:3001`.

## Database Schema

The system uses five core tables:
- `customers`: Stores user profiles.
- `orders`: Tracks individual purchases.
- `products`: Manages items and inventory.
- `order_items`: Maps products to specific orders.
- `payments`: Records payment transactions for orders.

## API Documentation

- `GET /customers`: List all customers.
- `GET /orders`: List all orders with associated customer names.
- `POST /orders`: Create a new order.
- `GET /order_items/:orderId`: Retrieve items for a specific order.
- `POST /order_items`: Add an item to an order and update product inventory.
- `GET /products`: List all products.
- `PATCH /products/:id/inventory`: Adjust product inventory level.
- `GET /payments/:orderId`: Retrieve payment status for an order.
- `POST /payments`: Submit a payment for an order.

## Known Issues (Symptom Level)

As the current lead for the OrderFlow project, you’ve received recent reports about the following data inconsistencies in production:

1.  **"Some orders appear in the system with no associated customer record"** — When listing all orders, certain entries show a `null` customer name, even though a `customer_id` is clearly recorded in the table.
2.  **"Certain products show negative inventory counts after order processing"** — Several products in the database have an `inventory_count` less than zero, which should not be possible in a real-world warehouse.
3.  **"Some completed orders show payment status as pending"** — For some specific orders, users have reported seeing ambiguous payment statuses or multiple payment records when only one was expected.

Your job is to investigate the database schema, write reproduction queries, identify the root causes of these bugs, and fix them.

## Bugs Fixed

All three production bugs have been identified, traced to their schema-level root causes, and fixed:

| # | Symptom | Root Cause | Fix |
|---|---------|------------|-----|
| 1 | Orders with `null` customer name in API response | `orders.customer_id` missing `FOREIGN KEY REFERENCES customers(id)` | Added FK constraint — orphaned `customer_id` values now rejected at insert time |
| 2 | Products with negative `inventory_count` | `products.inventory_count` missing `CHECK (inventory_count >= 0)` | Added CHECK constraint — any insert or update resulting in negative stock is rejected |
| 3 | Multiple payment records per order with conflicting statuses | `payments.order_id` missing `UNIQUE` constraint | Added UNIQUE constraint — only one payment record allowed per order |

See [DEBUG-REPORT.md](./DEBUG-REPORT.md) for the full investigation trail: reproduction queries, data flow traces, root cause analysis, fix SQL, and validation.

## Live Deployment

> **URL:** *(Add Render/Railway deployment URL here after deploying)*

### Deploy to Render

1. Go to [render.com](https://render.com) → New Web Service → Connect your GitHub repo
2. Build command: `npm install`
3. Start command: `npm start`
4. Add environment variable: `DATABASE_URL` → your PostgreSQL connection string
5. Deploy

