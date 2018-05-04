<%--
  Created by IntelliJ IDEA.
  User: tamx
  Date: 2018/4/8
  Time: 17:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.*,dao.Dao"%>
<html>
<head>
    <title>messionOne</title>
    <link href="bootstrap.min.css" rel="stylesheet">
    <script src="jquery-3.3.1.js"></script>
    <script src="bootstrap.min.js"></script>
    <script src="CurveLine.js"></script>
    <script src="d3.min.js"></script>
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=3.0&ak=key">
        //v2.0版本的引用方式：src="http://ap
        // i.map.baidu.com/api?v=2.0&ak=您的密钥"
    </script>
    <style>
        body {
            padding-top: 50px;
        }
        .starter-template {
            padding: 40px 15px;
            text-align: center;
        }
        #mcontainer
        {
            width: 100%;
            height: 95%;
        }

        body
        {
            overflow-x:hidden;
            overflow-y:hidden;
        }

        html
        {
            overflow-x:hidden;
            overflow-y:hidden;
        }

        .ruler {
            position: absolute;
            right: 23%;
            bottom: 100px;
        }

        .ruler .ruler_content {
            position: relative;
            width: 20px;
            height: 100px;
            background: linear-gradient(to top, #4caf50, #f44336);
        }
        .ruler .ruler_content .ruler_max {
            position: absolute;
            top: 0;
            left: 20px;
            text-shadow: 1px 1px 2px;
        }
        .ruler .ruler_content .ruler_min {
            position: absolute;
            bottom: 0;
            left: 20px;
            text-shadow: 1px 1px 2px;
        }

    </style>


</head>
<body>
<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="#">Mession One</a>
        </div>
        <%--<form name="info" method="post">--%>
            <div id="navbar" class="collapse navbar-collapse">
                <ul class="nav navbar-nav">
                    <li><a>开始时间：</a></li>
                    <li><a><input type="date" class="form-control" id="dateStart" name="dateStart" value="2014-03-23"></a></li>
                    <li><a>结束时间：</a></li>
                    <li><a><input type="date" class="form-control" id="dateEnd" name="dateEnd" value="2014-03-23"></a></li>
                    <li><a>最小流量值：</a></li>
                    <li><a><input type="text" class="form-control" id="flow" name="flow"></a></li>
                    <li><a><button onclick="" class="btn" id="btn" name="btn">搜索</button></a></li>
                </ul>
            </div><!--/.nav-collapse -->
        <%--</form>--%>
    </div>

</nav>

<div class="container">

    <div class="starter-template">
        <div id="mcontainer">
            <script type="text/javascript">
                var map = new BMap.Map("mcontainer");// 创建地图实例
                var point = new BMap.Point(120.160256, 30.267209);// 创建点坐标
                map.centerAndZoom(point, 15);// 初始化地图，设置中心点坐标和地图级别

                var opts = {type: BMAP_NAVIGATION_CONTROL_SMALL,anchor:BMAP_ANCHOR_TOP_RIGHT};
                map.enableScrollWheelZoom(true);//开启鼠标滚轮缩放
                map.addControl(new BMap.NavigationControl(opts));//缩放控件
                map.addControl(new BMap.ScaleControl());//比例尺
                map.setCurrentCity("杭州"); // 仅当设置城市信息时，MapTypeControl的切换功能才能可用


                function addMarker()
                {
                    <%
                      Dao dao=new Dao();
                      String jsonString=dao.getStationInfo();
                    %>

                    var mapPoints =<%=jsonString%>.map(function(point){ return new BMap.Point( point.X,point.Y) });
                    var options = {
                        size: BMAP_POINT_SIZE_BIG,//点大小
                        shape: BMAP_POINT_SHAPE_CIRCLE,   //点形状
                        color: '#3bb3d3'      //点颜色
                    }
                    // console.log(mapPoints);
                    var pointCollection = new BMap.PointCollection(mapPoints,options);
                    map.addOverlay(pointCollection);
                }



                window.onload = function () {
                    var btn = document.getElementById("btn");
                    btn.onclick = function () {
                            $.ajax({              //jquery的ajax外层格式
                                type : "post",//请求方式
                                url : "/Servlet", //action请求路径
                                //async:false,//false:同步，锁定浏览器；true：默认值，异步请求
                                data : {
                                    "dateStart": document.getElementById("dateStart").value,
                                    "dateEnd": document.getElementById("dateEnd").value,
                                    "flow":document.getElementById("flow").value
                                },//请求传递的数据
                                dataType : "text",		//Servlet返回数据的类型
                                success:function(msg){	//msg即为返回的数据
                                    // console.log(msg);
                                    map.clearOverlays();
                                    addMarker();
                                    addCurvelines(msg);
                                    // addArrow(msg,options);

                                },
                                error: function(XMLHttpRequest, textStatus) {
                                    alert(XMLHttpRequest.status);
                                    alert(XMLHttpRequest.readyState);
                                    alert(textStatus);
                                }
                            });
                        };
                };


                function getXY(id) {
                    var points=<%=jsonString%>;
                    points=eval(points);
                    for(var i=0;i<points.length;i++)
                    {
                        if(id===points[i].STATIONID)
                        {
                            return points[i];
                        }
                    }
                }

                function getColor(weight) {     			//求颜色插值
                    const compute = d3.interpolate('#4caf50','#f44336');    //获取绿色到红色的插值函数
                    return compute(weight);
                }


                function getStrokeWeight(weight) { 			 //求粗细大小
                    const Max = 20;    					 //固定最大值为10
                    return Math.round(weight*Max);
                }

                function addArrow(lines,line_style,info) {
                    let length = 14;
                    let angleValue = Math.PI/7;
                    let linePoint = lines.getPath();
                    let arrowCount = linePoint.length;
                    let middle = arrowCount / 2;
                    let pixelStart = map.pointToPixel(linePoint[Math.floor(middle)]);
                    let pixelEnd = map.pointToPixel(linePoint[Math.ceil(middle)]);
                    let angle = angleValue;
                    let r = length;
                    let delta = 0;
                    let param = 0;
                    let pixelTemX, pixelTemY;
                    let pixelX, pixelY, pixelX1, pixelY1;
                    if(pixelEnd.x - pixelStart.x == 0&&pixelEnd.y - pixelStart.y==0)//过滤自流量
                        return;
                    if (pixelEnd.x - pixelStart.x == 0) {
                        pixelTemX = pixelEnd.x;
                        if (pixelEnd.y > pixelStart.y) {
                            pixelTemY = pixelEnd.y - r;
                        } else {
                            pixelTemY = pixelEnd.y + r;
                        }
                        pixelX = pixelTemX - r * Math.tan(angle);
                        pixelX1 = pixelTemX + r * Math.tan(angle);
                        pixelY = pixelY1 = pixelTemY;
                    } else {
                        delta = (pixelEnd.y - pixelStart.y) / (pixelEnd.x - pixelStart.x);
                        param = Math.sqrt(delta * delta + 1);
                        if ((pixelEnd.x - pixelStart.x) < 0) {
                            pixelTemX = pixelEnd.x + r / param;
                            pixelTemY = pixelEnd.y + delta * r / param;
                        } else {
                            pixelTemX = pixelEnd.x - r / param;
                            pixelTemY = pixelEnd.y - delta * r / param;
                        }
                        pixelX = pixelTemX + Math.tan(angle) * r * delta / param;
                        pixelY = pixelTemY - Math.tan(angle) * r / param;
                        pixelX1 = pixelTemX - Math.tan(angle) * r * delta / param;
                        pixelY1 = pixelTemY + Math.tan(angle) * r / param;
                    }
                    let pointArrow = map.pixelToPoint(new BMap.Pixel(pixelX, pixelY));
                    let pointArrow1 = map.pixelToPoint(new BMap.Pixel(pixelX1, pixelY1));
                    let Arrow = new BMap.Polyline([pointArrow, linePoint[Math.ceil(middle)], pointArrow1], line_style);


                    var opts= {
                        width:200,
                        height:100,
                        title:"信息："
                    }
                    var point= new BMap.Point(linePoint[Math.ceil(middle)].lng, linePoint[Math.ceil(middle)].lat);
                    var myicon = new BMap.Icon(
                        'icon.png', // 百度图片
                        new BMap.Size(10,22), // 视窗大小
                        {
                            imageSize: new BMap.Size(144,92), // 引用图片实际大小
                            imageOffset:new BMap.Size(-10,0)  // 图片相对视窗的偏移
                        }
                    );
                    var marker=new BMap.Marker(point,{icon:myicon});
                    var infoWindow = new BMap.InfoWindow(info,opts);  // 创建信息窗口对象
                    marker.addEventListener("click", function() {
                        this.openInfoWindow(infoWindow,point);
                        console.log("clink");
                    });
                    map.addOverlay(marker);

                    map.addOverlay(Arrow);
                }

                function addCurvelines(msg) {      //relation即为站点关联数据
                    var relation = eval(msg);
                    const nums = relation.map(function (rel) { return rel.FLOW; }); //获取num数组
                    const Max = Math.max.apply(Math, nums); 			//找出最大值
                    console.log(Max);
                    relation.forEach(function (rel)
                    {
                        let from = getXY(rel.LEASESTATION);    			 //根据站点id获取坐标
                        let to = getXY(rel.RETURNSTATION);
                        if (typeof(from) != "undefined"&&typeof(to) !="undefined") {
                            const num = rel.FLOW;
                            const weight = (num / Max).toFixed(2);  //求权重（当前值除以最大值）
                            var fromP = new BMap.Point(from["X"], from["Y"]);
                            // console.log(from["X"]);
                            var toP = new BMap.Point(to["X"], to["Y"]);
                            const opt = {       					//弧线配置
                                strokeOpacity: 0.8,
                                strokeColor: getColor(weight), 		 //根据权重取颜色
                                strokeWeight: getStrokeWeight(weight)   //根据权重取弧线粗细大小
                            };
                            // console.log(weight);
                            var curveline = new BMapLib.CurveLine([fromP, toP], opt); //构建弧线对象
                            map.addOverlay(curveline);  			//增加弧线到地图上
                                var info="from:"+from["X"]+","+from["Y"]+"<br>"
                                    +"to:"+to["X"]+","+to["Y"]+"<br>"
                                    +"flow:"+num;
                            addArrow(curveline,opt,info);

                        }
                    });
                }
            </script>
        </div>
    </div>

</div><!-- /.container -->

<div class="ruler">
    <div class="ruler_content">
        <span class="ruler_max">255</span>			<%-->最大值，默认值255<--%>
        <span class="ruler_min">0</span>			<%-->最小值，默认值0<--%>
    </div>
</div>

</body>
</html>

<!--jQuary ajax需改-->