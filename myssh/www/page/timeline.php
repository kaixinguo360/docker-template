<?php

$result=$db->query("SELECT COUNT(*) AS count, DATE_FORMAT(time, '%Y-%m-%d %H') AS time FROM passwords WHERE time > DATE_SUB(NOW(), INTERVAL 1 DAY) GROUP BY DATE_FORMAT(time, '%Y-%m-%d %H');");

$source = array();
if ($result -> num_rows == 0) {
    $source[0] = array();
}
for ($i = 0; $i < $result -> num_rows; $i++) {
    $array = $result -> fetch_array();
    unset($item);
    $item['time'] = $array['time'];
    $item['count'] = $array['count'];
    $total += $array['count'];
    $source[$i] = $item;
}
$data['source'] = $source;

$dimensions = array('time', 'count');
$data['dimensions'] = $dimensions;

$data=json_encode($data);

?>

<body style="background: #404a59;">
<!-- <h1>Welcone To MySSH</h1> -->
<div id="main" style="width: 100%;height:100%;"></div>
<script type="text/javascript">
    // 基于准备好的dom，初始化echarts实例
    var myChart = echarts.init(document.getElementById('main'));

    // 指定图表的配置项和数据
    var option = {
        title : {
            text: 'Time Line',
            link: '?page=ip',
            target: 'self',
            subtext: 'Last 24 Hour, Total <?php echo $total ?>',
            subtarget: 'self',
            left: 'center',
            top: 'top',
            textStyle: {
                fontSize: 24,
                color: '#fff'
            }
        },
        backgroundColor: '#404a59',
        tooltip: {},
        legend: {},
        dataset: <?php echo $data ?>,
        xAxis: {
            type: 'time',
            axisLabel: {
                color: '#fff'
            }
        },
        yAxis: {
            type: 'value',
            axisLabel: {
                color: '#fff'
            }
        },
        dataZoom: [
            {
                type: 'slider',
                xAxisIndex: 0,
                start: 50,
                end: 100
            },
            {
                type: 'inside',
                xAxisIndex: 0,
                start: 50,
                end: 100
            }
        ],
        series: {
            type: 'line',
            encode: {
                x: 'time',
                y: 'count'
            }
        }
    };

    // 使用刚指定的配置项和数据显示图表。
    myChart.setOption(option);
</script>
</body>
