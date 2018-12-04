-- Worker specialty constraint
INSERT INTO Worker (Specialty, Surname)
VALUES ('Smeciality', 'Surname')

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