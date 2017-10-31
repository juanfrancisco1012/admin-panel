-- phpMyAdmin SQL Dump
-- version 4.6.5.2
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 26-10-2017 a las 02:26:34
-- Versión del servidor: 10.1.21-MariaDB
-- Versión de PHP: 5.6.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `app_finger_control`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `dat_acceso` ()  NO SQL
    COMMENT 'Este método recupera los datos necesarios para la identificación'
BEGIN


SELECT us.id_usu, us.nombre, pe.nombre, pe.apellido, pe.rut, us.huella  
FROM usuarios as us, personas as pe 
WHERE (us.id_usu = pe.id_usu);


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ins_marcacion` (IN `id_usu` INT)  NO SQL
    COMMENT 'inserta marcacion según usuario identificado'
BEGIN
DECLARE nombre varchar(25);

IF EXISTS(SELECT * 
FROM menu as me
WHERE
(me.fecha = CURRENT_DATE)
AND
(me.hora_inicio < CURRENT_TIME AND me.hora_fin > CURRENT_TIME)) THEN

SELECT @id_menu_activo := me.id_menu, me.nombre 
FROM menu as me
WHERE
(me.fecha = CURRENT_DATE)
AND
(me.hora_inicio < CURRENT_TIME AND me.hora_fin > CURRENT_TIME);


SELECT @contador_menu := COUNT(*) 
FROM marcaciones as ma
WHERE
(ma.id_usu = id_usu AND ma.fecha = CURRENT_DATE) 
AND
(ma.id_menu = @id_menu_activo);


IF (@contador_menu = 2) THEN

SET nombre = 'usted ya a marcado entrada y salida en este periodo por favor espere al proximo menu el cual es: ....';

ELSE

If EXISTS (SELECT * 
FROM marcaciones as ma
WHERE
(ma.id_usu = id_usu AND ma.fecha = CURRENT_DATE) 
AND
(ma.id_est = 1 AND ma.id_menu = @id_menu_activo)) THEN

SELECT @id_menu := me.id_menu, me.nombre 
FROM menu as me
WHERE
(me.fecha = CURRENT_DATE)
AND
(me.hora_inicio < CURRENT_TIME AND me.hora_fin > CURRENT_TIME);

INSERT INTO marcaciones (fecha, hora, id_est, id_usu, id_tipo_marc, id_menu) VALUES ( CURRENT_DATE , CURRENT_TIME, 2, id_usu, 1, @id_menu);


ELSE

SELECT @id_menu := me.id_menu, me.nombre 
FROM menu as me
WHERE
(me.fecha = CURRENT_DATE)
AND
(me.hora_inicio < CURRENT_TIME AND me.hora_fin > CURRENT_TIME);

INSERT INTO marcaciones (fecha, hora, id_est, id_usu, id_tipo_marc, id_menu) VALUES ( CURRENT_DATE , CURRENT_TIME, 1, id_usu, 1, @id_menu);


END IF;

END IF;

ELSE

SET nombre = 'no hay menus disponibles';

SELECT nombre;

END IF;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cursos`
--

