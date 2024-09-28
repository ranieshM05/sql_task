-- Create the customers table
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    address VARCHAR(255) NOT NULL
);

-- Create the products table
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description TEXT
);

-- Create the orders table
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- Insert sample data into customers
INSERT INTO customers (name, email, address)
VALUES 
('John Doe', 'john@example.com', '123 Elm Street'),
('Jane Smith', 'jane@example.com', '456 Oak Avenue'),
('Alice Johnson', 'alice@example.com', '789 Pine Road');

-- Insert sample data into products
INSERT INTO products (name, price, description)
VALUES 
('Product A', 30.00, 'Description of Product A'),
('Product B', 50.00, 'Description of Product B'),
('Product C', 40.00, 'Description of Product C');

-- Insert sample data into orders
INSERT INTO orders (customer_id, order_date, total_amount)
VALUES 
(1, '2023-08-20', 60.00),
(2, '2023-09-01', 50.00),
(1, '2023-09-15', 40.00);

SELECT DISTINCT c.id, c.name, c.email, c.address
FROM customers c
JOIN orders o ON c.id = o.customer_id
WHERE o.order_date >= CURDATE() - INTERVAL 30 DAY;

SELECT c.id, c.name, SUM(o.total_amount) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.name;

-- Update the price of Product C to 45.00
UPDATE products
SET price = 45.00
WHERE name = 'Product C';

ALTER TABLE products
ADD COLUMN discount DECIMAL(10, 2) DEFAULT 0;

-- Retrieve the top 3 products with the highest price
SELECT name, price
FROM products
ORDER BY price DESC
LIMIT 3;

-- Create order_items table
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Insert sample data into order_items
INSERT INTO order_items (order_id, product_id, quantity)
VALUES 
(1, 1, 2),  -- Order 1 contains 2 of Product A
(2, 2, 1),  -- Order 2 contains 1 of Product B
(3, 3, 1);  -- Order 3 contains 1 of Product C

SELECT DISTINCT c.name
FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE p.name = 'Product A';

SELECT c.name AS customer_name, o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.id;

-- Insert additional sample data into orders for testing
INSERT INTO orders (customer_id, order_date, total_amount)
VALUES 
(1, '2023-09-20', 200.00),  -- This order has a total amount greater than 150.00
(2, '2023-09-25', 160.00);   -- This order also has a total amount greater than 150.00


SELECT *
FROM orders
WHERE total_amount > 150.00;


-- Drop the total_amount column from orders table
ALTER TABLE orders
DROP COLUMN total_amount;


SELECT o.id AS order_id, o.order_date, c.name AS customer_name,
       SUM(oi.quantity * p.price) AS total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
GROUP BY o.id, o.order_date, c.name;


-- Your previous table and data creation code...

-- Retrieve the average total of all orders
SELECT AVG(order_total) AS average_order_total
FROM (
    SELECT o.id AS order_id, 
           SUM(oi.quantity * p.price) AS order_total
    FROM orders o
    JOIN order_items oi ON o.id = oi.order_id
    JOIN products p ON oi.product_id = p.id
    GROUP BY o.id
) AS total_orders;

