-- Event Manager Database Seed Data
-- Run this after the tables are created

-- Insert Sample Events
INSERT INTO Events (title, description, organizer, category, dateTime, location, price, imageUrl, rating, attendees, duration, difficulty, tags)
VALUES 
  ('Synthwave Nights', 'A retro synthwave party with live DJ sets and neon visuals. Dance the night away with cutting-edge synthesizer music and immersive light shows.', 'Neon Beats', 'Music', DATEADD(day, 4, CAST(CONVERT(varchar(10), GETDATE(), 23) as datetime)), 'Downtown Club, New York', 29.99, 'https://images.unsplash.com/photo-1506152983158-2c6b2a6e2b1c?w=800&q=80', 4.8, 324, '4 hours', 'All Ages', '["Music", "Party", "Live DJ", "Nightlife"]'),
  
  ('Flutter Forward', 'An immersive Flutter conference with workshops and talks. Learn from industry experts about the latest trends in mobile development.', 'DevCon', 'Tech', DATEADD(day, 10, CAST(CONVERT(varchar(10), GETDATE(), 23) as datetime)), 'Convention Center, San Francisco', 99.0, 'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?w=800&q=80', 4.7, 1250, '2 days', 'Intermediate', '["Flutter", "Mobile Dev", "Workshop", "Networking"]'),
  
  ('City Marathon', 'Join thousands for a city-wide marathon and fun run. Support local charities while staying fit.', 'RunCity', 'Sports', DATEADD(day, 20, CAST(CONVERT(varchar(10), GETDATE(), 23) as datetime)), 'Riverside Park, Boston', 15.0, 'https://images.unsplash.com/photo-1477904135755-6a4a6c9b9d8b?w=800&q=80', 4.6, 5000, '3 hours', 'Intermediate', '["Marathon", "Running", "Charity", "Fitness"]'),
  
  ('Creative Writing Workshop', 'Hands-on workshop to sharpen your storytelling skills. Learn from award-winning authors.', 'Wordsmiths', 'Workshop', DATEADD(day, 7, CAST(CONVERT(varchar(10), GETDATE(), 23) as datetime)), 'Studio 12, Austin', 49.0, 'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=800&q=80', 4.9, 42, '4 hours', 'Beginner', '["Writing", "Workshop", "Creative", "Learning"]'),
  
  ('Web3 Summit', 'Deep dive into blockchain, NFTs, and decentralized applications. Network with industry leaders.', 'CryptoElite', 'Tech', DATEADD(day, 15, CAST(CONVERT(varchar(10), GETDATE(), 23) as datetime)), 'Tech Hub, Dubai', 149.0, 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=800&q=80', 4.4, 800, '1 day', 'Advanced', '["Blockchain", "Crypto", "Web3", "Summit"]'),
  
  ('Jazz Evening Gala', 'Elegant evening of live jazz performances with world-class musicians.', 'Jazz Society', 'Music', DATEADD(day, 6, CAST(CONVERT(varchar(10), GETDATE(), 23) as datetime)), 'Grand Theatre, Chicago', 45.0, 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800&q=80', 4.9, 320, '3 hours', 'All Ages', '["Jazz", "Music", "Live Performance", "Elegant"]'),
  
  ('AI & Machine Learning Summit', 'Explore cutting-edge AI applications and machine learning breakthroughs with leading researchers.', 'Tech Leaders', 'Tech', DATEADD(day, 12, CAST(CONVERT(varchar(10), GETDATE(), 23) as datetime)), 'Innovation Hub, Seattle', 129.0, 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800&q=80', 4.7, 950, '2 days', 'Advanced', '["AI", "Machine Learning", "Tech", "Research"]'),
  
  ('Rock Concert Festival', 'Three days of non-stop rock music with legendary bands and emerging artists.', 'Live Events Co', 'Music', DATEADD(day, 30, CAST(CONVERT(varchar(10), GETDATE(), 23) as datetime)), 'Open Air Stadium, Los Angeles', 65.0, 'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?w=800&q=80', 4.8, 12000, '3 days', 'All Ages', '["Rock", "Music Festival", "Live Performance", "Weekend"]'),
  
  ('Yoga & Wellness Retreat', 'Rejuvenate with yoga, meditation, and wellness sessions in a serene mountain setting.', 'Zen Living', 'Workshop', DATEADD(day, 14, CAST(CONVERT(varchar(10), GETDATE(), 23) as datetime)), 'Mountain Resort, Colorado', 199.0, 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800&q=80', 4.9, 150, '3 days', 'Beginner', '["Yoga", "Wellness", "Retreat", "Health"]'),
  
  ('Basketball Championship', 'Watch the ultimate basketball championship with the best teams competing.', 'NBA Events', 'Sports', DATEADD(day, 25, CAST(CONVERT(varchar(10), GETDATE(), 23) as datetime)), 'Sports Arena, Miami', 85.0, 'https://images.unsplash.com/photo-1546519638-68711109d298?w=800&q=80', 4.7, 8500, '4 hours', 'All Ages', '["Basketball", "Sports", "Championship", "Live"]');

-- Insert Sample Users
INSERT INTO Users (name, email, password, phone)
VALUES 
  ('Jane Doe', 'jane@example.com', '$2a$10$9Td5qM8L7pL5F8K3N9Z8X.eV3L5Q9Z8X1C5M9K3L5F8E1D5A8B7C6', '+1234567890'),
  ('John Smith', 'john@example.com', '$2a$10$9Td5qM8L7pL5F8K3N9Z8X.eV3L5Q9Z8X1C5M9K3L5F8E1D5A8B7C6', '+9876543210');

-- Insert Sample Reviews
INSERT INTO Reviews (userId, eventId, rating, comment)
VALUES 
  (1, 1, 5, 'Amazing event! The DJ was incredible and the atmosphere was perfect.'),
  (2, 2, 4, 'Great conference with useful workshops. Would attend again.'),
  (1, 3, 5, 'Well organized marathon. Looking forward to the next one!');
