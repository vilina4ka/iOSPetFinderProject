ALTER TABLE messages
    ADD COLUMN IF NOT EXISTS sighting_id UUID REFERENCES sightings(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_messages_sighting_id ON messages(sighting_id);
