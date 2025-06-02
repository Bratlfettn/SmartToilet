USE smart_toilet;

-- Airquality
-- 1. Alle "stinky"-Messungen am Montag
SELECT * FROM air_quality_readings
WHERE health_environment = 'stinky'
  AND DAYNAME(timestamp) = 'Monday';

-- 2. Durchschnittlicher VOC-Wert pro Raum
SELECT r.room_name, AVG(a.voc) AS avg_voc
FROM air_quality_readings a
JOIN sensors s ON a.sensor_id = s.sensor_id
JOIN rooms r ON s.room_id = r.room_id
GROUP BY r.room_name;

-- 3. Anzahl kritischer NH₃-Werte (über 7)
SELECT COUNT(*) AS critical_nh3_count
FROM air_quality_readings
WHERE nh3 > 7;

-- 4. Messungen mit fehlendem NO₂-Wert
SELECT * FROM air_quality_readings
WHERE no2 IS NULL;

-- 5. Durchschnittswerte pro Wochentag
SELECT DAYNAME(timestamp) AS day_of_week, 
       ROUND(AVG(nh3), 2) AS avg_nh3, 
       ROUND(AVG(h2s), 4) AS avg_h2s,
       ROUND(AVG(voc), 1) AS avg_voc
FROM air_quality_readings
GROUP BY DAYNAME(timestamp);

-- Door Contacts
-- 1. Letzter Türstatus pro Sensor
SELECT sensor_id, MAX(timestamp) AS last_seen, door_closed
FROM door_contact_readings
GROUP BY sensor_id, door_closed;

-- 2. Alle offenen Türen am Montag
SELECT * FROM door_contact_readings
WHERE door_closed = FALSE
  AND day_of_week = 'monday';

-- 3. Häufigkeit offener Tür nach Wochentag
SELECT day_of_week, COUNT(*) AS opens
FROM door_contact_readings
WHERE door_closed = FALSE
GROUP BY day_of_week
ORDER BY FIELD(day_of_week, 
  'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday');

-- 4. Türereignisse an Samstagen
SELECT * FROM door_contact_readings
WHERE day_of_week = 'saturday';

-- 5. Anzahl Schließvorgänge pro Sensor
SELECT sensor_id, COUNT(*) AS closes
FROM door_contact_readings
WHERE door_closed = TRUE
GROUP BY sensor_id;

-- Light Sensor
-- 1. Durchschnittliche Lichtstärke pro Wochentag
SELECT day_of_week, ROUND(AVG(light_level_lux), 1) AS avg_lux
FROM light_sensor_readings
GROUP BY day_of_week
ORDER BY FIELD(day_of_week, 
  'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday');

-- 3. Durchschnittliche Lichtstärke in Zeitfenstern
SELECT
  CASE
    WHEN HOUR(timestamp) BETWEEN 6 AND 11 THEN 'morning'
    WHEN HOUR(timestamp) BETWEEN 12 AND 17 THEN 'afternoon'
    WHEN HOUR(timestamp) BETWEEN 18 AND 23 THEN 'evening'
    ELSE 'night'
  END AS time_of_day,
  ROUND(AVG(light_level_lux), 1) AS avg_lux
FROM light_sensor_readings
GROUP BY time_of_day
ORDER BY FIELD(time_of_day, 'morning', 'afternoon', 'evening', 'night');

-- 2. Alle Messungen mit Lux unter 100
SELECT * FROM light_sensor_readings
WHERE light_level_lux < 100;

-- 4. Höchste gemessene Lichtstärke pro Sensor
SELECT sensor_id, MAX(light_level_lux) AS max_lux
FROM light_sensor_readings
GROUP BY sensor_id;

-- 5. Letzte 10 Messungen bei eingeschaltetem Licht (Lux > 300)
SELECT *
FROM light_sensor_readings
WHERE light_level_lux > 300
ORDER BY timestamp DESC
LIMIT 10;