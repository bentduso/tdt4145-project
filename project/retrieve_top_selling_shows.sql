SELECT tp.name, s.show_date, COUNT(*) AS sold_tickets
FROM ticket t
         INNER JOIN show s
                    ON t.show_date = s.show_date
                        AND t.theater_play_id = s.theater_play_id
         INNER JOIN theater_play tp
                    ON s.theater_play_id = tp.theater_play_id
GROUP BY tp.name, t.show_date
ORDER BY sold_tickets DESC