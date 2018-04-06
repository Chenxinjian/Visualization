<%--
  Created by IntelliJ IDEA.
  User: tamx
  Date: 2018/3/18
  Time: 23:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" import="java.util.*,dao.Dao" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title>StationInfo</title>
  <style type="text/css">
    html{height:100%}
    body{height:100%;margin:0px;padding:0px}
    #container{height:100%}
  </style>
  <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=USH8Rom9kXEIymKD8onpSaguikuQy0zy">
      //v2.0版本的引用方式：src="http://api.map.baidu.com/api?v=2.0&ak=您的密钥"
  </script>

  <style>
    .context{border-top:dashed 1px #ccc;padding-top:0px;margin:5px;}
    .context{text-align:center;}
    .context .left{ float:left;}
    .context .center{ display:inline;}
    .context .right{ float:right;}
  </style>
</head>

  <body>

  <div id="container" style="height: 45%">
    <script type="text/javascript">
        var map = new BMap.Map("container");// 创建地图实例
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
            String points=new String();
            points="[";
            Dao dao = new Dao();
            ArrayList<HashMap<String,String>> stationList =dao.getStationInfo();
            Iterator itea = stationList.iterator();
            int number=0;//station的个数
            while(itea.hasNext())
            {
                HashMap<String,String> oneStationInfo=(HashMap<String, String>) itea.next();
                String point =new String();
                point="{"+
                "\"station_id\":"+"\""+oneStationInfo.get("STATIONID")+"\","
                +"\"lat\":"+"\""+oneStationInfo.get("X")+"\","
                +"\"lng\":"+"\""+oneStationInfo.get("Y")+"\","
                +"\"station_name\":"+"\""+oneStationInfo.get("ADDRESS")+"\""
                +"}";
                number=number+1;
                points=points+point+",";
            }
            points=points.substring(0,points.length()-1);
            points=points+"]";
            %>
            var points=<%=points%>;
            for(var i=0;i<<%=number%>;i++)
            {
                var point = new BMap.Point(points[i].lat,points[i].lng);
                var marker=new BMap.Marker(point);
                // var opts={
                //     width : 250,     // 信息窗口宽度
                //     height: 100      // 信息窗口高度
                //     }
                map.addOverlay(marker);
                (function () { //立即执行函数
                    var info="station id:"+points[i].station_id+"<br>"
                        +"station name:"+points[i].station_name+"<br>"
                        +"lat&lng:"+points[i].lat+","+points[i].lng;
                    var stationID=points[i].station_id;
                    var infoWindow = new BMap.InfoWindow(info);  // 创建信息窗口对象
                    marker.addEventListener("click", function() {   // 给站点增加点击事件
                        document.getElementById('idGet').value=stationID;
                        this.openInfoWindow(infoWindow,point);  // 地图在 point 位置处打开信息窗口
                    });
                })();

            }

        }
        addMarker();
    </script>
  </div>

  <form name="dateInfo" action="/servlet/TimeNumServlet" target="echartsIFrame">
    <div class="context">
      <h3 style="text-align: center">The long-term bicycle circulation view</h3>
      <div class="left">Station name:</div>
      <div class="center">select time periods:
        <input type="date" value="2014-03-23" id="data0" name="data0" onblur="sub()">
        to
        <input type="date" value="2014-03-23" id="data1" name="data1" onblur="sub()">
        <input type="hidden" id="idGet" name="idGet" value="">
      </div>
      <div class="right"></div>
    </div>
  </form>
<!--失去焦点提交表单script-->
  <script>
   function sub(){
    document.dateInfo.submit();
    }
  </script>
  <iframe name="echartsIFrame" style="height: 42%;width: 100%" src="demo.html" scrolling="no">
  </iframe>



  </body>
</html>
