CREATE OR REPLACE FUNCTION check_dino_species_num()
	RETURNS TRIGGER AS
$$
DECLARE
	speciesCount SMALLINT;
BEGIN
  WITH DinoEncSpec(Enclosure, Species, NumOfSameSpec) AS
	  (SELECT Enclosure, Species, COUNT(*) AS NumOfSameSpecies FROM Dinosaur
        WHERE Enclosure = NEW.Enclosure
        GROUP BY Enclosure, Species)
	SELECT NumOfSameSpec INTO speciesCount FROM DinoEncSpec;

	IF speciesCount >= 5 THEN
	RAISE EXCEPTION 'There can not be more than five dinosaurs of the same species in one enclosure.';
  END IF;
  RETURN NEW;
END; $$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION check_worker_look_after_num()
  RETURNS TRIGGER AS
$$
DECLARE
  lookAfterDinoCount SMALLINT;
BEGIN
  WITH WorkerDinoNum(id, dinoCount) AS
      (SELECT WorkerId, COUNT(*)
       FROM WorkerLooksAfterDinosaur
       WHERE WorkerId = 5
       GROUP BY WorkerId)
  SELECT dinoCount INTO lookAfterDinoCount FROM WorkerDinoNum;

  IF lookAfterDinoCount >= 3 THEN
  RAISE EXCEPTION 'A worker can not look after more than three dinosaurs.';
  END IF;
  RETURN NEW;
END; $$
LANGUAGE plpgsql;


CREATE TRIGGER SameSpeciesDino
BEFORE INSERT OR UPDATE ON Dinosaur
FOR EACH ROW
EXECUTE PROCEDURE check_dino_species_num();

CREATE TRIGGER WorkerLookAfterDino
BEFORE INSERT OR UPDATE ON WorkerLooksAfterDinosaur
FOR EACH ROW
EXECUTE PROCEDURE check_worker_look_after_num();