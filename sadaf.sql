-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 05, 2021 at 08:13 PM
-- Server version: 10.1.38-MariaDB
-- PHP Version: 5.6.40

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sadaf`
--

DELIMITER $$
--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `g2j` (`_edate` DATE) RETURNS VARCHAR(10) CHARSET utf8 BEGIN
declare gy,gm,gd    int ;
declare  g_day_no   int ;
declare  i  int;

declare j_day_no ,  j_np ,  jy , jm , jd  int ;
set gy  = year(_edate)-1600;
set gm = month(_edate)-1;
set gd  = day(_edate)-1;

if  (year(_edate) < 1900  or year(_edate) > 2100  )  or (month(_edate) <1  or month(_edate)  > 12 )   or  (day(_edate) < 1 or day(_edate) > 31 )  then
return 'date-error';
end if;

set g_day_no = 365 * gy + floor((gy+3) /  4) - floor((gy+99) / 100) + floor((gy+399)/ 400);

set i=0;
while i < gm do
  set g_day_no=g_day_no+(select  emon from EMonArray  where _id=i+1);
  set i = i + 1;
end while;
if  gm >1  and ((gy % 4 =0 and gy % 100 !=0)  or  (gy%400=0))   then
  set g_day_no = g_day_no + 1 ;
end if;
set  g_day_no = g_day_no + gd;
set  j_day_no =  g_day_no-79;
set  j_np = floor(j_day_no /  12053);
set  j_day_no = j_day_no % 12053;
set  jy = 979+33 *  j_np + 4  *  floor(j_day_no /  1461);
set j_day_no = j_day_no % 1461;

if   j_day_no >= 366  then
  set jy = jy + floor((j_day_no-1) /  365);
  set j_day_no = (j_day_no-1) % 365;
end if;

set  i=0;
while  i < 11  and j_day_no >=  ( select fmon from FMonArray  where _id= i + 1)  do
  set j_day_no = j_day_no - ( select fmon from FMonArray  where _id = i + 1);
  set  i = i + 1;
end while;

set jm = i+1;
set jd = j_day_no+1;

return  concat_ws('/',jy,if(jm < 10 , concat('0',jm) , jm)    ,if(jd < 10 , concat('0',jd) , jd ));
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `j2g` (`j_y` INT, `j_m` INT, `j_d` INT) RETURNS VARCHAR(10) CHARSET utf8 BEGIN

declare  jy,jm,jd  int ;
declare  j_day_no , g_day_no   , gy,gm,gd  int ;
declare  i int ;
declare  leap  bool;

if  (j_y < 1300  or  j_y > 1450  )  or (j_m <1  or j_m  > 12 )   or  (j_d < 1 or j_d > 31 )  then
return 'date-error';
end if;


set  jy = j_y-979;
set  jm = j_m-1;
set  jd = j_d-1;

set j_day_no = 365 * jy + floor(jy/33) * 8 + floor(((jy%33)+3) /  4);
set i  = 0;
while  i < jm  do
  set j_day_no = j_day_no + (select fmon from FMonArray  where  _id=i+1);
  set i = i+1;
end while;
set  j_day_no = j_day_no + jd;
set  g_day_no = j_day_no+79;
set  gy = 1600 + 400 *  floor(g_day_no /  146097);
set  g_day_no = g_day_no % 146097;
set  leap = true;
if  g_day_no >= 36525  then   
  set g_day_no = g_day_no - 1;
  set gy = gy + 100 * floor(g_day_no /  36524);
  set g_day_no = g_day_no % 36524;
  if  g_day_no >= 365  then
    set g_day_no  =  g_day_no + 1;
  else
    set leap = false;
  end if;
end if;
set gy = gy + 4 *  floor(g_day_no / 1461);
set g_day_no = g_day_no % 1461;
if  g_day_no >= 366  then
  set leap = false;
  set g_day_no = g_day_no - 1 ;
  set gy = gy + floor(g_day_no /  365);
  set g_day_no = g_day_no % 365;
end if;
set  i = 0;
while  g_day_no >= ( select  emon from EMonArray  where _id = i + 1 ) + ( select if(i = 1 and  leap = true , 1 , 0) )   do
  set g_day_no = g_day_no - (( select  emon from EMonArray  where _id = i + 1)  + ( select if ( i = 1 and  leap= true ,1,0)));
  set i = i + 1;
end while;
set gm = i+1;
set gd = g_day_no+1;
return  concat_ws('-',gy , gm , gd );
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `accountspecs`
--

CREATE TABLE `accountspecs` (
  `AccountSpecID` int(11) NOT NULL,
  `UserID` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `UserPassword` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `PersonID` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci;

--
-- Dumping data for table `accountspecs`
--

INSERT INTO `accountspecs` (`AccountSpecID`, `UserID`, `UserPassword`, `PersonID`) VALUES
(1, 'omid', 'omid3000', 1);

-- --------------------------------------------------------

--
-- Table structure for table `docs`
--

CREATE TABLE `docs` (
  `id` int(11) NOT NULL,
  `site_id` int(11) NOT NULL,
  `page` text NOT NULL,
  `link` text NOT NULL,
  `title` text NOT NULL,
  `topic` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `docs`
--

INSERT INTO `docs` (`id`, `site_id`, `page`, `link`, `title`, `topic`) VALUES
(140, 2, 'http://www.pellekan.ir/', 'http://pellekan.ir/Uploads/PDF/pellekan-fehreste-kalahaye-danesh-boniyan.pdf', 'موسسه پلکان | کلینیک تخصصی مالکیت فکری(ثبت اختراع وبرند) ', 'موسسه پلکان | کلینیک تخصصی مالکیت فکری(ثبت اختراع وبرند) '),
(141, 1, 'https://khev.um.ac.ir/index.php/component/content/article/112-%D9%85%D9%88%D8%B3%D8%B3%D9%87-%D8%BA%DB%8C%D8%B1%D9%85%D8%AC%D8%A7%D8%B2/476-2018-10-08-07-05-57.html', 'https://khev.um.ac.ir/images/171/akhbar/akademi.pdf', 'هیأت نظارت،ارزیابی و تضمین کیفیت آموزش عالی  خراسان رضوی', ' (هیأت نظارت، ارزیابی و تضمین کیفیت علوم، تحقیقات و فناوری خراسان رضوی)'),
(142, 1, 'https://khev.um.ac.ir/index.php/component/content/article/112-%D9%85%D9%88%D8%B3%D8%B3%D9%87-%D8%BA%DB%8C%D8%B1%D9%85%D8%AC%D8%A7%D8%B2/476-2018-10-08-07-05-57.html', 'https://khev.um.ac.ir/images/171/test/oloom_shomal.pdf', 'هیأت نظارت،ارزیابی و تضمین کیفیت آموزش عالی  خراسان رضوی', ' (هیأت نظارت، ارزیابی و تضمین کیفیت علوم، تحقیقات و فناوری خراسان رضوی)'),
(143, 1, 'https://khev.um.ac.ir/index.php/component/content/article/112-%D9%85%D9%88%D8%B3%D8%B3%D9%87-%D8%BA%DB%8C%D8%B1%D9%85%D8%AC%D8%A7%D8%B2/476-2018-10-08-07-05-57.html', 'https://khev.um.ac.ir/images/171/test/shahbazi.pdf', 'هیأت نظارت،ارزیابی و تضمین کیفیت آموزش عالی  خراسان رضوی', ' (هیأت نظارت، ارزیابی و تضمین کیفیت علوم، تحقیقات و فناوری خراسان رضوی)'),
(144, 1, 'https://khev.um.ac.ir/index.php/component/content/article/112-%D9%85%D9%88%D8%B3%D8%B3%D9%87-%D8%BA%DB%8C%D8%B1%D9%85%D8%AC%D8%A7%D8%B2/476-2018-10-08-07-05-57.html', 'https://khev.um.ac.ir/images/171/akhbar/arvand.pdf', 'هیأت نظارت،ارزیابی و تضمین کیفیت آموزش عالی  خراسان رضوی', ' (هیأت نظارت، ارزیابی و تضمین کیفیت علوم، تحقیقات و فناوری خراسان رضوی)'),
(145, 1, 'https://khev.um.ac.ir/index.php/component/content/article/112-%D9%85%D9%88%D8%B3%D8%B3%D9%87-%D8%BA%DB%8C%D8%B1%D9%85%D8%AC%D8%A7%D8%B2/476-2018-10-08-07-05-57.html', 'https://khev.um.ac.ir/images/171/mahortos.pdf', 'هیأت نظارت،ارزیابی و تضمین کیفیت آموزش عالی  خراسان رضوی', ' (هیأت نظارت، ارزیابی و تضمین کیفیت علوم، تحقیقات و فناوری خراسان رضوی)'),
(146, 1, 'https://khev.um.ac.ir/index.php/component/content/article/112-%D9%85%D9%88%D8%B3%D8%B3%D9%87-%D8%BA%DB%8C%D8%B1%D9%85%D8%AC%D8%A7%D8%B2/476-2018-10-08-07-05-57.html', 'https://khev.um.ac.ir/images/171/shojaei/kian_fmojavez.pdf', 'هیأت نظارت،ارزیابی و تضمین کیفیت آموزش عالی  خراسان رضوی', ' (هیأت نظارت، ارزیابی و تضمین کیفیت علوم، تحقیقات و فناوری خراسان رضوی)'),
(147, 1, 'https://khev.um.ac.ir/index.php/component/content/article/106-%D9%85%D9%86%D8%A7%D8%A8%D8%B9-%D8%B9%D9%84%D9%85%DB%8C/685-%D9%BE%D8%A7%DB%8C%D8%A7%D9%86-%D9%86%D8%A7%D9%85%D9%87.html', 'https://khev.um.ac.ir/images/171/new/aiinnameha/payanname/%D8%AA%D9%87%D8%AF%DB%8C%D8%AF%D8%A7%D8%AA_%D9%88_%D9%81%D8%B1%D8%B5%D8%AA%D9%87%D8%A7%DB%8C_%D9%BE%D8%AF%DB%8C%D8%AF%D9%87_%D8%AC%D9%87%D8%A7%D9%86%DB%8C_%D8%B4%D8%AF%D9%86_%D8%A8%D8%B1_%D8%A2%D9%85%D9%88%D8%B2%D8%B4_%D8%B9%D8%A7%D9%84%DB%8C_%D8%AE%D9%84%D8%A7%D8%B5%D9%87.pdf', 'هیأت نظارت،ارزیابی و تضمین کیفیت آموزش عالی  خراسان رضوی', ' (هیأت نظارت، ارزیابی و تضمین کیفیت علوم، تحقیقات و فناوری خراسان رضوی)'),
(148, 1, 'https://khev.um.ac.ir/index.php/component/content/article/106-%D9%85%D9%86%D8%A7%D8%A8%D8%B9-%D8%B9%D9%84%D9%85%DB%8C/685-%D9%BE%D8%A7%DB%8C%D8%A7%D9%86-%D9%86%D8%A7%D9%85%D9%87.html', 'https://khev.um.ac.ir/images/171/new/aiinnameha/payanname/%20%20%20%20%20%20%20%20.pdf', 'هیأت نظارت،ارزیابی و تضمین کیفیت آموزش عالی  خراسان رضوی', ' (هیأت نظارت، ارزیابی و تضمین کیفیت علوم، تحقیقات و فناوری خراسان رضوی)'),
(149, 1, 'https://khev.um.ac.ir/index.php/component/content/article/106-%D9%85%D9%86%D8%A7%D8%A8%D8%B9-%D8%B9%D9%84%D9%85%DB%8C/685-%D9%BE%D8%A7%DB%8C%D8%A7%D9%86-%D9%86%D8%A7%D9%85%D9%87.html', 'https://khev.um.ac.ir/images/171/new/aiinnameha/payanname/brasii%20avamel%20kholashe.pdf', 'هیأت نظارت،ارزیابی و تضمین کیفیت آموزش عالی  خراسان رضوی', ' (هیأت نظارت، ارزیابی و تضمین کیفیت علوم، تحقیقات و فناوری خراسان رضوی)'),
(150, 1, 'https://khev.um.ac.ir/index.php/component/content/article/106-%D9%85%D9%86%D8%A7%D8%A8%D8%B9-%D8%B9%D9%84%D9%85%DB%8C/685-%D9%BE%D8%A7%DB%8C%D8%A7%D9%86-%D9%86%D8%A7%D9%85%D9%87.html', 'https://khev.um.ac.ir/images/171/new/aiinnameha/payanname/%D8%A8%D8%B1%D8%B1%D8%B3%DB%8C_%D8%AA%D8%B7%D8%A8%DB%8C%D9%82%DB%8C_%D8%A7%D9%84%DA%AF%D9%88%D9%87%D8%A7%DB%8C_%D8%AA%D9%88%D8%B3%D8%B9%D9%87_%DA%A9%D9%85%DB%8C_%D9%88_%DA%A9%DB%8C%D9%81%DB%8C_%D8%A2%D9%85%D9%88%D8%B2%D8%B4_%D8%B9%D8%A7%D9%84%DB%8C_%D8%AF%D8%B1_%DA%A9%D8%B4%D9%88%D8%B1%D9%87%D8%A7%DB%8C_%D8%A7%DB%8C%D8%B1%D8%A7%D9%86_%D8%B3%D9%88%D8%A6%D8%AF_%D9%88_%D9%86%D8%B1%D9%88%DA%98_%D8%AE%D9%84%D8%A7%D8%B5%D9%87.pdf', 'هیأت نظارت،ارزیابی و تضمین کیفیت آموزش عالی  خراسان رضوی', ' (هیأت نظارت، ارزیابی و تضمین کیفیت علوم، تحقیقات و فناوری خراسان رضوی)'),
(151, 1, 'https://khev.um.ac.ir/index.php/component/content/article/106-%D9%85%D9%86%D8%A7%D8%A8%D8%B9-%D8%B9%D9%84%D9%85%DB%8C/685-%D9%BE%D8%A7%DB%8C%D8%A7%D9%86-%D9%86%D8%A7%D9%85%D9%87.html', 'https://khev.um.ac.ir/images/171/new/aiinnameha/payanname/barresi%20tatbighi%20norvezh.pdf', 'هیأت نظارت،ارزیابی و تضمین کیفیت آموزش عالی  خراسان رضوی', ' (هیأت نظارت، ارزیابی و تضمین کیفیت علوم، تحقیقات و فناوری خراسان رضوی)'),
(152, 1, 'https://khev.um.ac.ir/index.php/component/content/article/106-%D9%85%D9%86%D8%A7%D8%A8%D8%B9-%D8%B9%D9%84%D9%85%DB%8C/685-%D9%BE%D8%A7%DB%8C%D8%A7%D9%86-%D9%86%D8%A7%D9%85%D9%87.html', 'https://khev.um.ac.ir/images/171/new/aiinnameha/payanname/arzyabi%20mizan%20barkhordari.pdf', 'هیأت نظارت،ارزیابی و تضمین کیفیت آموزش عالی  خراسان رضوی', ' (هیأت نظارت، ارزیابی و تضمین کیفیت علوم، تحقیقات و فناوری خراسان رضوی)'),
(153, 1, 'https://khev.um.ac.ir/index.php/component/content/article/106-%D9%85%D9%86%D8%A7%D8%A8%D8%B9-%D8%B9%D9%84%D9%85%DB%8C/627-%D8%AE%D8%A8%D8%B1%D9%86%D8%A7%D9%85%D9%87-%D8%A2%D9%85%D9%88%D8%B2%D8%B4-%D8%B9%D8%A7%D9%84%DB%8C.html', 'https://khev.um.ac.ir/images/171/khabarname/khabarname8.pdf', 'هیأت نظارت،ارزیابی و تضمین کیفیت آموزش عالی  خراسان رضوی', ' (هیأت نظارت، ارزیابی و تضمین کیفیت علوم، تحقیقات و فناوری خراسان رضوی)'),
(154, 1, 'https://khev.um.ac.ir/index.php/component/content/article/106-%D9%85%D9%86%D8%A7%D8%A8%D8%B9-%D8%B9%D9%84%D9%85%DB%8C/627-%D8%AE%D8%A8%D8%B1%D9%86%D8%A7%D9%85%D9%87-%D8%A2%D9%85%D9%88%D8%B2%D8%B4-%D8%B9%D8%A7%D9%84%DB%8C.html', 'https://khev.um.ac.ir/images/171/khabarname/KHABARNAME7.pdf', 'هیأت نظارت،ارزیابی و تضمین کیفیت آموزش عالی  خراسان رضوی', ' (هیأت نظارت، ارزیابی و تضمین کیفیت علوم، تحقیقات و فناوری خراسان رضوی)'),
(155, 1, 'https://khev.um.ac.ir/index.php/component/content/article/106-%D9%85%D9%86%D8%A7%D8%A8%D8%B9-%D8%B9%D9%84%D9%85%DB%8C/627-%D8%AE%D8%A8%D8%B1%D9%86%D8%A7%D9%85%D9%87-%D8%A2%D9%85%D9%88%D8%B2%D8%B4-%D8%B9%D8%A7%D9%84%DB%8C.html', 'https://khev.um.ac.ir/images/171/khabarname/khabarname6.pdf', 'هیأت نظارت،ارزیابی و تضمین کیفیت آموزش عالی  خراسان رضوی', ' (هیأت نظارت، ارزیابی و تضمین کیفیت علوم، تحقیقات و فناوری خراسان رضوی)'),
(156, 1, 'https://khev.um.ac.ir/index.php/component/content/article/106-%D9%85%D9%86%D8%A7%D8%A8%D8%B9-%D8%B9%D9%84%D9%85%DB%8C/627-%D8%AE%D8%A8%D8%B1%D9%86%D8%A7%D9%85%D9%87-%D8%A2%D9%85%D9%88%D8%B2%D8%B4-%D8%B9%D8%A7%D9%84%DB%8C.html', 'https://khev.um.ac.ir/images/171/khabarname/khabarname5.pdf', 'هیأت نظارت،ارزیابی و تضمین کیفیت آموزش عالی  خراسان رضوی', ' (هیأت نظارت، ارزیابی و تضمین کیفیت علوم، تحقیقات و فناوری خراسان رضوی)'),
(157, 1, 'https://khev.um.ac.ir/index.php/component/content/article/106-%D9%85%D9%86%D8%A7%D8%A8%D8%B9-%D8%B9%D9%84%D9%85%DB%8C/627-%D8%AE%D8%A8%D8%B1%D9%86%D8%A7%D9%85%D9%87-%D8%A2%D9%85%D9%88%D8%B2%D8%B4-%D8%B9%D8%A7%D9%84%DB%8C.html', 'https://khev.um.ac.ir/images/171/khabarname/khabarname4.pdf', 'هیأت نظارت،ارزیابی و تضمین کیفیت آموزش عالی  خراسان رضوی', ' (هیأت نظارت، ارزیابی و تضمین کیفیت علوم، تحقیقات و فناوری خراسان رضوی)'),
(158, 1, 'https://khev.um.ac.ir/index.php/component/content/article/106-%D9%85%D9%86%D8%A7%D8%A8%D8%B9-%D8%B9%D9%84%D9%85%DB%8C/627-%D8%AE%D8%A8%D8%B1%D9%86%D8%A7%D9%85%D9%87-%D8%A2%D9%85%D9%88%D8%B2%D8%B4-%D8%B9%D8%A7%D9%84%DB%8C.html', 'https://khev.um.ac.ir/images/171/test/khabarname/khabarname3.pdf', 'هیأت نظارت،ارزیابی و تضمین کیفیت آموزش عالی  خراسان رضوی', ' (هیأت نظارت، ارزیابی و تضمین کیفیت علوم، تحقیقات و فناوری خراسان رضوی)'),
(159, 1, 'https://khev.um.ac.ir/index.php/component/content/article/106-%D9%85%D9%86%D8%A7%D8%A8%D8%B9-%D8%B9%D9%84%D9%85%DB%8C/627-%D8%AE%D8%A8%D8%B1%D9%86%D8%A7%D9%85%D9%87-%D8%A2%D9%85%D9%88%D8%B2%D8%B4-%D8%B9%D8%A7%D9%84%DB%8C.html', 'https://khev.um.ac.ir/images/171/test/khabarname/khabarname2.pdf', 'هیأت نظارت،ارزیابی و تضمین کیفیت آموزش عالی  خراسان رضوی', ' (هیأت نظارت، ارزیابی و تضمین کیفیت علوم، تحقیقات و فناوری خراسان رضوی)'),
(160, 1, 'https://khev.um.ac.ir/index.php/component/content/article/106-%D9%85%D9%86%D8%A7%D8%A8%D8%B9-%D8%B9%D9%84%D9%85%DB%8C/627-%D8%AE%D8%A8%D8%B1%D9%86%D8%A7%D9%85%D9%87-%D8%A2%D9%85%D9%88%D8%B2%D8%B4-%D8%B9%D8%A7%D9%84%DB%8C.html', 'https://khev.um.ac.ir/images/171/test/khabarname/khabarname1.pdf', 'هیأت نظارت،ارزیابی و تضمین کیفیت آموزش عالی  خراسان رضوی', ' (هیأت نظارت، ارزیابی و تضمین کیفیت علوم، تحقیقات و فناوری خراسان رضوی)'),
(161, 1, 'https://khev.um.ac.ir/index.php/component/content/article/106-%D9%85%D9%86%D8%A7%D8%A8%D8%B9-%D8%B9%D9%84%D9%85%DB%8C/735-%D9%85%D8%AC%D9%85%D9%88%D8%B9%D9%87-%D9%85%D9%82%D8%A7%D9%84%D8%A7%D8%AA-%DA%A9%D9%86%D9%81%D8%B1%D8%A7%D9%86%D8%B3%E2%80%8C%D9%87%D8%A7.html', 'https://khev.um.ac.ir/images/171/akhbar/13homin.pdf', 'هیأت نظارت،ارزیابی و تضمین کیفیت آموزش عالی  خراسان رضوی', ' (هیأت نظارت، ارزیابی و تضمین کیفیت علوم، تحقیقات و فناوری خراسان رضوی)'),
(162, 1, 'https://khev.um.ac.ir/index.php/component/content/article/106-%D9%85%D9%86%D8%A7%D8%A8%D8%B9-%D8%B9%D9%84%D9%85%DB%8C/735-%D9%85%D8%AC%D9%85%D9%88%D8%B9%D9%87-%D9%85%D9%82%D8%A7%D9%84%D8%A7%D8%AA-%DA%A9%D9%86%D9%81%D8%B1%D8%A7%D9%86%D8%B3%E2%80%8C%D9%87%D8%A7.html', 'https://khev.um.ac.ir/images/171/akhbar/12homin.pdf', 'هیأت نظارت،ارزیابی و تضمین کیفیت آموزش عالی  خراسان رضوی', ' (هیأت نظارت، ارزیابی و تضمین کیفیت علوم، تحقیقات و فناوری خراسان رضوی)'),
(163, 1, 'https://khev.um.ac.ir/index.php/component/content/article/106-%D9%85%D9%86%D8%A7%D8%A8%D8%B9-%D8%B9%D9%84%D9%85%DB%8C/735-%D9%85%D8%AC%D9%85%D9%88%D8%B9%D9%87-%D9%85%D9%82%D8%A7%D9%84%D8%A7%D8%AA-%DA%A9%D9%86%D9%81%D8%B1%D8%A7%D9%86%D8%B3%E2%80%8C%D9%87%D8%A7.html', 'https://khev.um.ac.ir/images/171/akhbar/11homin.pdf', 'هیأت نظارت،ارزیابی و تضمین کیفیت آموزش عالی  خراسان رضوی', ' (هیأت نظارت، ارزیابی و تضمین کیفیت علوم، تحقیقات و فناوری خراسان رضوی)'),
(164, 4, 'https://tvu.ac.ir/./fa/content/id/id=463184', 'https://tvu.ac.ir/./fa/content/id/id=463184/./file/2/attach2019091167786100195667.pdf', '           ارتباط با ما |         دانشگاه فنی و حرفه ای  ', 'ارتباط با ما'),
(165, 4, 'https://tvu.ac.ir/./fa/562205/-', 'https://tvu.ac.ir/./fa/562205/-/./file/2/attach2021012665492460341129.pdf', '           . |         دانشگاه فنی و حرفه ای  ', '.'),
(166, 4, 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594', 'https://tvu.ac.ir/file/2/attach2020121311300892329249.pdf', '           خبرنامه دانشگاه فنی و حرفه ای |         دانشگاه فنی و حرفه ای  ', 'خبرنامه دانشگاه فنی و حرفه ای'),
(167, 4, 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594', 'https://tvu.ac.ir/file/2/attach2021012449352542335890.pdf', '           خبرنامه دانشگاه فنی و حرفه ای |         دانشگاه فنی و حرفه ای  ', 'خبرنامه دانشگاه فنی و حرفه ای'),
(168, 4, 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594', 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594/./file/2/attach201710370375933698377.pdf', '           خبرنامه دانشگاه فنی و حرفه ای |         دانشگاه فنی و حرفه ای  ', 'خبرنامه دانشگاه فنی و حرفه ای'),
(169, 4, 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594', 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594/./file/2/attach2018013107045570109044.pdf', '           خبرنامه دانشگاه فنی و حرفه ای |         دانشگاه فنی و حرفه ای  ', 'خبرنامه دانشگاه فنی و حرفه ای'),
(170, 4, 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594', 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594/./file/2/attach2018032285334336114239.pdf', '           خبرنامه دانشگاه فنی و حرفه ای |         دانشگاه فنی و حرفه ای  ', 'خبرنامه دانشگاه فنی و حرفه ای'),
(171, 4, 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594', 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594/./file/2/attach2018043325914778116130.pdf', '           خبرنامه دانشگاه فنی و حرفه ای |         دانشگاه فنی و حرفه ای  ', 'خبرنامه دانشگاه فنی و حرفه ای'),
(172, 4, 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594', 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594/./file/2/attach2018052699555128119474.pdf', '           خبرنامه دانشگاه فنی و حرفه ای |         دانشگاه فنی و حرفه ای  ', 'خبرنامه دانشگاه فنی و حرفه ای'),
(173, 4, 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594', 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594/./file/2/attach2018061397047326123216.pdf', '           خبرنامه دانشگاه فنی و حرفه ای |         دانشگاه فنی و حرفه ای  ', 'خبرنامه دانشگاه فنی و حرفه ای'),
(174, 4, 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594', 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594/./file/2/attach2018073347131300126003.pdf', '           خبرنامه دانشگاه فنی و حرفه ای |         دانشگاه فنی و حرفه ای  ', 'خبرنامه دانشگاه فنی و حرفه ای'),
(175, 4, 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594', 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594/./file/2/attach2018093830644814129311.pdf', '           خبرنامه دانشگاه فنی و حرفه ای |         دانشگاه فنی و حرفه ای  ', 'خبرنامه دانشگاه فنی و حرفه ای'),
(176, 4, 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594', 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594/./file/2/attach2018092919933428133390.pdf', '           خبرنامه دانشگاه فنی و حرفه ای |         دانشگاه فنی و حرفه ای  ', 'خبرنامه دانشگاه فنی و حرفه ای'),
(177, 4, 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594', 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594/./file/2/attach2018112898053240137334.pdf', '           خبرنامه دانشگاه فنی و حرفه ای |         دانشگاه فنی و حرفه ای  ', 'خبرنامه دانشگاه فنی و حرفه ای'),
(178, 4, 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594', 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594/./file/2/attach2018121746460972146107.pdf', '           خبرنامه دانشگاه فنی و حرفه ای |         دانشگاه فنی و حرفه ای  ', 'خبرنامه دانشگاه فنی و حرفه ای'),
(179, 4, 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594', 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594/./file/2/attach2019032132158402157428.pdf', '           خبرنامه دانشگاه فنی و حرفه ای |         دانشگاه فنی و حرفه ای  ', 'خبرنامه دانشگاه فنی و حرفه ای'),
(180, 4, 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594', 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594/./file/2/attach2019062652587584176237.pdf', '           خبرنامه دانشگاه فنی و حرفه ای |         دانشگاه فنی و حرفه ای  ', 'خبرنامه دانشگاه فنی و حرفه ای'),
(181, 4, 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594', 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594/./file/2/attach2019083292753588188333.pdf', '           خبرنامه دانشگاه فنی و حرفه ای |         دانشگاه فنی و حرفه ای  ', 'خبرنامه دانشگاه فنی و حرفه ای'),
(182, 4, 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594', 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594/./file/2/attach2019091625593302197501.pdf', '           خبرنامه دانشگاه فنی و حرفه ای |         دانشگاه فنی و حرفه ای  ', 'خبرنامه دانشگاه فنی و حرفه ای'),
(183, 4, 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594', 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594/./file/2/attach2019111264732722206447.pdf', '           خبرنامه دانشگاه فنی و حرفه ای |         دانشگاه فنی و حرفه ای  ', 'خبرنامه دانشگاه فنی و حرفه ای'),
(184, 4, 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594', 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594/./file/2/attach2021012449352542335890.pdf', '           خبرنامه دانشگاه فنی و حرفه ای |         دانشگاه فنی و حرفه ای  ', 'خبرنامه دانشگاه فنی و حرفه ای'),
(185, 4, 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594', 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594/./file/2/attach2020121311300892329249.pdf', '           خبرنامه دانشگاه فنی و حرفه ای |         دانشگاه فنی و حرفه ای  ', 'خبرنامه دانشگاه فنی و حرفه ای'),
(186, 4, 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594', 'https://tvu.ac.ir/./fa/link/id/id=136496/token=3713913594/./file/2/attach2021012847057450335909.pdf', '           خبرنامه دانشگاه فنی و حرفه ای |         دانشگاه فنی و حرفه ای  ', 'خبرنامه دانشگاه فنی و حرفه ای'),
(187, 4, 'https://tvu.ac.ir/./fa/560361/%D9%88%DB%8C%DA%98%D9%87-%D9%86%D8%A7%D9%85%D9%87-%D9%87%D9%81%D8%AA%D9%87-%D9%85%D9%84%DB%8C-%D9%85%D9%87%D8%A7%D8%B1%D8%AA%D8%8C-%DA%A9%D8%A7%D8%B1%D8%A2%D9%81%D8%B1%DB%8C%D9%86%DB%8C-%D9%88-%D8%A2%D9%85%D9%88%D8%B2%D8%B4-%D9%87%D8%A7%DB%8C-%D9%81%D9%86%DB%8C-%D9%88-%D8%AD%D8%B1%D9%81%D9%87-%D8%A7%DB%8C', 'https://tvu.ac.ir/./fa/560361/%D9%88%DB%8C%DA%98%D9%87-%D9%86%D8%A7%D9%85%D9%87-%D9%87%D9%81%D8%AA%D9%87-%D9%85%D9%84%DB%8C-%D9%85%D9%87%D8%A7%D8%B1%D8%AA%D8%8C-%DA%A9%D8%A7%D8%B1%D8%A2%D9%81%D8%B1%DB%8C%D9%86%DB%8C-%D9%88-%D8%A2%D9%85%D9%88%D8%B2%D8%B4-%D9%87%D8%A7%DB%8C-%D9%81%D9%86%DB%8C-%D9%88-%D8%AD%D8%B1%D9%81%D9%87-%D8%A7%DB%8C/./file/2/attach2021014061466672335901.pdf', '           ویژه نامه هفته ملی مهارت، کارآفرینی و آموزش های فنی و حرفه ای |         دانشگاه فنی و حرفه ای  ', 'ویژه نامه هفته ملی مهارت، کارآفرینی و آموزش های فنی و حرفه ای'),
(188, 4, 'https://tvu.ac.ir/./fa/553761/%D8%AF%D9%88%D8%A7%D8%B2%D8%AF%D9%85%DB%8C%D9%86-%D8%B4%D9%85%D8%A7%D8%B1%D9%87-%D8%AE%D8%A8%D8%B1%D9%86%D8%A7%D9%85%D9%87-%D8%A2%D9%85%D9%88%D8%B2%D8%B4-%D8%B9%D8%A7%D9%84%DB%8C', 'https://tvu.ac.ir/./fa/553761/%D8%AF%D9%88%D8%A7%D8%B2%D8%AF%D9%85%DB%8C%D9%86-%D8%B4%D9%85%D8%A7%D8%B1%D9%87-%D8%AE%D8%A8%D8%B1%D9%86%D8%A7%D9%85%D9%87-%D8%A2%D9%85%D9%88%D8%B2%D8%B4-%D8%B9%D8%A7%D9%84%DB%8C/./file/2/attach2020112341477838320474.pdf', '           دوازدمین شماره خبرنامه آموزش عالی |         دانشگاه فنی و حرفه ای  ', 'دوازدمین شماره خبرنامه آموزش عالی'),
(189, 4, 'https://tvu.ac.ir/./fa/549152/%DB%8C%D8%A7%D8%B2%D8%AF%D9%87%D9%85%DB%8C%D9%86-%D8%B4%D9%85%D8%A7%D8%B1%D9%87-%D8%AE%D8%A8%D8%B1%D9%86%D8%A7%D9%85%D9%87-%D8%A2%D9%85%D9%88%D8%B2%D8%B4-%D8%B9%D8%A7%D9%84%DB%8C', 'https://tvu.ac.ir/./fa/549152/%DB%8C%D8%A7%D8%B2%D8%AF%D9%87%D9%85%DB%8C%D9%86-%D8%B4%D9%85%D8%A7%D8%B1%D9%87-%D8%AE%D8%A8%D8%B1%D9%86%D8%A7%D9%85%D9%87-%D8%A2%D9%85%D9%88%D8%B2%D8%B4-%D8%B9%D8%A7%D9%84%DB%8C/./file/2/attach2020101282980874309522.pdf', '           یازدهمین شماره خبرنامه آموزش عالی |         دانشگاه فنی و حرفه ای  ', 'یازدهمین شماره خبرنامه آموزش عالی'),
(190, 4, 'https://tvu.ac.ir/./fa/548860/%D8%B4%D9%85%D8%A7%D8%B1%D9%87-%D8%B3%D9%88%D9%85-%D9%86%D8%B4%D8%B1%DB%8C%D9%87-%D9%81%D9%86-%D9%88%D8%B1%D8%B2-%D8%AF%D8%A7%D9%86%D8%B4%DA%AF%D8%A7%D9%87-%D9%81%D9%86%DB%8C-%D9%88-%D8%AD%D8%B1%D9%81%D9%87-%D8%A7%DB%8C-%D8%A7%D8%B3%D8%AA%D8%A7%D9%86-%D9%81%D8%A7%D8%B1%D8%B3', 'https://tvu.ac.ir/./fa/548860/%D8%B4%D9%85%D8%A7%D8%B1%D9%87-%D8%B3%D9%88%D9%85-%D9%86%D8%B4%D8%B1%DB%8C%D9%87-%D9%81%D9%86-%D9%88%D8%B1%D8%B2-%D8%AF%D8%A7%D9%86%D8%B4%DA%AF%D8%A7%D9%87-%D9%81%D9%86%DB%8C-%D9%88-%D8%AD%D8%B1%D9%81%D9%87-%D8%A7%DB%8C-%D8%A7%D8%B3%D8%AA%D8%A7%D9%86-%D9%81%D8%A7%D8%B1%D8%B3/./file/2/attach2020102483594698308960.pdf', '           شماره سوم نشریه فن ورز دانشگاه فنی و حرفه ای استان فارس |         دانشگاه فنی و حرفه ای  ', 'شماره سوم نشریه فن ورز دانشگاه فنی و حرفه ای استان فارس'),
(191, 4, 'https://tvu.ac.ir/./fa/545977/%D9%86%D8%B3%D8%AE%D9%87-%D8%A7%D9%84%DA%A9%D8%AA%D8%B1%D9%88%D9%86%DB%8C%DA%A9%DB%8C-%D8%B4%D9%85%D8%A7%D8%B1%D9%87-%DB%B4-\"%D8%A7%D9%86%D8%AF%DB%8C%D8%B4%D9%87-%D9%86%D9%88\"%D8%8C-%D9%86%D8%B4%D8%B1%DB%8C%D9%87-%D8%AF%D8%A7%D9%86%D8%B4%DA%AF%D8%A7%D9%87-%D9%81%D9%86%DB%8C-%D9%88-%D8%AD%D8%B1%D9%81%D9%87-%D8%A7%DB%8C-%D8%A7%D8%B3%D8%AA%D8%A7%D9%86-%D8%A8%D9%88%D8%B4%D9%87%D8%B1-%D9%85%D9%86%D8%AA%D8%B4%D8%B1-%D8%B4%D8%AF', 'https://tvu.ac.ir/./fa/545977/%D9%86%D8%B3%D8%AE%D9%87-%D8%A7%D9%84%DA%A9%D8%AA%D8%B1%D9%88%D9%86%DB%8C%DA%A9%DB%8C-%D8%B4%D9%85%D8%A7%D8%B1%D9%87-%DB%B4-\"%D8%A7%D9%86%D8%AF%DB%8C%D8%B4%D9%87-%D9%86%D9%88\"%D8%8C-%D9%86%D8%B4%D8%B1%DB%8C%D9%87-%D8%AF%D8%A7%D9%86%D8%B4%DA%AF%D8%A7%D9%87-%D9%81%D9%86%DB%8C-%D9%88-%D8%AD%D8%B1%D9%81%D9%87-%D8%A7%DB%8C-%D8%A7%D8%B3%D8%AA%D8%A7%D9%86-%D8%A8%D9%88%D8%B4%D9%87%D8%B1-%D9%85%D9%86%D8%AA%D8%B4%D8%B1-%D8%B4%D8%AF/./file/2/attach2020093895212592300929.pdf', '           نسخه الکترونیکی شماره ۴ \"اندیشه نو\"، نشریه دانشگاه فنی و حرفه ای استان بوشهر منتشر شد |         دانشگاه فنی و حرفه ای  ', 'نسخه الکترونیکی شماره ۴ \"اندیشه نو\"، نشریه دانشگاه فنی و حرفه ای استان بوشهر منتشر شد');

-- --------------------------------------------------------

--
-- Table structure for table `emonarray`
--

CREATE TABLE `emonarray` (
  `_id` int(11) NOT NULL,
  `emon` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci;

--
-- Dumping data for table `emonarray`
--

INSERT INTO `emonarray` (`_id`, `emon`) VALUES
(1, 31),
(2, 28),
(3, 31),
(4, 30),
(5, 31),
(6, 30),
(7, 31),
(8, 31),
(9, 30),
(10, 31),
(11, 30),
(12, 31);

-- --------------------------------------------------------

--
-- Table structure for table `facilitypages`
--

CREATE TABLE `facilitypages` (
  `FacilityPageID` int(11) NOT NULL,
  `FacilityID` int(11) DEFAULT NULL,
  `PageName` varchar(145) COLLATE utf8_persian_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci;

--
-- Dumping data for table `facilitypages`
--

INSERT INTO `facilitypages` (`FacilityPageID`, `FacilityID`, `PageName`) VALUES
(9, 5, '/ManageAccountSpecs.php'),
(3, 3, '/ManageSystemFacilities.php'),
(4, 3, '/ManageFacilityPages.php'),
(5, 3, '/ManageSystemFacilities.php'),
(6, 3, '/ManageUserFacilities.php'),
(7, 4, '/ManageSystemFacilityGroups.php'),
(8, 1, '/Managepersons.php'),
(48, 12, '/GetJasonData.php'),
(25, 5, '/ManageUserPermissions.php'),
(52, 10, '/sites.php'),
(51, 9, '/crawl.php');

-- --------------------------------------------------------

--
-- Table structure for table `fmonarray`
--

CREATE TABLE `fmonarray` (
  `_id` int(11) NOT NULL,
  `fmon` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci;

--
-- Dumping data for table `fmonarray`
--

INSERT INTO `fmonarray` (`_id`, `fmon`) VALUES
(1, 31),
(2, 31),
(3, 31),
(4, 31),
(5, 31),
(6, 31),
(7, 30),
(8, 30),
(9, 30),
(10, 30),
(11, 30),
(12, 29);

-- --------------------------------------------------------

--
-- Table structure for table `persons`
--

CREATE TABLE `persons` (
  `PersonID` int(11) NOT NULL,
  `pfname` varchar(45) COLLATE utf8_persian_ci DEFAULT NULL,
  `plname` varchar(45) COLLATE utf8_persian_ci DEFAULT NULL,
  `CardNumber` varchar(45) CHARACTER SET latin1 DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci;

--
-- Dumping data for table `persons`
--

INSERT INTO `persons` (`PersonID`, `pfname`, `plname`, `CardNumber`) VALUES
(1, 'اميد', 'ميلاني فرد', '0');

-- --------------------------------------------------------

--
-- Table structure for table `sites`
--

CREATE TABLE `sites` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL,
  `domain` text NOT NULL,
  `is_ssl` tinyint(1) NOT NULL DEFAULT '0',
  `depth` int(11) NOT NULL DEFAULT '0',
  `max_docs` int(11) NOT NULL DEFAULT '100',
  `doc_formats` text NOT NULL,
  `status` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sites`
