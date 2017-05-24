-- MySQL dump 10.13  Distrib 5.7.18, for Linux (x86_64)
--
-- Host: localhost    Database: keystone
-- ------------------------------------------------------
-- Server version	5.7.18

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `access_token`
--

DROP TABLE IF EXISTS `access_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `access_token` (
  `id` varchar(64) NOT NULL,
  `access_secret` varchar(64) NOT NULL,
  `authorizing_user_id` varchar(64) NOT NULL,
  `project_id` varchar(64) NOT NULL,
  `role_ids` text NOT NULL,
  `consumer_id` varchar(64) NOT NULL,
  `expires_at` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_access_token_authorizing_user_id` (`authorizing_user_id`),
  KEY `ix_access_token_consumer_id` (`consumer_id`),
  CONSTRAINT `access_token_ibfk_1` FOREIGN KEY (`consumer_id`) REFERENCES `consumer` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `assignment`
--

DROP TABLE IF EXISTS `assignment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assignment` (
  `type` enum('UserProject','GroupProject','UserDomain','GroupDomain') NOT NULL,
  `actor_id` varchar(64) NOT NULL,
  `target_id` varchar(64) NOT NULL,
  `role_id` varchar(64) NOT NULL,
  `inherited` tinyint(1) NOT NULL,
  PRIMARY KEY (`type`,`actor_id`,`target_id`,`role_id`,`inherited`),
  KEY `ix_actor_id` (`actor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `config_register`
--

DROP TABLE IF EXISTS `config_register`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `config_register` (
  `type` varchar(64) NOT NULL,
  `domain_id` varchar(64) NOT NULL,
  PRIMARY KEY (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `consumer`
--

DROP TABLE IF EXISTS `consumer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `consumer` (
  `id` varchar(64) NOT NULL,
  `description` varchar(64) DEFAULT NULL,
  `secret` varchar(64) NOT NULL,
  `extra` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `credential`
--

DROP TABLE IF EXISTS `credential`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `credential` (
  `id` varchar(64) NOT NULL,
  `user_id` varchar(64) NOT NULL,
  `project_id` varchar(64) DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  `extra` text,
  `key_hash` varchar(64) NOT NULL,
  `encrypted_blob` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `endpoint`
--

DROP TABLE IF EXISTS `endpoint`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `endpoint` (
  `id` varchar(64) NOT NULL,
  `legacy_endpoint_id` varchar(64) DEFAULT NULL,
  `interface` varchar(8) NOT NULL,
  `service_id` varchar(64) NOT NULL,
  `url` text NOT NULL,
  `extra` text,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `region_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `service_id` (`service_id`),
  KEY `fk_endpoint_region_id` (`region_id`),
  CONSTRAINT `endpoint_service_id_fkey` FOREIGN KEY (`service_id`) REFERENCES `service` (`id`),
  CONSTRAINT `fk_endpoint_region_id` FOREIGN KEY (`region_id`) REFERENCES `region` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `endpoint_group`
--

DROP TABLE IF EXISTS `endpoint_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `endpoint_group` (
  `id` varchar(64) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text,
  `filters` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `federated_user`
--

DROP TABLE IF EXISTS `federated_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `federated_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(64) NOT NULL,
  `idp_id` varchar(64) NOT NULL,
  `protocol_id` varchar(64) NOT NULL,
  `unique_id` varchar(255) NOT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idp_id` (`idp_id`,`protocol_id`,`unique_id`),
  KEY `user_id` (`user_id`),
  KEY `federated_user_protocol_id_fkey` (`protocol_id`,`idp_id`),
  CONSTRAINT `federated_user_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `federated_user_ibfk_2` FOREIGN KEY (`idp_id`) REFERENCES `identity_provider` (`id`) ON DELETE CASCADE,
  CONSTRAINT `federated_user_protocol_id_fkey` FOREIGN KEY (`protocol_id`, `idp_id`) REFERENCES `federation_protocol` (`id`, `idp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `federation_protocol`
--

DROP TABLE IF EXISTS `federation_protocol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `federation_protocol` (
  `id` varchar(64) NOT NULL,
  `idp_id` varchar(64) NOT NULL,
  `mapping_id` varchar(64) NOT NULL,
  PRIMARY KEY (`id`,`idp_id`),
  KEY `idp_id` (`idp_id`),
  CONSTRAINT `federation_protocol_ibfk_1` FOREIGN KEY (`idp_id`) REFERENCES `identity_provider` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `group`
--

DROP TABLE IF EXISTS `group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `group` (
  `id` varchar(64) NOT NULL,
  `domain_id` varchar(64) NOT NULL,
  `name` varchar(64) NOT NULL,
  `description` text,
  `extra` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ixu_group_name_domain_id` (`domain_id`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `id_mapping`
--

DROP TABLE IF EXISTS `id_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `id_mapping` (
  `public_id` varchar(64) NOT NULL,
  `domain_id` varchar(64) NOT NULL,
  `local_id` varchar(64) NOT NULL,
  `entity_type` enum('user','group') NOT NULL,
  PRIMARY KEY (`public_id`),
  UNIQUE KEY `domain_id` (`domain_id`,`local_id`,`entity_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `identity_provider`
--

DROP TABLE IF EXISTS `identity_provider`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `identity_provider` (
  `id` varchar(64) NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `idp_remote_ids`
--

DROP TABLE IF EXISTS `idp_remote_ids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `idp_remote_ids` (
  `idp_id` varchar(64) DEFAULT NULL,
  `remote_id` varchar(255) NOT NULL,
  PRIMARY KEY (`remote_id`),
  KEY `idp_id` (`idp_id`),
  CONSTRAINT `idp_remote_ids_ibfk_1` FOREIGN KEY (`idp_id`) REFERENCES `identity_provider` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `implied_role`
--

DROP TABLE IF EXISTS `implied_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `implied_role` (
  `prior_role_id` varchar(64) NOT NULL,
  `implied_role_id` varchar(64) NOT NULL,
  PRIMARY KEY (`prior_role_id`,`implied_role_id`),
  KEY `implied_role_implied_role_id_fkey` (`implied_role_id`),
  CONSTRAINT `implied_role_implied_role_id_fkey` FOREIGN KEY (`implied_role_id`) REFERENCES `role` (`id`) ON DELETE CASCADE,
  CONSTRAINT `implied_role_prior_role_id_fkey` FOREIGN KEY (`prior_role_id`) REFERENCES `role` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `local_user`
--

DROP TABLE IF EXISTS `local_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `local_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(64) NOT NULL,
  `domain_id` varchar(64) NOT NULL,
  `name` varchar(255) NOT NULL,
  `failed_auth_count` int(11) DEFAULT NULL,
  `failed_auth_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `domain_id` (`domain_id`,`name`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `local_user_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mapping`
--

DROP TABLE IF EXISTS `mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mapping` (
  `id` varchar(64) NOT NULL,
  `rules` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `migrate_version`
--

DROP TABLE IF EXISTS `migrate_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `migrate_version` (
  `repository_id` varchar(250) NOT NULL,
  `repository_path` mediumtext,
  `version` int(11) DEFAULT NULL,
  PRIMARY KEY (`repository_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nonlocal_user`
--

DROP TABLE IF EXISTS `nonlocal_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nonlocal_user` (
  `domain_id` varchar(64) NOT NULL,
  `name` varchar(255) NOT NULL,
  `user_id` varchar(64) NOT NULL,
  PRIMARY KEY (`domain_id`,`name`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `nonlocal_user_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `password`
--

DROP TABLE IF EXISTS `password`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `password` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `local_user_id` int(11) NOT NULL,
  `password` varchar(128) DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  `self_service` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `local_user_id` (`local_user_id`),
  CONSTRAINT `password_ibfk_1` FOREIGN KEY (`local_user_id`) REFERENCES `local_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `policy`
--

DROP TABLE IF EXISTS `policy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `policy` (
  `id` varchar(64) NOT NULL,
  `type` varchar(255) NOT NULL,
  `blob` text NOT NULL,
  `extra` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `policy_association`
--

DROP TABLE IF EXISTS `policy_association`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `policy_association` (
  `id` varchar(64) NOT NULL,
  `policy_id` varchar(64) NOT NULL,
  `endpoint_id` varchar(64) DEFAULT NULL,
  `service_id` varchar(64) DEFAULT NULL,
  `region_id` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `endpoint_id` (`endpoint_id`,`service_id`,`region_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `project`
--

DROP TABLE IF EXISTS `project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project` (
  `id` varchar(64) NOT NULL,
  `name` varchar(64) NOT NULL,
  `extra` text,
  `description` text,
  `enabled` tinyint(1) DEFAULT NULL,
  `domain_id` varchar(64) NOT NULL,
  `parent_id` varchar(64) DEFAULT NULL,
  `is_domain` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `ixu_project_name_domain_id` (`domain_id`,`name`),
  KEY `project_parent_id_fkey` (`parent_id`),
  CONSTRAINT `project_domain_id_fkey` FOREIGN KEY (`domain_id`) REFERENCES `project` (`id`),
  CONSTRAINT `project_parent_id_fkey` FOREIGN KEY (`parent_id`) REFERENCES `project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `project_endpoint`
--

DROP TABLE IF EXISTS `project_endpoint`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_endpoint` (
  `endpoint_id` varchar(64) NOT NULL,
  `project_id` varchar(64) NOT NULL,
  PRIMARY KEY (`endpoint_id`,`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `project_endpoint_group`
--

DROP TABLE IF EXISTS `project_endpoint_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_endpoint_group` (
  `endpoint_group_id` varchar(64) NOT NULL,
  `project_id` varchar(64) NOT NULL,
  PRIMARY KEY (`endpoint_group_id`,`project_id`),
  CONSTRAINT `project_endpoint_group_ibfk_1` FOREIGN KEY (`endpoint_group_id`) REFERENCES `endpoint_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `region`
--

DROP TABLE IF EXISTS `region`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `region` (
  `id` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `parent_region_id` varchar(255) DEFAULT NULL,
  `extra` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `request_token`
--

DROP TABLE IF EXISTS `request_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `request_token` (
  `id` varchar(64) NOT NULL,
  `request_secret` varchar(64) NOT NULL,
  `verifier` varchar(64) DEFAULT NULL,
  `authorizing_user_id` varchar(64) DEFAULT NULL,
  `requested_project_id` varchar(64) NOT NULL,
  `role_ids` text,
  `consumer_id` varchar(64) NOT NULL,
  `expires_at` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_request_token_consumer_id` (`consumer_id`),
  CONSTRAINT `request_token_ibfk_1` FOREIGN KEY (`consumer_id`) REFERENCES `consumer` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `revocation_event`
--

DROP TABLE IF EXISTS `revocation_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `revocation_event` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain_id` varchar(64) DEFAULT NULL,
  `project_id` varchar(64) DEFAULT NULL,
  `user_id` varchar(64) DEFAULT NULL,
  `role_id` varchar(64) DEFAULT NULL,
  `trust_id` varchar(64) DEFAULT NULL,
  `consumer_id` varchar(64) DEFAULT NULL,
  `access_token_id` varchar(64) DEFAULT NULL,
  `issued_before` datetime NOT NULL,
  `expires_at` datetime DEFAULT NULL,
  `revoked_at` datetime NOT NULL,
  `audit_id` varchar(32) DEFAULT NULL,
  `audit_chain_id` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_revocation_event_new_revoked_at` (`revoked_at`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role` (
  `id` varchar(64) NOT NULL,
  `name` varchar(255) NOT NULL,
  `extra` text,
  `domain_id` varchar(64) NOT NULL DEFAULT '<<null>>',
  PRIMARY KEY (`id`),
  UNIQUE KEY `ixu_role_name_domain_id` (`name`,`domain_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sensitive_config`
--

DROP TABLE IF EXISTS `sensitive_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sensitive_config` (
  `domain_id` varchar(64) NOT NULL,
  `group` varchar(255) NOT NULL,
  `option` varchar(255) NOT NULL,
  `value` text NOT NULL,
  PRIMARY KEY (`domain_id`,`group`,`option`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service`
--

DROP TABLE IF EXISTS `service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service` (
  `id` varchar(64) NOT NULL,
  `type` varchar(255) DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `extra` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_provider`
--

DROP TABLE IF EXISTS `service_provider`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_provider` (
  `auth_url` varchar(256) NOT NULL,
  `id` varchar(64) NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  `description` text,
  `sp_url` varchar(256) NOT NULL,
  `relay_state_prefix` varchar(256) NOT NULL DEFAULT 'ss:mem:',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `token`
--

DROP TABLE IF EXISTS `token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `token` (
  `id` varchar(64) NOT NULL,
  `expires` datetime DEFAULT NULL,
  `extra` text,
  `valid` tinyint(1) NOT NULL,
  `trust_id` varchar(64) DEFAULT NULL,
  `user_id` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_token_expires` (`expires`),
  KEY `ix_token_expires_valid` (`expires`,`valid`),
  KEY `ix_token_user_id` (`user_id`),
  KEY `ix_token_trust_id` (`trust_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trust`
--

DROP TABLE IF EXISTS `trust`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trust` (
  `id` varchar(64) NOT NULL,
  `trustor_user_id` varchar(64) NOT NULL,
  `trustee_user_id` varchar(64) NOT NULL,
  `project_id` varchar(64) DEFAULT NULL,
  `impersonation` tinyint(1) NOT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  `remaining_uses` int(11) DEFAULT NULL,
  `extra` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `duplicate_trust_constraint` (`trustor_user_id`,`trustee_user_id`,`project_id`,`impersonation`,`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trust_role`
--

DROP TABLE IF EXISTS `trust_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trust_role` (
  `trust_id` varchar(64) NOT NULL,
  `role_id` varchar(64) NOT NULL,
  PRIMARY KEY (`trust_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` varchar(64) NOT NULL,
  `extra` text,
  `enabled` tinyint(1) DEFAULT NULL,
  `default_project_id` varchar(64) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `last_active_at` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_group_membership`
--

DROP TABLE IF EXISTS `user_group_membership`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_group_membership` (
  `user_id` varchar(64) NOT NULL,
  `group_id` varchar(64) NOT NULL,
  PRIMARY KEY (`user_id`,`group_id`),
  KEY `group_id` (`group_id`),
  CONSTRAINT `fk_user_group_membership_group_id` FOREIGN KEY (`group_id`) REFERENCES `group` (`id`),
  CONSTRAINT `fk_user_group_membership_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `whitelisted_config`
--

DROP TABLE IF EXISTS `whitelisted_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `whitelisted_config` (
  `domain_id` varchar(64) NOT NULL,
  `group` varchar(255) NOT NULL,
  `option` varchar(255) NOT NULL,
  `value` text NOT NULL,
  PRIMARY KEY (`domain_id`,`group`,`option`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-05-24 13:49:05
-- MySQL dump 10.13  Distrib 5.7.18, for Linux (x86_64)
--
-- Host: localhost    Database: keystone
-- ------------------------------------------------------
-- Server version	5.7.18

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `access_token`
--

LOCK TABLES `access_token` WRITE;
/*!40000 ALTER TABLE `access_token` DISABLE KEYS */;
/*!40000 ALTER TABLE `access_token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `assignment`
--

LOCK TABLES `assignment` WRITE;
/*!40000 ALTER TABLE `assignment` DISABLE KEYS */;
INSERT INTO `assignment` VALUES ('UserDomain','204bd3374f9148449dad1ce3e2f9d21b','default','7122c017e92f43b6af8e7325ae30cbc1',0);
INSERT INTO `assignment` VALUES ('UserDomain','204bd3374f9148449dad1ce3e2f9d21b','default','c82491c029dd48a6b58c029f3ee38c0e',0);
INSERT INTO `assignment` VALUES ('UserProject','4556055ad267437b877db68c176a67d2','f7de6b3052fc462e8d63b6a978c228b5','d9341a1347964a5890b194af6bb8f1d6',0);
INSERT INTO `assignment` VALUES ('UserDomain','bb615c9c41c945738569d55c373fcc35','default','4f62c83241774ef59d7b076b34e49ac5',0);
INSERT INTO `assignment` VALUES ('UserDomain','bb615c9c41c945738569d55c373fcc35','default','f6120fe6406a473682c3b25cdea4519c',0);
INSERT INTO `assignment` VALUES ('UserDomain','dee714cf256046609a3b7f9d235764ca','default','6deaae8411934899ab497498c0a36202',0);
/*!40000 ALTER TABLE `assignment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `config_register`
--

LOCK TABLES `config_register` WRITE;
/*!40000 ALTER TABLE `config_register` DISABLE KEYS */;
/*!40000 ALTER TABLE `config_register` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `consumer`
--

LOCK TABLES `consumer` WRITE;
/*!40000 ALTER TABLE `consumer` DISABLE KEYS */;
/*!40000 ALTER TABLE `consumer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `credential`
--

LOCK TABLES `credential` WRITE;
/*!40000 ALTER TABLE `credential` DISABLE KEYS */;
/*!40000 ALTER TABLE `credential` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `endpoint`
--

LOCK TABLES `endpoint` WRITE;
/*!40000 ALTER TABLE `endpoint` DISABLE KEYS */;
INSERT INTO `endpoint` VALUES ('0567c18224c648d7a2899181eeac7082',NULL,'admin','a60a7b1cc9d4449fad8a93e138b5ff17','http://keystone-admin:8000/v3/','{}',1,'usa');
INSERT INTO `endpoint` VALUES ('4895014ba5a24c048c2fc127c61868c3',NULL,'public','a60a7b1cc9d4449fad8a93e138b5ff17','http://keystone-public:8000/v3/','{}',1,'usa');
/*!40000 ALTER TABLE `endpoint` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `endpoint_group`
--

LOCK TABLES `endpoint_group` WRITE;
/*!40000 ALTER TABLE `endpoint_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `endpoint_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `federated_user`
--

LOCK TABLES `federated_user` WRITE;
/*!40000 ALTER TABLE `federated_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `federated_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `federation_protocol`
--

LOCK TABLES `federation_protocol` WRITE;
/*!40000 ALTER TABLE `federation_protocol` DISABLE KEYS */;
/*!40000 ALTER TABLE `federation_protocol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `group`
--

LOCK TABLES `group` WRITE;
/*!40000 ALTER TABLE `group` DISABLE KEYS */;
/*!40000 ALTER TABLE `group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `id_mapping`
--

LOCK TABLES `id_mapping` WRITE;
/*!40000 ALTER TABLE `id_mapping` DISABLE KEYS */;
/*!40000 ALTER TABLE `id_mapping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `identity_provider`
--

LOCK TABLES `identity_provider` WRITE;
/*!40000 ALTER TABLE `identity_provider` DISABLE KEYS */;
/*!40000 ALTER TABLE `identity_provider` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `idp_remote_ids`
--

LOCK TABLES `idp_remote_ids` WRITE;
/*!40000 ALTER TABLE `idp_remote_ids` DISABLE KEYS */;
/*!40000 ALTER TABLE `idp_remote_ids` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `implied_role`
--

LOCK TABLES `implied_role` WRITE;
/*!40000 ALTER TABLE `implied_role` DISABLE KEYS */;
/*!40000 ALTER TABLE `implied_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `local_user`
--

LOCK TABLES `local_user` WRITE;
/*!40000 ALTER TABLE `local_user` DISABLE KEYS */;
INSERT INTO `local_user` VALUES (1,'4556055ad267437b877db68c176a67d2','default','admin',0,NULL);
INSERT INTO `local_user` VALUES (2,'af11a85e26c74ec284f9b0eb47a41465','default','anthony@example.com',0,NULL);
INSERT INTO `local_user` VALUES (3,'204bd3374f9148449dad1ce3e2f9d21b','default','evelyn@example.com',0,NULL);
INSERT INTO `local_user` VALUES (4,'0ef9e63e22164651bfd459c4785759b7','default','james@example.com',0,NULL);
INSERT INTO `local_user` VALUES (5,'dee714cf256046609a3b7f9d235764ca','default','joseph@example.com',0,NULL);
INSERT INTO `local_user` VALUES (6,'eb5e3fafb7f24bf1981ae49cffae3cd6','default','lisa@example.com',0,NULL);
INSERT INTO `local_user` VALUES (7,'bb615c9c41c945738569d55c373fcc35','default','stephen@example.com',0,NULL);
/*!40000 ALTER TABLE `local_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `mapping`
--

LOCK TABLES `mapping` WRITE;
/*!40000 ALTER TABLE `mapping` DISABLE KEYS */;
/*!40000 ALTER TABLE `mapping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `migrate_version`
--

LOCK TABLES `migrate_version` WRITE;
/*!40000 ALTER TABLE `migrate_version` DISABLE KEYS */;
INSERT INTO `migrate_version` VALUES ('keystone','/usr/lib/python2.7/dist-packages/keystone/common/sql/migrate_repo',109);
INSERT INTO `migrate_version` VALUES ('keystone_contract','/usr/lib/python2.7/dist-packages/keystone/common/sql/contract_repo',4);
INSERT INTO `migrate_version` VALUES ('keystone_data_migrate','/usr/lib/python2.7/dist-packages/keystone/common/sql/data_migration_repo',4);
INSERT INTO `migrate_version` VALUES ('keystone_expand','/usr/lib/python2.7/dist-packages/keystone/common/sql/expand_repo',4);
/*!40000 ALTER TABLE `migrate_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `nonlocal_user`
--

LOCK TABLES `nonlocal_user` WRITE;
/*!40000 ALTER TABLE `nonlocal_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `nonlocal_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `password`
--

LOCK TABLES `password` WRITE;
/*!40000 ALTER TABLE `password` DISABLE KEYS */;
INSERT INTO `password` VALUES (2,1,'$6$rounds=10000$nU/CRy.VrLq0fYfb$6XLb5x/7OGdCQcpZSvSS02abU8J/qNfXDSo6G.ErNXn300SPg3I84r4xzdEY/ibKSo//mJ05jU.qrySShvGXA1','2017-05-23 15:59:27',0,'2017-05-23 02:00:26');
INSERT INTO `password` VALUES (3,2,'$6$rounds=10000$ptP.CQPmjMQWbdPu$0dwVRR/gIDFuZl13tY1niF3RPb9LR3l.fPe2lg7g0K7Or2.tVIS0TZpv6bWVU51FO/ykSJE56LLdUxEVUFqEC1',NULL,0,'2017-05-23 03:24:30');
INSERT INTO `password` VALUES (4,3,'$6$rounds=10000$DD3OfaAYKs5e2W7N$5Fg01C1eSgdt6atn254n.TSzq5ZPhmxil6tK5Zjy6oKcI9ViKRLuQUIeYGddLtkW8bOIrwAzXVboSL9mwkeZx/',NULL,0,'2017-05-23 03:26:16');
INSERT INTO `password` VALUES (5,4,'$6$rounds=10000$NQNuOpyulppvTWWN$C0LSdPF9if9tPo4v/KnXtQgfK/E9WZ5Yzq810WEPklBoy8BKjZAVZH/LT67liDKe5EjpGKspocolt8.5YIZ391',NULL,0,'2017-05-23 03:26:28');
INSERT INTO `password` VALUES (6,5,'$6$rounds=10000$LZcKaHoxjrKjJ5FU$aCfHXdecLLK9cp90HM0tRht4HQHqv.A7BPvcA4bEMbv84UajeU9qigj1KnRYQ/UsgCmk2BuWb4tR9I4/aNERr/',NULL,0,'2017-05-23 03:33:59');
INSERT INTO `password` VALUES (7,6,'$6$rounds=10000$sxWxV5daqJDyZ/ey$TqiqxQO2mQKR9OiTc663VrLhN5P.EHrReo.OBRCxQJqyzDNkPUKKXrnFHYfMdba2ZYrWfE73NN6BRTRm54G.c.',NULL,0,'2017-05-23 03:34:08');
INSERT INTO `password` VALUES (8,7,'$6$rounds=10000$OcMQq1cTfaN4tv9M$dmnh/DDtN9hq6ooS2Y7B1kY8Ytpjvoy/6BnuHVFyiPrI4x1JVhPiEKL/ncN7X/K5XjjJHgFVpt4JS82gnf.yg.',NULL,0,'2017-05-23 03:34:18');
INSERT INTO `password` VALUES (9,1,'$6$rounds=10000$KgkKLNpmFd6Pu/s6$M07wpTx8BFFkTcpK7iH.hCRo3c7izHtQ//EWjyAnnW9SVbH6cpVAGK8Nd8eHczPA0A2uHK7j2u1wTKZ/5Rzoo0',NULL,0,'2017-05-23 15:59:27');
/*!40000 ALTER TABLE `password` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `policy`
--

LOCK TABLES `policy` WRITE;
/*!40000 ALTER TABLE `policy` DISABLE KEYS */;
/*!40000 ALTER TABLE `policy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `policy_association`
--

LOCK TABLES `policy_association` WRITE;
/*!40000 ALTER TABLE `policy_association` DISABLE KEYS */;
/*!40000 ALTER TABLE `policy_association` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `project`
--

LOCK TABLES `project` WRITE;
/*!40000 ALTER TABLE `project` DISABLE KEYS */;
INSERT INTO `project` VALUES ('0372a7b8d40b4a6e90b91b245fb572e3','demo','{}','Demo Project',1,'default','default',0);
INSERT INTO `project` VALUES ('969b3f59a12c43ff8b7e9cbe95bcd521','service','{}','Service Project',1,'default','default',0);
INSERT INTO `project` VALUES ('<<keystone.domain.root>>','<<keystone.domain.root>>','{}','',0,'<<keystone.domain.root>>',NULL,1);
INSERT INTO `project` VALUES ('default','Default','{}','The default domain',1,'<<keystone.domain.root>>',NULL,1);
INSERT INTO `project` VALUES ('f7de6b3052fc462e8d63b6a978c228b5','admin','{}','Bootstrap project for initializing the cloud.',1,'default','default',0);
/*!40000 ALTER TABLE `project` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `project_endpoint`
--

LOCK TABLES `project_endpoint` WRITE;
/*!40000 ALTER TABLE `project_endpoint` DISABLE KEYS */;
/*!40000 ALTER TABLE `project_endpoint` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `project_endpoint_group`
--

LOCK TABLES `project_endpoint_group` WRITE;
/*!40000 ALTER TABLE `project_endpoint_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `project_endpoint_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `region`
--

LOCK TABLES `region` WRITE;
/*!40000 ALTER TABLE `region` DISABLE KEYS */;
INSERT INTO `region` VALUES ('usa','',NULL,'{}');
/*!40000 ALTER TABLE `region` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES ('4f62c83241774ef59d7b076b34e49ac5','Users','{}','<<null>>');
INSERT INTO `role` VALUES ('6deaae8411934899ab497498c0a36202','Contractors','{}','<<null>>');
INSERT INTO `role` VALUES ('7122c017e92f43b6af8e7325ae30cbc1','Project One Devs','{}','<<null>>');
INSERT INTO `role` VALUES ('c82491c029dd48a6b58c029f3ee38c0e','Project Two Devs','{}','<<null>>');
INSERT INTO `role` VALUES ('d9341a1347964a5890b194af6bb8f1d6','admin','{}','<<null>>');
INSERT INTO `role` VALUES ('f6120fe6406a473682c3b25cdea4519c','Admins','{}','<<null>>');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `sensitive_config`
--

LOCK TABLES `sensitive_config` WRITE;
/*!40000 ALTER TABLE `sensitive_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `sensitive_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `service`
--

LOCK TABLES `service` WRITE;
/*!40000 ALTER TABLE `service` DISABLE KEYS */;
INSERT INTO `service` VALUES ('a60a7b1cc9d4449fad8a93e138b5ff17','identity',1,'{\"name\": \"keystone\"}');
/*!40000 ALTER TABLE `service` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `service_provider`
--

LOCK TABLES `service_provider` WRITE;
/*!40000 ALTER TABLE `service_provider` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_provider` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `trust`
--

LOCK TABLES `trust` WRITE;
/*!40000 ALTER TABLE `trust` DISABLE KEYS */;
/*!40000 ALTER TABLE `trust` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `trust_role`
--

LOCK TABLES `trust_role` WRITE;
/*!40000 ALTER TABLE `trust_role` DISABLE KEYS */;
/*!40000 ALTER TABLE `trust_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('0ef9e63e22164651bfd459c4785759b7','{}',1,NULL,'2017-05-23 03:26:28',NULL);
INSERT INTO `user` VALUES ('204bd3374f9148449dad1ce3e2f9d21b','{}',1,NULL,'2017-05-23 03:26:16',NULL);
INSERT INTO `user` VALUES ('4556055ad267437b877db68c176a67d2','{}',1,NULL,'2017-05-22 22:59:31',NULL);
INSERT INTO `user` VALUES ('af11a85e26c74ec284f9b0eb47a41465','{}',1,NULL,'2017-05-23 03:24:30',NULL);
INSERT INTO `user` VALUES ('bb615c9c41c945738569d55c373fcc35','{}',1,NULL,'2017-05-23 03:34:18',NULL);
INSERT INTO `user` VALUES ('dee714cf256046609a3b7f9d235764ca','{}',1,NULL,'2017-05-23 03:33:59',NULL);
INSERT INTO `user` VALUES ('eb5e3fafb7f24bf1981ae49cffae3cd6','{}',1,NULL,'2017-05-23 03:34:08',NULL);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `user_group_membership`
--

LOCK TABLES `user_group_membership` WRITE;
/*!40000 ALTER TABLE `user_group_membership` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_group_membership` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `whitelisted_config`
--

LOCK TABLES `whitelisted_config` WRITE;
/*!40000 ALTER TABLE `whitelisted_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `whitelisted_config` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-05-24 13:49:05
