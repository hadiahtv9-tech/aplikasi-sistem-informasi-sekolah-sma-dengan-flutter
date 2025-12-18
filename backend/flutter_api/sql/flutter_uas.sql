-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 18, 2025 at 01:34 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `flutter_uas`
--

-- --------------------------------------------------------

--
-- Table structure for table `jadwal`
--

CREATE TABLE `jadwal` (
  `id` int(11) NOT NULL,
  `hari` varchar(50) NOT NULL,
  `mapel` varchar(255) NOT NULL,
  `kelas_id` int(11) DEFAULT NULL,
  `guru_id` varchar(64) DEFAULT NULL,
  `jam` varchar(50) DEFAULT NULL,
  `ruangan` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `jadwal`
--

INSERT INTO `jadwal` (`id`, `hari`, `mapel`, `kelas_id`, `guru_id`, `jam`, `ruangan`, `created_at`) VALUES
(6, 'Senin', 'Bahasa Indonesia', 2, '5', '07:30-09:00', 'Ruang 201', '2025-12-13 22:25:52'),
(8, 'Selasa', 'Sejarah', 2, '18', '07.30-09.30', '21', '2025-12-16 11:23:55'),
(9, 'Kamis', 'IPA', 1, '18', '09.30-10.00', '24', '2025-12-16 11:24:30');

-- --------------------------------------------------------

--
-- Table structure for table `kelas`
--

CREATE TABLE `kelas` (
  `id` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kelas`
--

INSERT INTO `kelas` (`id`, `nama`, `created_at`) VALUES
(1, '10 A', '2025-12-13 22:25:52'),
(2, '10 B', '2025-12-13 22:25:52'),
(3, '11 A', '2025-12-13 22:25:52'),
(4, '11 B', '2025-12-13 22:25:52'),
(5, '12 A', '2025-12-13 22:25:52'),
(6, '12 B', '2025-12-13 22:25:52');

-- --------------------------------------------------------

--
-- Table structure for table `nilai`
--

CREATE TABLE `nilai` (
  `id` int(11) NOT NULL,
  `siswa_id` varchar(64) NOT NULL,
  `mapel_id` varchar(64) DEFAULT NULL,
  `semester` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `uts` double DEFAULT NULL,
  `uas` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `nilai`
--

INSERT INTO `nilai` (`id`, `siswa_id`, `mapel_id`, `semester`, `created_at`, `updated_at`, `uts`, `uas`) VALUES
(15, '6', 'IPA', 'Ganjil', '2025-12-16 23:48:40', '2025-12-17 16:38:06', 22, NULL),
(16, '7', 'IPA', 'Ganjil', '2025-12-16 23:48:40', '2025-12-17 16:38:06', 22, NULL),
(17, '8', 'IPA', 'Ganjil', '2025-12-16 23:48:40', '2025-12-17 16:38:06', 22, NULL),
(18, '15', 'IPA', 'Ganjil', '2025-12-16 23:48:40', '2025-12-17 16:38:06', 22, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `notifikasi`
--

CREATE TABLE `notifikasi` (
  `id` int(11) NOT NULL,
  `user_id` varchar(64) NOT NULL,
  `judul` varchar(255) NOT NULL,
  `pesan` text DEFAULT NULL,
  `dibaca` tinyint(1) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifikasi`
--

INSERT INTO `notifikasi` (`id`, `user_id`, `judul`, `pesan`, `dibaca`, `created_at`) VALUES
(4, '6', 'xaxsa', 'sasas', 0, '2025-12-17 19:03:58'),
(5, '7', 'xaxsa', 'sasas', 0, '2025-12-17 19:03:58'),
(6, '8', 'xaxsa', 'sasas', 0, '2025-12-17 19:03:58'),
(7, '9', 'xaxsa', 'sasas', 0, '2025-12-17 19:03:58'),
(8, '15', 'xaxsa', 'sasas', 1, '2025-12-17 19:03:58'),
(9, '2', 'dad', 'adada', 0, '2025-12-17 19:57:56'),
(10, '4', 'dad', 'adada', 0, '2025-12-17 19:57:56'),
(11, '5', 'dad', 'adada', 0, '2025-12-17 19:57:56'),
(12, '18', 'dad', 'adada', 1, '2025-12-17 19:57:56');

-- --------------------------------------------------------

--
-- Table structure for table `tugas`
--

CREATE TABLE `tugas` (
  `id` int(11) NOT NULL,
  `guru_id` varchar(64) DEFAULT NULL,
  `kelas_id` int(11) DEFAULT NULL,
  `judul` varchar(255) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `deadline` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tugas`
--

INSERT INTO `tugas` (`id`, `guru_id`, `kelas_id`, `judul`, `deskripsi`, `deadline`, `created_at`) VALUES
(5, '18', 5, 'adv', 'xccsc', '2025-12-16 00:00:00', '2025-12-16 12:21:00'),
(6, '18', 1, 'zad', 'ada', '2025-12-17 00:00:00', '2025-12-16 20:15:21');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `nama` varchar(255) DEFAULT NULL,
  `role` varchar(50) DEFAULT 'siswa' COMMENT 'admin, guru, siswa',
  `kelas_id` int(11) DEFAULT NULL,
  `wali_kelas_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `nama`, `role`, `kelas_id`, `wali_kelas_id`, `created_at`) VALUES
(12, 'admin@gmail.com', '$2y$10$J1svl1nnVDakXy6el9jXxOoKD9YH.T8Cm80V/ss6/tgRa62pbtz.O', 'Administrator', 'admin', NULL, NULL, '2025-12-13 22:49:56'),
(15, 'farid@gmail.com', '$2y$10$QegpcxfYt7dgwq9YT1cVH.mA9Vq8uSSakBdoCZ.PBuaSm48h0elTW', 'farid', 'siswa', 1, NULL, '2025-12-15 17:59:00'),
(18, 'sasa@gmail.com', '$2y$10$DX..FT0crDcP19fOVReXk.vktmJcLRUotjQ..8CtxCGXyKSQXS9g2', 'Sasa', 'guru', NULL, 2, '2025-12-15 18:07:36');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `jadwal`
--
ALTER TABLE `jadwal`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_hari` (`hari`),
  ADD KEY `idx_kelas_id` (`kelas_id`),
  ADD KEY `idx_guru_id` (`guru_id`);

--
-- Indexes for table `kelas`
--
ALTER TABLE `kelas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_nama` (`nama`);

--
-- Indexes for table `nilai`
--
ALTER TABLE `nilai`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_siswa_id` (`siswa_id`),
  ADD KEY `idx_mapel_id` (`mapel_id`);

--
-- Indexes for table `notifikasi`
--
ALTER TABLE `notifikasi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_dibaca` (`dibaca`);

--
-- Indexes for table `tugas`
--
ALTER TABLE `tugas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_guru_id` (`guru_id`),
  ADD KEY `idx_deadline` (`deadline`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_role` (`role`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `jadwal`
--
ALTER TABLE `jadwal`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `kelas`
--
ALTER TABLE `kelas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `nilai`
--
ALTER TABLE `nilai`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `notifikasi`
--
ALTER TABLE `notifikasi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `tugas`
--
ALTER TABLE `tugas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