--

INSERT INTO `sites` (`id`, `name`, `domain`, `is_ssl`, `depth`, `max_docs`, `doc_formats`, `status`) VALUES
(1, 'khev', 'khev.um.ac.ir', 1, 3, 100, 'a:8:{i:0;s:3:\"doc\";i:1;s:4:\"docx\";i:2;s:3:\"pdf\";i:3;s:3:\"xls\";i:4;s:4:\"xlsx\";i:5;s:3:\"ppt\";i:6;s:4:\"pptx\";i:7;s:3:\"txt\";}', 2),
(2, 'pellekan', 'pellekan.ir', 0, 4, 100, 'a:8:{i:0;s:3:\"doc\";i:1;s:4:\"docx\";i:2;s:3:\"pdf\";i:3;s:3:\"xls\";i:4;s:4:\"xlsx\";i:5;s:3:\"ppt\";i:6;s:4:\"pptx\";i:7;s:3:\"txt\";}', 2),
(3, 'فرهنگیان', 'cfu.ac.ir', 1, 2, 100, 'a:8:{i:0;s:3:\"doc\";i:1;s:4:\"docx\";i:2;s:3:\"pdf\";i:3;s:3:\"xls\";i:4;s:4:\"xlsx\";i:5;s:3:\"ppt\";i:6;s:4:\"pptx\";i:7;s:3:\"txt\";}', 2),
(4, 'فنی و حرفه ای', 'tvu.ac.ir', 1, 3, 100, 'a:8:{i:0;s:3:\"doc\";i:1;s:4:\"docx\";i:2;s:3:\"pdf\";i:3;s:3:\"xls\";i:4;s:4:\"xlsx\";i:5;s:3:\"ppt\";i:6;s:4:\"pptx\";i:7;s:3:\"txt\";}', 2);

