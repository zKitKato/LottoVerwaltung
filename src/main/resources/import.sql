DROP VIEW IF EXISTS ticket_union_view;
CREATE VIEW ticket_union_view AS
SELECT
    id,
    player_id,
    losnummer,
    valid_from,
    valid_until,
    total_price,
    created_at,
    'LOTTO' AS game_type
FROM tickets_lotto
UNION ALL
SELECT
    id,
    player_id,
    losnummer,
    valid_from,
    valid_until,
    total_price,
    created_at,
    'EURO' AS game_type
FROM tickets_euro;