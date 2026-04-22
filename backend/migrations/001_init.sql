CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";

CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    yandex_id VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255),
    email VARCHAR(255),
    avatar_url TEXT,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS pets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    owner_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(50), 
    breed VARCHAR(255),
    age INT,
    lost_date TIMESTAMP,
    description TEXT,
    external_signs TEXT,
    contact_phone VARCHAR(20),
    contact_name VARCHAR(255),
    image_urls TEXT[] DEFAULT ARRAY[]::TEXT[],
    latitude FLOAT8 NOT NULL,
    longitude FLOAT8 NOT NULL,
    address VARCHAR(500),
    status VARCHAR(50) DEFAULT 'lost',
    location GEOGRAPHY(POINT, 4326),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION update_pet_location()
RETURNS TRIGGER AS $$
BEGIN
    NEW.location := ST_GeogFromText('POINT(' || NEW.longitude || ' ' || NEW.latitude || ')');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER pet_location_trigger
BEFORE INSERT OR UPDATE ON pets
FOR EACH ROW
EXECUTE FUNCTION update_pet_location();

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
        ST_DWithin(
            p.location,
            ST_GeogFromText('POINT(' || lon || ' ' || lat || ')'),
            radius_meters
        )
        AND (
            search_text = ''
            OR LOWER(p.name) LIKE LOWER('%' || search_text || '%')
            OR LOWER(p.type) LIKE LOWER('%' || search_text || '%')
            OR LOWER(p.breed) LIKE LOWER('%' || search_text || '%')
        )
    ORDER BY p.created_at DESC;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE IF NOT EXISTS sightings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pet_id UUID NOT NULL REFERENCES pets(id) ON DELETE CASCADE,
    reporter_id UUID REFERENCES users(id) ON DELETE SET NULL,
    latitude FLOAT8 NOT NULL,
    longitude FLOAT8 NOT NULL,
    address VARCHAR(500),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pet_id UUID NOT NULL REFERENCES pets(id) ON DELETE CASCADE,
    sender_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    recipient_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    text TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_pets_owner_id ON pets(owner_id);
CREATE INDEX IF NOT EXISTS idx_pets_status ON pets(status);
CREATE INDEX IF NOT EXISTS idx_pets_location ON pets USING GIST(location);
CREATE INDEX IF NOT EXISTS idx_sightings_pet_id ON sightings(pet_id);
CREATE INDEX IF NOT EXISTS idx_sightings_reporter_id ON sightings(reporter_id);
CREATE INDEX IF NOT EXISTS idx_messages_pet_id ON messages(pet_id);
CREATE INDEX IF NOT EXISTS idx_messages_sender_id ON messages(sender_id);
CREATE INDEX IF NOT EXISTS idx_messages_recipient_id ON messages(recipient_id);
CREATE INDEX IF NOT EXISTS idx_messages_created_at ON messages(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_users_yandex_id ON users(yandex_id);
