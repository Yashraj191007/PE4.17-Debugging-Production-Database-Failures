-- Insert 5 real customers
INSERT INTO customers (id, name, email) VALUES
(1, 'John Doe', 'john.doe@example.com'),
(2, 'Jane Smith', 'jane.smith@example.com'),
(3, 'Bob Johnson', 'bob.johnson@example.com'),
(4, 'Alice Williams', 'alice.williams@example.com'),
(5, 'Charlie Brown', 'charlie.brown@example.com');

-- Insert products
-- FIX 2 Applied: Negative inventory values (-3, -5) corrected to 0.
-- The CHECK (inventory_count >= 0) constraint now prevents any future negative inserts.
INSERT INTO products (id, name, sku, inventory_count, price) VALUES
(1, 'Mechanical Keyboard', 'SKU-001', 50, 89.99),
(2, 'Wireless Mouse', 'SKU-002', 0, 25.00),       -- was -3, corrected to 0
(3, 'USB-C Cable (1m)', 'SKU-003', 0, 12.50),     -- was -5, corrected to 0
(4, '27-inch Monitor', 'SKU-004', 15, 299.99),
(5, 'Laptop Stand', 'SKU-005', 10, 45.00);

-- Insert orders (all with valid customer_ids)
-- FIX 1 Applied: Orphaned orders (customer_id 9999) removed.
-- The FOREIGN KEY constraint on orders.customer_id now prevents inserts
-- referencing non-existent customers.
INSERT INTO orders (id, customer_id, status, total) VALUES
(1, 1, 'completed', 114.99),
(2, 2, 'pending', 299.99);

-- Insert order items (unchanged)
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 89.99),
(1, 2, 1, 25.00),
(2, 4, 1, 299.99);

-- Insert payments (one payment per order)
-- FIX 3 Applied: Duplicate payment for order_id 1 removed.
-- The UNIQUE constraint on payments.order_id now prevents inserting
-- multiple payment records for the same order.
INSERT INTO payments (order_id, amount, status) VALUES
(1, 114.99, 'completed'),
(2, 299.99, 'pending');

-- Continue normal sequences for SERIAL
SELECT setval('customers_id_seq', (SELECT MAX(id) FROM customers));
SELECT setval('products_id_seq', (SELECT MAX(id) FROM products));
SELECT setval('orders_id_seq', (SELECT MAX(id) FROM orders));
