<?php

	include ("conexion.php");

	$consulta = "SELECT id_marc,fecha,hora,id_est,id_usu,id_tipo_marc,id_menu FROM marcaciones";
	$registro = mysql_query($consulta,$db);

	$tabla = "";

	while($row = mysql_fetch_array($registro)){

		$tabla.='{
				  "id_marc":"'.$row['id_marc'].'",
				  "fecha":"'.$row['fecha'].'",
				  "hora":"'.$row['hora'].'",
				  "id_est":"'.$row['id_est'].'",
				  "id_usu":"'.$row['id_usu'].'",
				  "id_tipo_marc":"'.$row['id_tipo_marc'].'",
				  "id_menu":"'.$row['id_menu'].'",
				},';
				
	}//Aqui se declaran variables con variables json

	//Eliminamos la coma que sobra
	$tabla = substr($tabla,0, strlen($tabla) - 1);

	echo '{"data":['.$tabla.']}';

?>
