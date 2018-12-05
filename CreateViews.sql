CREATE VIEW RegisteredVisitor
  AS SELECT *, AGE(Birthday) AS Age, CONCAT(Name, ' ', Surname) AS Fullname
  FROM _RegisteredVisitor;

CREATE VIEW DinosaursLewisLooksAfter
  AS SELECT *
  FROM WorkerLooksAfterDinosaur
  WHERE WorkerId = 5 -- Lewis' ID
  WITH CHECK OPTION;

CREATE VIEW VisitorMoneySpentOnFacilities
  AS SELECT VisitId, SUM(MoneySpent) AS MoneySpent
  FROM VisitUsesFacility GROUP BY VisitId;

CREATE VIEW VisitorMoneySpentOnTickets
  AS SELECT VisitId, SUM(TicketCost) as TicketTotal
  FROM VisitBuysTicketEnclosure GROUP BY VisitId;

CREATE VIEW Visit
  AS SELECT _Visit.*,
       COALESCE(VisitorMoneySpentOnFacilities.MoneySpent, 0) +
       COALESCE(VisitorMoneySpentOnTickets.TicketTotal, 0) AS MoneySpent
     FROM _Visit
       LEFT OUTER JOIN VisitorMoneySpentOnFacilities ON _Visit.id = VisitorMoneySpentOnFacilities.VisitId
       LEFT OUTER JOIN VisitorMoneySpentOnTickets ON _Visit.id = VisitorMoneySpentOnTickets.VisitId;

