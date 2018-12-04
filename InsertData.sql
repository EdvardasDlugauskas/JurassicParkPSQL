INSERT INTO Worker(Specialty, Surname)
VALUES
  ('Cleaner', 'Robinson'),
  ('Cleaner', 'Smith'),
  ('Cleaner', 'Jones'),
  ('Cleaner', 'Brown'),
  ('Trainer', 'Lewis'),
  ('Veterinarian', 'Allen'),
  ('Feeder', 'Bailey'),
  ('Feeder', 'Jones'),
  ('Feeder', 'Cox'),
  ('Feeder', 'Jenkins');

INSERT INTO Enclosure(EnclosureType, Size, CostNoDiscount, CostWithDiscount, AgeLimit, DiscountAge)
VALUES
  ('Land', 987.45, 15.5, 8.75, 0, 6),
  ('Land', 1520.4, 22.0, 13.5, 18, 18),
  ('Land', 2511.3, 30.0, 16.8, 21, 22),
  ('Land', 1240.8, 23.2, 14.7, 21, 21),
  ('Land', 1050.4, 26.6, 15.0, 12, 13),
  ('Aerial', 1403.7, 28.5, 16.4, 12, 12),
  ('Aerial', 1508.62, 29.5, 15.5, 12, 12),
  ('Water', 1020.11, 19.5, 16.3, 0, 5),
  ('Water', 1256.47, 27.3, 12.2, 21, 24),
  ('Water', 2200.55, 22.5, 14.8, 18, 24);

INSERT INTO Dinosaur(Name, Species, Enclosure)
VALUES
  ('Joe', 'Velociraptor', 2),
  ('Tom', 'Velociraptor', 2),
  ('Bobby', 'T-Rex', 3),
  ('Red', 'Iguanodon', 1),
  ('Rexy', 'T-Rex', 4),
  ('Samantha', 'Mososaurus', 8),
  ('Joey', 'Pterodactyl', 6),
  ('Pug', 'Pterodactyl', 7),
  ('Benjamin', 'Velociraptor', 4),
  ('Kyle', 'Ankylosaurus', 4),
  ('Jason', 'Mososaurus', 9),
  ('Sam', 'Mososaurus', 10);

INSERT INTO Facility(FacilityType)
VALUES
  ('General'),
  ('Restaurant'),
  ('Restroom'),
  ('Shop'),
  ('Observatory'),
  ('Observatory'),
  ('Hotel');

INSERT INTO _RegisteredVisitor(Name, Surname, Birthday)
VALUES
  ('John', 'Lee', '1957-01-14'),
  ('Tom', 'Smith', '2000-11-27'),
  ('Sarah', 'Johanson', '1994-03-09'),
  ('Anna', 'Smith', '1992-05-08'),
  ('Charles', 'Winston', '2005-08-19'),
  ('Samantha', 'Burn', '1952-06-01'),
  ('Joey', 'Salads', '1987-06-18'),
  ('Peter', 'Parns', '1978-05-15'),
  ('Billy', 'Bob', '2015-02-21'),
  ('Britney', 'Monson', '1945-09-13'),
  ('John', 'Lee', '1986-06-25');

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
  (4, 11),
  (5, 1),
  (5, 6),
  (5, 8),
  (6, 5),
  (7, 6),
  (8, 8),
  (9, 2),
  (10, 3);

INSERT INTO _Visit(Date, TicketType, CitizenId)
VALUES
  ('2018-12-03', 'Child', 9),
  ('2018-12-03', 'Adult', 7),
  ('2018-12-05', 'Adult', 8),
  ('2018-12-05', 'Senior', 1),
  ('2018-12-05', 'Adult', 4);

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