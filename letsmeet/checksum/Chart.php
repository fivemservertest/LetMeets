 
<html>
<head> 
<?php  include 'conn.php'; ?>
<?php 

$room_id=$_GET['room_id'];
$name=$_GET['name'];


?>

<title> ส่วนชื่อเอกสาร </title> 
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" integrity="sha384-IQsoLXl5PILFhosVNubq5LC7Qb9DXgDA9i+tQ8Zj3iwWAwPtgFTxbJ8NT4GN1R8p" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" integrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.4.0/Chart.js"></script>




</head>
 

<body>
     <center>
            <div class="card">
  <div class="card-body">
    <canvas id="myChart" width="820px" height="500px"></canvas>

  </div>
</div





     
     </center>

     


<?php
    $sql = "SELECT DISTINCT COUNT(reserve_id) AS total , DATE_FORMAT(datein, '%M') as month FROM tb_reservation WHERE room_id='$room_id'
GROUP by DATE_FORMAT(datein, '%M') order by datein asc " ;
    $query = $connect->query($sql);
    while ($row = mysqli_fetch_array($query)) {

        $month[] = "".$row['month']." (".$row['total']." times)";

        // $month[] = $row['month'],$row['total'];
        $total[] = $row['total'];
    }
    ?>


<script>
const ctx = document.getElementById('myChart').getContext('2d');
const myChart = new Chart(ctx, {
     responsive: true,
    type: 'bar',
    data: {
        labels: <?php echo json_encode($month); ?>,
        datasets: [{
            label: 'Number of meeting <?php echo $name; ?>',
            data: <?php echo json_encode($total); ?>,
           
            backgroundColor: [
                'rgba(255, 99, 132, 0.2)',
                'rgba(54, 162, 235, 0.2)',
                'rgba(255, 206, 86, 0.2)',
                'rgba(75, 192, 192, 0.2)',
                'rgba(153, 102, 255, 0.2)',
                'rgba(255, 159, 64, 0.2)'
            ],
            borderColor: [
                'rgba(255, 99, 132, 1)',
                'rgba(54, 162, 235, 1)',
                'rgba(255, 206, 86, 1)',
                'rgba(75, 192, 192, 1)',
                'rgba(153, 102, 255, 1)',
                'rgba(255, 159, 64, 1)'
            ],
            borderWidth: 3
        }]
    },
     options: {
        legend: {
            labels: {
                fontColor: 'black',
                fontSize:30,
            },

        },
        scales: {
            xAxes: [{
               ticks:{
                    fontColor: 'black',
                    fontSize:30,
                    // fontStyle: 'bold',
               },
                // stacked: true,
            }],
            yAxes: [{
               ticks:{
                    fontColor: 'black',
                    fontSize:30,
                    // fontStyle: 'bold',
               },
                stacked: true
            }]

        }
    }


});
</script>
   
 

 

 

</body>
 
</html>





