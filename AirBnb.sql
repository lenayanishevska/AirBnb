create database AirBnb;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    date_of_birth DATE NOT NULL,
    email VARCHAR(45) NOT NULL CHECK (email REGEXP '^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'),
    phone_number VARCHAR(11) CHECK (phone_number REGEXP '^[0-9]{11}$'),
    profile_picture BLOB,
    type ENUM('host','guest') NOT NULL, 
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE amenities (
    id SERIAL PRIMARY KEY,
    name VARCHAR(45) NOT NULL,
    description VARCHAR(45)
);

CREATE TABLE rooms (
    id SERIAL PRIMARY KEY,
    name VARCHAR(45) NOT NULL,
    amount_of_residents INT NOT NULL,
    price DECIMAL NOT NULL,
    description TEXT,
    room_type ENUM('single', 'double', 'suite') NOT NULL,
    picture BLOB,
    address VARCHAR(45) NOT NULL,
    city VARCHAR(45),
    country VARCHAR(45),
    hosts_id BIGINT UNSIGNED NOT NULL,
    amenities_id BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (hosts_id) REFERENCES AirBnb.users(id),
    FOREIGN KEY (amenities_id) REFERENCES AirBnb.amenities(id)
);

CREATE TABLE reservations (
    id SERIAL PRIMARY KEY,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    total_price DECIMAL NOT NULL,
    payment_status ENUM('pending', 'paid', 'cancelled') NOT NULL, 
    special_requests TEXT,
    rooms_id BIGINT UNSIGNED NOT NULL,
    guests_id BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (rooms_id) REFERENCES rooms(id),
    FOREIGN KEY (guests_id) REFERENCES users(id)
);

CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,
    title VARCHAR(45) NOT NULL,
    comment TEXT NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5) NOT NULL, 
    published_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    rooms_id BIGINT UNSIGNED NOT NULL,
    users_id BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (rooms_id) REFERENCES rooms(id),
    FOREIGN KEY (users_id) REFERENCES users(id)
);

INSERT INTO users (first_name, last_name, date_of_birth, email, phone_number, profile_picture, type, registration_date)
VALUES 
('John', 'Doe', '1990-01-15', 'john.doe@example.com', '12345678901', NULL, 'host', CURRENT_TIMESTAMP),
('Alice', 'Smith', '1985-05-22', 'alice.smith@example.com', '98765432109', NULL, 'host', CURRENT_TIMESTAMP),
('Bob', 'Johnson', '1988-11-30', 'bob.johnson@example.com', '55511122334', NULL, 'guest', CURRENT_TIMESTAMP);

INSERT INTO amenities (name, description)
VALUES 
('Wi-Fi', 'High-speed internet connection'),
('Air Conditioning', 'Climate control for comfort'),
('Parking', 'Secure parking facilities');

INSERT INTO rooms (name, amount_of_residents, price, description, room_type, picture, address, city, country, hosts_id, amenities_id)
VALUES 
('Cozy Suite', 2, 150.00, 'A comfortable suite with a view', 'suite', NULL, '123 Main Street', 'Cityville', 'Countryland', 1, 1),
('Spacious Double Room', 2, 100.00, 'Perfect for couples', 'double', NULL, '456 Oak Avenue', 'Townsville', 'Countryland', 2, 2),
('Single Room', 1, 75.00, 'Compact and convenient', 'single', NULL, '789 Pine Road', 'Villagetown', 'Countryland', 3, 3);

INSERT INTO reservations (check_in_date, check_out_date, total_price, payment_status, special_requests, rooms_id, guests_id)
VALUES 
('2023-02-01', '2023-02-05', 400.00, 'paid', 'No special requests', 1, 2),
('2023-03-10', '2023-03-15', 300.00, 'pending', 'Early check-in requested', 2, 3),
('2023-04-20', '2023-04-25', 250.00, 'paid', 'Late check-out requested', 3, 1);

INSERT INTO reviews (title, comment, rating, published_at, rooms_id, users_id)
VALUES 
('Great Experience', 'Wonderful stay, highly recommend!', 5, CURRENT_TIMESTAMP, 1, 2),
('Comfortable and Clean', 'The room was spacious and clean.', 4, CURRENT_TIMESTAMP, 2, 3),
('Good Value for Money', 'Simple and affordable accommodation.', 3, CURRENT_TIMESTAMP, 3, 1);

SELECT u.id AS user_id, u.first_name AS first_name, u.last_name AS last_name, COUNT(r.id) AS reservation_count
FROM users u
JOIN reservations r ON u.id = r.guests_id
GROUP BY u.id
ORDER BY reservation_count DESC
LIMIT 1;
