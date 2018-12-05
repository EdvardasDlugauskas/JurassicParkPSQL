DROP VIEW RegisteredVisitor;

DROP VIEW DinosaursJonasLooksAfter;

DROP VIEW Visit;

DROP VIEW VisitorMoneySpentOnFacilites;

DROP VIEW VisitorMoneySpentOnTickets;

DROP MATERIALIZED VIEW FacilityReport;

DROP MATERIALIZED VIEW DinosaurSpecies;

DROP INDEX DinosaurNames;

DROP INDEX WorkerInfo;

DROP INDEX EnclosureInfo;

DROP INDEX FacilityTypes;

DROP TRIGGER SameSpeciesDino ON Dinosaur;

DROP TRIGGER WorkerLookAfterDino ON WorkerLooksAfterDinosaur;

DROP TRIGGER UpToDateTicketCost ON VisitBuysTicketEnclosure;

DROP TRIGGER VisitorAgeLimit ON VisitBuysTicketEnclosure;

DROP FUNCTION IF EXISTS check_dino_species_num();

DROP FUNCTION IF EXISTS check_worker_look_after_num();

DROP FUNCTION IF EXISTS check_up_to_date_ticket_cost();

DROP FUNCTION IF EXISTS check_is_eligible_to_buy_ticket();

DROP TABLE WorkerKeepsCleanEnclosure;

DROP TABLE WorkerLooksAfterDinosaur;

DROP TABLE VisitBuysTicketEnclosure;

DROP TABLE VisitUsesFacility;

DROP TABLE Worker;

DROP TABLE Dinosaur;

DROP TABLE Enclosure;

DROP TABLE Facility CASCADE;

DROP TABLE _Visit CASCADE;

DROP TABLE _RegisteredVisitor CASCADE;