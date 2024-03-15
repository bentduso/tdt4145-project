SELECT DISTINCT tp.name AS theater_play_name,
                p.name  AS actor_name,
                r.name  AS role_name
FROM performer p
         INNER JOIN played_by pb
                    ON p.performer_id = pb.performer_id
         INNER JOIN role r
                    ON pb.role_id = r.role_id
         INNER JOIN plays_act pa
                    ON r.role_id = pa.role_id
         INNER JOIN theater_play tp
                    ON pa.theater_play_id = tp.theater_play_id;