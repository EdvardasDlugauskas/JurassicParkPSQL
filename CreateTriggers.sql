CREATE OR REPLACE FUNCTION check_dino_species_num()
	RETURNS TRIGGER AS
DECLARE
	speciesCount := smallint;
$$
BEGIN
SELECT NumOfSameSpecies INTO speciesCount FROM (SELECT Enclosure, Species, COUNT(*) AS NumOfSameSpecies FROM Dinosaur
        WHERE Enclosure = NEW.Enclosure
        GROUP BY Enclosure, Species) AS temp)
IF speciesCount >= 5
THEN
	RAISE EXCEPTION 'There can not be more than five dinosaurs of the same species in one enclosure.';
END IF;
RETURN NEW;
END; $$
LANGUAGE plpgsql;


CREATE TRIGGER SameSpeciesDino
BEFORE INSERT OR UPDATE ON Dinosaur
FOR EACH ROW
EXECUTE PROCEDURE check_dino_species_num();



-- (SELECT NumOfSameSpecies FROM (SELECT Enclosure, Species, COUNT(*) AS NumOfSameSpecies FROM Dinosaur
-- GROUP BY Enclosure, Species) AS temp WHERE temp.Enclosure = NEW.Enclosure) >= 5