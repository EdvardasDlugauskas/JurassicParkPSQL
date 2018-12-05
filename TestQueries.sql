-- COLUMN CONSTRAINTS --

-- Worker specialty constraint
INSERT INTO Worker (Specialty, Surname)
VALUES ('Smeciality', 'Surname');

-- AgeLimit constraint
-- 10 is not valid age limit
INSERT INTO Enclosure (EnclosureType, Size, CostNoDiscount, CostWithDiscount, AgeLimit, DiscountAge)
VALUES ('Aerial', 1000, 15, 8, 10, 0);

-- EnclosureType constraint
INSERT INTO Enclosure (EnclosureType, Size, CostNoDiscount, CostWithDiscount, AgeLimit, DiscountAge)
VALUES ('bad type!', 1000, 15, 8, 0, 6);

-- FacilityType constraint
INSERT INTO Facility(FacilityType)
VALUES ('bad type!');

-- TRIGGER CONSTRAINTS --

-- Dinosaur trigger constraint
-- Already
INSERT INTO Dinosaur(Name, Species, Enclosure)
VALUES ('Dodo', 'Velociraptor', 2);

-- WorkerLooksAfterDinosaur trigger constraint
-- Lewis already looks after 3 dinosaurs
INSERT INTO workerlooksafterdinosaur(WorkerId, DinosaurId)
VALUES (5, 11);

-- VisitBuysTicket trigger constraint
-- 999.99 is not a ticket registered cost in enclosure
INSERT INTO VisitBuysTicketEnclosure(VisitId, EnclosureId, TicketCost)
VALUES (2, 9, 999.99);

-- VisitBuysTicket trigger constraint
-- Visitor from visit 1 is too young to visit enclosure 3
INSERT INTO VisitBuysTicketEnclosure(VisitId, EnclosureId, TicketCost)
VALUES (1, 3, 30.0);

