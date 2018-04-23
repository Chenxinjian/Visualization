package dao;
import convert.Re2json;
import model.UserBean;
import org.json.JSONException;

import utility.DBUtility;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;


public class Dao implements DaoInterface{
    public String getStationInfo()
    {
        DBUtility dbUtility = null;
        Connection connection = null;
        Statement statement = null;
        ResultSet resultSet=null;
        Re2json re2json=null;
        String jsonString=null;

        try
        {
            dbUtility = new DBUtility();
            connection = dbUtility.getConn();
            statement = connection.createStatement();
            String sql = "select info.STATIONID,X,Y,ADDRESS " +
                    "from SYSTEM.G_STATIONINFO info join SYSTEM.G_STATIONORIENT orient on info.STATIONID=orient.STATIONID";
            resultSet = statement.executeQuery(sql);

            re2json=new Re2json();
            jsonString=re2json.resultSetToJson(resultSet);
            System.out.print(jsonString);

        }
        catch (SQLException e)
        {
            e.printStackTrace();
        } catch (JSONException e) {
            e.printStackTrace();
        } finally
        {
            DBUtility.release(connection,statement,resultSet);
        }
        return jsonString;
    }

    public String getCurvelines(UserBean userBean)
    {
        DBUtility dbUtility = null;
        Connection connection = null;
        Statement statement = null;
        ResultSet resultSet=null;
        Re2json re2json=null;
        String jsonString=null;
        try
        {
            dbUtility=new DBUtility();
            connection=dbUtility.getConn();/*错误？*/
            statement=connection.createStatement();
            String sql="select leasestation,returnstation,sum(bikenum) as flow " +
                    "from system.t_123 " +
                    "where  leasedate>='"+userBean.getDataBegin()+"' "+ "and leasetime<='" +userBean.getDataEnd()+"' "+
                    "group by leasestation,returnstation " +
                    "having sum(bikenum)>"+userBean.getMiniFlow();
            resultSet = statement.executeQuery(sql);

            re2json=new Re2json();
            jsonString=re2json.resultSetToJson(resultSet);
//            jsonString="twstsdss";
//            System.out.println(jsonString);
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
        catch (JSONException e) {
            e.printStackTrace();
        }finally
        {
            DBUtility.release(connection,statement,resultSet);
        }
        return jsonString;
    }

}
