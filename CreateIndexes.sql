CREATE UNIQUE INDEX DinosaurNames
  ON Dinosaur(Name);

CREATE INDEX WorkerInfo
  ON Worker(Specialty, Surname);

CREATE INDEX EnclosureInfo
  ON Enclosure(EnclosureType, Size);

CREATE INDEX FacilityTypes
  ON Facility(FacilityType);