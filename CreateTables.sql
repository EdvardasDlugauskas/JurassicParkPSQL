-- TODO: verslo taisykles

-- FOR ENUMS, next to attribute: CHECK( constraint in ('1', '2', '3')
-- FOR MULTIPLE ATTRIBUTES: CONSTRAINT name CHECK ( condition )

-- GENERATED ALWAYS/BY DEFAULT
-- AS IDENTITY START WITH ... INCREMENT BY ...
-- or SERIAL datatype


-- FK deletion/update restrictions:
--  RESTRICT / NO ACTION / CASCADE / SET NULL / SET DEFAULT

-- TRIGGER ideas:
--  Worker can't look after more than X dinosaurs
--  Instead of VIEW for MoneySpent



CREATE TABLE Worker
(
  id INT NOT NULL,
  Specialty VARCHAR(255) NOT NULL, -- TODO: ENUM
  Surname VARCHAR(255) NOT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE Enclosure
(
  id INT NOT NULL,
  EnclosureType VARCHAR(255) NOT NULL,
  Size DOUBLE PRECISION NOT NULL,
  CostNoDiscount DOUBLE PRECISION NOT NULL,
  CostWithDiscount DOUBLE PRECISION NOT NULL,
  AgeLimit INT NOT NULL, -- TODO: ENUM?

  PRIMARY KEY (id)
);

CREATE TABLE RegisteredVisitor
(
  id INT NOT NULL,
  Name VARCHAR(255) NOT NULL,
  Surname VARCHAR(255) NOT NULL,
  Birthday DATE NOT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE Facility
(
  id INT NOT NULL,
  FacilityType VARCHAR(255) NOT NULL, -- TODO: ENUM

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
  id INT NOT NULL,
  Name VARCHAR(255) NOT NULL, -- TODO: UNIQUE INDEX (?), "CONSTRAINT attr UNIQUE"
  Species VARCHAR(255) NOT NULL,
  Enclosure INT NOT NULL,

  PRIMARY KEY (id),
  FOREIGN KEY (Enclosure) REFERENCES Enclosure(id) --TODO: ON DELETE NO ACTION (default, can skip)
);

CREATE TABLE Visit
(
  id INT NOT NULL,
  Date DATE NOT NULL,
  TicketType VARCHAR(255) NOT NULL,
  CitizenId INT NOT NULL,

  PRIMARY KEY (id),
  FOREIGN KEY (CitizenId) REFERENCES RegisteredVisitor(id) --TODO: ON DELETE CASCADE
);

CREATE TABLE WorkerLooksAfterDinosaur
(
  WorkerId INT NOT NULL,
  DinosaurId INT NOT NULL,

  PRIMARY KEY (WorkerId, DinosaurId),
  FOREIGN KEY (WorkerId) REFERENCES Worker(id), -- TODO: ON DELETE CASCADE
  FOREIGN KEY (DinosaurId) REFERENCES Dinosaur(id) -- TODO: ON DELETE CASCADE
);

CREATE TABLE VisitBuysTicketEnclosure
(
  VisitId INT NOT NULL,
  EnclosureId INT NOT NULL,

  PRIMARY KEY (VisitId, EnclosureId),
  FOREIGN KEY (VisitId) REFERENCES Visit(id), --TODO: ON DELETE CASCADE
  FOREIGN KEY (EnclosureId) REFERENCES Enclosure(id)
);

CREATE TABLE VisitUsesFacility
(
  MoneySpent DOUBLE PRECISION NOT NULL,
  VisitId INT NOT NULL,
  FacilityId INT NOT NULL,

  PRIMARY KEY (VisitId, FacilityId),
  FOREIGN KEY (VisitId) REFERENCES Visit(id),
  FOREIGN KEY (FacilityId) REFERENCES Facility(id)
);

CREATE VIEW VisitorAge
  AS SELECT *, AGE(Birthday) AS Age
  FROM RegisteredVisitor;
