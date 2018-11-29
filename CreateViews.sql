CREATE VIEW RegisteredVisitor
  AS SELECT *, AGE(Birthday) AS Age, Name + ' ' + Surname AS Fullname
  FROM _RegisteredVisitor;

CREATE VIEW DinosaursJonasLooksAfter
  AS SELECT *
  FROM WorkerLooksAfterDinosaur
  WHERE WorkerId = 1 -- Jonas' ID
  WITH CHECK OPTION; -- galima keist tik Jono santykius su dinozaurais

CREATE VIEW VisitorMoneySpentOnFacilites
  AS SELECT VisitId, SUM(MoneySpent) AS MoneySpent
  FROM VisitUsesFacility GROUP BY VisitId;

CREATE VIEW VisitorMoneySpentOnTickets
  AS SELECT VisitId, SUM(TicketCost) as TicketTotal
  FROM VisitBuysTicketEnclosure GROUP BY VisitId;


-- TODO check if this view works correctly
CREATE VIEW Visit
  AS SELECT _Visit.*,
       VisitorMoneySpentOnFacilites.MoneySpent + VisitorMoneySpentOnTickets.TicketTotal AS MoneySpent
  FROM _Visit
  INNER JOIN VisitorMoneySpentOnFacilites ON _Visit.id = VisitorMoneySpentOnFacilites.VisitId
  INNER JOIN VisitorMoneySpentOnTickets ON _Visit.id = VisitorMoneySpentOnTickets.VisitId;

-- CREATE VIEW Visit
--   AS SELECT _Visit.*, visitFacility.spent +  visitEnclosure.spent as MoneySpent
--   FROM _Visit
--        INNER JOIN (SELECT VisitId, SUM(MoneySpent) as spent FROM VisitUsesFacility GROUP BY VisitId)
--           visitFacility on _Visit.id = visitFacility.VisitId
--        INNER JOIN (SELECT VisitId, SUM(TicketCost) as spent FROM VisitBuysTicketEnclosure GROUP BY VisitId)
--           visitEnclosure on _Visit.id = visitEnclosure.VisitId;
