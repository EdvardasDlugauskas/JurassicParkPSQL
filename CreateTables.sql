CREATE TABLE Worker
(
  id INT NOT NULL,
  Specialty INT NOT NULL,
  Surname INT NOT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE Enclosure
(
  id INT NOT NULL,
  EnclosureType INT NOT NULL,
  Size INT NOT NULL,
  CostNoDiscount INT NOT NULL,
  CostWithDiscount INT NOT NULL,
  AgeLimit INT NOT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE RegisteredVisitor
(
  id INT NOT NULL,
  Name INT NOT NULL,
  Surname INT NOT NULL,
  Birthday INT NOT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE Facility
(
  id INT NOT NULL,
  FacilityType INT NOT NULL,

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
  Name INT NOT NULL,
  id INT NOT NULL,
  Species INT NOT NULL,
  Enclosure INT NOT NULL,

  PRIMARY KEY (id),
  FOREIGN KEY (Enclosure) REFERENCES Enclosure(id)
);

CREATE TABLE Visit
(
  id INT NOT NULL,
  Date INT NOT NULL,
  TicketType INT NOT NULL,
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
  MoneySpent INT NOT NULL,
  VisitId INT NOT NULL,
  FacilityId INT NOT NULL,

  PRIMARY KEY (VisitId, FacilityId),
  FOREIGN KEY (VisitId) REFERENCES Visit(id),
  FOREIGN KEY (FacilityId) REFERENCES Facility(id)
);