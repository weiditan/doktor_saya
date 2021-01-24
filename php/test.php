<?php

$age = array("Peter"=>"35", "Ben"=>"37", "Joe"=>"43");
$name = array("Peter", "Ben", "Joe");


foreach($age as $x => $x_value) {
    echo "Key=$x, Value=$x_value";
    echo "<br>";
}

echo "<h3>For Loop</h3>";
for($i=0; $i<count($name); $i++){
    echo "Key=" . $name[$i] . ", Value=" . $age[$name[$i]];
    echo "<br>";
}

echo "<h3>While Loop</h3>";
$i=0; 
while($i<count($name)){
    echo "Key=" . $name[$i] . ", Value=" . $age[$name[$i]];
    echo "<br>";
    $i++;
}

echo "<h3>DO...While Loop</h3>";
$i=0; 
do{
    echo "Key=" . $name[$i] . ", Value=" . $age[$name[$i]];
    echo "<br>";
    $i++;
}while($i<count($name));

?>

<h3>Sort</h3>

<?php

$age = array("Peter"=>"35", "Ben"=>"37", "Joe"=>"43");
$name = array("Peter", "Ben", "Joe");

arsort($age);

foreach($age as $x=>$x_value)
   {
   echo "Key=" . $x . ", Value=" . $x_value;
   echo "<br>";
   }
?>

<h3>Json</h3>

<?php

$age = array("Peter"=>"35", "Ben"=>"37", "Joe"=>"43");
$name = array("Peter", "Ben", "Joe");

$myJSON = json_encode($age);

echo $myJSON;

?>
