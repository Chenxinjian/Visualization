package ajax;

import dao.Dao;
import model.UserBean;


import java.io.IOException;


public class Servlet extends javax.servlet.http.HttpServlet {
    protected void doPost(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws javax.servlet.ServletException, IOException {
        response.setContentType("text/html;charset=utf-8");
        String dateStart=request.getParameter("dateStart");
        String dateEnd=request.getParameter("dateEnd");
        String flow=request.getParameter("flow");
        UserBean ub=new UserBean();

        ub.setDataBegin(dateStart);
        ub.setDataEnd(dateEnd);
        ub.setMiniFlow(flow);

        Dao dao=new Dao();
        String curvelines=dao.getCurvelines(ub);/*错误*/

        System.out.println("POST done");
        response.getWriter().write(curvelines);
    }

    protected void doGet(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws javax.servlet.ServletException, IOException {
    }
}
