/*
 Navicat Premium Data Transfer

 Source Server         : local
 Source Server Type    : MariaDB
 Source Server Version : 100424
 Source Host           : localhost:3306
 Source Schema         : biblioteka

 Target Server Type    : MariaDB
 Target Server Version : 100424
 File Encoding         : 65001

 Date: 15/06/2022 15:09:08
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for archiwum_wypozyczenia
-- ----------------------------
DROP TABLE IF EXISTS `archiwum_wypozyczenia`;
CREATE TABLE `archiwum_wypozyczenia`  (
  `id_archiwum_wypo` int(11) NOT NULL AUTO_INCREMENT,
  `id_czytelnika` int(11) NULL DEFAULT NULL,
  `id_egzemplarza` int(11) NOT NULL,
  `id_bibliotekarza_wydal` int(11) NULL DEFAULT NULL,
  `id_bibliotekarza_przyjal` int(11) NULL DEFAULT NULL,
  `data_wypozyczenia` datetime NOT NULL,
  `termin_oddania` date NOT NULL,
  `data_oddania` datetime NOT NULL,
  UNIQUE INDEX `id_archiwum_unique`(`id_archiwum_wypo`, `data_oddania`) USING BTREE,
  INDEX `FK_id_czytelnika_archiwum_wypo`(`id_czytelnika`) USING BTREE,
  INDEX `FK_id_egzemplarza_archiwum_wypo`(`id_egzemplarza`) USING BTREE,
  INDEX `FK_id_bibliotekarza_wydal_archiwum_wypo`(`id_bibliotekarza_wydal`) USING BTREE,
  INDEX `FK_id_bibliotekarza_przyjal_archiwum_wypo`(`id_bibliotekarza_przyjal`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic PARTITION BY RANGE (year(`data_oddania`))
PARTITIONS 3
(PARTITION `rok_do_2021` VALUES LESS THAN (2022) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `rok_2022` VALUES LESS THAN (2023) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `po_2022` VALUES LESS THAN (MAXVALUE) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 )
;

-- ----------------------------
-- Records of archiwum_wypozyczenia
-- ----------------------------
INSERT INTO `archiwum_wypozyczenia` VALUES (1, 2, 4, 1, 1, '2022-06-15 15:05:06', '2022-08-15', '2022-06-15 15:07:19');

-- ----------------------------
-- Table structure for autor
-- ----------------------------
DROP TABLE IF EXISTS `autor`;
CREATE TABLE `autor`  (
  `id_autor` int(11) NOT NULL AUTO_INCREMENT,
  `imie` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `nazwisko` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id_autor`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of autor
-- ----------------------------
INSERT INTO `autor` VALUES (1, 'Carl', 'Sagan');
INSERT INTO `autor` VALUES (2, 'Marek', 'Krośniak');
INSERT INTO `autor` VALUES (3, 'Nick', 'Bilton');
INSERT INTO `autor` VALUES (4, 'Rafał', 'Lisowski');
INSERT INTO `autor` VALUES (5, 'Edward', 'Snowden');
INSERT INTO `autor` VALUES (6, 'Robert C.', 'Martin');

-- ----------------------------
-- Table structure for autorstwo
-- ----------------------------
DROP TABLE IF EXISTS `autorstwo`;
CREATE TABLE `autorstwo`  (
  `id_wydania` int(11) NOT NULL,
  `id_autora` int(11) NOT NULL,
  INDEX `FK_id_wydania_autorstwo`(`id_wydania`) USING BTREE,
  INDEX `FK_id_autora_czytelnik`(`id_autora`) USING BTREE,
  CONSTRAINT `FK_id_autora_czytelnik` FOREIGN KEY (`id_autora`) REFERENCES `autor` (`id_autor`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_id_wydania_autorstwo` FOREIGN KEY (`id_wydania`) REFERENCES `wydanie` (`id_wydanie`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of autorstwo
-- ----------------------------
INSERT INTO `autorstwo` VALUES (1, 1);
INSERT INTO `autorstwo` VALUES (2, 1);
INSERT INTO `autorstwo` VALUES (3, 3);
INSERT INTO `autorstwo` VALUES (5, 4);
INSERT INTO `autorstwo` VALUES (6, 6);

-- ----------------------------
-- Table structure for bibliotekarz
-- ----------------------------
DROP TABLE IF EXISTS `bibliotekarz`;
CREATE TABLE `bibliotekarz`  (
  `id_bibliotekarz` int(11) NOT NULL AUTO_INCREMENT,
  `id_uzytkownika` int(11) NOT NULL,
  PRIMARY KEY (`id_bibliotekarz`) USING BTREE,
  UNIQUE INDEX `id_uzytkownika_bibliotekarz`(`id_uzytkownika`) USING BTREE,
  CONSTRAINT `FK_id_uzytkownika_bibliotekarz` FOREIGN KEY (`id_uzytkownika`) REFERENCES `uzytkownik` (`id_uzytkownik`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bibliotekarz
-- ----------------------------
INSERT INTO `bibliotekarz` VALUES (1, 19);
INSERT INTO `bibliotekarz` VALUES (2, 20);

-- ----------------------------
-- Table structure for egzemplarz
-- ----------------------------
DROP TABLE IF EXISTS `egzemplarz`;
CREATE TABLE `egzemplarz`  (
  `id_egzemplarz` int(11) NOT NULL AUTO_INCREMENT,
  `id_lokalizacji` int(11) NOT NULL,
  `id_wydania` int(11) NOT NULL,
  `stan_egzemplarza` enum('wypozyczona','dostepna','niedostepna','zagubiona') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'dostepna',
  PRIMARY KEY (`id_egzemplarz`) USING BTREE,
  INDEX `FK_id_lokalizacji_egzemplarz`(`id_lokalizacji`) USING BTREE,
  INDEX `FK_id_wydania_egzemplarz`(`id_wydania`) USING BTREE,
  INDEX `FK_id_stanu_egzemplarza_egzemplarz`(`stan_egzemplarza`) USING BTREE,
  CONSTRAINT `FK_id_lokalizacji_egzemplarz` FOREIGN KEY (`id_lokalizacji`) REFERENCES `lokalizacja` (`id_lokalizacja`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_id_wydania_egzemplarz` FOREIGN KEY (`id_wydania`) REFERENCES `wydanie` (`id_wydanie`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of egzemplarz
-- ----------------------------
INSERT INTO `egzemplarz` VALUES (4, 1, 1, 'dostepna');
INSERT INTO `egzemplarz` VALUES (5, 1, 1, 'wypozyczona');
INSERT INTO `egzemplarz` VALUES (6, 1, 2, 'dostepna');
INSERT INTO `egzemplarz` VALUES (7, 1, 2, 'dostepna');
INSERT INTO `egzemplarz` VALUES (8, 2, 2, 'dostepna');

-- ----------------------------
-- Table structure for format
-- ----------------------------
DROP TABLE IF EXISTS `format`;
CREATE TABLE `format`  (
  `id_format` int(11) NOT NULL AUTO_INCREMENT,
  `format` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_format`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of format
-- ----------------------------
INSERT INTO `format` VALUES (1, 'Miękka oprawa');
INSERT INTO `format` VALUES (2, 'Twarda odprawa');

-- ----------------------------
-- Table structure for gatunek
-- ----------------------------
DROP TABLE IF EXISTS `gatunek`;
CREATE TABLE `gatunek`  (
  `id_gatunek` int(11) NOT NULL AUTO_INCREMENT,
  `nazwa_gatunku` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_gatunek`) USING BTREE,
  UNIQUE INDEX `UNIQ_gatunek_nazwa`(`nazwa_gatunku`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gatunek
-- ----------------------------
INSERT INTO `gatunek` VALUES (2, 'Biografia');
INSERT INTO `gatunek` VALUES (4, 'Informatyka');
INSERT INTO `gatunek` VALUES (3, 'Literatura faktu i reportaż');
INSERT INTO `gatunek` VALUES (1, 'Literatura popularno-naukowa');

-- ----------------------------
-- Table structure for gatunki
-- ----------------------------
DROP TABLE IF EXISTS `gatunki`;
CREATE TABLE `gatunki`  (
  `id_ksiazki` int(11) NOT NULL,
  `id_gatunku` int(11) NOT NULL,
  INDEX `FK_id_ksiazki_gatunki`(`id_ksiazki`) USING BTREE,
  INDEX `FK_id_gatunku_gatunki`(`id_gatunku`) USING BTREE,
  CONSTRAINT `FK_id_gatunku_gatunki` FOREIGN KEY (`id_gatunku`) REFERENCES `gatunek` (`id_gatunek`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_id_ksiazki_gatunki` FOREIGN KEY (`id_ksiazki`) REFERENCES `ksiazka` (`id_ksiazka`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gatunki
-- ----------------------------
INSERT INTO `gatunki` VALUES (1, 1);
INSERT INTO `gatunki` VALUES (2, 2);
INSERT INTO `gatunki` VALUES (2, 3);
INSERT INTO `gatunki` VALUES (3, 2);

-- ----------------------------
-- Table structure for jezyk
-- ----------------------------
DROP TABLE IF EXISTS `jezyk`;
CREATE TABLE `jezyk`  (
  `id_jezyk` int(11) NOT NULL AUTO_INCREMENT,
  `jezyk` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `kod_jezyka` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_jezyk`) USING BTREE,
  UNIQUE INDEX `UNIQ_nazwa_jezyka`(`jezyk`) USING BTREE COMMENT 'Nie możemy wprowadzić do bazy dwóch takich samych jezykow',
  UNIQUE INDEX `UNIQ_kod_jezyka`(`kod_jezyka`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of jezyk
-- ----------------------------
INSERT INTO `jezyk` VALUES (1, 'polski', 'PL');
INSERT INTO `jezyk` VALUES (2, 'angielski', 'EN');

-- ----------------------------
-- Table structure for ksiazka
-- ----------------------------
DROP TABLE IF EXISTS `ksiazka`;
CREATE TABLE `ksiazka`  (
  `id_ksiazka` int(11) NOT NULL AUTO_INCREMENT,
  `tytul` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_ksiazka`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ksiazka
-- ----------------------------
INSERT INTO `ksiazka` VALUES (1, 'Pale Blue Dot A Vision of the Human Future in Space');
INSERT INTO `ksiazka` VALUES (2, 'Król darknetu');
INSERT INTO `ksiazka` VALUES (3, 'Permanent Record');
INSERT INTO `ksiazka` VALUES (4, 'Clean Code');

-- ----------------------------
-- Table structure for lokalizacja
-- ----------------------------
DROP TABLE IF EXISTS `lokalizacja`;
CREATE TABLE `lokalizacja`  (
  `id_lokalizacja` int(11) NOT NULL AUTO_INCREMENT,
  `kod_pocztowy` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `miejscowosc` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `ulica` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `numer_domu` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `numer_mieszkania` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id_lokalizacja`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of lokalizacja
-- ----------------------------
INSERT INTO `lokalizacja` VALUES (1, '30-698', 'Kraków', 'Stepowa', '12', NULL);
INSERT INTO `lokalizacja` VALUES (2, '31-231', 'Kraków', 'Jabłonna', '23', NULL);

-- ----------------------------
-- Table structure for rezerwacja
-- ----------------------------
DROP TABLE IF EXISTS `rezerwacja`;
CREATE TABLE `rezerwacja`  (
  `id_rezerwacja` int(11) NOT NULL AUTO_INCREMENT,
  `id_wydania` int(11) NOT NULL,
  `id_czytelnika` int(11) NOT NULL,
  `data_rezerwacji` datetime NOT NULL,
  PRIMARY KEY (`id_rezerwacja`) USING BTREE,
  INDEX `FK_id_czytelnika_rezerwacja`(`id_czytelnika`) USING BTREE,
  INDEX `FK_id_wydania_rezerwacja`(`id_wydania`) USING BTREE,
  CONSTRAINT `FK_id_czytelnika_rezerwacja` FOREIGN KEY (`id_czytelnika`) REFERENCES `uzytkownik` (`id_uzytkownik`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_id_wydania_rezerwacja` FOREIGN KEY (`id_wydania`) REFERENCES `wydanie` (`id_wydanie`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of rezerwacja
-- ----------------------------
INSERT INTO `rezerwacja` VALUES (1, 1, 4, '2022-06-15 15:06:24');
INSERT INTO `rezerwacja` VALUES (2, 1, 5, '2022-06-15 15:06:43');

-- ----------------------------
-- Table structure for tlumaczenie
-- ----------------------------
DROP TABLE IF EXISTS `tlumaczenie`;
CREATE TABLE `tlumaczenie`  (
  `id_wydania` int(11) NOT NULL,
  `id_autora` int(11) NOT NULL,
  INDEX `FK_id_wydania_tlumaczenie`(`id_wydania`) USING BTREE,
  INDEX `FK_id_autora_tlumaczenie`(`id_autora`) USING BTREE,
  CONSTRAINT `FK_id_autora_tlumaczenie` FOREIGN KEY (`id_autora`) REFERENCES `autor` (`id_autor`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_id_wydania_tlumaczenie` FOREIGN KEY (`id_wydania`) REFERENCES `wydanie` (`id_wydanie`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tlumaczenie
-- ----------------------------
INSERT INTO `tlumaczenie` VALUES (2, 2);
INSERT INTO `tlumaczenie` VALUES (3, 4);

-- ----------------------------
-- Table structure for uzytkownik
-- ----------------------------
DROP TABLE IF EXISTS `uzytkownik`;
CREATE TABLE `uzytkownik`  (
  `id_uzytkownik` int(11) NOT NULL AUTO_INCREMENT,
  `pesel` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `imie` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `nazwisko` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `data_urodzenia` date NOT NULL,
  `telefon` varchar(9) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `haslo` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_uzytkownik`) USING BTREE,
  UNIQUE INDEX `unikatowy pesel`(`pesel`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of uzytkownik
-- ----------------------------
INSERT INTO `uzytkownik` VALUES (1, '77041681279', 'rwisoky@gmail.com', 'Miłowita', 'Karczmarczyk', '1977-04-16', '824344794', '6pBUXfrdUCey6EwXMkD4bCDqn3ZAeafK');
INSERT INTO `uzytkownik` VALUES (2, '53121414531', 'mccullough.agustin@hotmail.com', 'Donata', 'Myszkowski', '1953-12-14', '588349650', 'Yg6nWVZhYDguJcSVWVqxYuoLVNLAorLM');
INSERT INTO `uzytkownik` VALUES (3, '47092317331', 'franecki.twila@romaguera.com', 'Kajusz', 'Słoma', '1947-09-23', '451856284', '8gyvCYc24SVcvdyRzoPXgC9CQkDDbQQJ');
INSERT INTO `uzytkownik` VALUES (4, '76012055844', 'nschinner@hayes.com', 'Luiza', 'Krupa', '1976-01-20', '437862341', 'wPDzdfZFymjuYgLX5ZmL4UPjESng9Cq5');
INSERT INTO `uzytkownik` VALUES (5, '75060773199', 'deja21@schuppe.info', 'Gwidona', 'Czerw', '1975-06-07', '175000966', 'Rt4u9uA8fj2DYd3uDNE78TPdcBTKDHfU');
INSERT INTO `uzytkownik` VALUES (6, '78080468414', 'tito26@kuhic.com', 'Koryna', 'Mostowski', '1978-08-04', '518034819', 'AJPaCPGjy9nXLNRP3VmzeAcRBw2EDFZE');
INSERT INTO `uzytkownik` VALUES (7, '76102872951', 'sbechtelar@watsica.info', 'Jolanta', 'Stróżyński', '1976-10-28', '636323658', 'PefSunAtVoQ7B7n4t7487Fp9BPdFVDLb');
INSERT INTO `uzytkownik` VALUES (8, '75010159512', 'bridgette53@hodkiewicz.com', 'Mirosława', 'Podstawka', '1975-01-01', '394904001', 'jrtcdu5ygm6jSRLKoehUk6tnm7sGaDhS');
INSERT INTO `uzytkownik` VALUES (9, '93010328138', 'fhoeger@yahoo.com', 'Samir', 'Gradowski', '1993-01-03', '234521432', 'ubv86Z6MKAv3RGdEnUY7rSScpKkYN2gH');
INSERT INTO `uzytkownik` VALUES (10, '65090628318', 'zkonopelski@yahoo.com', 'Roberta', 'Walecki', '1965-09-06', '439062338', 'Ccf8CLkNLfg4nT88exD5PWGD7r3kSJtU');
INSERT INTO `uzytkownik` VALUES (11, '84082547925', 'qheller@sipes.biz', 'Iwan', 'Sawka', '1984-08-25', '611511012', 'm8tojdBvThXEAwdeuhJHEQMbFeVYoNj9');
INSERT INTO `uzytkownik` VALUES (12, '81062271368', 'cecelia17@cassin.com', 'Protazy', 'Rynkowski', '1981-06-22', '732596067', 'ncW5QXY9EoeEkSjdAsnEHyfPcBdZQWyB');
INSERT INTO `uzytkownik` VALUES (13, '54080314535', 'kirlin.berniece@hotmail.com', 'Nora', 'Michałowicz', '1954-08-03', '310327560', 'yU7Phwonj3s4kaFk3tpbr5q473tnprpo');
INSERT INTO `uzytkownik` VALUES (14, '68032889338', 'wsawayn@funk.info', 'Heliodor', 'Skorupiński', '1968-03-28', '815966167', 'LUBtQqfzR73AG9ma2aKRDzka3dWR5KEf');
INSERT INTO `uzytkownik` VALUES (15, '79092245967', 'williamson.rosamond@jacobson.com', 'Tymora', 'Grochala', '1979-09-22', '757006613', '5F9mwNkMkMNrmyZL8b3cbMMCr9UUkYAP');
INSERT INTO `uzytkownik` VALUES (16, '55070414392', 'mara.oconnell@gmail.com', 'Hermes', 'Olender', '1955-07-04', '966099845', '69z2nke7wsWgrotYYVBz8NCYoWj7nkmR');
INSERT INTO `uzytkownik` VALUES (17, '64122112786', 'milton.hettinger@dibbert.com', 'Jarad', 'Kochan', '1964-12-21', '830336953', 'SmjD6Wa2PxHFmA5JV6JukLS79BDUmqbC');
INSERT INTO `uzytkownik` VALUES (18, '53111892561', 'lakin.harold@brekke.org', 'Dżanan', 'Łączyński', '1953-11-18', '912623394', 'aTGEgh7vffB2f6bBBkvmwNS5QVpBKZEk');
INSERT INTO `uzytkownik` VALUES (19, '82110173971', 'moen.imelda@hotmail.com', 'Cezaria', 'Banasik', '1982-11-01', '333043928', 'kMqZuWVaBWAhtcjvVefRtynHTbK4APNm');
INSERT INTO `uzytkownik` VALUES (20, '81091354984', 'cindy.osinski@oreilly.com', 'Odyla', 'Duliński', '1981-09-13', '734534565', '2CLVZ8v2vwHp8rju6YLXWx7f9gHawVUW');

-- ----------------------------
-- Table structure for wydanie
-- ----------------------------
DROP TABLE IF EXISTS `wydanie`;
CREATE TABLE `wydanie`  (
  `id_wydanie` int(11) NOT NULL AUTO_INCREMENT,
  `tytul_wydania` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `isbn` varchar(17) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `id_ksiazki` int(11) NOT NULL,
  `id_jezyka` int(11) NOT NULL,
  `id_formatu` int(11) NOT NULL,
  `id_wydawnictwa` int(11) NOT NULL,
  PRIMARY KEY (`id_wydanie`) USING BTREE,
  INDEX `FK_id_ksiazki_wydanie`(`id_ksiazki`) USING BTREE,
  INDEX `FK_id_jezyka_wydanie`(`id_jezyka`) USING BTREE,
  INDEX `FK_id_formatu_wydanie`(`id_formatu`) USING BTREE,
  INDEX `FK_id_wydawnictwa_wydanie`(`id_wydawnictwa`) USING BTREE,
  FULLTEXT INDEX `tytul_wydania`(`tytul_wydania`),
  CONSTRAINT `FK_id_formatu_wydanie` FOREIGN KEY (`id_formatu`) REFERENCES `format` (`id_format`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_id_jezyka_wydanie` FOREIGN KEY (`id_jezyka`) REFERENCES `jezyk` (`id_jezyk`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_id_ksiazki_wydanie` FOREIGN KEY (`id_ksiazki`) REFERENCES `ksiazka` (`id_ksiazka`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_id_wydawnictwa_wydanie` FOREIGN KEY (`id_wydawnictwa`) REFERENCES `wydawnictwo` (`id_wydawnictwo`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wydanie
-- ----------------------------
INSERT INTO `wydanie` VALUES (1, 'Pale Blue Dot: A Vision of the Human Future in Space', '9780345376596', 1, 2, 1, 1);
INSERT INTO `wydanie` VALUES (2, 'Błękitna kropka', '9788381162678', 1, 1, 2, 2);
INSERT INTO `wydanie` VALUES (3, 'Król darknetu. Polowanie na genialnego cyberprzestępcę. Wydanie II', '9788381914321', 2, 1, 1, 3);
INSERT INTO `wydanie` VALUES (5, 'Pamięć nieulotna', '9473826591032', 3, 1, 2, 4);
INSERT INTO `wydanie` VALUES (6, 'Czysty kod. Podręcznik dobrego programisty', '9298384710823', 4, 2, 1, 5);

-- ----------------------------
-- Table structure for wydawnictwo
-- ----------------------------
DROP TABLE IF EXISTS `wydawnictwo`;
CREATE TABLE `wydawnictwo`  (
  `id_wydawnictwo` int(11) NOT NULL AUTO_INCREMENT,
  `wydawnictwo` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_wydawnictwo`) USING BTREE,
  UNIQUE INDEX `UNIQ_wydawznictwo_nazwa`(`wydawnictwo`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wydawnictwo
-- ----------------------------
INSERT INTO `wydawnictwo` VALUES (1, 'Ballantine Books');
INSERT INTO `wydawnictwo` VALUES (5, 'Helion');
INSERT INTO `wydawnictwo` VALUES (4, 'Insignis');
INSERT INTO `wydawnictwo` VALUES (3, 'Wydawnictwo czarne');
INSERT INTO `wydawnictwo` VALUES (2, 'Zysk I S-Ka');

-- ----------------------------
-- Table structure for wypozyczenie
-- ----------------------------
DROP TABLE IF EXISTS `wypozyczenie`;
CREATE TABLE `wypozyczenie`  (
  `id_wypozyczenie` int(11) NOT NULL AUTO_INCREMENT,
  `id_czytelnika` int(11) NOT NULL,
  `id_bibliotekarza` int(11) NOT NULL,
  `id_egzemplarza` int(11) NOT NULL,
  `data_wypozyczenia` datetime NOT NULL,
  `termin_oddania` date NOT NULL,
  PRIMARY KEY (`id_wypozyczenie`) USING BTREE,
  INDEX `FK_id_czytelnika_wypozyczenie`(`id_czytelnika`) USING BTREE,
  INDEX `FK_id_bibliotekarza_wypozyczenie`(`id_bibliotekarza`) USING BTREE,
  INDEX `FK_id_egzemplarza_wypozyczenie`(`id_egzemplarza`) USING BTREE,
  CONSTRAINT `FK_id_bibliotekarza_wypozyczenie` FOREIGN KEY (`id_bibliotekarza`) REFERENCES `bibliotekarz` (`id_bibliotekarz`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_id_czytelnika_wypozyczenie` FOREIGN KEY (`id_czytelnika`) REFERENCES `uzytkownik` (`id_uzytkownik`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_id_egzemplarza_wypozyczenie` FOREIGN KEY (`id_egzemplarza`) REFERENCES `egzemplarz` (`id_egzemplarz`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wypozyczenie
-- ----------------------------
INSERT INTO `wypozyczenie` VALUES (4, 2, 1, 5, '2022-06-15 15:06:00', '2022-08-15');

-- ----------------------------
-- View structure for view_licznik_wypozyczen
-- ----------------------------
DROP VIEW IF EXISTS `view_licznik_wypozyczen`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `view_licznik_wypozyczen` AS SELECT 
u.imie,
u.nazwisko,
COUNT(w.id_egzemplarza) AS `liczba wypozyczonych ksiazek`
from uzytkownik AS u, wypozyczenie AS w 
WHERE w.id_czytelnika=u.id_uzytkownik
GROUP BY u.id_uzytkownik ; ;

-- ----------------------------
-- View structure for view_spoznienia
-- ----------------------------
DROP VIEW IF EXISTS `view_spoznienia`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `view_spoznienia` AS select `u`.`id_uzytkownik` AS `id_czytelnika`,`w`.`id_egzemplarza` AS `id_egzemplarza`,`u`.`imie` AS `imie`,`u`.`nazwisko` AS `nazwisko`,`wyd`.`tytul_wydania` AS `tytul`,`w`.`termin_oddania` AS `termin_oddania`,to_days(current_timestamp()) - to_days(`w`.`termin_oddania`) AS `ile dni spoznienia` from (((`wypozyczenie` `w` join `uzytkownik` `u` on(`u`.`id_uzytkownik` = `w`.`id_czytelnika`)) join `egzemplarz` `e` on(`e`.`id_egzemplarz` = `w`.`id_egzemplarza`)) join `wydanie` `wyd` on(`wyd`.`id_wydanie` = `e`.`id_wydania`)) where `w`.`termin_oddania` < current_timestamp() ; ;

-- ----------------------------
-- Procedure structure for anuluj_rezerwacje
-- ----------------------------
DROP PROCEDURE IF EXISTS `anuluj_rezerwacje`;
delimiter ;;
CREATE PROCEDURE `anuluj_rezerwacje`(`_id_rezerwacja` INT(11))
BEGIN
    DELETE FROM rezerwacja WHERE rezerwacja.id_rezerwacja=_id_rezerwacja;
END
;;
delimiter ;

-- ----------------------------
-- Function structure for czy_dostepna
-- ----------------------------
DROP FUNCTION IF EXISTS `czy_dostepna`;
delimiter ;;
CREATE FUNCTION `czy_dostepna`(`id_egzemplarza` INT)
 RETURNS tinyint(4)
BEGIN
	RETURN (SELECT CASE
		WHEN (SELECT stan_egzemplarza FROM egzemplarz WHERE id_egzemplarz = id_egzemplarza) = 'dostepna'
			THEN TRUE
		ELSE 
			FALSE
		END
	);	
END
;;
delimiter ;

-- ----------------------------
-- Function structure for czy_wypozyczona
-- ----------------------------
DROP FUNCTION IF EXISTS `czy_wypozyczona`;
delimiter ;;
CREATE FUNCTION `czy_wypozyczona`(`id_egzemplarza` INT)
 RETURNS tinyint(4)
BEGIN
	RETURN (SELECT CASE
		WHEN (SELECT stan_egzemplarza FROM egzemplarz WHERE id_egzemplarz = id_egzemplarza) = 'wypozyczona'
			THEN TRUE
		ELSE 
			FALSE
		END
	);	
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for dodaj_bibliotekarza
-- ----------------------------
DROP PROCEDURE IF EXISTS `dodaj_bibliotekarza`;
delimiter ;;
CREATE PROCEDURE `dodaj_bibliotekarza`(`id_uzytkownika` INT(11))
BEGIN
	INSERT INTO bibliotekarz(id_uzytkownika) VALUES(id_uzytkownika);
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for dodaj_jezyk
-- ----------------------------
DROP PROCEDURE IF EXISTS `dodaj_jezyk`;
delimiter ;;
CREATE PROCEDURE `dodaj_jezyk`(`jezyk_nazwa` VARCHAR(32),`jezyk_kod` VARCHAR(4))
BEGIN
	INSERT INTO jezyk(jezyk, kod_jezyka) VALUES(jezyk_nazwa, jezyk_kod);
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for dodaj_ksiazke
-- ----------------------------
DROP PROCEDURE IF EXISTS `dodaj_ksiazke`;
delimiter ;;
CREATE PROCEDURE `dodaj_ksiazke`(`tytul` VARCHAR(128))
BEGIN
	INSERT INTO ksiazka(tytul) VALUES(tytul);
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for dodaj_n_egzemplarzy
-- ----------------------------
DROP PROCEDURE IF EXISTS `dodaj_n_egzemplarzy`;
delimiter ;;
CREATE PROCEDURE `dodaj_n_egzemplarzy`(`ilosc` int(11),`id_wydanie` int(11),`id_lokacji` int(11))
BEGIN
	FOR i IN 1 .. ilosc DO
		INSERT INTO egzemplarz(id_wydania, id_lokalizacji) VALUES(id_wydanie, id_lokacji);
	END FOR;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for dodaj_uzytkownika
-- ----------------------------
DROP PROCEDURE IF EXISTS `dodaj_uzytkownika`;
delimiter ;;
CREATE PROCEDURE `dodaj_uzytkownika`(`pesel` VARCHAR(11),`email` VARCHAR(255),`imie` VARCHAR(50),`nazwisko` VARCHAR(80),`telefon` VARCHAR(9),`haslo` VARCHAR(128))
BEGIN
	INSERT INTO uzytkownik(pesel, email, imie, nazwisko, telefon, haslo) VALUES(pesel, email, imie, nazwisko, telefon, haslo);
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for dodaj_wydanie
-- ----------------------------
DROP PROCEDURE IF EXISTS `dodaj_wydanie`;
delimiter ;;
CREATE PROCEDURE `dodaj_wydanie`(`tytul_wydania` VARCHAR(255),`isbn` VARCHAR(17),`id_ksiazka` INT(11),`id_jezyk` INT(11),`id_format` INT(11),`id_wydawnictwo` INT(11))
BEGIN
	INSERT INTO wydanie(tytul_wydania, isbn, id_ksiazki, id_jezyka, id_formatu, id_wydawnictwa) VALUES(tytul_wydania, isbn, id_ksiazka, id_jezyk, id_format, id_wydawnictwo);
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for dodaj_wydawnictwo
-- ----------------------------
DROP PROCEDURE IF EXISTS `dodaj_wydawnictwo`;
delimiter ;;
CREATE PROCEDURE `dodaj_wydawnictwo`(`nazwa_wydawnictwa` VARCHAR(64))
BEGIN
	INSERT INTO wydawnictwo(wydawnictwo) VALUES(nazwa_wydawnictwa);
END
;;
delimiter ;

-- ----------------------------
-- Function structure for ilosc_egzemplarzy_w_lokacji
-- ----------------------------
DROP FUNCTION IF EXISTS `ilosc_egzemplarzy_w_lokacji`;
delimiter ;;
CREATE FUNCTION `ilosc_egzemplarzy_w_lokacji`(`_id_wydania` int(11), `_id_lokacji` int(11))
 RETURNS int(11)
BEGIN
	RETURN (SELECT COUNT(*) FROM egzemplarz WHERE id_wydania = _id_wydania and id_lokalizacji=_id_lokacji and stan_egzemplarza='dostepna');
END
;;
delimiter ;

-- ----------------------------
-- Function structure for ilosc_rezerwacji_na_wydanie
-- ----------------------------
DROP FUNCTION IF EXISTS `ilosc_rezerwacji_na_wydanie`;
delimiter ;;
CREATE FUNCTION `ilosc_rezerwacji_na_wydanie`(`_id_wydania` INT(11))
 RETURNS int(11)
BEGIN
	RETURN (SELECT COUNT(*) FROM rezerwacja WHERE rezerwacja.id_wydania=_id_wydania);
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for oddaj_ksiazke
-- ----------------------------
DROP PROCEDURE IF EXISTS `oddaj_ksiazke`;
delimiter ;;
CREATE PROCEDURE `oddaj_ksiazke`(`_id_egzemplarza` int(11), `_id_bibliotekarza` int(11))
BEGIN

	DECLARE _id_wypozyczenia int(11);
	DECLARE _id_czytelnika int(11);
	DECLARE _id_biblio_wydal int(11);
	DECLARE _data_wypo datetime;
	DECLARE _termin_odd date;
	
	SET _id_wypozyczenia = (SELECT id_wypozyczenie FROM wypozyczenie WHERE _id_egzemplarza=wypozyczenie.id_egzemplarza);
	
	START TRANSACTION;
	
	IF(_id_wypozyczenia is NULL) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ten egzemplarz nie jest wypozyczony';
	END IF;
	
	SELECT id_czytelnika, id_bibliotekarza, data_wypozyczenia, termin_oddania FROM wypozyczenie WHERE _id_wypozyczenia=wypozyczenie.id_wypozyczenie
   INTO _id_czytelnika, _id_biblio_wydal, _data_wypo, _termin_odd;
	
	-- zapisac do archiwum 
	INSERT INTO archiwum_wypozyczenia(id_czytelnika, id_egzemplarza, id_bibliotekarza_wydal, id_bibliotekarza_przyjal, data_wypozyczenia, termin_oddania, data_oddania) VALUES (_id_czytelnika, _id_egzemplarza, _id_biblio_wydal, _id_bibliotekarza, _data_wypo, _termin_odd, now());
	
	-- zmienic status na dostepny 
	UPDATE egzemplarz SET egzemplarz.stan_egzemplarza = 'dostepna' WHERE id_egzemplarz=_id_egzemplarza;
	
	-- usunac rekord z wypozyczenie
	DELETE FROM wypozyczenie WHERE wypozyczenie.id_wypozyczenie=_id_wypozyczenia;
	
	COMMIT;

END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for okresl_autora
-- ----------------------------
DROP PROCEDURE IF EXISTS `okresl_autora`;
delimiter ;;
CREATE PROCEDURE `okresl_autora`(`_id_wydania` INT(11), `_imie` varchar(50), `_nazwisko` varchar(50))
BEGIN
	DECLARE _id_autora int(11);
	SELECT id_autor=_id_autora FROM autor WHERE autor.imie = _imie AND autor.nazwisko = nazwisko;
	IF(_id_autora is NULL) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nie ma takiego autora. Najpierw dodaj nowego autora do bazy';
	ELSE
		INSERT INTO autorstwo(id_autora, id_wydania) VALUES (_id_autora, _id_wydania);
	END IF;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for okresl_gatunek_ksiazki
-- ----------------------------
DROP PROCEDURE IF EXISTS `okresl_gatunek_ksiazki`;
delimiter ;;
CREATE PROCEDURE `okresl_gatunek_ksiazki`(`_id_ksiazki` INT(11), `_id_gatunku` INT(11))
BEGIN
	INSERT INTO gatunki(id_ksiazki, id_gatunku) VALUES (_id_ksiazki, _id_gatunku);
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for okresl_tlumacza
-- ----------------------------
DROP PROCEDURE IF EXISTS `okresl_tlumacza`;
delimiter ;;
CREATE PROCEDURE `okresl_tlumacza`(`_id_wydania` INT(11), `_id_tlumacza` INT(11))
BEGIN
	INSERT INTO tlumaczenie(id_autora, id_wydania) VALUES (_id_tlumacza, _id_wydania);
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for przedluz_wypozyczenie
-- ----------------------------
DROP PROCEDURE IF EXISTS `przedluz_wypozyczenie`;
delimiter ;;
CREATE PROCEDURE `przedluz_wypozyczenie`(id_wypozyczenie int(11))
BEGIN
	UPDATE wypozyczenie 
	SET termin_oddania = ADDDATE(termin_oddania, INTERVAL 2 MONTH);
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for wypozycz_ksiazke
-- ----------------------------
DROP PROCEDURE IF EXISTS `wypozycz_ksiazke`;
delimiter ;;
CREATE PROCEDURE `wypozycz_ksiazke`(`_id_egzemplarza` int(11), `_id_czytelnika` int(11), `_id_bibliotekarza` int(11), `_id_lokalizacji` int(11))
BEGIN
	DECLARE _id_rezer int(11);
	DECLARE _nasza_rezerwacja datetime;
	DECLARE _id_wydania int(11);
	DECLARE _ile_przed_nami int(11);
	DECLARE _ile_rezerwacji_na_wydanie int(11);
	
	-- czy ksiązka jest zarezerwowana przez 
	SET _id_wydania = (SELECT egzemplarz.id_wydania FROM egzemplarz WHERE egzemplarz.id_egzemplarz=_id_egzemplarza);
	SET _id_rezer = (SELECT id_rezerwacja FROM rezerwacja WHERE rezerwacja.id_czytelnika=_id_czytelnika and rezerwacja.id_wydania= _id_wydania);
	SET _ile_rezerwacji_na_wydanie = ilosc_rezerwacji_na_wydanie(_id_wydania);

	START TRANSACTION;
	-- mamy rezerwacje
	IF(_id_rezer is NOT NULL) THEN
		SET _nasza_rezerwacja = (SELECT rezerwacja.data_rezerwacji FROM rezerwacja WHERE rezerwacja.id_rezerwacja=_id_rezer);
		SET _ile_przed_nami = (SELECT COUNT(*) FROM rezerwacja WHERE rezerwacja.id_wydania=_id_wydania and rezerwacja.data_rezerwacji < _nasza_rezerwacja);
		
		-- jestesmy w kolejce, ale jest odpowiednia ilosc egzemplarzy dla nas i wszysktich przed nami
		IF(_ile_przed_nami < ilosc_egzemplarzy_w_lokacji(_id_wydania,_id_lokalizacji)) THEN
			UPDATE egzemplarz SET egzemplarz.stan_egzemplarza = 'wypozyczona' WHERE id_egzemplarz=_id_egzemplarza;
			INSERT INTO wypozyczenie (id_czytelnika, id_bibliotekarza, id_egzemplarza, data_wypozyczenia, termin_oddania)
												VALUES (_id_czytelnika, _id_bibliotekarza, _id_egzemplarza, now(), now() + interval 2 month);
			DELETE FROM rezerwacja WHERE rezerwacja.id_rezerwacja = _id_rezer;
			
		-- nie ma dla nas ksiazki, albo jestemy w za długiej kolejce 
		ELSE 
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nie mozna wypozyczyc ksiazki, czekasz w kolejce rezerwacji';
		END IF;
		
	-- nie mamy rezerwacji
	ELSEIF(_ile_rezerwacji_na_wydanie<ilosc_egzemplarzy_w_lokacji(_id_wydania,_id_lokalizacji)) THEN
		UPDATE egzemplarz SET egzemplarz.stan_egzemplarza = 'wypozyczona' WHERE id_egzemplarz=_id_egzemplarza;
		INSERT INTO wypozyczenie (id_czytelnika, id_bibliotekarza, id_egzemplarza, data_wypozyczenia, termin_oddania)
											VALUES (_id_czytelnika, _id_bibliotekarza, _id_egzemplarza, now(), now() + interval 2 month);

	-- brak dostepnych ksiazek lub wszystkie dostepne zarezerwowane
	ELSE 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nie mozna wypozyczyc ksiazki';
	END IF;
	
COMMIT;
	
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for zarezerwuj_ksiazke
-- ----------------------------
DROP PROCEDURE IF EXISTS `zarezerwuj_ksiazke`;
delimiter ;;
CREATE PROCEDURE `zarezerwuj_ksiazke`(`_id_wydania` int(11), `_id_czytelnika` int(11))
BEGIN
	IF((SELECT COUNT(*) FROM egzemplarz WHERE id_wydania = _id_wydania and stan_egzemplarza='dostepna') > 0) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ksiazka jest dostepna, możesz ja wypozyczyć';
	ELSE 
		INSERT INTO rezerwacja(id_wydania, id_czytelnika, data_rezerwacji) VALUES (_id_wydania, _id_czytelnika, now());
	END IF;
END
;;
delimiter ;

-- ----------------------------
-- Event structure for ustaw_ezgemplarz_jako_zagubiony
-- ----------------------------
DROP EVENT IF EXISTS `ustaw_ezgemplarz_jako_zagubiony`;
delimiter ;;
CREATE EVENT `ustaw_ezgemplarz_jako_zagubiony`
ON SCHEDULE
EVERY '1' WEEK STARTS '2022-06-01 00:00:00'
ON COMPLETION PRESERVE
DO UPDATE egzemplarz
SET egzemplarz.stan_egzemplarza = 'zagubiona'
WHERE (SELECT id_egzemplarz FROM egzemplarz e JOIN wypozyczenie w ON w.id_egzemplarza=e.id_egzemplarz WHERE (SELECT datediff(now(), (SELECT termin_oddania FROM wypozyczenie, egzemplarz WHERE wypozyczenie.id_egzemplarza=egzemplarz.id_egzemplarz)) > 365))=egzemplarz.id_egzemplarz
;
;;
delimiter ;

-- ----------------------------
-- Event structure for usun_stare_logi_archiwum_wypozyczenia
-- ----------------------------
DROP EVENT IF EXISTS `usun_stare_logi_archiwum_wypozyczenia`;
delimiter ;;
CREATE EVENT `usun_stare_logi_archiwum_wypozyczenia`
ON SCHEDULE
EVERY '1' SECOND STARTS '2022-06-13 19:45:00'
ON COMPLETION PRESERVE
DO delete from archiwum_wypozyczenia where datediff(now(), data_oddania) > 3652
;
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table autor
-- ----------------------------
DROP TRIGGER IF EXISTS `TR_i_NameAndSurnameBothNotNull`;
delimiter ;;
CREATE TRIGGER `TR_i_NameAndSurnameBothNotNull` BEFORE INSERT ON `autor` FOR EACH ROW IF (NEW.imie = '' OR NEW.imie IS NULL) AND (NEW.nazwisko = '' OR NEW.nazwisko IS NULL) THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Imie i nazwisko autora nie moze byc puste';
end IF
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table autor
-- ----------------------------
DROP TRIGGER IF EXISTS `TR_u_NameAndSurnameBothNotNull`;
delimiter ;;
CREATE TRIGGER `TR_u_NameAndSurnameBothNotNull` BEFORE UPDATE ON `autor` FOR EACH ROW IF (NEW.imie = '' OR NEW.imie IS NULL) AND (NEW.nazwisko = '' OR NEW.nazwisko IS NULL) THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Imie i nazwisko autora nie moze byc puste';
ELSEIF (OLD.imie = '' OR OLD.imie IS NULL) and (NEW.nazwisko = '' OR NEW.nazwisko IS NULL) THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Imie i nazwisko autora nie moze byc puste';
ELSEIF (NEW.imie = '' OR NEW.imie IS NULL) and (OLD.nazwisko = '' OR OLD.nazwisko IS NULL) THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Imie i nazwisko autora nie moze byc puste';
end if
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table uzytkownik
-- ----------------------------
DROP TRIGGER IF EXISTS `TR_i_telefon`;
delimiter ;;
CREATE TRIGGER `TR_i_telefon` BEFORE INSERT ON `uzytkownik` FOR EACH ROW BEGIN
	IF( NOT new.telefon REGEXP '^[0-9]+$') THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Numer telefonu musi składać się z cyfr';
	ELSEIF( LENGTH(new.telefon) <> 9) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Numer telefonu musi składać się z 9 cyfr';
	END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table uzytkownik
-- ----------------------------
DROP TRIGGER IF EXISTS `TR_i_email`;
delimiter ;;
CREATE TRIGGER `TR_i_email` BEFORE INSERT ON `uzytkownik` FOR EACH ROW BEGIN
	IF (new.email NOT LIKE '%@%.%') THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nieprawidłowy email';
	END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table uzytkownik
-- ----------------------------
DROP TRIGGER IF EXISTS `TR_i_pesel`;
delimiter ;;
CREATE TRIGGER `TR_i_pesel` BEFORE INSERT ON `uzytkownik` FOR EACH ROW BEGIN
	DECLARE wagi_sumy_kontrolnej varchar(11);
	DECLARE suma_kontrolna integer;
	DECLARE i integer;
	DECLARE c char;
	DECLARE tmp integer;
	DECLARE rok integer;
	DECLARE miesiac integer;
	DECLARE str varchar(10);
	
	SET wagi_sumy_kontrolnej = '13791379131';
	SET suma_kontrolna = 0;
	SET i = 1;
	
	IF ( NOT new.pesel REGEXP '^[0-9]+$') THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Numer pesel musi składać się z cyfr';
	ELSEIF (LENGTH(new.pesel) <> 11) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pesel musi składać się z 11 cyfr';
	END IF;

	WHILE (i <= 11) DO
		SET c = SUBSTR(new.pesel,i,1);
		SET suma_kontrolna = suma_kontrolna + CAST(SUBSTR(wagi_sumy_kontrolnej,i,1) as integer) * CAST(c as integer);
		SET i = i + 1;
	END WHILE;
	
	IF (suma_kontrolna%10 <> 0) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pesel jest nieprawidłowy - suma kontrolna nie zgadza się';
	END IF;
	
	SET tmp	= SUBSTR(new.pesel,1,2);
	SET rok = 1900 + tmp;
	SET tmp = SUBSTR(new.pesel,3,1);
	IF (tmp >= 2 AND tmp < 8) THEN
		SET rok = rok + tmp / 2 * 100;
	ELSEIF (tmp>=8) THEN
		SET rok = rok - 100;
	END IF;
	
	SET miesiac = (tmp%2)*10+SUBSTRING(new.pesel,4,1);

	SET new.data_urodzenia = STR_TO_DATE(CONCAT(rok,' ',miesiac,' ',SUBSTR(new.pesel,5,2)), '%Y %c %d');
		
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table uzytkownik
-- ----------------------------
DROP TRIGGER IF EXISTS `TR_u_telefon`;
delimiter ;;
CREATE TRIGGER `TR_u_telefon` BEFORE UPDATE ON `uzytkownik` FOR EACH ROW BEGIN
	IF( NOT new.telefon REGEXP '^[0-9]+$') THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Numer telefonu musi składać się z cyfr';
	ELSEIF( LENGTH(new.telefon) <> 9) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Numer telefonu musi składać się z 9 cyfr';
	END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table uzytkownik
-- ----------------------------
DROP TRIGGER IF EXISTS `TR_u_email`;
delimiter ;;
CREATE TRIGGER `TR_u_email` BEFORE UPDATE ON `uzytkownik` FOR EACH ROW BEGIN
	IF( NOT new.telefon REGEXP '^[0-9]+$') THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Numer telefonu musi składać się z cyfr';
	ELSEIF( LENGTH(new.telefon) <> 9) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Numer telefonu musi składać się z 9 cyfr';
	END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table uzytkownik
-- ----------------------------
DROP TRIGGER IF EXISTS `TR_u_pesel`;
delimiter ;;
CREATE TRIGGER `TR_u_pesel` BEFORE UPDATE ON `uzytkownik` FOR EACH ROW BEGIN
	DECLARE wagi_sumy_kontrolnej varchar(11);
	DECLARE suma_kontrolna integer;
	DECLARE i integer;
	DECLARE c char;
	DECLARE tmp integer;
	DECLARE rok integer;
	DECLARE miesiac integer;
	DECLARE str varchar(10);
	
	SET wagi_sumy_kontrolnej = '13791379131';
	SET suma_kontrolna = 0;
	SET i = 1;
	
	IF ( NOT new.pesel REGEXP '^[0-9]+$') THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Numer pesel musi składać się z cyfr';
	ELSEIF (LENGTH(new.pesel) <> 11) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pesel musi składać się z 11 cyfr';
	END IF;

	WHILE (i <= 11) DO
		SET c = SUBSTR(new.pesel,i,1);
		SET suma_kontrolna = suma_kontrolna + CAST(SUBSTR(wagi_sumy_kontrolnej,i,1) as integer) * CAST(c as integer);
		SET i = i + 1;
	END WHILE;
	
	IF (suma_kontrolna%10 <> 0) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pesel jest nieprawidłowy - suma kontrolna nie zgadza się';
	END IF;
	
	SET tmp	= SUBSTR(new.pesel,1,2);
	SET rok = 1900 + tmp;
	SET tmp = SUBSTR(new.pesel,3,1);
	IF (tmp >= 2 AND tmp < 8) THEN
		SET rok = rok + tmp / 2 * 100;
	ELSEIF (tmp>=8) THEN
		SET rok = rok - 100;
	END IF;
	
	SET miesiac = (tmp%2)*10+SUBSTRING(new.pesel,4,1);

	SET new.data_urodzenia = STR_TO_DATE(CONCAT(rok,' ',miesiac,' ',SUBSTR(new.pesel,5,2)), '%Y %c %d');
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table wypozyczenie
-- ----------------------------
DROP TRIGGER IF EXISTS `TR_u_czas_wypoż`;
delimiter ;;
CREATE TRIGGER `TR_u_czas_wypoż` BEFORE UPDATE ON `wypozyczenie` FOR EACH ROW BEGIN
    IF( new.termin_oddania>ADDDATE(old.data_wypozyczenia, INTERVAL 6 MONTH)) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nie można więcej przedłużyć wypożyczenia.';
    END IF;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
