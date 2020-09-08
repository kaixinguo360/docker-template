<?php

$result=$db->query("SELECT COUNT(*) AS attack, rhost, country_name, region_name, city, latitude, longitude FROM passwords a LEFT JOIN ips b ON (a.rhost=b.ip) WHERE time > DATE_SUB(NOW(), INTERVAL 1 DAY)".
    ($_GET["range"]=="china" ? " AND country_code='cn'" : "")
    ." GROUP BY rhost");

$source = array();
if ($result -> num_rows == 0) {
    $max = 0;
    $source[0] = array();
}
for ($i = 0; $i < $result -> num_rows; $i++) {
    $array = $result -> fetch_array();
    unset($item);
    if($array['attack'] > $max) {
        $max = $array['attack'];
    }
    $item['attack'] = $array['attack'];
    $item['rhost'] = $array['rhost'];
    $item['country_name'] = htmlentities($array['country_name']);
    $item['region_name'] = htmlentities($array['region_name']);
    $item['city'] = htmlentities($array['city']);
    $item['latitude'] = $array['latitude'];
    $item['longitude'] = $array['longitude'];
    $source[$i] = $item;
}
$data['source'] = $source;

$dimensions = array('attack', 'rhost', 'country_name', 'region_name', 'city', 'latitude', 'longitude');
$data['dimensions'] = $dimensions;

$data=json_encode($data);

?>

<body style="background: #404a59;">
<!-- <h1>Welcone To MySSH</h1> -->
<div id="main" style="width: 100%;height:100%;"></div>
<script src="res/world.js"></script>
<script src="res/china.js"></script>
<script type="text/javascript">
    // 基于准备好的dom，初始化echarts实例
    var myChart = echarts.init(document.getElementById('main'));
    var data = <?php echo $data ?>;
    var max = <?php echo $max ?>;

    var option = {
        title : {
            text: 'The source of the attack',
            link: '?page=timeline',
            target: 'self',
            subtext: 'Last 24 hour from the <?php echo ($_GET["range"]=="china" ? "China" : "world") ?>',
            sublink : '?page=ip&range=<?php echo ($_GET["range"]=="china" ? "world" : "china") ?>',
            subtarget: 'self',
            left: 'center',
            top: 'top',
            textStyle: {
                fontSize: 24,
                color: '#fff'
            }
        },
        backgroundColor: '#404a59',
        geo: {
            map: '<?php echo ($_GET["range"]=="china" ? "china" : "world")  ?>',
            roam: true,
            zoom:1,
            label: {
                emphasis: {
                    show: false
                }
            },
            itemStyle: {
                normal: {
                    areaColor: '#323c48',
                    borderColor: '#111'
                },
                emphasis: {
                    areaColor: '#2a333d'
                }
            }
        },
        tooltip: {
            trigger: 'item',
            formatter : function (params) {
                return "Attack: " + params.value['attack'] + '<br/>' +
                    "IP: " + params.value['rhost'] + '<br/>' +
                    "Country: " + params.value['country_name'] + '<br/>' +
                    "Region: " + params.value['region_name'];
            }
        },
        dataset: data,
        visualMap: {
            type: 'piecewise',
            pieces: [
                {gt: 5000},
                {gt: 1000, lte: 5000},
                {gt: 500, lte: 1000},
                {gt: 100, lte: 500},
                {gt: 10, lte: 100},
                {gt: 1, lte: 10},
                {value: 1}
            ],
            dimension: "attack",
            inRange: {
                color: ['#50a3ba','#eac736','#d94e5d'],
                symbolSize: [10, 50]
            },
            textStyle: {
                color: '#fff'
            }
        },
        series: [
            {
                type: "scatter",
                coordinateSystem: 'geo',
                encode: {
                    lat: "latitude",
                    lng: "longitude",
                    tooltip: [0, 1, 2, 3, 4, 5, 6]
                }
            }
        ]
    };
    myChart.setOption(option);

    // $.get('res/world.json', function (worldJson) {
    //     echarts.registerMap('world', worldJson); // 注册地图

        // $.get('https://api.db-ip.com/v2/free/173.82.212.18', function (locationJson) {
        //     alert(locationJson);
        // });
    // });
</script>
</body>
