#!/bin/bash

echo "Setting up Posey PostgreSQL Database..."

# Copy CSV files to accessible location
echo "Copying CSV files to /tmp for database access..."
cp ../posey_data/*.csv /tmp/
chmod 644 /tmp/*.csv

# Create database (as postgres user)
echo "Creating database 'posey'..."
sudo -u postgres createdb posey 2>/dev/null || echo "Database 'posey' may already exist"

# Connect to database and create tables
sudo -u postgres psql -d posey << 'EOF'

-- Create region table
DROP TABLE IF EXISTS region CASCADE;
CREATE TABLE region (
    id INTEGER PRIMARY KEY,
    name VARCHAR(50)
);

-- Create sales_reps table  
DROP TABLE IF EXISTS sales_reps CASCADE;
CREATE TABLE sales_reps (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100),
    region_id INTEGER REFERENCES region(id)
);

-- Create accounts table
DROP TABLE IF EXISTS accounts CASCADE;
CREATE TABLE accounts (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100),
    website VARCHAR(100),
    lat DECIMAL(10,8),
    long DECIMAL(11,8),
    primary_poc VARCHAR(100),
    sales_rep_id INTEGER REFERENCES sales_reps(id)
);

-- Create orders table
DROP TABLE IF EXISTS orders CASCADE;
CREATE TABLE orders (
    id INTEGER PRIMARY KEY,
    account_id INTEGER REFERENCES accounts(id),
    occurred_at TIMESTAMP,
    standard_qty INTEGER,
    gloss_qty INTEGER,
    poster_qty INTEGER,
    total INTEGER,
    standard_amt_usd DECIMAL(10,2),
    gloss_amt_usd DECIMAL(10,2),
    poster_amt_usd DECIMAL(10,2),
    total_amt_usd DECIMAL(10,2)
);

-- Create web_events table
DROP TABLE IF EXISTS web_events CASCADE;
CREATE TABLE web_events (
    id INTEGER PRIMARY KEY,
    account_id INTEGER REFERENCES accounts(id),
    occurred_at TIMESTAMP,
    channel VARCHAR(50)
);

EOF

# Import CSV data
echo "Importing CSV data..."

# Import region data
sudo -u postgres psql -d posey -c "\COPY region FROM '/tmp/region.csv' WITH CSV HEADER;"

# Import sales_reps data  
sudo -u postgres psql -d posey -c "\COPY sales_reps FROM '/tmp/sales_reps.csv' WITH CSV HEADER;"

# Import accounts data
sudo -u postgres psql -d posey -c "\COPY accounts FROM '/tmp/accounts.csv' WITH CSV HEADER;"

# Import orders data
sudo -u postgres psql -d posey -c "\COPY orders FROM '/tmp/orders.csv' WITH CSV HEADER;"

# Import web_events data
sudo -u postgres psql -d posey -c "\COPY web_events FROM '/tmp/web_events.csv' WITH CSV HEADER;"

# Verify data import
echo ""
echo "Verifying data import..."
sudo -u postgres psql -d posey -c "
SELECT 'region' as table_name, COUNT(*) as row_count FROM region
UNION ALL
SELECT 'sales_reps', COUNT(*) FROM sales_reps  
UNION ALL
SELECT 'accounts', COUNT(*) FROM accounts
UNION ALL  
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'web_events', COUNT(*) FROM web_events;
"

echo ""
echo "Posey database setup completed successfully!"
