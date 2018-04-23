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
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=key">
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
            <a class="navbar-brand" href="#">Mission One</a>
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
                addMarker();


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
                                    addCurvelines(msg);

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

                function getStrokeWeight(weight) { 			 //求粗细大小
                    const Max = 10;    					 //固定最大值为10
                    return Math.round(weight*Max);
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
                            from = new BMap.Point(from["X"], from["Y"]);
                            // console.log(from["X"]);
                            to = new BMap.Point(to["X"], to["Y"]);
                            const opt = {       					//弧线配置
                                strokeOpacity: 0.8,
                                strokeColor: '#7ed30a', 		 //根据权重取颜色
                                strokeWeight: getStrokeWeight(weight)   //根据权重取弧线粗细大小
                            };
                            const curveline = new BMapLib.CurveLine([from, to], opt); //构建弧线对象
                            map.addOverlay(curveline);  			//增加弧线到地图上
                        }
                    });
                }
            </script>
        </div>
    </div>

</div><!-- /.container -->
</body>
</html>

<!--jQuary ajax需改-->