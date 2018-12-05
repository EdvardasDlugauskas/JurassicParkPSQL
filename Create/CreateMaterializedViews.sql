-- CREATE MVL

CREATE MATERIALIZED VIEW
  FacilityReport(Facility, VisitorsCount, MoneyEarned)
  AS SELECT FacilityId, COUNT(VisitId), SUM(MoneySpent)
    FROM VisitUsesFacility
    GROUP BY FacilityId
  WITH NO DATA;


CREATE MATERIALIZED VIEW
  DinosaurSpecies(DinosaurSpecies)
  AS SELECT DISTINCT Species
    FROM Dinosaur
  WITH DATA;

-- REFRESH MVL

REFRESH MATERIALIZED VIEW FacilityReport;

REFRESH MATERIALIZED VIEW DinosaurSpecies;