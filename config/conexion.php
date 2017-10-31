<?php
function conexion(){
    $db=mysql_connect("localhost","root","") or die("No se conecto al servidor");
    
            mysql_select_db("app_finger_control",$db) or die ("No se conecto a la base de datos");
            return $db;
}
$db=conexion();
?>