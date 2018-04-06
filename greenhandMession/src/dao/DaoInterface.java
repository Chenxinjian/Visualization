package dao;
import model.UserBean;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;
public interface DaoInterface {
     ArrayList<HashMap<String,String>> getStationInfo();
     ArrayList<HashMap<String,String>> getStationHoursInfo_lease(UserBean userBean);
     ArrayList<HashMap<String,String>> getStationHoursInfo_ruturn(UserBean userBean);
}
