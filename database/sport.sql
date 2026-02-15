USE DATABASE BD_LOCAL;
CREATE TABLE sport (id_sport int Primary KEY , nom_sport int);
SELECT * FROM sport;
ALTER TABLE sport
ADD COLUMN type ENUM('collectif','individuel');
ALTER TABLE sport
MODIFY COLUMN nom_sport VARCHAR(100);
ALTER TABLE sport
MODIFY COLUMN id_sport INT AUTO_INCREMENT;


DESCRIBE sport;


INSERT INTO sport (nom_sport, type) VALUES
('Football', 'collectif'),
('Basketball', 'collectif'),
('Musculation', 'individuel'),
('Yoga', 'individuel');
