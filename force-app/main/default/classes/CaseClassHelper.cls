public class CaseClassHelper {
    public String firstName;
    public String lastName;
    public String phone;
    public String email;
    public String SKU;
    public String subject;
    public String description;
    public String street;
    public String city;
    public String country;
    public String province;
    public String postalCode;
    
    public static CaseClassHelper parse(String json) {
        return (CaseClassHelper) System.JSON.deserialize(json, CaseClassHelper.class);
    }

}