SELECT DISTINCT tp.name AS performance_name, 
                COUNT(t.ticket_id) AS sold_tickets
FROM theater_play tp
         LEFT JOIN show s
                    ON tp.theater_play_id = s.theater_play_id
         LEFT JOIN ticket_transaction tt
                    ON s.show_date = tt.show_date AND tp.theater_play_id = tt.theater_play_id
         LEFT JOIN ticket t
                    ON tt.transaction_id = t.transaction_id
WHERE s.show_date = '2024-02-12'
GROUP BY tp.theater_play_id