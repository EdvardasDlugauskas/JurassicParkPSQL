CREATE VIEW RegisteredVisitor
  AS SELECT *, AGE(Birthday) AS Age
  FROM _RegisteredVisitor;

CREATE VIEW Visit
  AS SELECT *, SUM(VF.MoneySpent) + SUM(VE.TicketCost)
  FROM _Visit, VisitUsesFacility AS VF, VisitBuysTicketEnclosure AS VE
  WHERE VF.VisitId = _Visit.id AND VE.VisitId = _Visit.id;