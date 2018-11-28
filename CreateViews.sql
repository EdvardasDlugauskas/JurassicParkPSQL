CREATE VIEW VisitorAge
  AS SELECT *, AGE(Birthday) AS Age
  FROM RegisteredVisitor;

CREATE VIEW 