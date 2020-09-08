<?php

require("./common/head.php");

if($_GET['mod']) {
    require("./model/".$_GET['mod'].'.php');
} else {
    $action = $_GET['page'] ? $_GET['page'] : 'ip';
    $title = $action;
    require("./page/".$action.'.php');
}

require("./common/foot.php");
