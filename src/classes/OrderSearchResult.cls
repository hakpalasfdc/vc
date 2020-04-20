public class OrderSearchResult {

    public class OrderSearch {
        public Integer count;
        public List<Data> data;
        public Integer start;
        public Boolean additional_records;
    }

    public class Attributes {
    }

    public class Data {
        public String sync_status;
        public List<Attributes> attributes;
        public String guid;
        public String id;
        public DateTime order_date;
        public String checkout_date;
        public String customer_first_name;
        public String customer_last_name;
        public String customer_email;
        public String status;
        public String lu_dt;
        public String cr_dt;
    }

    
    public static OrderSearch parse(String json) {
        return (OrderSearch) System.JSON.deserialize(json, OrderSearch.class);
    }
}