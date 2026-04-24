CREATE TABLE `anomalies` (
	`id` int AUTO_INCREMENT NOT NULL,
	`reimbursementId` int NOT NULL,
	`anomalyType` varchar(100) NOT NULL,
	`anomalyScore` decimal(5,2) NOT NULL,
	`historicalAverage` decimal(15,2),
	`deviationPercentage` decimal(5,2),
	`description` text,
	`status` enum('Bloqueado','Revisado','Aprovado','Rejeitado') NOT NULL DEFAULT 'Bloqueado',
	`reviewedBy` int,
	`reviewReason` text,
	`createdAt` timestamp NOT NULL DEFAULT (now()),
	`updatedAt` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
	CONSTRAINT `anomalies_id` PRIMARY KEY(`id`)
);
--> statement-breakpoint
CREATE TABLE `auditLogs` (
	`id` int AUTO_INCREMENT NOT NULL,
	`userId` int NOT NULL,
	`action` varchar(100) NOT NULL,
	`entityType` varchar(50) NOT NULL,
	`entityId` int NOT NULL,
	`changes` json,
	`reason` text,
	`ipAddress` varchar(45),
	`createdAt` timestamp NOT NULL DEFAULT (now()),
	CONSTRAINT `auditLogs_id` PRIMARY KEY(`id`)
);
--> statement-breakpoint
CREATE TABLE `declarations` (
	`id` int AUTO_INCREMENT NOT NULL,
	`declarationNumber` varchar(100) NOT NULL,
	`ncm` varchar(20) NOT NULL,
	`paidValue` decimal(15,2) NOT NULL,
	`paidTariff` decimal(5,2) NOT NULL,
	`currentTariff` decimal(5,2) NOT NULL,
	`declarationDate` timestamp NOT NULL,
	`documentUrl` varchar(500),
	`extractedData` json,
	`status` enum('Apta para Reembolso','Pendente','Divergente') NOT NULL DEFAULT 'Pendente',
	`uploadedBy` int NOT NULL,
	`createdAt` timestamp NOT NULL DEFAULT (now()),
	`updatedAt` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
	CONSTRAINT `declarations_id` PRIMARY KEY(`id`),
	CONSTRAINT `declarations_declarationNumber_unique` UNIQUE(`declarationNumber`)
);
--> statement-breakpoint
CREATE TABLE `documents` (
	`id` int AUTO_INCREMENT NOT NULL,
	`declarationId` int NOT NULL,
	`reimbursementId` int,
	`documentType` varchar(50) NOT NULL,
	`documentUrl` varchar(500) NOT NULL,
	`fileName` varchar(255) NOT NULL,
	`fileSize` int,
	`uploadedBy` int NOT NULL,
	`createdAt` timestamp NOT NULL DEFAULT (now()),
	CONSTRAINT `documents_id` PRIMARY KEY(`id`)
);
--> statement-breakpoint
CREATE TABLE `reimbursements` (
	`id` int AUTO_INCREMENT NOT NULL,
	`declarationId` int NOT NULL,
	`reimbursementValue` decimal(15,2) NOT NULL,
	`status` enum('Apta para Reembolso','Pendente','Divergente','Aprovado','Rejeitado') NOT NULL DEFAULT 'Pendente',
	`approvedBy` int,
	`approvalReason` text,
	`voucherUrl` varchar(500),
	`webhookSent` int DEFAULT 0,
	`createdAt` timestamp NOT NULL DEFAULT (now()),
	`updatedAt` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
	CONSTRAINT `reimbursements_id` PRIMARY KEY(`id`)
);
--> statement-breakpoint
ALTER TABLE `users` MODIFY COLUMN `role` enum('user','admin','operador') NOT NULL DEFAULT 'user';