CREATE TABLE `cursos` (
  `id_cur` int(11) NOT NULL,
  `nombre` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estados`
--

CREATE TABLE `estados` (
  `id_est` int(11) NOT NULL,
  `nombre` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `estados`
--

INSERT INTO `estados` (`id_est`, `nombre`) VALUES
(1, 'entrada'),
(2, 'salida');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jornadas`
--

CREATE TABLE `jornadas` (
  `id_jor` int(11) NOT NULL,
  `nombre` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Volcado de datos para la tabla `jornadas`
--

INSERT INTO `jornadas` (`id_jor`, `nombre`) VALUES
(1, 'Mañana'),
(2, 'Tarde'),
(3, 'Vespertina'),
(4, 'Completa');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `marcaciones`
--

CREATE TABLE `marcaciones` (
  `id_marc` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `id_est` int(11) NOT NULL,
  `id_usu` int(11) NOT NULL,
  `id_tipo_marc` int(11) NOT NULL,
  `id_menu` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `marcaciones`
--

INSERT INTO `marcaciones` (`id_marc`, `fecha`, `hora`, `id_est`, `id_usu`, `id_tipo_marc`, `id_menu`) VALUES
(1, '2017-10-25', '20:48:22', 1, 1, 1, 7),
(2, '2017-10-25', '20:48:25', 2, 1, 1, 7);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `menu`
--

CREATE TABLE `menu` (
  `id_menu` int(11) NOT NULL,
  `nombre` varchar(25) NOT NULL,
  `dia` int(11) NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `fecha` date NOT NULL,
  `fijo` int(11) NOT NULL,
  `id_t_menu` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `menu`
--

INSERT INTO `menu` (`id_menu`, `nombre`, `dia`, `hora_inicio`, `hora_fin`, `fecha`, `fijo`, `id_t_menu`) VALUES
(1, 'pan con huevo + te', 1, '09:00:00', '09:30:00', '2017-10-24', 0, 1),
(2, 'tallarines con salsa', 1, '13:00:00', '14:00:00', '2017-10-24', 0, 2),
(3, 'pan con palta + te', 1, '17:00:00', '17:30:00', '2017-10-24', 0, 3),
(4, 'prueba 1', 1, '12:00:00', '14:59:00', '2017-10-25', 0, 3),
(5, 'prueba 2', 1, '16:00:00', '18:00:00', '2017-10-25', 0, 3),
(6, 'prueba 3', 1, '18:45:00', '18:45:00', '2017-10-25', 0, 3),
(7, 'prueba 4', 1, '18:45:00', '22:45:00', '2017-10-25', 0, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `personas`
--

CREATE TABLE `personas` (
  `id_per` int(11) NOT NULL,
  `rut` varchar(11) NOT NULL,
  `nombre` varchar(25) NOT NULL,
  `apellido` varchar(25) NOT NULL,
  `edad` int(11) NOT NULL,
  `f_nacimiento` date NOT NULL,
  `email` varchar(50) NOT NULL,
  `sexo` int(11) NOT NULL,
  `direccion` varchar(50) NOT NULL,
  `id_cur` int(11) DEFAULT NULL,
  `id_jor` int(11) DEFAULT NULL,
  `id_usu` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `personas`
--

INSERT INTO `personas` (`id_per`, `rut`, `nombre`, `apellido`, `edad`, `f_nacimiento`, `email`, `sexo`, `direccion`, `id_cur`, `id_jor`, `id_usu`) VALUES
(1, '180397590', 'Cesar', 'Bugueno', 25, '1992-04-12', 'cbug@outlook.es', 1, 'los quinotos 034 las pircas machali', NULL, 0, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_marcacion`
--

CREATE TABLE `tipo_marcacion` (
  `id_tipo_marc` int(11) NOT NULL,
  `nombre` varchar(15) NOT NULL,
  `descripcion` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `tipo_marcacion`
--

INSERT INTO `tipo_marcacion` (`id_tipo_marc`, `nombre`, `descripcion`) VALUES
(1, 'Lector de huell', ''),
(2, 'Teclado Numeric', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_usuario`
--

CREATE TABLE `tipo_usuario` (
  `id_t_cta` int(11) NOT NULL,
  `nombre` varchar(25) NOT NULL,
  `descripcion` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Volcado de datos para la tabla `tipo_usuario`
--

INSERT INTO `tipo_usuario` (`id_t_cta`, `nombre`, `descripcion`) VALUES
(1, 'Super Administrador', 'Todos los permisos'),
(2, 'Administrador', 'Algunos permisos'),
(3, 'Estudiantes', 'Ver marcaciones, menus etc');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `t_menu`
--

CREATE TABLE `t_menu` (
  `id_t_menu` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Volcado de datos para la tabla `t_menu`
--

INSERT INTO `t_menu` (`id_t_menu`, `nombre`) VALUES
(1, 'Desayuno'),
(2, 'Almuerzo'),
(3, 'Once');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usu` int(11) NOT NULL,
  `nombre` varchar(25) NOT NULL,
  `contrasena` varchar(25) NOT NULL,
  `huella` blob NOT NULL,
  `id_t_cta` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usu`, `nombre`, `contrasena`, `huella`, `id_t_cta`) VALUES
(1, 'Admin', 'satori_92', 0x00f87f01c82ae3735cc0413709ab71b0871455925ba19e2507bc8ddccd4d88f01a1d32c3db44d68d4fec56696fa63614dd6a37e2822c33e660eabf6a97dc856ded7f745ff9b552abf9149c7e1117b16f934c1039faa9d9a2576b957705f7aec955dc4b0f6c9856b565e620cfed9b2160e54115c03fd342f913951597f05f43e9efddb9ec1423f47e91928c7f8c3783b5423508dc5b5b9b4882015ee7eb232678f37a77aacfa49c68e8818abdde76a90bde57261ce14b98d237fdf71617b68d3261a3a0944be22825c40a82f797c804073d1dd56a774a8067e85ea5556215b5f8c2f4974c49c6c042606b951ab24258cc39ff2ed1426d51859844cf60a62771d7524389872e9b3cf457ec95d997f97bc9ff583e794c16918fee51dbbd0727135e8cf145625c8c24083bce12b39b9d4250d75140f50848819b53f48c06e25598b234d1255c9f53ca6400da3b65663cc98cf545c7a655caabac6dd20e0da6e91071f87d90a9284c916ff4a4783f1695172cb11e9770b8ff5ff2228ea03b124048a3210f266f00f87e01c82ae3735cc0413709ab71b0951455925d295f905a45d4f4db69e43704c8a5b37f70e345cc474906b77a33313a0fa7c6175639ffd240a308370bbcfbb05f1f03b8991177cb9612145a8c267d5ccad321e8a3acd8479e8d960cb24114058e930ba5e2624002ebe3cc8d960a98c5262385129dc569980ae691b8adde1e22e1d3e8937c0cdc9775548a1804322c8c4454ca06d540f0e05efc67f335e3b99f74829b961f39eae5bce36c5401344f6ab756d877243a028faf7eb99eff10e154234b22e710d0f18a4dfff799d1c82697b3ad303ea06199da697c2584403bfbc39192a577135c5ae75e94317aad083caf3ff7529656c757f15e77f861a931d2af8f1add6fb40f655f8bb7c1d10e865981967f040106f5560c5f5c1d979dba3842bb4ce2137f6ac4086040400bed4ecaba7c5fb9fb11c3dc4302af665ac8c1af93d9652b179ed9923d2fcdee41ac85722540b104b970468d3f4004a2f02998129f77995f0e3a18734286a18428b07443704c3d68cd1eb36fe502685b7bf78112312f6f00f88001c82ae3735cc0413709ab7170ae145592026a3c7289fc62920cc471745e611edceceb50ea1fec5e15eaeac53cd6022dd4820fbe1242a2a51db741210376fca90cf29eeebf843fc3442a2406b37eb986fb3356baa456cc2e780a204e61f2401a5b7f6f9f09a80f09eff98e9135b94413cbcdcc704be6eb11cf10fe5605eb43c95455ac17cb55dafa9b866e84fd1920c25b573fe47a8fe18a6773c7a189ad4c179fe493027fe0dcdcc043ca991e70c79a39c5eef9702d088f978e9ece981d3cf7aa2c7bb1fe7a03ec5d7355da0e64fe87d9c62cff14da4a7c7fbe3a012b4b1f75f310284b4c53642b7c1ea23060ed239991c907c38283f0d1f723ba9bb6295c4c5e33547cde63dbc3fb0b46f0fee16f176ee95bdb5368aa96823db55de78efd48ec6220432f3052a19bde635afaff6fb1bbd32cc7542913b1a4671328443cbe10cc7a3d9cd11ff126ff3b57d4de750d0e725b12f1e9b3b93b103a8886ca224afebdb1df06d1c80a9c88bfdb3111cd2de8c9337c7023df927663a2d6a8c9bc9b970d6f00e88101c82ae3735cc0413709ab71f09c1455928aaf56b33ea588ac89e2ba6ff795736ba5a69fd7c24366e7e55d6a072d0420afad6a288958ea044847133260034e7c03fdfd3101ef01372bd44d11f7f82e54104ac2c584a96821026c85ce6f1f92ec912e71ca0f976e8587ce4edf7803cf756639ce16678164d25d8be47f3b9ca9ee7fde9fd67ccdf19fb1d549a2b0a16f8c56a40f15cc6aa9bc7e2873606f1a3973b467b2537e5298d900a00331bb67aa3aa60376116f1d445fcc8a80e8da36f04f1811d06a2345f2905c94c607ebf522456c3f851a7d5d6b575ff13f138ece3cbe1a96dbf0fb1e5914c6549ea5b36f8b2713644bc74c59eb30f91aafc7296c40610733a3a92f14ecac89af521861df4a9abc185e46291104fc99ed9b484b6cb3534a008fdcfdb4f344f5356f650c46d379a32407d64b7e147fabdacb9efa4e855149d664920000f6313a82b9f6486cec51700e2517138b7e033dd4feb83c0d4eb61a84e129a77dc8b72e9a87c23154f1fa1334ca41f566aa4fa9e8af199afdd6fc750c6f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000, 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `cursos`
--
ALTER TABLE `cursos`
  ADD PRIMARY KEY (`id_cur`);

--
-- Indices de la tabla `estados`
--
ALTER TABLE `estados`
  ADD PRIMARY KEY (`id_est`);

--
-- Indices de la tabla `jornadas`
--
ALTER TABLE `jornadas`
  ADD PRIMARY KEY (`id_jor`);

--
-- Indices de la tabla `marcaciones`
--
ALTER TABLE `marcaciones`
  ADD PRIMARY KEY (`id_marc`),
  ADD KEY `id_tipo_marcacion` (`id_tipo_marc`),
  ADD KEY `id_usuario` (`id_usu`),
  ADD KEY `estado` (`id_est`),
  ADD KEY `id_usuario_2` (`id_usu`),
  ADD KEY `estado_2` (`id_est`),
  ADD KEY `id_tipo_marc` (`id_tipo_marc`),
  ADD KEY `id_menu` (`id_menu`);

--
-- Indices de la tabla `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`id_menu`);

--
-- Indices de la tabla `personas`
--
ALTER TABLE `personas`
  ADD PRIMARY KEY (`id_per`),
  ADD UNIQUE KEY `rut` (`rut`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `id_usu` (`id_usu`),
  ADD KEY `sexo` (`sexo`),
  ADD KEY `id_cur` (`id_cur`),
  ADD KEY `id_jor` (`id_jor`);

--
-- Indices de la tabla `tipo_marcacion`
--
ALTER TABLE `tipo_marcacion`
  ADD PRIMARY KEY (`id_tipo_marc`);

--
-- Indices de la tabla `tipo_usuario`
--
ALTER TABLE `tipo_usuario`
  ADD PRIMARY KEY (`id_t_cta`);

--
-- Indices de la tabla `t_menu`
--
ALTER TABLE `t_menu`
  ADD PRIMARY KEY (`id_t_menu`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usu`),
  ADD KEY `id_tipo_usuario` (`id_t_cta`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `cursos`
--
ALTER TABLE `cursos`
  MODIFY `id_cur` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT de la tabla `estados`
--
ALTER TABLE `estados`
  MODIFY `id_est` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT de la tabla `jornadas`
--
ALTER TABLE `jornadas`
  MODIFY `id_jor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT de la tabla `marcaciones`
--
ALTER TABLE `marcaciones`
  MODIFY `id_marc` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT de la tabla `menu`
--
ALTER TABLE `menu`
  MODIFY `id_menu` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT de la tabla `personas`
--
ALTER TABLE `personas`
  MODIFY `id_per` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT de la tabla `tipo_marcacion`
--
ALTER TABLE `tipo_marcacion`
  MODIFY `id_tipo_marc` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT de la tabla `tipo_usuario`
--
ALTER TABLE `tipo_usuario`
  MODIFY `id_t_cta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT de la tabla `t_menu`
--
ALTER TABLE `t_menu`
  MODIFY `id_t_menu` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usu` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
