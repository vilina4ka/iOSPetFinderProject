CREATE OR REPLACE FUNCTION pets_in_radius(
    lat FLOAT8,
    lon FLOAT8,
    radius_meters INT DEFAULT 5000,
    search_text VARCHAR DEFAULT ''
)
RETURNS TABLE (
    id UUID,
    owner_id UUID,
    name VARCHAR,
    type VARCHAR,
    breed VARCHAR,
    age INT,
    lost_date TIMESTAMP,
    description TEXT,
    external_signs TEXT,
    contact_phone VARCHAR,
    contact_name VARCHAR,
    image_urls TEXT[],
    latitude FLOAT8,
    longitude FLOAT8,
    address VARCHAR,
    status VARCHAR,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.id, p.owner_id, p.name, p.type, p.breed, p.age, p.lost_date,
        p.description, p.external_signs, p.contact_phone, p.contact_name,
        p.image_urls, p.latitude, p.longitude, p.address, p.status,
        p.created_at, p.updated_at
    FROM pets p
    WHERE
        p.status != 'found'
        AND ST_DWithin(
            p.location,
            ST_GeogFromText('POINT(' || lon || ' ' || lat || ')'),
            radius_meters
        )
        AND (
            search_text = ''
            OR LOWER(p.name)           LIKE LOWER('%' || search_text || '%')
            OR LOWER(p.type)           LIKE LOWER('%' || search_text || '%')
            OR LOWER(p.breed)          LIKE LOWER('%' || search_text || '%')
            OR LOWER(p.description)    LIKE LOWER('%' || search_text || '%')
            OR LOWER(p.external_signs) LIKE LOWER('%' || search_text || '%')
        )
    ORDER BY p.lost_date DESC NULLS LAST, p.created_at DESC;
END;
$$ LANGUAGE plpgsql;
