/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name NOT IN ('Gabumon');
SELECT * FROM animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;
 
BEGIN;
UPDATE animals
SET species = 'unspecified';
SELECT name, species FROM animals;
ROLLBACK;

BEGIN;
UPDATE animals
SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals 
SET species = 'pokemon' WHERE species IS NULL;
SELECT name, species FROM animals;
COMMIT;

-- delete and rollback
BEGIN;
DELETE FROM animals;
SELECT * FROM animals;
ROLLBACK;


-- delete and savepoint

BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT before_deletion;
SELECT * FROM animals;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO before_deletion;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
SELECT * FROM animals;
COMMIT;
------------------------------

-- How many animals are there ?
SELECT COUNT(*) FROM animals;
-- How many animals have never tried to escape?
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
-- What is the average weight of animals?
SELECT AVG(weight_kg) FROM animals;
-- Who escapes the most, neutered or not neutered animals?
SELECT neutered, SUM(escape_attempts) AS total_attempts FROM animals GROUP BY neutered ORDER BY total_attempts DESC LIMIT 1;
-- What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg) AS minimum, MAX(weight_kg) AS maximum FROM animals GROUP BY species;
-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;


-----------------------------------------------------
--What animals belong to Melody Pond?
SELECT a.id, a.name, o.full_name
FROM animals a
JOIN owners o ON a.owner_id = o.id WHERE o.full_name = 'Melody Pond';

-----------------------------------------------------
--List of all animals that are pokemon (their type is Pokemon)

SELECT a.id, a.name, s.name
FROM animals a
JOIN species s on a.species_id = s.id WHERE s.name = 'Pokemon';

-------------------------------------------------------
--List all owners and their animals, remember to include those that don't own any animal.
SELECT o.full_name, o.id, a.name FROM owners o
LEFT JOIN animals a ON o.id = a.owner_id;

-------------------------------------------------------
-- How many animals are there per species?
SELECT s.id, s.name as species, COUNT(a.id) as number_of_animals
FROM animals a JOIN species s ON a.species_id = s.id
GROUP BY s.id;
-----------------------------------------------------------
-- List all Digimon owned by Jennifer Orwell.
SELECT a.id, a.name, o.full_name, s.name as species FROM animals a
JOIN owners o ON a.owner_id = o.id
JOIN species s ON a.species_id = s.id
WHERE o.full_name = 'Jennifer Orwell' AND s.name = 'Digimon';
--------------------------------------------------------
-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT a.id, a.name
FROM animals a
JOIN owners o ON a.owner_id = o.id WHERE o.full_name = 'Dean Winchester' AND a.escape_attempts = 0 ;
--------------------------------------------------------
SELECT o.id, o.full_name, COUNT(a.id) as number_of_animals
FROM owners o
LEFT JOIN animals a ON o.id = a.owner_id
GROUP BY o.id
ORDER BY number_of_animals DESC LIMIT 1;

-------------------------------------------------------------
-- Who was the last animal seen by William Tatcher?
SELECT animals.name FROM animals 
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'William Tatcher' ORDER BY visits.date_of_visit DESC LIMIT 1;

---------------------------------------------------------------
-- How many different animals did Stephanie Mendez see?
SELECT COUNT(animals.id) FROM animals 
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez';
-------------------------------------------------------
-- List all vets and their specialties, including vets with no specialties.
SELECT vets.name as Vet_name, species.name FROM vets
LEFT JOIN specializations ON vets.id = specializations.vet_id
LEFT JOIN species ON specializations.species_id = species.id;
---------------------------------------------------------------
-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT animals.name FROM animals 
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez' AND visits.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';
----------------------------------------------------------
-- What animal has the most visits to vets?
SELECT animals.name, COUNT(visits.animal_id) as count FROM animals 
JOIN visits ON animals.id = visits.animal_id
GROUP BY animals.name
ORDER BY COUNT(visits.animal_id) DESC LIMIT 1;
------------------------------------------------------------
-- Who was Maisy Smith's first visit?
SELECT animals.name, visits.date_of_visit FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets on visits.vet_id = vets.id
WHERE vets.name = 'Maisy Smith' ORDER BY visits.date_of_visit DESC LIMIT 1;
------------------------------------------------------------
-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT animals.name as animal, vets.name as vet, visits.date_of_visit FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets on visits.vet_id = vets.id
ORDER BY visits.date_of_visit DESC LIMIT 1;
------------------------------------------------------------
-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*) FROM visits
JOIN animals on visits.animal_id = animals.id 
JOIN vets on visits.vet_id = vets.id
LEFT JOIN specializations on vets.id = specializations.vet_id and animals.species_id = specializations.species_id
WHERE specializations.species_id IS NULL;
-----------------------------------------------------------
-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT species.name as Maisy_spacialty from species
JOIN animals on species.id = animals.species_id
JOIN visits on animals.id = visits.animal_id
JOIN vets on visits.vet_id = vets.id
WHERE vets.name = 'Maisy Smith' GROUP BY species.name ORDER BY COUNT(visits.date_of_visit) DESC LIMIT 1;
-----------------------------------------------------------