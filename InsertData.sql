INSERT INTO Worker(id, Specialty, Surname)
VALUES
  (1, 'Cleaner', 'Robinson'),
  (2, 'Cleaner', 'Smith'),
  (3, 'Cleaner', 'Jones'),
  (4, 'Cleaner', 'Brown'),
  (5, 'Trainer', 'Lewis'),
  (6, 'Veterinarian', 'Allen'),
  (7, 'Feeder', 'Bailey'),
  (8, 'Feeder', 'Jones'),
  (9, 'Feeder', 'Cox'),
  (10, 'Feeder', 'Jenkins');

INSERT INTO Enclosure (id, EnclosureType, Size, CostNoDiscount, CostWithDiscount, AgeLimit, DiscountAge)
VALUES
  (1, 'Land', 987.45, 15.5, 8.75, 0, 6),
  (2, 'Land', 1520.4, 22.0, 13.5, 18, 18),
  (3, 'Land', 2511.3, 30.0, 16.8, 21, 22),
  (4, 'Land', 1240.8, 23.2, 14.7, 21, 21),
  (5, 'Land', 1050.4, 26.6, 15.0, 12, 13),
  (6, 'Aerial', 1403.7, 28.5, 16.4, 12, 12),
  (7, 'Aerial', 1508.62, 29.5, 15.5, 12, 12),
  (8, 'Water', 1020.11, 19.5, 16.3, 0, 5),
  (9, 'Water', 1256.47, 27.3, 12.2, 21, 24),
  (10, 'Water', 2200.55, 22.5, 14.8, 18, 24);

INSERT INTO Dinosaur(id, Name, Species, Enclosure)
VALUES
  (1, 'Joe', 'Velociraptor', 2),
  (2, 'Tom', 'Velociraptor', 2),
  (3, 'Bobby', 'T-Rex', 3),
  (4, 'Red', 'Iguanodon', 1),
  (5, 'Rexy', 'T-Rex', 4),
  (6, 'Samantha', 'Mososaurus', 8),
  (7, 'Joey', 'Pterodactyl', 6),
  (8, 'Pug', 'Pterodactyl', 7),
  (9, 'Benjamin', 'Velociraptor', 4),
  (10, 'Kyle', 'Ankylosaurus', 4),
  (11, 'Jason', 'Mososaurus', 9),
  (12, 'Sam', 'Mososaurus', 10);

INSERT INTO Facility(id, FacilityType)
VALUES
  (1, 'General'),
  (2, 'Restaurant'),
  (3, 'Restroom'),
  (4, 'Shop'),
  (5, 'Observatory'),
  (6, 'Observatory'),
  (7, 'Hotel');

INSERT INTO _RegisteredVisitor(id, Name, Surname, Birthday)
VALUES
  (1, 'John', 'Lee', '1957-01-14'),
  (2, 'Tom', 'Smith', '2000-11-27'),
  (3, 'Sarah', 'Johanson', '1994-03-09'),
  (4, 'Anna', 'Smith', '1992-05-08'),
  (5, 'Charles', 'Winston', '2005-08-19'),
  (6, 'Samantha', 'Burn', '1952-06-01'),
  (7, 'Joey', 'Salads', '1987-06-18'),
  (8, 'Peter', 'Parns', '1978-05-15'),
  (9, 'Billy', 'Bob', '2015-02-21'),
  (10, 'Britney', 'Monson', '1945-09-13'),
  (11, 'John', 'Lee', '1986-06-25');

INSERT INTO WorkerKeepsCleanEnclosure(WorkerId, EnclosureId)
VALUES
  (2, 1),
  (2, 5),
  (2, 7),
  (1, 2),
  (1, 3),
  (3, 4),
  (3, 2),
  (3, 6),
  (3, 8),
  (4, 9),
  (4, 5);

INSERT INTO WorkerLooksAfterDinosaur(WorkerId, DinosaurId)
VALUES
  (4, 12),
  (5, 1),
  (5, 6),
  (5, 8),
  (6, 5),
  (7, 6),
  (8, 8),
  (9, 2),
  (10, 3);

INSERT INTO _Visit(id, Date, TicketType, CitizenId)
VALUES
  (1, '2018-12-03', 'Child', 9),
  (2, '2018-12-03', 'Adult', 7),
  (3, '2018-12-05', 'Adult', 8),
  (4, '2018-12-05', 'Senior', 1),
  (5, '2018-12-05', 'Adult', 4);

INSERT INTO VisitBuysTicketEnclosure(VisitId, EnclosureId, TicketCost)
VALUES
  (2, 9, 27.3),
  (1, 1, 8.75),
  (5, 3, 30.0);

INSERT INTO VisitUsesFacility(MoneySpent, VisitId, FacilityId)
VALUES
  (35.4, 3, 2),
  (0.5, 3, 3),
  (21.6, 2, 2),
  (5.0, 1, 5),
  (120.0, 4, 7),
  (27.5, 2, 4);