DROP TRIGGER SameSpeciesDino ON Dinosaur;

DROP TRIGGER WorkerLookAfterDino ON WorkerLooksAfterDinosaur;

DROP TRIGGER UpToDateTicketCost ON VisitBuysTicketEnclosure;

DROP FUNCTION IF EXISTS check_dino_species_num();

DROP FUNCTION IF EXISTS check_worker_look_after_num();

DROP FUNCTION IF EXISTS check_up_to_date_ticket_cost();