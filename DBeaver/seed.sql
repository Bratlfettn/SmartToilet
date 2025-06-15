USE smart_toilet;

INSERT INTO buildings (name, address) VALUES 
('GGW', 'Am Silberberg 26, 8074 Raaba');

INSERT INTO tenants (name, apartment_number, lease_start, lease_end, building_id) VALUES 
('Matthias Winkler', '1', '2024-02-01', '2026-02-01', 1),
('Michael Wettl', '2', '2024-05-03', '2026-07-08', 1),
('Felix Feistritzer', '3', '2023-08-01', '2025-07-31', 1);

INSERT INTO rooms (room_name, building_id) VALUES 
('Toilette EG', 1),
('Toilette OG', 1),
('Accessible toilet', 1);

INSERT INTO sensors (sensor_type, installation_date, room_id) VALUES 
('light_sensor', '2024-06-01', 1),     -- sensor_id = 1
('door_contact', '2024-06-05', 2),     -- sensor_id = 2
('air_quality', '2024-06-10', 3);      -- sensor_id = 3
