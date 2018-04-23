package model;

public class UserBean {
    private String dataBegin;
    private String dataEnd;
    private String id;
    private String miniFlow;

    public String getDataBegin() {
        return this.dataBegin;
    }
    public void setDataBegin(String dataBeg)
    {
        this.dataBegin=dataBeg;
    }

    public String getDataEnd()
    {
        return this.dataEnd;
    }
    public void setDataEnd(String dataEd)
    {
        this.dataEnd=dataEd;
    }

    public String getId()
    {
        return this.id;
    }
    public void setId(String idi)
    {
        this.id=idi;
    }

    public String getMiniFlow()
    {
        return this.miniFlow;
    }
    public void setMiniFlow(String miniFlow)
    {
        this.miniFlow=miniFlow;
    }
}
