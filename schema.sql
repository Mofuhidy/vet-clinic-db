/* Database schema to keep the structure of entire database. */
CREATE DATABASE vet_clinic;

CREATE TABLE animals (
    id int GENERATED ALWAYS AS IDENTITY NOT NULL,
    name varchar(250) NOT NULL,
    date_of_birth date NOT NULL,
    escape_attempts int NOT NULL,
    neutered boolean NOT NULL,
    weight_kg decimal NOT NULL,
    PRIMARY KEY(id)
);

ALTER TABLE animals
ADD COLUMN species VARCHAR;

----------------------------------------
CREATE TABLE owners (
    id int GENERATED ALWAYS AS IDENTITY NOT NULL,
    full_name varchar(250) NOT NULL,
    age int NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE species (
    id int GENERATED ALWAYS AS IDENTITY NOT NULL,
    name varchar(250) NOT NULL,
    PRIMARY KEY(id)
);

ALTER TABLE animals DROP COLUMN species;

ALTER TABLE animals ADD COLUMN species_id int;
ALTER TABLE animals ADD CONSTRAINT fk_species FOREIGN KEY (species_id) REFERENCES species(id);
ALTER TABLE animals ADD COLUMN owner_id int;
ALTER TABLE animals ADD CONSTRAINT fk_owner FOREIGN KEY (owner_id) REFERENCES owners(id);