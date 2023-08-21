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

--------------------------------------------------------

CREATE TABLE vets (
    id int GENERATED ALWAYS AS IDENTITY NOT NULL,
    name varchar(250) NOT NULL,
    age int NOT NULL,
    date_of_graduation date NOT NULL,
    PRIMARY KEY(id)
);

-- Join table
CREATE TABLE specializations (
    vet_id int NOT NULL,
    species_id int NOT NULL,
    PRIMARY KEY(vet_id, species_id),
    FOREIGN KEY (vet_id) REFERENCES vets(id),
    FOREIGN KEY (species_id) REFERENCES species(id)
);

-- Join table 
CREATE TABLE visits (
    animal_id int NOT NULL,
    vet_id int NOT NULL,
    date_of_visit date NOT NULL,
    PRIMARY KEY(animal_id, vet_id, date_of_visit),
    FOREIGN KEY (animal_id) REFERENCES animals(id),
    FOREIGN KEY (vet_id) REFERENCES vets(id)
);

-- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);

CREATE INDEX vistis_animal_id ON visits(animal_id);

CREATE INDEX vistis_vet_id ON visits(vet_id);

CREATE INDEX owners_email ON owners(email);