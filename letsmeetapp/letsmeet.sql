-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 15, 2021 at 08:59 AM
-- Server version: 10.4.21-MariaDB
-- PHP Version: 8.0.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `letsmeet`
--

-- --------------------------------------------------------

--
-- Table structure for table `tb_inmeeting`
--

CREATE TABLE `tb_inmeeting` (
  `inmeeting_id` int(11) NOT NULL,
  `reserve_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `Invitestatus` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_inmeeting`
--

INSERT INTO `tb_inmeeting` (`inmeeting_id`, `reserve_id`, `user_id`, `Invitestatus`) VALUES
(29, 33, 2, 1),
(32, 34, 2, 1),
(33, 35, 2, 1),
(34, 36, 2, 1),
(35, 36, 5, 1),
(36, 37, 12, 0),
(37, 36, 13, 1),
(38, 38, 13, 1),
(39, 39, 15, 1),
(40, 39, 13, 1),
(41, 40, 13, 2),
(42, 41, 13, 1),
(43, 41, 16, 0),
(44, 42, 13, 1),
(45, 39, 13, 1),
(46, 39, 17, 0),
(47, 43, 13, 1),
(48, 43, 15, 0),
(49, 43, 17, 0),
(50, 40, 13, 1),
(51, 40, 15, 0),
(52, 40, 17, 0),
(53, 43, 13, 2),
(54, 43, 15, 0),
(55, 43, 17, 0),
(56, 45, 13, 0),
(57, 45, 15, 0),
(58, 45, 17, 0),
(59, 46, 13, 0),
(60, 46, 15, 0),
(61, 46, 17, 0),
(62, 47, 13, 1),
(63, 48, 13, 1),
(64, 48, 15, 0),
(65, 48, 17, 0),
(66, 50, 13, 1),
(67, 50, 15, 0),
(68, 50, 17, 0),
(69, 52, 13, 2),
(70, 52, 15, 0),
(71, 52, 17, 0),
(72, 53, 13, 2),
(73, 53, 15, 0),
(74, 53, 17, 0),
(75, 54, 13, 2),
(76, 54, 15, 0),
(77, 54, 17, 0),
(78, 56, 13, 1),
(79, 56, 15, 0),
(80, 56, 17, 0),
(81, 57, 13, 1),
(82, 57, 15, 0),
(83, 57, 17, 0),
(84, 58, 13, 1),
(85, 58, 15, 0),
(86, 58, 17, 0),
(87, 59, 13, 1),
(88, 59, 15, 0),
(89, 59, 17, 0),
(90, 60, 13, 1),
(91, 60, 15, 0),
(92, 60, 17, 0),
(93, 61, 13, 1),
(94, 61, 15, 0),
(95, 61, 17, 0),
(96, 62, 13, 1),
(97, 62, 19, 1),
(98, 62, 20, 2),
(99, 62, 21, 2),
(100, 50, 19, 2),
(101, 50, 20, 0),
(102, 50, 21, 0),
(103, 64, 13, 1),
(104, 64, 19, 0),
(105, 64, 20, 0),
(106, 64, 21, 0),
(107, 65, 13, 2),
(108, 65, 19, 0),
(109, 65, 20, 0),
(110, 65, 21, 0),
(111, 66, 13, 2),
(112, 66, 19, 0),
(113, 66, 20, 0),
(114, 66, 21, 0),
(115, 66, 21, 0),
(116, 67, 13, 2),
(117, 67, 19, 0),
(118, 67, 20, 0),
(119, 67, 21, 0),
(120, 68, 13, 1),
(121, 68, 19, 0),
(122, 68, 20, 0),
(123, 68, 21, 0);

-- --------------------------------------------------------

--
-- Table structure for table `tb_meetingroom`
--

CREATE TABLE `tb_meetingroom` (
  `room_id` int(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `detail` longtext NOT NULL,
  `size` varchar(255) NOT NULL,
  `price` float NOT NULL,
  `image` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_meetingroom`
--

INSERT INTO `tb_meetingroom` (`room_id`, `name`, `detail`, `size`, `price`, `image`, `status`) VALUES
(13, 'Test_VMS703', '4 Big Desk, 40 Chairs\n', '40', 0, '14102021120656_roomimg.jpg', 1),
(14, 'Test_VMS1003', 'No Desk\n', '80', 0, '14102021121044_roomimg.jpg', 1),
(15, 'Test_VMS0101', 'Many seat', '100', 0, '14102021124042_roomimg.jpg', 1);

-- --------------------------------------------------------

--
-- Table structure for table `tb_reservation`
--

CREATE TABLE `tb_reservation` (
  `reserve_id` int(255) NOT NULL,
  `room_id` varchar(255) NOT NULL,
  `user_id` varchar(255) NOT NULL,
  `dateTime` datetime NOT NULL DEFAULT current_timestamp(),
  `datein` datetime NOT NULL,
  `dateout` datetime NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_reservation`
--

INSERT INTO `tb_reservation` (`reserve_id`, `room_id`, `user_id`, `dateTime`, `datein`, `dateout`, `status`) VALUES
(33, '1', '1', '2021-09-29 09:47:06', '2021-09-29 16:00:00', '2021-09-29 18:00:00', '1'),
(34, '1', '1', '2021-09-29 09:56:09', '2021-09-29 09:00:00', '2021-09-29 11:00:00', '1'),
(35, '1', '1', '2021-09-29 14:28:29', '2021-09-29 13:00:00', '2021-09-29 15:00:00', '1'),
(36, '1', '1', '2021-10-01 11:37:11', '2021-10-01 16:00:00', '2021-10-01 18:00:00', '1'),
(37, '7', '3', '2021-10-01 16:49:26', '2021-10-01 09:00:00', '2021-10-01 11:00:00', '1'),
(38, '1', '14', '2021-10-01 17:06:05', '2021-10-01 19:00:00', '2021-10-01 21:00:00', '1'),
(39, '1', '14', '2021-10-03 17:07:34', '2021-10-05 13:00:00', '2021-10-05 15:00:00', '1'),
(40, '2', '1', '2021-10-04 19:09:05', '2021-10-05 16:00:00', '2021-10-05 18:00:00', '1'),
(41, '8', '14', '2021-10-04 19:12:38', '2021-10-05 13:00:00', '2021-10-05 15:00:00', '1'),
(42, '9', '1', '2021-10-04 19:22:35', '2021-10-05 13:00:00', '2021-10-05 15:00:00', '1'),
(43, '10', '1', '2021-10-05 15:11:04', '2021-10-06 16:00:00', '2021-10-06 18:00:00', '1'),
(44, '10', '14', '2021-10-05 15:12:07', '2021-10-06 19:00:00', '2021-10-06 21:00:00', '1'),
(45, '10', '1', '2021-10-06 14:31:48', '2021-10-06 13:00:00', '2021-10-06 15:00:00', '1'),
(46, '11', '1', '2021-10-06 14:44:42', '2021-10-10 13:00:00', '2021-10-10 15:00:00', '1'),
(47, '1', '1', '2021-10-14 16:53:21', '2021-10-15 16:00:00', '2021-10-15 18:00:00', '1'),
(48, '1', '1', '2021-10-14 16:54:19', '2021-10-15 14:00:00', '2021-10-15 15:00:00', '1'),
(49, '12', '1', '2021-10-14 16:55:32', '2021-10-14 16:55:00', '2021-10-14 17:55:00', '1'),
(50, '13', '1', '2021-10-14 17:07:36', '2021-10-15 18:00:00', '2021-10-15 20:00:00', '1'),
(51, '13', '1', '2021-10-14 17:08:10', '2021-10-14 18:00:00', '2021-10-14 20:00:00', '1'),
(52, '13', '1', '2021-10-14 17:09:17', '2021-10-15 20:01:00', '2021-10-15 22:00:00', '1'),
(53, '14', '1', '2021-10-14 17:11:24', '2021-10-16 12:00:00', '2021-10-16 18:00:00', '1'),
(54, '14', '1', '2021-10-14 17:12:09', '2021-10-17 12:00:00', '2021-10-17 18:11:00', '1'),
(55, '13', '1', '2021-10-14 17:14:26', '2021-10-18 18:00:00', '2021-10-18 20:00:00', '1'),
(56, '13', '1', '2021-10-14 17:17:21', '2021-10-19 12:00:00', '2021-10-19 18:00:00', '1'),
(57, '14', '1', '2021-10-14 17:37:08', '2021-10-19 12:00:00', '2021-10-19 18:00:00', '1'),
(58, '13', '14', '2021-10-14 17:39:15', '2021-10-17 12:00:00', '2021-10-17 18:00:00', '1'),
(59, '15', '1', '2021-10-14 17:44:19', '2021-10-14 12:00:00', '2021-10-14 18:00:00', '1'),
(60, '15', '1', '2021-10-14 17:45:01', '2021-10-14 18:01:00', '2021-10-14 20:00:00', '1'),
(61, '13', '1', '2021-10-14 18:33:42', '2021-10-14 20:01:00', '2021-10-14 00:00:00', '1'),
(62, '13', '1', '2021-10-14 20:13:15', '2021-10-20 12:00:00', '2021-10-20 15:00:00', '1'),
(63, '13', '1', '2021-10-15 00:43:57', '2021-10-15 00:42:00', '2021-10-15 01:42:00', '1'),
(64, '13', '1', '2021-10-15 13:01:56', '2021-10-21 12:00:00', '2021-10-21 18:00:00', '1'),
(65, '14', '1', '2021-10-15 13:04:10', '2021-10-20 13:04:00', '2021-10-20 14:04:00', '1'),
(66, '15', '1', '2021-10-15 13:04:17', '2021-10-20 13:04:00', '2021-10-20 14:04:00', '1'),
(67, '15', '1', '2021-10-15 13:04:25', '2021-10-21 13:04:00', '2021-10-21 14:04:00', '1'),
(68, '13', '14', '2021-10-15 13:35:43', '2021-10-15 13:35:00', '2021-10-15 14:35:00', '1');

-- --------------------------------------------------------

--
-- Table structure for table `tb_user`
--

CREATE TABLE `tb_user` (
  `user_id` int(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `firstname` varchar(255) NOT NULL,
  `lastname` varchar(255) NOT NULL,
  `department` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `age` int(3) NOT NULL,
  `verify_account` int(1) NOT NULL,
  `permission` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_user`
--

INSERT INTO `tb_user` (`user_id`, `username`, `password`, `firstname`, `lastname`, `department`, `email`, `age`, `verify_account`, `permission`) VALUES
(1, 'admin', '1234', 'Natapon', 'Taecheroenchai', 'Sci-Tech', 'u6037621@au.edu', 20, 1, 'Admin'),
(13, 'u6037621', '1234', 'Nathapol', 'Taecharoenchai', '', 'cobrazero1@hotmail.com', 22, 1, 'Participant'),
(14, 'manager_aum', '1234', 'NTP', 'TAE', 'Sci-Tech', 'aumiii@hotmail.com', 22, 1, 'Managers'),
(19, 'u6017637', '1234', 'Phubodee', 'Kongchaoroensukying', 'IT', 'boom262524@hotmail.com', 22, 1, 'Participant'),
(20, 'user3', '1234', 'user3', '33', '33', 'user3@mail.com', 23, 1, 'Participant'),
(21, 'user4', '1234', 'user4', '44', '44', 'user4@mail.com', 23, 1, 'Participant');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tb_inmeeting`
--
ALTER TABLE `tb_inmeeting`
  ADD PRIMARY KEY (`inmeeting_id`);

--
-- Indexes for table `tb_meetingroom`
--
ALTER TABLE `tb_meetingroom`
  ADD PRIMARY KEY (`room_id`);

--
-- Indexes for table `tb_reservation`
--
ALTER TABLE `tb_reservation`
  ADD PRIMARY KEY (`reserve_id`);

--
-- Indexes for table `tb_user`
--
ALTER TABLE `tb_user`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tb_inmeeting`
--
ALTER TABLE `tb_inmeeting`
  MODIFY `inmeeting_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=124;

--
-- AUTO_INCREMENT for table `tb_meetingroom`
--
ALTER TABLE `tb_meetingroom`
  MODIFY `room_id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `tb_reservation`
--
ALTER TABLE `tb_reservation`
  MODIFY `reserve_id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=69;

--
-- AUTO_INCREMENT for table `tb_user`
--
ALTER TABLE `tb_user`
  MODIFY `user_id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
