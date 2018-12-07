CREATE OR REPLACE FUNCTION check_dino_species_num()
  RETURNS TRIGGER AS
$$
DECLARE
  speciesCount SMALLINT;
BEGIN
  WITH DinoEncSpec(Enclosure, Species, NumOfSameSpec) AS
      (SELECT Enclosure, Species, COUNT(*) AS NumOfSameSpecies FROM Dinosaur
       WHERE Enclosure = NEW.Enclosure
         AND Species = NEW.Species
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
DECLARE
  tempTicketCost SMALLINT;
BEGIN
  WITH TicketCostsEnclosure(rowCount) AS
      (SELECT COUNT(*) FROM Enclosure AS E
       WHERE NEW.EnclosureId = E.Id
         AND (NEW.TicketCost = E.CostNoDiscount OR NEW.TicketCost = E.CostWithDiscount))
  SELECT rowCount INTO tempTicketCost FROM TicketCostsEnclosure;

  IF tempTicketCost = 0 THEN
    RAISE EXCEPTION 'The table''s "VisitBuysTicketEnclosure" TicketCost column value must be from the Enclosure table.';
  END IF;
  RETURN NEW;
END; $$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION check_is_eligible_to_buy_ticket()
  RETURNS TRIGGER AS
$$
DECLARE
  visitorAge SMALLINT;
  ageLimit SMALLINT;
BEGIN
  SELECT EXTRACT(YEAR FROM RV.Age) INTO visitorAge FROM _Visit AS V, RegisteredVisitor AS RV
  WHERE NEW.VisitId = V.Id
    AND V.CitizenId = RV.Id;

  SELECT E.AgeLimit INTO ageLimit FROM Enclosure AS E
  WHERE NEW.EnclosureId = E.Id;

  IF visitorAge < ageLimit AND ageLimit <> 0 THEN
    RAISE EXCEPTION 'A visitor can not buy a ticket to an enclosure if his age is less than the set age limit of an enclosure.';
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


CREATE TRIGGER VisitorAgeLimit
BEFORE INSERT OR UPDATE ON VisitBuysTicketEnclosure
FOR EACH ROW
EXECUTE PROCEDURE check_is_eligible_to_buy_ticket();