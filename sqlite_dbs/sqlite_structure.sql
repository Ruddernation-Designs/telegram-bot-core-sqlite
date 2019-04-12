CREATE TABLE IF NOT EXISTS `user` (
  `id` bigint,
  `is_bot` tinyint(1) DEFAULT 0,
  `first_name` CHAR(255) NOT NULL DEFAULT '',
  `last_name` CHAR(255) DEFAULT NULL,
  `username` CHAR(191) DEFAULT NULL,
  `language_code` CHAR(10) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,

  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `chat` (
  `id` bigint,
  `type` TEXT CHECK( `type` IN ('private', 'group', 'supergroup', 'channel') ) NOT NULL DEFAULT 'private',
  `title` CHAR(255) DEFAULT '',
  `username` CHAR(255) DEFAULT NULL,
  `all_members_are_administrators` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `old_id` bigint DEFAULT NULL,

  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `user_chat` (
  `user_id` bigint,
  `chat_id` bigint,

  PRIMARY KEY (`user_id`, `chat_id`),

  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`chat_id`) REFERENCES `chat` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS `inline_query` (
  `id` bigint UNSIGNED,
  `user_id` bigint NULL,
  `location` CHAR(255) NULL DEFAULT NULL,
  `query` TEXT NOT NULL,
  `offset` CHAR(255) NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,

  PRIMARY KEY (`id`),

  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
);

CREATE TABLE IF NOT EXISTS `chosen_inline_result` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  `result_id` CHAR(255) NOT NULL DEFAULT '',
  `user_id` bigint NULL,
  `location` CHAR(255) NULL DEFAULT NULL,
  `inline_message_id` CHAR(255) NULL DEFAULT NULL,
  `query` TEXT NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,

  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
);

CREATE TABLE IF NOT EXISTS `message` (
  `chat_id` bigint,
  `id` bigint UNSIGNED,
  `user_id` bigint NULL,
  `date` timestamp NULL DEFAULT NULL,
  `forward_from` bigint NULL DEFAULT NULL,
  `forward_from_chat` bigint NULL DEFAULT NULL,
  `forward_from_message_id` bigint NULL DEFAULT NULL,
  `forward_date` timestamp NULL DEFAULT NULL,
  `reply_to_chat` bigint NULL DEFAULT NULL,
  `reply_to_message` bigint UNSIGNED DEFAULT NULL,
  `media_group_id` TEXT,
  `text` TEXT,
  `entities` TEXT,
  `audio` TEXT,
  `document` TEXT,
  `animation` TEXT,
  `game` TEXT,
  `photo` TEXT,
  `sticker` TEXT,
  `video` TEXT,
  `voice` TEXT,
  `video_note` TEXT,
  `contact` TEXT,
  `location` TEXT,
  `venue` TEXT,
  `caption` TEXT,
  `new_chat_members` TEXT,
  `left_chat_member` bigint NULL DEFAULT NULL,
  `new_chat_title` CHAR(255) DEFAULT NULL,
  `new_chat_photo` TEXT,
  `delete_chat_photo` tinyint(1) DEFAULT 0,
  `group_chat_created` tinyint(1) DEFAULT 0,
  `supergroup_chat_created` tinyint(1) DEFAULT 0,
  `channel_chat_created` tinyint(1) DEFAULT 0,
  `migrate_to_chat_id` bigint NULL DEFAULT NULL,
  `migrate_from_chat_id` bigint NULL DEFAULT NULL,
  `pinned_message` TEXT NULL,
  `connected_website` TEXT NULL,
  `passport_data` TEXT NULL,

  PRIMARY KEY (`chat_id`, `id`),

  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  FOREIGN KEY (`chat_id`) REFERENCES `chat` (`id`),
  FOREIGN KEY (`forward_from`) REFERENCES `user` (`id`),
  FOREIGN KEY (`forward_from_chat`) REFERENCES `chat` (`id`),
  FOREIGN KEY (`reply_to_chat`, `reply_to_message`) REFERENCES `message` (`chat_id`, `id`),
  FOREIGN KEY (`forward_from`) REFERENCES `user` (`id`),
  FOREIGN KEY (`left_chat_member`) REFERENCES `user` (`id`)
);

CREATE TABLE IF NOT EXISTS `callback_query` (
  `id` bigint UNSIGNED,
  `user_id` bigint NULL,
  `chat_id` bigint NULL,
  `message_id` bigint UNSIGNED,
  `inline_message_id` CHAR(255) NULL DEFAULT NULL,
  `data` CHAR(255) NOT NULL DEFAULT '',
  `created_at` timestamp NULL DEFAULT NULL,

  PRIMARY KEY (`id`),

  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  FOREIGN KEY (`chat_id`, `message_id`) REFERENCES `message` (`chat_id`, `id`)
);

CREATE TABLE IF NOT EXISTS `edited_message` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  `chat_id` bigint,
  `message_id` bigint UNSIGNED,
  `user_id` bigint NULL,
  `edit_date` timestamp NULL DEFAULT NULL,
  `text` TEXT,
  `entities` TEXT,
  `caption` TEXT,

  FOREIGN KEY (`chat_id`) REFERENCES `chat` (`id`),
  FOREIGN KEY (`chat_id`, `message_id`) REFERENCES `message` (`chat_id`, `id`),
  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
);

CREATE TABLE IF NOT EXISTS `telegram_update` (
  `id` UNSIGNED INTEGER,
  `chat_id` bigint NULL DEFAULT NULL,
  `message_id` bigint UNSIGNED DEFAULT NULL,
  `inline_query_id` bigint UNSIGNED DEFAULT NULL,
  `chosen_inline_result_id` bigint UNSIGNED DEFAULT NULL,
  `callback_query_id` bigint UNSIGNED DEFAULT NULL,
  `edited_message_id` bigint UNSIGNED DEFAULT NULL,

  PRIMARY KEY (`id`),

  FOREIGN KEY (`chat_id`, `message_id`) REFERENCES `message` (`chat_id`, `id`),
  FOREIGN KEY (`inline_query_id`) REFERENCES `inline_query` (`id`),
  FOREIGN KEY (`chosen_inline_result_id`) REFERENCES `chosen_inline_result` (`id`),
  FOREIGN KEY (`callback_query_id`) REFERENCES `callback_query` (`id`),
  FOREIGN KEY (`edited_message_id`) REFERENCES `edited_message` (`id`)
);

CREATE TABLE IF NOT EXISTS `conversation` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  `user_id` bigint NULL DEFAULT NULL,
  `chat_id` bigint NULL DEFAULT NULL,
  `status` TEXT CHECK( `status` IN ('active', 'cancelled', 'stopped') ) NOT NULL DEFAULT 'active',
  `command` varchar(160) DEFAULT '',
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,

  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  FOREIGN KEY (`chat_id`) REFERENCES `chat` (`id`)
);

CREATE TABLE IF NOT EXISTS `botan_shortener` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  `user_id` bigint NULL DEFAULT NULL,
  `url` text NOT NULL,
  `short_url` CHAR(255) NOT NULL DEFAULT '',
  `created_at` timestamp NULL DEFAULT NULL,

  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
);

CREATE TABLE IF NOT EXISTS `request_limiter` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  `chat_id` char(255) NULL DEFAULT NULL,
  `inline_message_id` char(255) NULL DEFAULT NULL,
  `method` char(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL
);
