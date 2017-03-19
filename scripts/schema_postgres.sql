/* Drop Tables */

DROP TABLE IF EXISTS lookup CASCADE;
DROP TABLE IF EXISTS lookup_entity CASCADE;
DROP TABLE IF EXISTS domain CASCADE;
DROP TABLE IF EXISTS domain_type CASCADE;
DROP TABLE IF EXISTS sentiment_type CASCADE;
DROP TABLE IF EXISTS lookup_state CASCADE;

--------------------------------------------------------------------------------

/* Create Tables */

CREATE TABLE lookup
(
	id BIGSERIAL NOT NULL,
	lookup_entity_id BIGINT NOT NULL,
	date TIMESTAMP(6) NOT NULL,

	sentiment_type_code CHAR(3) NULL,
	lookup_state_code SMALLINT NOT NULL,

	CONSTRAINT pk_lookup PRIMARY KEY (id)
);

CREATE TABLE domain_lookup
(
	id BIGSERIAL NOT NULL,

	negative_cnt BIGINT,
	neutral_cnt BIGINT,
	positive_cnt BIGINT,

	negative_qty DOUBLE,
	positive_qty DOUBLE,
	neutral_qty DOUBLE,

	lookup_id BIGINT NOT NULL,
	domain_code SMALLINT NOT NULL,
	sentiment_type_code CHAR(3),

	CONSTRAINT pk_domain_lookup PRIMARY KEY (id)
);

CREATE TABLE lookup_entity
(
	id BIGSERIAL NOT NULL,
	name VARCHAR(255) NOT NULL,

	CONSTRAINT pk_lookup_entity PRIMARY KEY (id)
);

CREATE TABLE domain_type
(
	code SMALLINT NOT NULL,
	name VARCHAR(150) NOT NULL,

	CONSTRAINT pk_domain_type PRIMARY KEY (code)
);

CREATE TABLE domain
(
	code SMALLINT NOT NULL,
	name VARCHAR(150) NOT NULL,
	active BOOLEAN DEFAULT TRUE NOT NULL,

	domain_type_code SMALLINT NOT NULL,

	CONSTRAINT pk_domain PRIMARY KEY (code)
);

CREATE TABLE sentiment_type
(
	code CHAR(3) DEFAULT 'NEU' NOT NULL, -- Values: NEU, POS, NEG
	name VARCHAR(150) NULL,

	CONSTRAINT pk_sentiment_type PRIMARY KEY (code)
);

CREATE TABLE lookup_state
(
	code SMALLINT NOT NULL,
	name VARCHAR(150) NOT NULL,

	CONSTRAINT pk_lookup_state PRIMARY KEY (code)
);

--------------------------------------------------------------------------------
 
/* Create Foreign Key Constraints */

ALTER TABLE lookup
ADD CONSTRAINT fk_lookup_sentiment_type
FOREIGN KEY (sentiment_type_code)
	REFERENCES sentiment_type (code);

ALTER TABLE lookup
ADD CONSTRAINT fk_lookup_lookup_state
FOREIGN KEY (lookup_state_code)
	REFERENCES lookup_state (code);

ALTER TABLE lookup
ADD CONSTRAINT fk_lookup_lookup_entity
	FOREIGN KEY (lookup_entity_id)
		REFERENCES lookup_entity(id);

-------------

ALTER TABLE domain_lookup
ADD CONSTRAINT fk_domain_lookup_domain
FOREIGN KEY (domain_code)
	REFERENCES domain (code);

ALTER TABLE domain_lookup
ADD CONSTRAINT fk_domain_lookup_sentiment_type
FOREIGN KEY (sentiment_type_code)
	REFERENCES sentiment_type (code);

-------------

ALTER TABLE domain
ADD CONSTRAINT fk_domain_domain_type
FOREIGN KEY (domain_type_code)
	REFERENCES domain_type (code);

------------------------------------------------------------------------------
 

/* Create Indexes, Uniques, Checks, Triggers */

-- TODO: Margus

---------------------------------------------------------------------------	

/* Classifier values */

INSERT INTO lookup_state (code, name)
VALUES (1, 'Queued');

INSERT INTO lookup_state(code, name)
VALUES (2, 'In progress');

INSERT INTO lookup_state(code, name)
VALUES (3, 'Complete');

-------------

INSERT INTO domain_type (code, name)
VALUES (1, 'Search Engine');

INSERT INTO domain_type (code, name)
VALUES (2, 'Social Media');

-------------

INSERT INTO domain (code, name, active, domain_type_code)
VALUES (1, 'Google', TRUE, 1);

INSERT INTO domain (code, name, active domain_type_code)
VALUES (2, 'Bing', TRUE, 1);

INSERT INTO domain (code, name, active domain_type_code)
VALUES (3, 'Yahoo', TRUE, 1);

INSERT INTO domain (code, name, active domain_type_code)
VALUES (4, 'Facebook', TRUE, 2);

INSERT INTO domain (code, name, active domain_type_code)
VALUES (5, 'Twitter', TRUE, 2);

-------------

INSERT INTO sentiment_type (code, name)
VALUES ('NEU', 'Neutral');

INSERT INTO sentiment_type (code, name)
VALUES ('POS', 'Positive');

INSERT INTO sentiment_type (code, name)
VALUES ('NEG', 'Negative');

---------------------------------------------------------------------------

