-- =============================================================
-- Konekta Database Schema
-- MySQL 8.0+
-- =============================================================

DROP DATABASE IF EXISTS konekta;
CREATE DATABASE konekta CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE konekta;

-- -------------------------------------------------------------
-- Table: users
-- -------------------------------------------------------------
CREATE TABLE users (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name            VARCHAR(120)    NOT NULL,
    email           VARCHAR(180)    NOT NULL,
    password_hash   VARCHAR(255)    NOT NULL,
    role            ENUM('influencer','brand') NOT NULL,
    avatar_url      VARCHAR(500)    NULL,
    is_verified     TINYINT(1)      NOT NULL DEFAULT 0,
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_users_email (email)
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- Table: influencer_profiles
-- -------------------------------------------------------------
CREATE TABLE influencer_profiles (
    user_id          BIGINT UNSIGNED NOT NULL,
    username         VARCHAR(80)     NOT NULL,
    bio              VARCHAR(500)    NULL,
    niche            VARCHAR(120)    NULL,
    industry         VARCHAR(120)    NULL,
    location         VARCHAR(120)    NULL,
    tiktok_account   VARCHAR(120)    NULL,
    instagram_handle VARCHAR(120)    NULL,
    youtube_handle   VARCHAR(120)    NULL,
    followers_count  INT UNSIGNED    NOT NULL DEFAULT 0,
    engagement_rate  DECIMAL(5,2)    NOT NULL DEFAULT 0.00,
    rate_card        DECIMAL(15,2)   NOT NULL DEFAULT 0.00,
    media_kit_url    VARCHAR(500)    NULL,
    payout_bank      VARCHAR(80)     NULL,
    payout_account   VARCHAR(40)     NULL,
    created_at       TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id),
    UNIQUE KEY uk_influencer_username (username),
    CONSTRAINT fk_influencer_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- Table: brand_profiles
-- -------------------------------------------------------------
CREATE TABLE brand_profiles (
    user_id         BIGINT UNSIGNED NOT NULL,
    brand_name      VARCHAR(120)    NOT NULL,
    description     VARCHAR(500)    NULL,
    industry        VARCHAR(120)    NULL,
    website         VARCHAR(255)    NULL,
    location        VARCHAR(120)    NULL,
    logo_url        VARCHAR(500)    NULL,
    plan            ENUM('free','pro_monthly','pro_annual') NOT NULL DEFAULT 'free',
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id),
    CONSTRAINT fk_brand_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- Table: social_media_accounts
-- -------------------------------------------------------------
CREATE TABLE social_media_accounts (
    id                BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    influencer_user_id BIGINT UNSIGNED NOT NULL,
    platform          ENUM('instagram','tiktok','youtube','twitter','facebook','other') NOT NULL,
    handle            VARCHAR(120)    NOT NULL,
    followers_count   INT UNSIGNED    NOT NULL DEFAULT 0,
    engagement_rate   DECIMAL(5,2)    NOT NULL DEFAULT 0.00,
    created_at        TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_sm_influencer (influencer_user_id),
    CONSTRAINT fk_sm_influencer FOREIGN KEY (influencer_user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- Table: offers (campaigns)
-- -------------------------------------------------------------
CREATE TABLE offers (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    brand_user_id       BIGINT UNSIGNED NOT NULL,
    influencer_user_id  BIGINT UNSIGNED NOT NULL,
    title               VARCHAR(180)    NOT NULL,
    brief               TEXT            NULL,
    budget              DECIMAL(15,2)   NOT NULL DEFAULT 0.00,
    reward_per_creator  DECIMAL(15,2)   NOT NULL DEFAULT 0.00,
    target_views        INT UNSIGNED    NOT NULL DEFAULT 0,
    target_likes        INT UNSIGNED    NOT NULL DEFAULT 0,
    target_shares       INT UNSIGNED    NOT NULL DEFAULT 0,
    deliverables         TEXT            NULL,
    requirements        TEXT            NULL,
    target_audience     VARCHAR(255)    NULL,
    deadline            DATE            NULL,
    room_code           VARCHAR(40)     NULL,
    status              ENUM('draft','open','offered','negotiation','accepted','in_progress','submitted','completed','rejected','cancelled') NOT NULL DEFAULT 'open',
    is_public           TINYINT(1)      NOT NULL DEFAULT 1,
    created_at          TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_offers_brand (brand_user_id),
    KEY idx_offers_influencer (influencer_user_id),
    KEY idx_offers_status (status),
    CONSTRAINT fk_offers_brand FOREIGN KEY (brand_user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_offers_influencer FOREIGN KEY (influencer_user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- Table: campaign_applicants
-- -------------------------------------------------------------
CREATE TABLE campaign_applicants (
    id                 BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    offer_id           BIGINT UNSIGNED NOT NULL,
    influencer_user_id BIGINT UNSIGNED NOT NULL,
    status             ENUM('pending','approved','rejected','completed') NOT NULL DEFAULT 'pending',
    progress           INT UNSIGNED    NOT NULL DEFAULT 0,
    views              INT UNSIGNED    NOT NULL DEFAULT 0,
    likes              INT UNSIGNED    NOT NULL DEFAULT 0,
    shares             INT UNSIGNED    NOT NULL DEFAULT 0,
    created_at         TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at         TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_apply (offer_id, influencer_user_id),
    KEY idx_apply_influencer (influencer_user_id),
    CONSTRAINT fk_apply_offer FOREIGN KEY (offer_id) REFERENCES offers(id) ON DELETE CASCADE,
    CONSTRAINT fk_apply_influencer FOREIGN KEY (influencer_user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- Table: conversations
-- -------------------------------------------------------------
CREATE TABLE conversations (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_a_id       BIGINT UNSIGNED NOT NULL,
    user_b_id       BIGINT UNSIGNED NOT NULL,
    offer_id        BIGINT UNSIGNED NULL,
    last_message_at TIMESTAMP       NULL,
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_conv_pair (user_a_id, user_b_id, offer_id),
    KEY idx_conv_user_a (user_a_id),
    KEY idx_conv_user_b (user_b_id),
    CONSTRAINT fk_conv_a FOREIGN KEY (user_a_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_conv_b FOREIGN KEY (user_b_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_conv_offer FOREIGN KEY (offer_id) REFERENCES offers(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- Table: messages
-- -------------------------------------------------------------
CREATE TABLE messages (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    conversation_id BIGINT UNSIGNED NOT NULL,
    sender_user_id  BIGINT UNSIGNED NOT NULL,
    message_text    TEXT            NOT NULL,
    attachment_url  VARCHAR(500)    NULL,
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_msg_conv (conversation_id),
    CONSTRAINT fk_msg_conv FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE,
    CONSTRAINT fk_msg_sender FOREIGN KEY (sender_user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- Table: notifications
-- -------------------------------------------------------------
CREATE TABLE notifications (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id     BIGINT UNSIGNED NOT NULL,
    type        VARCHAR(60)     NOT NULL,
    title       VARCHAR(180)    NOT NULL,
    body        VARCHAR(500)    NULL,
    icon        VARCHAR(40)     NULL,
    read_status TINYINT(1)      NOT NULL DEFAULT 0,
    created_at  TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_notif_user (user_id),
    CONSTRAINT fk_notif_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- Table: earnings
-- -------------------------------------------------------------
CREATE TABLE earnings (
    id                 BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    influencer_user_id BIGINT UNSIGNED NOT NULL,
    offer_id           BIGINT UNSIGNED NULL,
    description        VARCHAR(255)    NOT NULL,
    amount             DECIMAL(15,2)   NOT NULL,
    created_at         TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_earn_influencer (influencer_user_id),
    CONSTRAINT fk_earn_influencer FOREIGN KEY (influencer_user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- Seed data
-- -------------------------------------------------------------
-- password is "password123" hashed with bcrypt
-- $2b$10$wH8QH4kH2QYr1z1bQ3v6E.W0J2eRk6l8aJZ1qE0H5w3W1K5z8V4qe
INSERT INTO users (name, email, password_hash, role) VALUES
('Ava Creator',  'ava@konekta_mobile_app.test',  '$2b$10$wH8QH4kH2QYr1z1bQ3v6E.W0J2eRk6l8aJZ1qE0H5w3W1K5z8V4qe', 'influencer'),
('Leo Lifestyle','leo@konekta_mobile_app.test',  '$2b$10$wH8QH4kH2QYr1z1bQ3v6E.W0J2eRk6l8aJZ1qE0H5w3W1K5z8V4qe', 'influencer'),
('Maya Beauty',  'maya@konekta_mobile_app.test', '$2b$10$wH8QH4kH2QYr1z1bQ3v6E.W0J2eRk6l8aJZ1qE0H5w3W1K5z8V4qe', 'influencer'),
('Kopi Susu Co.','brand1@konekta_mobile_app.test','$2b$10$wH8QH4kH2QYr1z1bQ3v6E.W0J2eRk6l8aJZ1qE0H5w3W1K5z8V4qe', 'brand'),
('Aula Skincare','brand2@konekta_mobile_app.test','$2b$10$wH8QH4kH2QYr1z1bQ3v6E.W0J2eRk6l8aJZ1qE0H5w3W1K5z8V4qe', 'brand'),
('NBA Indonesia','brand3@konekta_mobile_app.test','$2b$10$wH8QH4kH2QYr1z1bQ3v6E.W0J2eRk6l8aJZ1qE0H5w3W1K5z8V4qe', 'brand');

INSERT INTO influencer_profiles (user_id, username, bio, niche, industry, location, tiktok_account, followers_count, engagement_rate, rate_card) VALUES
(1, 'avacreator',  'Lifestyle creator. Coffee, travel, & honest reviews.',   'Lifestyle', 'Lifestyle', 'Jakarta',  '@avacreator',  12500, 4.20, 3500000.00),
(2, 'leolifestyle','Food & lifestyle. Always open for collabs.',           'Lifestyle', 'Food',      'Bandung',  '@leolifestyle',25400, 3.20, 5000000.00),
(3, 'mayabeauty',  'Beauty content, tutorials, and honest reviews.',       'Beauty',    'Beauty',    'Surabaya', '@mayabeauty',  47800, 5.10, 7000000.00);

INSERT INTO brand_profiles (user_id, brand_name, description, industry, website, location) VALUES
(4, 'Kopi Susu Co.',  'Premium iced coffee brand looking for lifestyle creators.', 'F&B',         'kopisusu.id',    'Jakarta'),
(5, 'Aula Skincare',  'Local skincare focused on natural ingredients.',           'Beauty',      'aulaskincare.id','Bandung'),
(6, 'NBA Indonesia',  'Official NBA merchandise retailer in Indonesia.',         'Sports/Fashion','nba.id',         'Jakarta');

INSERT INTO social_media_accounts (influencer_user_id, platform, handle, followers_count, engagement_rate) VALUES
(1,'tiktok',   '@avacreator',  8500,  4.50),
(1,'instagram','@avacreator',  4000,  3.80),
(2,'tiktok',   '@leolifestyle',21000, 3.40),
(2,'instagram','@leolifestyle',4400,  2.80),
(3,'tiktok',   '@mayabeauty',  32000, 5.30),
(3,'instagram','@mayabeauty',  15800,4.90);

INSERT INTO offers (brand_user_id, influencer_user_id, title, brief, budget, reward_per_creator, target_views, target_likes, target_shares, deadline, room_code, status) VALUES
(4, 1, 'Summer Iced Latte Launch',   'Promote our new summer iced latte line. 1 TikTok video + 1 Instagram story.', 50000, 150000, 50000, 5000, 200, DATE_ADD(CURDATE(), INTERVAL 14 DAY), '2H19CDhe901', 'in_progress'),
(5, 2, 'Aula Skincare Glow Up',       'Create tutorial content using Aula Skincare products.',                        100000,100000, 100000,10000,200, DATE_ADD(CURDATE(), INTERVAL 12 DAY), 'AULAGLOW2025', 'in_progress'),
(6, 3, 'NBA Merch Drop',              'Promote the new NBA merchandise drop with a TikTok video.',                   67000, 67000,  67000, 6000, 150, DATE_ADD(CURDATE(), INTERVAL 1 DAY),  'NBAMERCH2025', 'completed');

INSERT INTO campaign_applicants (offer_id, influencer_user_id, status, progress, views, likes, shares) VALUES
(1, 1, 'approved', 78,  39000, 3900, 156),
(1, 2, 'approved', 40,  40000, 4000, 160),
(1, 3, 'completed',100,67000, 6000, 150);

INSERT INTO conversations (user_a_id, user_b_id, offer_id) VALUES
(4, 1, 1), (5, 2, 2), (6, 3, 3);

INSERT INTO messages (conversation_id, sender_user_id, message_text) VALUES
(1, 4, 'Hi! We love your recent post. We would like to discuss a potential collaboration.'),
(1, 1, 'Thanks for the update. Let me know when...'),
(2, 5, 'Sure, let me join your room campaign.'),
(3, 6, 'Hey! Are you available for a campaign?');

INSERT INTO notifications (user_id, type, title, body, icon, read_status) VALUES
(1, 'campaign_target', 'Campaign Target Success',  'Congratulations! You accomplished the target for "Kopi Susu".',   'trending_up', 0),
(1, 'message',         'New Message from Malboro',  'Hey! We loved your recent post. We would like to discuss...',     'chat',        0),
(1, 'payment',         'Payment Processed',         'Your payout of Rp125.000 for the "Tech Review" campaign...',     'payments',    1),
(1, 'verification',    'Profile Verification Complete','Your identity has been verified. You now have full access to apply.','verified',1),
(1, 'application',     'Application Accepted',      'ViewSonic has accepted your contract to join campaign...',      'task_alt',    1);

INSERT INTO earnings (influencer_user_id, offer_id, description, amount) VALUES
(1, NULL, 'Summer Tech Series', 125000.00),
(1, NULL, 'Summer Tech Series', 123000.00),
(1, NULL, 'Summer Tech Series',  99000.00);
