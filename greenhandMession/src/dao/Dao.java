package dao;
import model.UserBean;
import utility.DBUtility;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class Dao implements DaoInterface{
    public ArrayList<HashMap<String,String>> getStationInfo()
    {
        DBUtility dbUtility = null;
        ArrayList<HashMap<String,String>> stationList = null;
        Connection connection = null;
        Statement statement = null;
        ResultSet resultSet=null;
        try
        {
            dbUtility = new DBUtility();
            connection = dbUtility.getConn();
            statement = connection.createStatement();
            String sql = "select info.STATIONID,X,Y,ADDRESS " +
                    "from SYSTEM.G_STATIONINFO info join SYSTEM.G_STATIONORIENT orient on info.STATIONID=orient.STATIONID";
            resultSet = statement.executeQuery(sql);

            stationList = new ArrayList<HashMap<String, String>>();

            ResultSetMetaData md = resultSet.getMetaData(); //得到结果集的结构信息
            int columnCount = md.getColumnCount(); //返回此 ResultSet 对象中的列数
            while (resultSet.next())
            {
                HashMap<String,String> oneStationInfo=new HashMap<String, String>();
                for(int i=1;i<=columnCount;i++)
                {
                    oneStationInfo.put(md.getColumnName(i),resultSet.getString(i));
                }
                stationList.add(oneStationInfo);
            }
        }
        catch (SQLException e)
        {
            e.printStackTrace();
        }
        finally
        {
            DBUtility.release(connection,statement,resultSet);
        }
        return stationList;
    }


    public ArrayList<HashMap<String,String>> getStationHoursInfo_lease(UserBean userBean)
    {
        DBUtility dbUtility = null;
        ArrayList<HashMap<String,String>> stationList = null;
        Connection connection = null;
        Statement statement = null;
        ResultSet resultSet=null;
        try
        {
            dbUtility = new DBUtility();
            connection = dbUtility.getConn();
            statement = connection.createStatement();
            String sql = "select leasetime,sum(bikenum) as leaseNumber" +
                    " from system.t_123 " +
                    " where leasestation =\'"+userBean.getId()+"\'"+
                    " and leasedate>=\'"+userBean.getDataBegin()+"\'"+" and leasetime<=\'"+userBean.getDataEnd()+"\'" +
                    " group by leasetime" +
                    " order by leasetime";
            resultSet = statement.executeQuery(sql);

            stationList = new ArrayList<HashMap<String, String>>();

            ResultSetMetaData md = resultSet.getMetaData(); //得到结果集的结构信息
            int columnCount = md.getColumnCount(); //返回此 ResultSet 对象中的列数
            while (resultSet.next())
            {
                HashMap<String,String> oneStationInfo=new HashMap<String, String>();
                for(int i=1;i<=columnCount;i++)
                {
                    oneStationInfo.put(md.getColumnName(i),resultSet.getString(i));
                }
                stationList.add(oneStationInfo);
            }
        }
        catch (SQLException e)
        {
            e.printStackTrace();
        }
        finally
        {
            DBUtility.release(connection,statement,resultSet);
        }
        return stationList;
    }

    public ArrayList<HashMap<String,String>> getStationHoursInfo_ruturn(UserBean userBean)
    {
        DBUtility dbUtility = null;
        ArrayList<HashMap<String,String>> stationList = null;
        Connection connection = null;
        Statement statement = null;
        ResultSet resultSet=null;
        try
        {
            dbUtility = new DBUtility();
            connection = dbUtility.getConn();
            statement = connection.createStatement();
            String sql = "select leasetime,sum(bikenum) as returnNumber" +
                    " from system.t_123 " +
                    " where returnstation =\'"+userBean.getId()+"\'"+
                    " and leasedate>=\'"+userBean.getDataBegin()+"\'"+" and leasetime<=\'"+userBean.getDataEnd()+"\'" +
                    " group by leasetime" +
                    " order by leasetime";

            resultSet = statement.executeQuery(sql);

            stationList = new ArrayList<HashMap<String, String>>();

            ResultSetMetaData md = resultSet.getMetaData(); //得到结果集的结构信息
            int columnCount = md.getColumnCount(); //返回此 ResultSet 对象中的列数
            while (resultSet.next())
            {
                HashMap<String,String> oneStationInfo=new HashMap<String, String>();
                for(int i=1;i<=columnCount;i++)
                {
                    oneStationInfo.put(md.getColumnName(i),resultSet.getString(i));
                }
                stationList.add(oneStationInfo);
            }
        }
        catch (SQLException e)
        {
            e.printStackTrace();
        }
        finally
        {
            DBUtility.release(connection,statement,resultSet);
        }
        return stationList;
    }
}
