CREATE OR REPLACE FUNCTION seeded_random(seed TEXT)
RETURNS DOUBLE PRECISION AS $$
DECLARE 
   hash TEXT;
   num BIGINT;
BEGIN
   hash := md5(seed);
   num := ('x' || substr(hash, 1, 16))::bit(64)::bigint;
   RETURN abs(num) / 9223372036854775807.0;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION seeded_random_range(
 seed TEXT,
 min_val INT,
 max_val INT
)
RETURNS INT AS $$
DECLARE 
    r DOUBLE PRECISION;
BEGIN
    r := seeded_random(seed);
    RETURN floor(min_val + r * (max_val - min_val + 1))::INT;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION generate_user(
    p_seed TEXT,
    p_locale TEXT,
    p_batch INT,
    p_row INT
)
RETURNS TABLE (
    full_name TEXT,
    address TEXT,
    email TEXT,
    phone TEXT,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    height INT,
    eye_color TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
    (CASE 
        WHEN seeded_random(p_seed || p_locale || p_batch || p_row || 'use_title') > 0.5
        THEN (SELECT title FROM titles
              WHERE locale = p_locale
              ORDER BY seeded_random(p_seed || p_locale || p_batch || p_row || id)
              LIMIT 1) || ' '
        ELSE '' 
     END)
    ||
    (SELECT name FROM names
     WHERE locale = p_locale
     ORDER BY seeded_random(p_seed || p_locale || p_batch || p_row || id)
     LIMIT 1)
    || ' ' ||
    (SELECT surname FROM surnames
     WHERE locale = p_locale
     ORDER BY seeded_random(p_seed || p_locale || p_batch || p_row || id)
     LIMIT 1),
    (SELECT street FROM streets
     WHERE locale = p_locale
     ORDER BY seeded_random(p_seed || p_locale || p_batch || p_row || id)
     LIMIT 1)
    || ' ' ||
    seeded_random_range(p_seed || p_locale || p_batch || p_row || 'house', 1, 200)
    || ', ' ||
    (SELECT city FROM cities
     WHERE locale = p_locale
     ORDER BY seeded_random(p_seed || p_locale || p_batch || p_row || id)
     LIMIT 1),
    lower(
        (SELECT name FROM names WHERE locale=p_locale
         ORDER BY seeded_random(p_seed || p_locale || p_batch || p_row || id) LIMIT 1)
        || '.' ||
        (SELECT surname FROM surnames WHERE locale=p_locale
         ORDER BY seeded_random(p_seed || p_locale || p_batch || p_row || id) LIMIT 1)
    )
    || '@' ||
    (SELECT domain FROM email_domains
     ORDER BY seeded_random(p_seed || p_locale || p_batch || p_row || id) LIMIT 1),
    (CASE 
        WHEN p_locale = 'en_US' THEN '+1'
        WHEN p_locale = 'de_DE' THEN '+49'
        ELSE '+1'
    END)
    || ' (' ||
    seeded_random_range(p_seed || p_locale || p_batch || p_row || 'p1',0,9) ||
    seeded_random_range(p_seed || p_locale || p_batch || p_row || 'p2',0,9) ||
    seeded_random_range(p_seed || p_locale || p_batch || p_row || 'p3',0,9) || ') ' ||
    seeded_random_range(p_seed || p_locale || p_batch || p_row || 'p4',0,9) ||
    seeded_random_range(p_seed || p_locale || p_batch || p_row || 'p5',0,9) ||
    seeded_random_range(p_seed || p_locale || p_batch || p_row || 'p6',0,9) || '-' ||
    seeded_random_range(p_seed || p_locale || p_batch || p_row || 'p7',0,9) ||
    seeded_random_range(p_seed || p_locale || p_batch || p_row || 'p8',0,9) ||
    seeded_random_range(p_seed || p_locale || p_batch || p_row || 'p9',0,9) ||
    seeded_random_range(p_seed || p_locale || p_batch || p_row || 'p10',0,9),
    degrees(asin(2 * seeded_random(p_seed || p_locale || p_batch || p_row || 'lat') - 1)),
    360 * seeded_random(p_seed || p_locale || p_batch || p_row || 'lon') - 180,
    GREATEST(
        140,
        LEAST(
            210,
            ROUND(
                170 + 10 * sqrt(-2 * ln(seeded_random(p_seed || p_locale || p_batch || p_row || 'h1')))
                * cos(2 * pi() * seeded_random(p_seed || p_locale || p_batch || p_row || 'h2'))
            )
        )
    )::INT,
    (SELECT color FROM eye_colors
     ORDER BY seeded_random(p_seed || p_locale || p_batch || p_row || id)
     LIMIT 1);
END;
$$ LANGUAGE plpgsql;
SELECT *
FROM generate_series(1, 10) AS gs
CROSS JOIN LATERAL generate_user('123', 'en_US', 0, gs);

