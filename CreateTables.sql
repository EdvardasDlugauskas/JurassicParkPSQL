-- TODO: verslo taisykles

-- FOR ENUMS, next to attribute: CHECK( constraint in ('1', '2', '3')
-- FOR MULTIPLE ATTRIBUTES: CONSTRAINT name CHECK ( condition )

-- GENERATED ALWAYS/BY DEFAULT
-- AS IDENTITY START WITH ... INCREMENT BY ...
-- or SERIAL datatype


-- FK deletion/update restrictions:
-- RESTRICT / NO ACTION / CASCADE / SET NULL / SET DEFAULT

-- TRIGGERS:
-- Don't forget to check not only on INSERT but also on UPDATE!
-- Can be used to create custom Id's before INSERT.
-- A function for a trigger must RETURN TRIGGER and have 'plpgsql' as its LANGUAGE.

-- JP TRIGGER ideas (GOING TO BE TIME CONSUMING):
-- Worker can't look after more than X dinosaurs.
-- No more than X dinosaurs of the same species in an enclosure.
-- TicketCost in VisitBuysTicketEnlcosure must be caculated with the newest prices from Enclosure.


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
  EnclosureType VARCHAR(255) NOT NULL,
  Size DOUBLE PRECISION NOT NULL,
  CostNoDiscount DOUBLE PRECISION NOT NULL,
  CostWithDiscount DOUBLE PRECISION NOT NULL,
  AgeLimit INT NOT NULL
      CONSTRAINT AgeLimits
      CHECK(AgeLimit IN (0, 12, 18, 21))
      DEFAULT DEFAULT 0,
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
  FOREIGN KEY (Enclosure) REFERENCES Enclosure(id) ON DELETE NO ACTION,
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
  FOREIGN KEY (CitizenId) REFERENCES _RegisteredVisitor(id) ON DELETE CASCADE,
);

CREATE TABLE WorkerLooksAfterDinosaur
(
  WorkerId INT NOT NULL,
  DinosaurId INT NOT NULL,

  PRIMARY KEY (WorkerId, DinosaurId),
  FOREIGN KEY (WorkerId) REFERENCES Worker(id) ON DELETE CASCADE,
  FOREIGN KEY (DinosaurId) REFERENCES Dinosaur(id) ON DELETE CASCADE,
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
  MoneySpent DOUBLE PRECISION NOT NULL,
  VisitId INT NOT NULL,
  FacilityId INT NOT NULL,

  PRIMARY KEY (VisitId, FacilityId),
  FOREIGN KEY (VisitId) REFERENCES _Visit(id),
  FOREIGN KEY (FacilityId) REFERENCES Facility(id)
);