-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3308
-- Gegenereerd op: 26 apr 2024 om 11:58
-- Serverversie: 10.4.28-MariaDB
-- PHP-versie: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `eindopdrachtmad`
--

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `tasks`
--

CREATE TABLE `tasks` (
  `task_id` int(11) NOT NULL,
  `naam` varchar(255) NOT NULL,
  `beschrijving` varchar(255) DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `tasks`
--

INSERT INTO `tasks` (`task_id`, `naam`, `beschrijving`, `user_id`) VALUES
(16, 'fdafdsf', 'Maak vandaag een goede foto van sjors ', 6),
(18, 'Jakubdffdsgdad', 'fsadfdsfdsafadfs', 6),
(21, 'fsdafsadfads', 'fdsafadsfasd', 8),
(44, 'fdsafdsaf', '', 16),
(45, 'fdsafsadf', '', 16),
(46, 'fdsfadsfds', '', 16);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`) VALUES
(2, 'Jakub', '123'),
(3, 'Jakub', '123'),
(4, 'Jakub', '123'),
(5, 'Jakub', '1234'),
(6, 'Sjors', '1234'),
(7, 'string', 'string'),
(8, 'Jakub', '12345'),
(9, 'Jakubski', '1234'),
(10, 'Jaskubsid', '$2b$12$G7ZUealMKragw8AJwfYTx.FftKovjObwmAsFMk4QTnCBMFgsCke36'),
(11, 'Sjorski', '$2b$12$l1BE4h3V2JfE0KrPzmB6NOxBffWkJCu5jPNQ6yrFNf1hF9mHEYWR6'),
(12, 'Sjorski', '$2b$12$X3LMpCMHjiiW4g9Ho40KS.fRuFfeMU6X2bvSPzO4kEvAtfHNoZO3W'),
(13, 'Sjorspapa', '$2b$12$9QeMo8IEVIEy9drGoB2se.QkypAAWGJElRUGUNSwGf7WrBMA0t4aK'),
(14, 'Larskipapski', '$2b$12$qHYe1.mxA90B5V7hv4gaW.YIlF6Inw.LABIaFIf2mzeDvRJOBmHdG'),
(15, 'Jakubski', '$2b$12$nlQ987G71mp29XtvxHA2Lumucf1mlXUy9CLlW.q3qcIZBLD3WrYp.'),
(16, 'Mohammed', '$2b$12$xmJs8CA31De1nmFbvtnfvOlsIjN2RofxeN6omoM1v/WM.pKjdhw.6');

--
-- Indexen voor geëxporteerde tabellen
--

--
-- Indexen voor tabel `tasks`
--
ALTER TABLE `tasks`
  ADD PRIMARY KEY (`task_id`),
  ADD KEY `tasks_ibfk_1` (`user_id`);

--
-- Indexen voor tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT voor geëxporteerde tabellen
--

--
-- AUTO_INCREMENT voor een tabel `tasks`
--
ALTER TABLE `tasks`
  MODIFY `task_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT voor een tabel `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- Beperkingen voor geëxporteerde tabellen
--

--
-- Beperkingen voor tabel `tasks`
--
ALTER TABLE `tasks`
  ADD CONSTRAINT `tasks_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
