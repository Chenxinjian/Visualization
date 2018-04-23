package dao;
import model.UserBean;
import org.json.JSONObject;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;
public interface DaoInterface {
//     ArrayList<HashMap<String,String>> getStationInfo();
     String getStationInfo();
     String getCurvelines(UserBean userBean);
}