-- --------------------------------------------------------

--
-- Table structure for table `specialpages`
--

CREATE TABLE `specialpages` (
  `SpecialPageID` int(11) NOT NULL,
  `PageName` varchar(245) COLLATE utf8_persian_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci;

--
-- Dumping data for table `specialpages`
--

INSERT INTO `specialpages` (`SpecialPageID`, `PageName`) VALUES
(1, 'main.php'),
(2, '/main.php'),
(3, '/Menu.php'),
(4, '/MainContent.php'),
(5, '/ChangePassword.php'),
(6, '/MyActions.php'),
(7, '/SelectPersonel.php'),
(8, '/SelectCustomer.php'),
(9, '/SelectStaff.php'),
(10, '/GetExamItemPrice.php');

-- --------------------------------------------------------

--
-- Table structure for table `sysaudit`
--

CREATE TABLE `sysaudit` (
  `RecID` bigint(20) UNSIGNED NOT NULL,
  `UserID` varchar(15) COLLATE utf8_persian_ci DEFAULT NULL,
  `ActionType` tinyint(3) UNSIGNED DEFAULT NULL,
  `ActionDesc` varchar(500) COLLATE utf8_persian_ci DEFAULT NULL,
  `IPAddress` bigint(20) DEFAULT NULL,
  `SysCode` tinyint(3) UNSIGNED DEFAULT NULL,
  `IsSecure` tinyint(3) UNSIGNED DEFAULT NULL,
  `ATS` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci;

--
-- Dumping data for table `sysaudit`
--

INSERT INTO `sysaudit` (`RecID`, `UserID`, `ActionType`, `ActionDesc`, `IPAddress`, `SysCode`, `IsSecure`, `ATS`) VALUES
(1, 'omid', NULL, 'ثبت داده جدید در  با کد 6', 0, 0, NULL, '2021-02-05 16:26:51'),
(2, 'omid', NULL, 'ثبت داده جدید در  با کد 7', 0, 0, NULL, '2021-02-05 16:27:41'),
(3, 'omid', NULL, 'ثبت داده جدید در  با کد 5', 0, 0, NULL, '2021-02-05 16:27:56'),
(4, 'omid', NULL, 'ثبت داده جدید در  با کد 6', 0, 0, NULL, '2021-02-05 16:28:13'),
(5, 'omid', NULL, 'ثبت داده جدید در  با کد 49', 0, 0, NULL, '2021-02-05 16:33:24'),
(6, 'omid', NULL, 'ثبت داده جدید در  با کد 50', 0, 0, NULL, '2021-02-05 16:33:51'),
(7, 'omid', NULL, 'حذف داده با شماره شناسایی 6 از ', 0, 0, NULL, '2021-02-05 17:10:10'),
(8, 'omid', NULL, 'حذف داده با شماره شناسایی 7 از ', 0, 0, NULL, '2021-02-05 17:10:10'),
(9, 'omid', NULL, 'ثبت داده جدید در  با کد 8', 0, 0, NULL, '2021-02-05 17:10:36'),
(10, 'omid', NULL, 'ثبت داده جدید در  با کد 7', 0, 0, NULL, '2021-02-05 17:10:46'),
(11, 'omid', NULL, 'حذف داده با شماره شناسایی 8 از ', 0, 0, NULL, '2021-02-05 17:11:31'),
(12, 'omid', NULL, 'ثبت داده جدید در  با کد 9', 0, 0, NULL, '2021-02-05 17:12:57'),
(13, 'omid', NULL, 'بروز رسانی داده با شماره شناسایی 9 در  - موارد تغییر داده شده: ترتیب', 0, 0, NULL, '2021-02-05 17:13:16'),
(14, 'omid', NULL, 'ثبت داده جدید در  با کد 8', 0, 0, NULL, '2021-02-05 17:13:21'),
(15, 'omid', NULL, 'ثبت داده جدید در  با کد 9', 0, 0, NULL, '2021-02-05 17:13:23'),
(16, 'omid', NULL, 'حذف داده با شماره شناسایی 9 از ', 0, 0, NULL, '2021-02-05 17:13:25'),
(17, 'omid', NULL, 'ثبت داده جدید در  با کد 51', 0, 0, NULL, '2021-02-05 17:15:32'),
(18, 'omid', NULL, 'ثبت داده جدید در  با کد 10', 0, 0, NULL, '2021-02-05 17:17:04'),
(19, 'omid', NULL, 'ثبت داده جدید در  با کد 10', 0, 0, NULL, '2021-02-05 17:17:11'),
(20, 'omid', NULL, 'ثبت داده جدید در  با کد 52', 0, 0, NULL, '2021-02-05 17:19:40');

-- --------------------------------------------------------

--
-- Table structure for table `systemdblog`
--

CREATE TABLE `systemdblog` (
  `RecID` bigint(20) UNSIGNED NOT NULL,
  `page` varchar(200) COLLATE utf8_persian_ci DEFAULT NULL COMMENT 'صفحه',
  `query` text COLLATE utf8_persian_ci COMMENT 'پرس و جو',
  `SerializedParam` text COLLATE utf8_persian_ci COMMENT 'پارامتر پرس و جو',
  `UserID` varchar(15) COLLATE utf8_persian_ci DEFAULT NULL COMMENT 'شناسه کاربر',
  `IPAddress` bigint(20) DEFAULT NULL COMMENT 'آدرس IP',
  `SysCode` tinyint(3) UNSIGNED DEFAULT NULL COMMENT 'کد سیستم',
  `ATS` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'تاریخ اجرا',
  `ExecuteTime` float(14,10) NOT NULL COMMENT 'مدت زمان اجرا',
  `QueryStatus` enum('SUCCESS','FAILED') COLLATE utf8_persian_ci DEFAULT 'SUCCESS' COMMENT 'وضعیت پرس و جو',
  `DBName` varchar(30) COLLATE utf8_persian_ci DEFAULT '' COMMENT 'نام پایگاه داده'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci;

-- --------------------------------------------------------

--
-- Table structure for table `systemfacilities`
--

CREATE TABLE `systemfacilities` (
  `FacilityID` int(11) NOT NULL,
  `FacilityName` varchar(245) COLLATE utf8_persian_ci DEFAULT NULL,
  `GroupID` int(11) DEFAULT NULL,
  `OrderNo` int(11) DEFAULT NULL,
  `PageAddress` varchar(345) COLLATE utf8_persian_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci;

--
-- Dumping data for table `systemfacilities`
--

INSERT INTO `systemfacilities` (`FacilityID`, `FacilityName`, `GroupID`, `OrderNo`, `PageAddress`) VALUES
(1, 'مدیریت افراد', 1, 3, 'Managepersons.php'),
(3, 'مدیریت امکانات', 1, 2, 'ManageSystemFacilities.php'),
(4, 'مدیریت گروه های منو', 1, 1, 'ManageSystemFacilityGroups.php'),
(5, 'مدیریت کاربران', 1, 4, 'ManageAccountSpecs.php'),
(10, 'سایت ها', 2, 2, 'sites.php'),
(9, ' کراول', 2, 1, 'crawl.php');

-- --------------------------------------------------------

--
-- Table structure for table `systemfacilitygroups`
--

CREATE TABLE `systemfacilitygroups` (
  `GroupID` int(11) NOT NULL,
  `GroupName` varchar(145) COLLATE utf8_persian_ci DEFAULT NULL,
  `OrderNo` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci;

--
-- Dumping data for table `systemfacilitygroups`
--

INSERT INTO `systemfacilitygroups` (`GroupID`, `GroupName`, `OrderNo`) VALUES
(1, 'مدیریت', 1),
(2, 'عملیات کاری', 3),
(3, 'گزارشات', 4);

-- --------------------------------------------------------

--
-- Table structure for table `userfacilities`
--

CREATE TABLE `userfacilities` (
  `FacilityPageID` int(11) NOT NULL,
  `UserID` varchar(100) COLLATE utf8_persian_ci DEFAULT NULL,
  `FacilityID` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci;

--
-- Dumping data for table `userfacilities`
--

INSERT INTO `userfacilities` (`FacilityPageID`, `UserID`, `FacilityID`) VALUES
(1, 'omid', 1),
(2, 'omid', 3),
(3, 'omid', 4),
(4, 'omid', 5),
(10, 'omid', 10),
(8, 'omid', 9);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accountspecs`
--
ALTER TABLE `accountspecs`
  ADD PRIMARY KEY (`AccountSpecID`);

--
-- Indexes for table `docs`
--
ALTER TABLE `docs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `emonarray`
--
ALTER TABLE `emonarray`
  ADD PRIMARY KEY (`_id`);

--
-- Indexes for table `facilitypages`
--
ALTER TABLE `facilitypages`
  ADD PRIMARY KEY (`FacilityPageID`);

--
-- Indexes for table `fmonarray`
--
ALTER TABLE `fmonarray`
  ADD PRIMARY KEY (`_id`);

--
-- Indexes for table `persons`
--
ALTER TABLE `persons`
  ADD PRIMARY KEY (`PersonID`);

--
-- Indexes for table `sites`
--
ALTER TABLE `sites`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `specialpages`
--
ALTER TABLE `specialpages`
  ADD PRIMARY KEY (`SpecialPageID`);

--
-- Indexes for table `sysaudit`
--
ALTER TABLE `sysaudit`
  ADD PRIMARY KEY (`RecID`),
  ADD KEY `UserID` (`UserID`);

--
-- Indexes for table `systemdblog`
--
ALTER TABLE `systemdblog`
  ADD PRIMARY KEY (`RecID`),
  ADD KEY `UserID` (`UserID`);

--
-- Indexes for table `systemfacilities`
--
ALTER TABLE `systemfacilities`
  ADD PRIMARY KEY (`FacilityID`);

--
-- Indexes for table `systemfacilitygroups`
--
ALTER TABLE `systemfacilitygroups`
  ADD PRIMARY KEY (`GroupID`);

--
-- Indexes for table `userfacilities`
--
ALTER TABLE `userfacilities`
  ADD PRIMARY KEY (`FacilityPageID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accountspecs`
--
ALTER TABLE `accountspecs`
  MODIFY `AccountSpecID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `docs`
--
ALTER TABLE `docs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=192;

--
-- AUTO_INCREMENT for table `facilitypages`
--
ALTER TABLE `facilitypages`
  MODIFY `FacilityPageID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT for table `persons`
--
ALTER TABLE `persons`
  MODIFY `PersonID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `sites`
--
ALTER TABLE `sites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `specialpages`
--
ALTER TABLE `specialpages`
  MODIFY `SpecialPageID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `sysaudit`
--
ALTER TABLE `sysaudit`
  MODIFY `RecID` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `systemdblog`
--
ALTER TABLE `systemdblog`
  MODIFY `RecID` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `systemfacilities`
--
ALTER TABLE `systemfacilities`
  MODIFY `FacilityID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `systemfacilitygroups`
--
ALTER TABLE `systemfacilitygroups`
  MODIFY `GroupID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `userfacilities`
--
ALTER TABLE `userfacilities`
  MODIFY `FacilityPageID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
