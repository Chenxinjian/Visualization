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
    <script src="bootstrap.min.js"></script>
    <script src="CurveLine.js"></script>
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=q2tZwvXGI7YWKR60OS3SfiA8CEA5g4zG">
      //v2.0版本的引用方式：src="http://api.map.baidu.com/api?v=2.0&ak=您的密钥"
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
        <form name="info" method="post">
          <div id="navbar" class="collapse navbar-collapse">
            <ul class="nav navbar-nav">
              <li><a>开始时间：</a></li>
              <li><a><input type="date" class="form-control" id="dateStart" name="dateStart" value="2014-03-23"></a></li>
              <li><a>结束时间：</a></li>
              <li><a><input type="date" class="form-control" id="dateEnd" name="dateEnd" value="2014-03-23"></a></li>
              <li><a>最小流量值：</a></li>
              <li><a><input type="text" class="form-control" id="flow" name="flow"></a></li>
              <li><a><button onclick="ajax()" class="btn" id="btn" name="btn">搜索</button></a></li>
            </ul>
          </div><!--/.nav-collapse -->
        </form>
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


            // function addCurvelines(text) {      //relation即为站点关联数据
            //     const nums = relation.map(function (rel) { return rel.num; }); //获取num数组
            //     const Max = Math.max.apply(Math, nums); 			//找出最大值
            //     relation.forEach(function (rel) {
            //         let from = getXY(rel.from);    			 //根据站点id获取坐标
            //         let to = getXY(rel.to);
            //         const num = rel.num;
            //         const weight = (num/Max).toFixed(2);  //求权重（当前值除以最大值）
            //         from = new BMap.Point(from.lng, from.lat);
            //         to = new BMap.Point(to.lng, to.lat);
            //         const opt = {       					//弧线配置
            //             strokeOpacity: 0.8,
            //             strokeColor: getColor(weight), 		 //根据权重取颜色
            //             strokeWeight: getStrokeWeight(weight)   //根据权重取弧线粗细大小
            //         };
            //         const curveline = new BMapLib.CurveLine([from, to], opt); //构建弧线对象
            //         map.addOverlay(curveline);  			//增加弧线到地图上
            //     });
            //
            //     function getColor(weight) {     			//求颜色插值
            //         const compute = d3.interpolate('#4caf50','#f44336');    //获取绿色到红色的插值函数
            //         return compute(weight);
            //     }
            //
            //     function getStrokeWeight(weight) { 			 //求粗细大小
            //         const Max = 10;    					 //固定最大值为10
            //         return Math.round(weight*Max);
            //     }
            //
            //     function getXY(id) {   					 //根据id获取具体站点数据
            //         const points = data.points;
            //         for(let i=0;i<points.length;i++){
            //             if(id === points[i].id) return points[i];
            //         }
            //     }
            // }


             var ajax= function(){
                // var btn = document.getElementById("btn");
                // btn.onclick = function(){
                    //得到异步对象
                    // var xmlHttp=null;
                    // if (window.XMLHttpRequest)
                    // {
                    //     //  IE7+, Firefox, Chrome, Opera, Safari 浏览器执行代码
                    //     xmlhttp=new XMLHttpRequest();
                    // }
                    // else
                    // {
                    //     // IE6, IE5 浏览器执行代码
                    //     xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
                    // }
                    var xmlHttp=new XMLHttpRequest();
                    /*
                        打开与服务器链接
                        >指定请求方式
                        >指定请求的URL
                        >指定是否为异步请求
                    */
                    /******修改请求方法为POST*****/
                    xmlHttp.open("POST","/Servlet",true);

                    /******设置请求头*****/
                    xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");

                    //发送请求
                    /******设置请求体*****/
                    var mesg="dateStart="+document.getElementById("dateStart").value+"&dateEnd="+document.getElementById("dateEnd").value+"&flow="+document.getElementById("flow").value;
                    console.log(mesg);
                    xmlHttp.send(mesg);//get没有请求体，也要给出null，否则有些浏览器发送出错！
                    console.log("111");
                    //给异步对象的onreadystatechange 事件注册监听器
                    xmlHttp.onreadystatechange = function(){
                        //双重判断：xmlHttp的状态为4（服务器响应结束），响应码为200（响应成功）
                        if(xmlHttp.readyState == 4 && xmlHttp.status == 200){
                            //获取服务器的响应结束
                            var infos = xmlHttp.responseText;
                            console.log(infos);
                            const nums=text.map(function (rel) { return rel.FLOW;});
                            const Max=Math.max.apply(Math,nums);
                            infos.forEach(function (rel) {
                                let from =getXY(rel.LEASESTATION);
                                let to=getXY(rel.RETURNSTATION);
                                const num=rel.num;
                                const weight=(num/Max).toFixed(2);
                                from = new BMap.Point(from.lng, from.lat);
                                to = new BMap.Point(to.lng, to.lat);
                                const opt = {       					//弧线配置
                                    strokeOpacity: 0.8,
                                    strokeColor: '#d3b25e', 		 //根据权重取颜色
                                    strokeWeight: getStrokeWeight(weight)   //根据权重取弧线粗细大小

                                };
                                const curveline = new BMapLib.CurveLine([from, to], opt); //构建弧线对象
                                map.addOverlay(curveline);

                            });
                        };
                    };
                // };
            };

            function getXY(id) {
                var points=<%=dao.getStationInfo()%>;
                for(let i=0;i<points.length;i++)
                {
                    if(id===points[i].STATIONID)
                        return points[i];
                }
            }

            function getStrokeWeight(weight) { 			 //求粗细大小
                const Max = 10;    					 //固定最大值为10
                return Math.round(weight*Max);
            }
        </script>
      </div>
    </div>

  </div><!-- /.container -->

    <!--异步请求-->
        <%--// function createXMLHttpRequest() {//根据不同浏览器获取网页的异步请求对象XMLHttpRequest--%>
        <%--//     try {--%>
        <%--//         return new XMLHttpRequest();--%>
        <%--//     }--%>
        <%--//     catch (e) {--%>
        <%--//         try {--%>
        <%--//             return new ActiveXObject("Msxml2.XMLHTTP");--%>
        <%--//         } catch (e) {--%>
        <%--//             try {--%>
        <%--//                 return new ActiveXObject("Microsoft.XMLHTTP");--%>
        <%--//             } catch (e) {--%>
        <%--//                 alert("你使用的浏览器我识别不了！");--%>
        <%--//                 throw e;--%>
        <%--//             }--%>
        <%--//--%>
        <%--//         }--%>
        <%--//     }--%>
        <%--// }--%>



  </body>
</html>

<!--jQuary ajax需改-->