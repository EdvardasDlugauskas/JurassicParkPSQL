CREATE VIEW RegisteredVisitor
  AS SELECT *, AGE(Birthday) AS Age
  FROM _RegisteredVisitor;


-- TODO check if this view works correctly
CREATE VIEW Visit
  AS SELECT _Visit.*, visitFacility.spent +  visitEnclosure.spent as MoneySpent
  FROM _Visit
       INNER JOIN (SELECT VisitId, SUM(MoneySpent) as spent FROM VisitUsesFacility GROUP BY VisitId)
          visitFacility on _Visit.id = visitFacility.VisitId
       INNER JOIN (SELECT VisitId, SUM(TicketCost) as spent FROM VisitBuysTicketEnclosure GROUP BY VisitId)
          visitEnclosure on _Visit.id = visitEnclosure.VisitId;