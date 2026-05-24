-- Drop tables in order of dependencies
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

-- Customer records
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- FIX 1: Added FOREIGN KEY constraint on customer_id.
-- Previously: customer_id INTEGER  (no reference)
-- Now: customer_id INTEGER NOT NULL REFERENCES customers(id)
-- This prevents orders from being created for non-existent customers,
-- eliminating orphaned records that cause NULL customer_name in JOIN results.
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(id),
    status VARCHAR(20) DEFAULT 'pending',
    total DECIMAL(10,2) DEFAULT 0.00,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- FIX 2: Added CHECK constraint on inventory_count.
-- Previously: inventory_count INTEGER DEFAULT 0  (no lower bound)
-- Now: inventory_count INTEGER DEFAULT 0 CHECK (inventory_count >= 0)
-- This prevents negative stock values from being written by any INSERT or UPDATE,
-- enforcing the real-world rule that you cannot have fewer than zero units in stock.
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    sku VARCHAR(50) NOT NULL UNIQUE,
    inventory_count INTEGER DEFAULT 0 CHECK (inventory_count >= 0),
    price DECIMAL(10,2) NOT NULL
);

-- Order Items table (unchanged — already had proper FK constraints)
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(id),
    product_id INTEGER NOT NULL REFERENCES products(id),
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL
);

-- FIX 3: Added UNIQUE constraint on order_id in payments.
-- Previously: order_id INTEGER NOT NULL  (no uniqueness enforcement)
-- Now: order_id INTEGER NOT NULL UNIQUE
-- This ensures each order can only have one payment record, preventing duplicate
-- entries that cause ambiguous or contradictory payment statuses.
CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL UNIQUE,
    amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT NOW()
);
