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
       WHERE WorkerId = NEW.WorkerId
       GROUP BY WorkerId)
  SELECT dinoCount INTO lookAfterDinoCount FROM WorkerDinoNum;

  IF lookAfterDinoCount >= 3 THEN
  RAISE EXCEPTION 'A worker can not look after more than three dinosaurs.';
  END IF;
  RETURN NEW;
END; $$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION check_up_to_date_ticket_cost()
  RETURNS TRIGGER AS
$$
BEGIN
  PERFORM (WITH TicketCostsEnclosure(Id, TicketCost) AS
  (SELECT VBT.EnclosureId, VBT.TicketCost FROM VisitBuysTicketEnclosure AS VBT, Enclosure AS E
    WHERE VBT.EnclosureId = NEW.EnclosureId
    AND VBT.EnclosureId = E.Id
    AND (VBT.TicketCost = E.CostNoDiscount OR VBT.TicketCost = E.CostWithDiscount))
  SELECT TicketCost FROM TicketCostsEnclosure);
  IF NOT FOUND THEN
  RAISE EXCEPTION 'The table''s "VisitBuysTicketEnclosure" TicketCost column value must be from the Enclosure table.';
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

CREATE TRIGGER UpToDateTicketCost
BEFORE INSERT OR UPDATE ON VisitBuysTicketEnclosure
FOR EACH ROW
EXECUTE PROCEDURE check_up_to_date_ticket_cost();