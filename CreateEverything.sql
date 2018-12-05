-- CREATE TABLES --

CREATE TABLE Worker
(
  id SERIAL,
  Specialty VARCHAR(255) NOT NULL
    CONSTRAINT WorkerSpecialties
    CHECK(Specialty IN ('Cleaner', 'Veterinarian', 'Feeder', 'Trainer'))
    DEFAULT 'Cleaner',
  Surname VARCHAR(255) NOT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE Enclosure
(
  id SERIAL,
  EnclosureType VARCHAR(255) NOT NULL
    CONSTRAINT EnclosureTypes
    CHECK(EnclosureType IN ('Land', 'Aerial', 'Water'))
                           DEFAULT 'Land',
  Size DOUBLE PRECISION NOT NULL,
  CostNoDiscount DOUBLE PRECISION NOT NULL,
  CostWithDiscount DOUBLE PRECISION NOT NULL,
  AgeLimit INT NOT NULL
    CONSTRAINT AgeLimits
    CHECK(AgeLimit IN (0, 12, 18, 21))
                           DEFAULT 0,
  DiscountAge INT NOT NULL DEFAULT 0,

  PRIMARY KEY (id)
);

CREATE TABLE _RegisteredVisitor
(
  id SERIAL,
  Name VARCHAR(255) NOT NULL,
  Surname VARCHAR(255) NOT NULL,
  Birthday DATE NOT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE Facility
(
  id SERIAL,
  FacilityType VARCHAR(255) NOT NULL
    CONSTRAINT FacilityTypes
    CHECK(FacilityType IN ('General', 'Restaurant', 'Restroom', 'Shop', 'Hotel', 'Observatory'))
    DEFAULT 'General',

  PRIMARY KEY (id)
);

CREATE TABLE WorkerKeepsCleanEnclosure
(
  WorkerId INT NOT NULL,
  EnclosureId INT NOT NULL,

  PRIMARY KEY (WorkerId, EnclosureId),
  FOREIGN KEY (WorkerId) REFERENCES Worker(id),
  FOREIGN KEY (EnclosureId) REFERENCES Enclosure(id)
);

CREATE TABLE Dinosaur
(
  id SERIAL,
  Name VARCHAR(255) NOT NULL,
  Species VARCHAR(255) NOT NULL,
  Enclosure INT NOT NULL,

  PRIMARY KEY (id),
  FOREIGN KEY (Enclosure) REFERENCES Enclosure(id) ON DELETE NO ACTION
);

CREATE TABLE _Visit
(
  id SERIAL,
  Date DATE NOT NULL,
  TicketType VARCHAR(255) NOT NULL
    CONSTRAINT TicketTypes
    CHECK (TicketType IN ('Child', 'Teen', 'Adult', 'Senior'))
    DEFAULT 'Adult',
  CitizenId INT NOT NULL,

  PRIMARY KEY (id),
  FOREIGN KEY (CitizenId) REFERENCES _RegisteredVisitor(id) ON DELETE CASCADE
);

CREATE TABLE WorkerLooksAfterDinosaur
(
  WorkerId INT NOT NULL,
  DinosaurId INT NOT NULL,

  PRIMARY KEY (WorkerId, DinosaurId),
  FOREIGN KEY (WorkerId) REFERENCES Worker(id) ON DELETE CASCADE,
  FOREIGN KEY (DinosaurId) REFERENCES Dinosaur(id) ON DELETE CASCADE
);

CREATE TABLE VisitBuysTicketEnclosure
(
  VisitId INT NOT NULL,
  EnclosureId INT NOT NULL,
  TicketCost DOUBLE PRECISION NOT NULL,

  PRIMARY KEY (VisitId, EnclosureId),
  FOREIGN KEY (VisitId) REFERENCES _Visit(id) ON DELETE CASCADE,
  FOREIGN KEY (EnclosureId) REFERENCES Enclosure(id)
);

CREATE TABLE VisitUsesFacility
(
  VisitId INT NOT NULL,
  FacilityId INT NOT NULL,
  MoneySpent DOUBLE PRECISION NOT NULL,

  PRIMARY KEY (VisitId, FacilityId),
  FOREIGN KEY (VisitId) REFERENCES _Visit(id),
  FOREIGN KEY (FacilityId) REFERENCES Facility(id)
);

-- CREATE VIEWS --
CREATE VIEW RegisteredVisitor
  AS SELECT *, AGE(Birthday) AS Age, CONCAT(Name, ' ', Surname) AS Fullname
     FROM _RegisteredVisitor;

CREATE VIEW DinosaursLewisLooksAfter
  AS SELECT *
     FROM WorkerLooksAfterDinosaur
     WHERE WorkerId = 5 -- Lewis' ID
  WITH CHECK OPTION;

CREATE VIEW VisitorMoneySpentOnFacilities
  AS SELECT VisitId, SUM(MoneySpent) AS MoneySpent
     FROM VisitUsesFacility GROUP BY VisitId;

CREATE VIEW VisitorMoneySpentOnTickets
  AS SELECT VisitId, SUM(TicketCost) as TicketTotal
     FROM VisitBuysTicketEnclosure GROUP BY VisitId;

CREATE VIEW Visit
  AS SELECT _Visit.*,
       COALESCE(VisitorMoneySpentOnFacilities.MoneySpent, 0) +
       COALESCE(VisitorMoneySpentOnTickets.TicketTotal, 0) AS MoneySpent
     FROM _Visit
       LEFT OUTER JOIN VisitorMoneySpentOnFacilities ON _Visit.id = VisitorMoneySpentOnFacilities.VisitId
       LEFT OUTER JOIN VisitorMoneySpentOnTickets ON _Visit.id = VisitorMoneySpentOnTickets.VisitId;



-- CREATE MVLs --
CREATE MATERIALIZED VIEW
  FacilityReport(Facility, VisitorsCount, MoneyEarned)
  AS SELECT FacilityId, COUNT(VisitId), SUM(MoneySpent)
     FROM VisitUsesFacility
     GROUP BY FacilityId
WITH NO DATA;


CREATE MATERIALIZED VIEW
  DinosaurSpecies(DinosaurSpecies)
  AS SELECT DISTINCT Species
     FROM Dinosaur
WITH DATA;

-- REFRESH MVLs --

REFRESH MATERIALIZED VIEW FacilityReport;

-- Not mandatory
REFRESH MATERIALIZED VIEW DinosaurSpecies;

-- CREATE INDEXES --
CREATE UNIQUE INDEX DinosaurNames
  ON Dinosaur(Name);

CREATE INDEX WorkerInfo
  ON Worker(Specialty, Surname);

CREATE INDEX EnclosureInfo
  ON Enclosure(EnclosureType, Size);

CREATE INDEX FacilityTypes
  ON Facility(FacilityType);

-- CREATE TRIGGERS --
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