package servlet;

import dao.Dao;
import model.UserBean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

@WebServlet(name = "TimeNumServlet")
public class TimeNumServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String data0=request.getParameter("data0");
        String data1=request.getParameter("data1");
        String id=request.getParameter("idGet");
        //String stationID=request.getParameter()
        UserBean ub=new UserBean();
        ub.setDataBegin(data0);
        ub.setDataEnd(data1);
        ub.setId(id);

        Dao dao=new Dao();
        dao.getStationHoursInfo_lease(ub);
        dao.getStationHoursInfo_ruturn(ub);

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String data0=request.getParameter("data0");
        String data1=request.getParameter("data1");
        String id=request.getParameter("idGet");
        //String stationID=request.getParameter()
        UserBean ub=new UserBean();
        ub.setDataBegin(data0);
        ub.setDataEnd(data1);
        ub.setId(id);

        Dao dao=new Dao();
        ArrayList<HashMap<String,String>> list =dao.getStationHoursInfo_lease(ub);
        Iterator itea = list.iterator();
        String str0 = new String();
        str0="";
        System.out.println(str0);
        str0="[";
        System.out.println(str0);
        while(itea.hasNext())
        {
            HashMap<String, String> timeNum_lease = (HashMap<String, String>) itea.next();
            str0=str0+timeNum_lease.get("LEASENUMBER")+",";
            System.out.println(str0);
        }
        str0=str0.substring(0,str0.length()-1);
        str0=str0+"]";
        System.out.println(str0);

        ArrayList<HashMap<String,String>> list1 =dao.getStationHoursInfo_ruturn(ub);
        Iterator itea1 = list1.iterator();
        String str1 = new String();
        str1="";
        System.out.println(str1);
        str1="[";
        System.out.println(str1);
        while(itea1.hasNext())
        {
            HashMap<String, String> timeNum_return = (HashMap<String, String>) itea1.next();
            str1=str1+timeNum_return.get("RETURNNUMBER")+",";
            System.out.println(str1);
        }
        str1=str1.substring(0,str1.length()-1);
        str1=str1+"]";
        System.out.println(str1);



        dao.getStationHoursInfo_ruturn(ub);

        request.setCharacterEncoding("utf-8");
        response.setContentType("text/html;charset=utf-8");
        response.setCharacterEncoding("utf-8");
        PrintWriter out = response.getWriter();
        out.println(
"<html>\n"+
	"<head>\n"+
	"<meta charset=\"utf-8\">\n"+
	"<script src=\"../../echarts.js\"></script>\n"+
	"</head>\n"+
	"<body>\n"+
		"<div style=\"width:100%;height: 40%\" id=\"main\">\n"+
			"<script type=\"text/javascript\">\n"+
                "var container=document.getElementById(\'main\');\n"+
        "var resizeWorldMapContainer = function () {\n"+
            "container.style.width = window.innerWidth+\'px\';\n"+
            "container.style.height = window.innerHeight+\'px\';\n"+
        "};\n"+

        "resizeWorldMapContainer();\n"+

        "var myChart = echarts.init(container);\n"+
        "option = {\n"+
                "title: {\n"+
            "text: \'The selected rental and return time:\'\n"+
        "},\n"+
        "tooltip: {\n"+
            "trigger: \'axis\'\n"+
        "},\n"+
        "legend: {\n"+
            "data:[\'rental number\',\'return number\']\n"+
        "},\n"+
        "xAxis:  {\n"+
            "type: \'category\',\n"+
                    "boundaryGap: false,\n"+
                    "name:\'Time of rental and return bike\',\n"+
                    "data: [\'6\',\'7\',\'8\',\'9\',\'10\',\'11\',\'12\',\'13\',\'14\',\'15\',\'16\',\'17\',\'18\',\'19\',\'20\']\n"+
        "},\n"+
        "yAxis: {\n"+
            "type: \'value\',\n"+
                    "name:\'Number of rental and return bike\',\n"+
                    "boundaryGap: false\n"+
        "},\n"+
        "series: [\n"+
        "{\n"+
            "name:\'rental number\',\n"+
            "type:\'line\',\n"+
            "smooth:true,\n"+
            "itemStyle: " +
            "{\n"+
                "normal: " +
                "{\n"+
                    "areaStyle:" +
                        "{\n"+
                            "type: \'default\',\n"+
                            "color:\'#ff7e50\'\n"+
                        "},\n"+
                    "lineStyle:{\n"+
                        "color:\'#ff7e50\'\n"+
                    "}\n"+
                "}\n"+
            "},\n"+
            "data:"+str0+",\n"+
            "markPoint: {\n"+
                "data: [\n"+
                "{type: \'max\', name: \'最大值\'},\n"+
                "{type: \'min\', name: \'最小值\'}\n"+
				                "]\n"+
            "}\n"+
        "},\n"+
        "{\n"+
            "name:\'return number\',\n"+
                    "type:\'line\',\n"+
                "smooth:true,\n"+
                "itemStyle: {\n"+
                "normal: {\n"+
                "areaStyle:{\n"+
                    "type: \'default\',\n"+
                    "color:\'#87cffb\'\n"+
                "},\n"+
                "lineStyle:{\n"+
                    "color:\'#87cffb\'\n"+
                "}\n"+
            "}\n"+
        "},\n"+
            "data:"+str1+""+",\n"+
            "markPoint: {\n"+
                "data: [\n"+
                "{type: \'max\', name: \'最大值\'},\n"+
                "{type: \'min\', name: \'最小值\'}\n"+
				                "]\n"+
            "}\n"+
        "}\n"+
				    "]\n"+
				"};\n"+
        "myChart.setOption(option);\n"+
        "window.onresize = function () {\n"+
            "resizeWorldMapContainer();\n"+
            "myChart.resize();\n"+
        "};\n"+
			"</script>\n"+
		"</div>\n"+
	"</body>\n"+
"</html>\n"
        );
    }
}