CREATE TABLE Worker
(
  id INT NOT NULL,
  Specialty VARCHAR(255) NOT NULL,
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
  AgeLimit INT NOT NULL,

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
  FacilityType VARCHAR(255) NOT NULL,

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
  Name VARCHAR(255) NOT NULL,
  id INT NOT NULL,
  Species VARCHAR(255) NOT NULL,
  Enclosure INT NOT NULL,

  PRIMARY KEY (id),
  FOREIGN KEY (Enclosure) REFERENCES Enclosure(id)
);

CREATE TABLE Visit
(
  id INT NOT NULL,
  Date DATE NOT NULL,
  TicketType VARCHAR(255) NOT NULL,
  CitizenId INT NOT NULL,

  PRIMARY KEY (id),
  FOREIGN KEY (CitizenId) REFERENCES RegisteredVisitor(id)
);

CREATE TABLE WorkerLooksAfterDinosaur
(
  WorkerId INT NOT NULL,
  DinosaurId INT NOT NULL,

  PRIMARY KEY (WorkerId, DinosaurId),
  FOREIGN KEY (WorkerId) REFERENCES Worker(id),
  FOREIGN KEY (DinosaurId) REFERENCES Dinosaur(id)
);

CREATE TABLE VisitBuysTicketEnclosure
(
  VisitId INT NOT NULL,
  EnclosureId INT NOT NULL,

  PRIMARY KEY (VisitId, EnclosureId),
  FOREIGN KEY (VisitId) REFERENCES Visit(id),
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
