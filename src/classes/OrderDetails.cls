// The supplied json has fields with names that are not valid in apex
// and so can only be parsed with explicitly generated code, this option
// was auto selected for you.

public class OrderDetails {

    public class Country_Z {
        public Integer id {get;set;} 
        public String enum_Z {get;set;} // in json: enum

        public Country_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getIntegerValue();
                        } else if (text == 'enum') {
                            enum_Z = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Country_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Type_Z {
        public Integer id {get;set;} 
        public String enum_Z {get;set;} // in json: enum
        public String label {get;set;} 
        public String label_short {get;set;} 

        public Type_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getIntegerValue();
                        } else if (text == 'enum') {
                            enum_Z = parser.getText();
                        } else if (text == 'label') {
                            label = parser.getText();
                        } else if (text == 'label_short') {
                            label_short = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Type_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Address {
        public String attention {get;set;} 
        public String address1 {get;set;} 
        public String city {get;set;} 
        public String postal_code {get;set;} 
        public Country_region country_region {get;set;} 
        public Country country {get;set;} 

        public Address(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'attention') {
                            attention = parser.getText();
                        } else if (text == 'address1') {
                            address1 = parser.getText();
                        } else if (text == 'city') {
                            city = parser.getText();
                        } else if (text == 'postal_code') {
                            postal_code = parser.getText();
                        } else if (text == 'country_region') {
                            country_region = new Country_region(parser);
                        } else if (text == 'country') {
                            country = new Country(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Address consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Customer {
        public String guid {get;set;} 
        public String label {get;set;} 
        public String cd {get;set;} 
        public String name {get;set;} 
        public String first_name {get;set;} 
        public String last_name {get;set;} 
        public String email {get;set;} 
        public Integer suspended {get;set;} 
        public Boolean closed {get;set;} 

        public Customer(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'guid') {
                            guid = parser.getText();
                        } else if (text == 'label') {
                            label = parser.getText();
                        } else if (text == 'cd') {
                            cd = parser.getText();
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'first_name') {
                            first_name = parser.getText();
                        } else if (text == 'last_name') {
                            last_name = parser.getText();
                        } else if (text == 'email') {
                            email = parser.getText();
                        } else if (text == 'suspended') {
                            suspended = parser.getIntegerValue();
                        } else if (text == 'closed') {
                            closed = parser.getBooleanValue();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Customer consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Values {
        public String stringValue {get;set;} 

        public Values(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'stringValue') {
                            stringValue = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Values consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Attributes {
        public String guid {get;set;} 
        public String preview {get;set;} 
        public String id {get;set;} 
        public List<Values> values {get;set;} 

        public Attributes(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'guid') {
                            guid = parser.getText();
                        } else if (text == 'preview') {
                            preview = parser.getText();
                        } else if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'values') {
                            values = arrayOfValues(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Attributes consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Shipping_groups_W {
        public Shipping_method shipping_method {get;set;} 
        public List<Order_item_W> order_item {get;set;} 

        public Shipping_groups_W(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'shipping_method') {
                            shipping_method = new Shipping_method(parser);
                        } else if (text == 'order_item') {
                            order_item = arrayOfOrder_item_W(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Shipping_groups_W consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Shipping_groups_X {
        public Shipping_method shipping_method {get;set;} 
        public List<Order_item_X> order_item {get;set;} 

        public Shipping_groups_X(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'shipping_method') {
                            shipping_method = new Shipping_method(parser);
                        } else if (text == 'order_item') {
                            order_item = arrayOfOrder_item_X(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Shipping_groups_X consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Shipping_groups_Y {
        public Shipping_method shipping_method {get;set;} 
        public List<Order_item_Y> order_item {get;set;} 

        public Shipping_groups_Y(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'shipping_method') {
                            shipping_method = new Shipping_method(parser);
                        } else if (text == 'order_item') {
                            order_item = arrayOfOrder_item_Y(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Shipping_groups_Y consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Values_Z {
        public String guid {get;set;} 
        public String id {get;set;} 
        public String label {get;set;} 

        public Values_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'guid') {
                            guid = parser.getText();
                        } else if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'label') {
                            label = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Values_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Order_item_Y {
        public Boolean cancelled {get;set;} 
        public List<Attributes> attributes {get;set;} 
        public List<Object_emails> object_emails {get;set;} 
        public List<Object_emails> object_activities {get;set;} 
        public List<Object_emails> object_events {get;set;} 
        public String guid {get;set;} 
        public String iso_currency_cd {get;set;} 
        public Integer line_id {get;set;} 
        public String cd {get;set;} 
        public String description {get;set;} 
        public String description_localized {get;set;} 
        public Integer quantity {get;set;} 
        public Integer quantity_ordered {get;set;} 
        public Integer quantity_allocated {get;set;} 
        public Integer quantity_fulfilled {get;set;} 
        public Integer unit_price_ref {get;set;} 
        public Integer extended_price {get;set;} 
        public Boolean gift {get;set;} 
        public Boolean dropship {get;set;} 
        public Integer tax_rate {get;set;} 
        public Boolean tax_shipping {get;set;} 
        public Boolean tax_handling {get;set;} 
        public Boolean approved {get;set;} 
        public Boolean taxable {get;set;} 
        public String unit_tax {get;set;} 
        public String product_unit_tax {get;set;} 
        public String unit_shipping {get;set;} 
        public String unit_shipping_tax {get;set;} 
        public String unit_handling {get;set;} 
        public String unit_handling_tax {get;set;} 
        public String unit_insurance {get;set;} 
        public Integer price_adjustment {get;set;} 
        public String unit_price_adjustment {get;set;} 
        public String unit_price_adjustment_tax {get;set;} 
        public String unit_order_price_adjustment {get;set;} 
        public String unit_order_price_adjustment_tax {get;set;} 
        public String lu_dt {get;set;} 
        public String cr_dt {get;set;} 
        public Catalog catalog {get;set;} 
        public Item_Y item {get;set;} 
        public List<Shipments> shipments {get;set;} 
        public List<Object_emails> price_adjustments {get;set;} 
        public List<Object_emails> price_adjustment_distributions {get;set;} 
        public Integer unit_price {get;set;} 
        public Double tax {get;set;} 
        public Double product_tax {get;set;} 

        public Order_item_Y(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'cancelled') {
                            cancelled = parser.getBooleanValue();
                        } else if (text == 'attributes') {
                            attributes = arrayOfAttributes(parser);
                        } else if (text == 'object_emails') {
                            object_emails = arrayOfObject_emails(parser);
                        } else if (text == 'object_activities') {
                            object_activities = arrayOfObject_emails(parser);
                        } else if (text == 'object_events') {
                            object_events = arrayOfObject_emails(parser);
                        } else if (text == 'guid') {
                            guid = parser.getText();
                        } else if (text == 'iso_currency_cd') {
                            iso_currency_cd = parser.getText();
                        } else if (text == 'line_id') {
                            line_id = parser.getIntegerValue();
                        } else if (text == 'cd') {
                            cd = parser.getText();
                        } else if (text == 'description') {
                            description = parser.getText();
                        } else if (text == 'description_localized') {
                            description_localized = parser.getText();
                        } else if (text == 'quantity') {
                            quantity = parser.getIntegerValue();
                        } else if (text == 'quantity_ordered') {
                            quantity_ordered = parser.getIntegerValue();
                        } else if (text == 'quantity_allocated') {
                            quantity_allocated = parser.getIntegerValue();
                        } else if (text == 'quantity_fulfilled') {
                            quantity_fulfilled = parser.getIntegerValue();
                        } else if (text == 'unit_price_ref') {
                            unit_price_ref = parser.getIntegerValue();
                        } else if (text == 'extended_price') {
                            extended_price = parser.getIntegerValue();
                        } else if (text == 'gift') {
                            gift = parser.getBooleanValue();
                        } else if (text == 'dropship') {
                            dropship = parser.getBooleanValue();
                        } else if (text == 'tax_rate') {
                            tax_rate = parser.getIntegerValue();
                        } else if (text == 'tax_shipping') {
                            tax_shipping = parser.getBooleanValue();
                        } else if (text == 'tax_handling') {
                            tax_handling = parser.getBooleanValue();
                        } else if (text == 'approved') {
                            approved = parser.getBooleanValue();
                        } else if (text == 'taxable') {
                            taxable = parser.getBooleanValue();
                        } else if (text == 'unit_tax') {
                            unit_tax = parser.getText();
                        } else if (text == 'product_unit_tax') {
                            product_unit_tax = parser.getText();
                        } else if (text == 'unit_shipping') {
                            unit_shipping = parser.getText();
                        } else if (text == 'unit_shipping_tax') {
                            unit_shipping_tax = parser.getText();
                        } else if (text == 'unit_handling') {
                            unit_handling = parser.getText();
                        } else if (text == 'unit_handling_tax') {
                            unit_handling_tax = parser.getText();
                        } else if (text == 'unit_insurance') {
                            unit_insurance = parser.getText();
                        } else if (text == 'price_adjustment') {
                            price_adjustment = parser.getIntegerValue();
                        } else if (text == 'unit_price_adjustment') {
                            unit_price_adjustment = parser.getText();
                        } else if (text == 'unit_price_adjustment_tax') {
                            unit_price_adjustment_tax = parser.getText();
                        } else if (text == 'unit_order_price_adjustment') {
                            unit_order_price_adjustment = parser.getText();
                        } else if (text == 'unit_order_price_adjustment_tax') {
                            unit_order_price_adjustment_tax = parser.getText();
                        } else if (text == 'lu_dt') {
                            lu_dt = parser.getText();
                        } else if (text == 'cr_dt') {
                            cr_dt = parser.getText();
                        } else if (text == 'catalog') {
                            catalog = new Catalog(parser);
                        } else if (text == 'item') {
                            item = new Item_Y(parser);
                        } else if (text == 'shipments') {
                            shipments = arrayOfShipments(parser);
                        } else if (text == 'price_adjustments') {
                            price_adjustments = arrayOfObject_emails(parser);
                        } else if (text == 'price_adjustment_distributions') {
                            price_adjustment_distributions = arrayOfObject_emails(parser);
                        } else if (text == 'unit_price') {
                            unit_price = parser.getIntegerValue();
                        } else if (text == 'tax') {
                            tax = parser.getDoubleValue();
                        } else if (text == 'product_tax') {
                            product_tax = parser.getDoubleValue();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Order_item_Y consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Item {
        public String guid {get;set;} 
        public String cd {get;set;} 
        public Integer quantity_on_hold {get;set;} 
        public Integer quantity_on_allocation {get;set;} 
        public Integer pieces_per_unit {get;set;} 
        public Integer pieces_per_shipping_unit {get;set;} 
        public Integer shipping_units {get;set;} 
        public Boolean available {get;set;} 
        public Boolean taxable {get;set;} 
        public Object_emails dimensions {get;set;} 
        public List<Object_emails> kit_items {get;set;} 

        public Item(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'guid') {
                            guid = parser.getText();
                        } else if (text == 'cd') {
                            cd = parser.getText();
                        } else if (text == 'quantity_on_hold') {
                            quantity_on_hold = parser.getIntegerValue();
                        } else if (text == 'quantity_on_allocation') {
                            quantity_on_allocation = parser.getIntegerValue();
                        } else if (text == 'pieces_per_unit') {
                            pieces_per_unit = parser.getIntegerValue();
                        } else if (text == 'pieces_per_shipping_unit') {
                            pieces_per_shipping_unit = parser.getIntegerValue();
                        } else if (text == 'shipping_units') {
                            shipping_units = parser.getIntegerValue();
                        } else if (text == 'available') {
                            available = parser.getBooleanValue();
                        } else if (text == 'taxable') {
                            taxable = parser.getBooleanValue();
                        } else if (text == 'dimensions') {
                            dimensions = new Object_emails(parser);
                        } else if (text == 'kit_items') {
                            kit_items = arrayOfObject_emails(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Item consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Order_item_Z {
        public Boolean cancelled {get;set;} 
        public List<Attributes> attributes {get;set;} 
        public List<Object_emails> object_emails {get;set;} 
        public List<Object_emails> object_activities {get;set;} 
        public List<Object_emails> object_events {get;set;} 
        public String guid {get;set;} 
        public String iso_currency_cd {get;set;} 
        public Integer line_id {get;set;} 
        public String cd {get;set;} 
        public String description {get;set;} 
        public String description_localized {get;set;} 
        public Integer quantity {get;set;} 
        public Integer quantity_ordered {get;set;} 
        public Integer quantity_allocated {get;set;} 
        public Integer quantity_fulfilled {get;set;} 
        public Integer unit_price {get;set;} 
        public Integer extended_price {get;set;} 
        public Boolean gift {get;set;} 
        public Boolean dropship {get;set;} 
        public Integer tax_rate {get;set;} 
        public Boolean tax_shipping {get;set;} 
        public Boolean tax_handling {get;set;} 
        public Boolean approved {get;set;} 
        public Boolean taxable {get;set;} 
        public Double tax {get;set;} 
        public String unit_tax {get;set;} 
        public Double product_tax {get;set;} 
        public String product_unit_tax {get;set;} 
        public String unit_shipping {get;set;} 
        public String unit_shipping_tax {get;set;} 
        public String unit_handling {get;set;} 
        public String unit_handling_tax {get;set;} 
        public String unit_insurance {get;set;} 
        public String unit_price_adjustment {get;set;} 
        public String unit_price_adjustment_tax {get;set;} 
        public String unit_order_price_adjustment {get;set;} 
        public String unit_order_price_adjustment_tax {get;set;} 
        public String lu_dt {get;set;} 
        public String cr_dt {get;set;} 
        public Catalog catalog {get;set;} 
        public Item_Z item {get;set;} 
        public List<Shipments> shipments {get;set;} 
        public List<Object_emails> price_adjustments {get;set;} 
        public List<Object_emails> price_adjustment_distributions {get;set;} 

        public Order_item_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'cancelled') {
                            cancelled = parser.getBooleanValue();
                        } else if (text == 'attributes') {
                            attributes = arrayOfAttributes(parser);
                        } else if (text == 'object_emails') {
                            object_emails = arrayOfObject_emails(parser);
                        } else if (text == 'object_activities') {
                            object_activities = arrayOfObject_emails(parser);
                        } else if (text == 'object_events') {
                            object_events = arrayOfObject_emails(parser);
                        } else if (text == 'guid') {
                            guid = parser.getText();
                        } else if (text == 'iso_currency_cd') {
                            iso_currency_cd = parser.getText();
                        } else if (text == 'line_id') {
                            line_id = parser.getIntegerValue();
                        } else if (text == 'cd') {
                            cd = parser.getText();
                        } else if (text == 'description') {
                            description = parser.getText();
                        } else if (text == 'description_localized') {
                            description_localized = parser.getText();
                        } else if (text == 'quantity') {
                            quantity = parser.getIntegerValue();
                        } else if (text == 'quantity_ordered') {
                            quantity_ordered = parser.getIntegerValue();
                        } else if (text == 'quantity_allocated') {
                            quantity_allocated = parser.getIntegerValue();
                        } else if (text == 'quantity_fulfilled') {
                            quantity_fulfilled = parser.getIntegerValue();
                        } else if (text == 'unit_price') {
                            unit_price = parser.getIntegerValue();
                        } else if (text == 'extended_price') {
                            extended_price = parser.getIntegerValue();
                        } else if (text == 'gift') {
                            gift = parser.getBooleanValue();
                        } else if (text == 'dropship') {
                            dropship = parser.getBooleanValue();
                        } else if (text == 'tax_rate') {
                            tax_rate = parser.getIntegerValue();
                        } else if (text == 'tax_shipping') {
                            tax_shipping = parser.getBooleanValue();
                        } else if (text == 'tax_handling') {
                            tax_handling = parser.getBooleanValue();
                        } else if (text == 'approved') {
                            approved = parser.getBooleanValue();
                        } else if (text == 'taxable') {
                            taxable = parser.getBooleanValue();
                        } else if (text == 'tax') {
                            tax = parser.getDoubleValue();
                        } else if (text == 'unit_tax') {
                            unit_tax = parser.getText();
                        } else if (text == 'product_tax') {
                            product_tax = parser.getDoubleValue();
                        } else if (text == 'product_unit_tax') {
                            product_unit_tax = parser.getText();
                        } else if (text == 'unit_shipping') {
                            unit_shipping = parser.getText();
                        } else if (text == 'unit_shipping_tax') {
                            unit_shipping_tax = parser.getText();
                        } else if (text == 'unit_handling') {
                            unit_handling = parser.getText();
                        } else if (text == 'unit_handling_tax') {
                            unit_handling_tax = parser.getText();
                        } else if (text == 'unit_insurance') {
                            unit_insurance = parser.getText();
                        } else if (text == 'unit_price_adjustment') {
                            unit_price_adjustment = parser.getText();
                        } else if (text == 'unit_price_adjustment_tax') {
                            unit_price_adjustment_tax = parser.getText();
                        } else if (text == 'unit_order_price_adjustment') {
                            unit_order_price_adjustment = parser.getText();
                        } else if (text == 'unit_order_price_adjustment_tax') {
                            unit_order_price_adjustment_tax = parser.getText();
                        } else if (text == 'lu_dt') {
                            lu_dt = parser.getText();
                        } else if (text == 'cr_dt') {
                            cr_dt = parser.getText();
                        } else if (text == 'catalog') {
                            catalog = new Catalog(parser);
                        } else if (text == 'item') {
                            item = new Item_Z(parser);
                        } else if (text == 'shipments') {
                            shipments = arrayOfShipments(parser);
                        } else if (text == 'price_adjustments') {
                            price_adjustments = arrayOfObject_emails(parser);
                        } else if (text == 'price_adjustment_distributions') {
                            price_adjustment_distributions = arrayOfObject_emails(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Order_item_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Order_item_W {
        public Boolean cancelled {get;set;} 
        public List<Attributes> attributes {get;set;} 
        public List<Object_emails> object_emails {get;set;} 
        public List<Object_emails> object_activities {get;set;} 
        public List<Object_emails> object_events {get;set;} 
        public String guid {get;set;} 
        public String iso_currency_cd {get;set;} 
        public Integer line_id {get;set;} 
        public String cd {get;set;} 
        public String description {get;set;} 
        public String description_localized {get;set;} 
        public Integer quantity {get;set;} 
        public Integer quantity_ordered {get;set;} 
        public Integer quantity_allocated {get;set;} 
        public Integer quantity_fulfilled {get;set;} 
        public Integer unit_price {get;set;} 
        public Double extended_price {get;set;} 
        public Boolean gift {get;set;} 
        public Boolean dropship {get;set;} 
        public Integer tax_rate {get;set;} 
        public Boolean tax_shipping {get;set;} 
        public Boolean tax_handling {get;set;} 
        public Boolean approved {get;set;} 
        public Boolean taxable {get;set;} 
        public Double tax {get;set;} 
        public String unit_tax {get;set;} 
        public Double product_tax {get;set;} 
        public String product_unit_tax {get;set;} 
        public String unit_shipping {get;set;} 
        public String unit_shipping_tax {get;set;} 
        public String unit_handling {get;set;} 
        public String unit_handling_tax {get;set;} 
        public String unit_insurance {get;set;} 
        public Double price_adjustment {get;set;} 
        public String unit_price_adjustment {get;set;} 
        public String unit_price_adjustment_tax {get;set;} 
        public String unit_order_price_adjustment {get;set;} 
        public String unit_order_price_adjustment_tax {get;set;} 
        public String lu_dt {get;set;} 
        public String cr_dt {get;set;} 
        public Catalog catalog {get;set;} 
        public Item_Z item {get;set;} 
        public List<Shipments> shipments {get;set;} 
        public List<Object_emails> price_adjustments {get;set;} 
        public List<Object_emails> price_adjustment_distributions {get;set;} 

        public Order_item_W(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'cancelled') {
                            cancelled = parser.getBooleanValue();
                        } else if (text == 'attributes') {
                            attributes = arrayOfAttributes(parser);
                        } else if (text == 'object_emails') {
                            object_emails = arrayOfObject_emails(parser);
                        } else if (text == 'object_activities') {
                            object_activities = arrayOfObject_emails(parser);
                        } else if (text == 'object_events') {
                            object_events = arrayOfObject_emails(parser);
                        } else if (text == 'guid') {
                            guid = parser.getText();
                        } else if (text == 'iso_currency_cd') {
                            iso_currency_cd = parser.getText();
                        } else if (text == 'line_id') {
                            line_id = parser.getIntegerValue();
                        } else if (text == 'cd') {
                            cd = parser.getText();
                        } else if (text == 'description') {
                            description = parser.getText();
                        } else if (text == 'description_localized') {
                            description_localized = parser.getText();
                        } else if (text == 'quantity') {
                            quantity = parser.getIntegerValue();
                        } else if (text == 'quantity_ordered') {
                            quantity_ordered = parser.getIntegerValue();
                        } else if (text == 'quantity_allocated') {
                            quantity_allocated = parser.getIntegerValue();
                        } else if (text == 'quantity_fulfilled') {
                            quantity_fulfilled = parser.getIntegerValue();
                        } else if (text == 'unit_price') {
                            unit_price = parser.getIntegerValue();
                        } else if (text == 'extended_price') {
                            extended_price = parser.getDoubleValue();
                        } else if (text == 'gift') {
                            gift = parser.getBooleanValue();
                        } else if (text == 'dropship') {
                            dropship = parser.getBooleanValue();
                        } else if (text == 'tax_rate') {
                            tax_rate = parser.getIntegerValue();
                        } else if (text == 'tax_shipping') {
                            tax_shipping = parser.getBooleanValue();
                        } else if (text == 'tax_handling') {
                            tax_handling = parser.getBooleanValue();
                        } else if (text == 'approved') {
                            approved = parser.getBooleanValue();
                        } else if (text == 'taxable') {
                            taxable = parser.getBooleanValue();
                        } else if (text == 'tax') {
                            tax = parser.getDoubleValue();
                        } else if (text == 'unit_tax') {
                            unit_tax = parser.getText();
                        } else if (text == 'product_tax') {
                            product_tax = parser.getDoubleValue();
                        } else if (text == 'product_unit_tax') {
                            product_unit_tax = parser.getText();
                        } else if (text == 'unit_shipping') {
                            unit_shipping = parser.getText();
                        } else if (text == 'unit_shipping_tax') {
                            unit_shipping_tax = parser.getText();
                        } else if (text == 'unit_handling') {
                            unit_handling = parser.getText();
                        } else if (text == 'unit_handling_tax') {
                            unit_handling_tax = parser.getText();
                        } else if (text == 'unit_insurance') {
                            unit_insurance = parser.getText();
                        } else if (text == 'price_adjustment') {
                            price_adjustment = parser.getDoubleValue();
                        } else if (text == 'unit_price_adjustment') {
                            unit_price_adjustment = parser.getText();
                        } else if (text == 'unit_price_adjustment_tax') {
                            unit_price_adjustment_tax = parser.getText();
                        } else if (text == 'unit_order_price_adjustment') {
                            unit_order_price_adjustment = parser.getText();
                        } else if (text == 'unit_order_price_adjustment_tax') {
                            unit_order_price_adjustment_tax = parser.getText();
                        } else if (text == 'lu_dt') {
                            lu_dt = parser.getText();
                        } else if (text == 'cr_dt') {
                            cr_dt = parser.getText();
                        } else if (text == 'catalog') {
                            catalog = new Catalog(parser);
                        } else if (text == 'item') {
                            item = new Item_Z(parser);
                        } else if (text == 'shipments') {
                            shipments = arrayOfShipments(parser);
                        } else if (text == 'price_adjustments') {
                            price_adjustments = arrayOfObject_emails(parser);
                        } else if (text == 'price_adjustment_distributions') {
                            price_adjustment_distributions = arrayOfObject_emails(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Order_item_W consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Order_item_X {
        public Boolean cancelled {get;set;} 
        public List<Attributes> attributes {get;set;} 
        public List<Object_emails> object_emails {get;set;} 
        public List<Object_emails> object_activities {get;set;} 
        public List<Object_emails> object_events {get;set;} 
        public String guid {get;set;} 
        public String iso_currency_cd {get;set;} 
        public Integer line_id {get;set;} 
        public String cd {get;set;} 
        public String description {get;set;} 
        public String description_localized {get;set;} 
        public Integer quantity {get;set;} 
        public Integer quantity_ordered {get;set;} 
        public Integer quantity_allocated {get;set;} 
        public Integer quantity_fulfilled {get;set;} 
        public Integer extended_price {get;set;} 
        public Boolean gift {get;set;} 
        public Boolean dropship {get;set;} 
        public Integer tax_rate {get;set;} 
        public Boolean tax_shipping {get;set;} 
        public Boolean tax_handling {get;set;} 
        public Boolean approved {get;set;} 
        public Boolean taxable {get;set;} 
        public String unit_tax {get;set;} 
        public String product_unit_tax {get;set;} 
        public Double shipping {get;set;} 
        public String unit_shipping {get;set;} 
        public String unit_shipping_tax {get;set;} 
        public String unit_handling {get;set;} 
        public String unit_handling_tax {get;set;} 
        public String unit_insurance {get;set;} 
        public Integer price_adjustment {get;set;} 
        public String unit_price_adjustment {get;set;} 
        public String unit_price_adjustment_tax {get;set;} 
        public String unit_order_price_adjustment {get;set;} 
        public String unit_order_price_adjustment_tax {get;set;} 
        public String lu_dt {get;set;} 
        public String cr_dt {get;set;} 
        public Catalog catalog {get;set;} 
        public Item item {get;set;} 
        public List<Shipments> shipments {get;set;} 
        public List<Object_emails> price_adjustments {get;set;} 
        public List<Object_emails> price_adjustment_distributions {get;set;} 
        public Integer unit_price {get;set;} 

        public Order_item_X(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'cancelled') {
                            cancelled = parser.getBooleanValue();
                        } else if (text == 'attributes') {
                            attributes = arrayOfAttributes(parser);
                        } else if (text == 'object_emails') {
                            object_emails = arrayOfObject_emails(parser);
                        } else if (text == 'object_activities') {
                            object_activities = arrayOfObject_emails(parser);
                        } else if (text == 'object_events') {
                            object_events = arrayOfObject_emails(parser);
                        } else if (text == 'guid') {
                            guid = parser.getText();
                        } else if (text == 'iso_currency_cd') {
                            iso_currency_cd = parser.getText();
                        } else if (text == 'line_id') {
                            line_id = parser.getIntegerValue();
                        } else if (text == 'cd') {
                            cd = parser.getText();
                        } else if (text == 'description') {
                            description = parser.getText();
                        } else if (text == 'description_localized') {
                            description_localized = parser.getText();
                        } else if (text == 'quantity') {
                            quantity = parser.getIntegerValue();
                        } else if (text == 'quantity_ordered') {
                            quantity_ordered = parser.getIntegerValue();
                        } else if (text == 'quantity_allocated') {
                            quantity_allocated = parser.getIntegerValue();
                        } else if (text == 'quantity_fulfilled') {
                            quantity_fulfilled = parser.getIntegerValue();
                        } else if (text == 'extended_price') {
                            extended_price = parser.getIntegerValue();
                        } else if (text == 'gift') {
                            gift = parser.getBooleanValue();
                        } else if (text == 'dropship') {
                            dropship = parser.getBooleanValue();
                        } else if (text == 'tax_rate') {
                            tax_rate = parser.getIntegerValue();
                        } else if (text == 'tax_shipping') {
                            tax_shipping = parser.getBooleanValue();
                        } else if (text == 'tax_handling') {
                            tax_handling = parser.getBooleanValue();
                        } else if (text == 'approved') {
                            approved = parser.getBooleanValue();
                        } else if (text == 'taxable') {
                            taxable = parser.getBooleanValue();
                        } else if (text == 'unit_tax') {
                            unit_tax = parser.getText();
                        } else if (text == 'product_unit_tax') {
                            product_unit_tax = parser.getText();
                        } else if (text == 'shipping') {
                            shipping = parser.getDoubleValue();
                        } else if (text == 'unit_shipping') {
                            unit_shipping = parser.getText();
                        } else if (text == 'unit_shipping_tax') {
                            unit_shipping_tax = parser.getText();
                        } else if (text == 'unit_handling') {
                            unit_handling = parser.getText();
                        } else if (text == 'unit_handling_tax') {
                            unit_handling_tax = parser.getText();
                        } else if (text == 'unit_insurance') {
                            unit_insurance = parser.getText();
                        } else if (text == 'price_adjustment') {
                            price_adjustment = parser.getIntegerValue();
                        } else if (text == 'unit_price_adjustment') {
                            unit_price_adjustment = parser.getText();
                        } else if (text == 'unit_price_adjustment_tax') {
                            unit_price_adjustment_tax = parser.getText();
                        } else if (text == 'unit_order_price_adjustment') {
                            unit_order_price_adjustment = parser.getText();
                        } else if (text == 'unit_order_price_adjustment_tax') {
                            unit_order_price_adjustment_tax = parser.getText();
                        } else if (text == 'lu_dt') {
                            lu_dt = parser.getText();
                        } else if (text == 'cr_dt') {
                            cr_dt = parser.getText();
                        } else if (text == 'catalog') {
                            catalog = new Catalog(parser);
                        } else if (text == 'item') {
                            item = new Item(parser);
                        } else if (text == 'shipments') {
                            shipments = arrayOfShipments(parser);
                        } else if (text == 'price_adjustments') {
                            price_adjustments = arrayOfObject_emails(parser);
                        } else if (text == 'price_adjustment_distributions') {
                            price_adjustment_distributions = arrayOfObject_emails(parser);
                        } else if (text == 'unit_price') {
                            unit_price = parser.getIntegerValue();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Order_item_X consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class CurrencyObj {
        public String cd {get;set;} 
        public String label {get;set;} 

        public CurrencyObj(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'cd') {
                            cd = parser.getText();
                        } else if (text == 'label') {
                            label = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Currency consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Shipping_method_Z {
        public Integer id {get;set;} 
        public Integer processor_id {get;set;} 
        public String enum_Z {get;set;} // in json: enum

        public Shipping_method_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getIntegerValue();
                        } else if (text == 'processor_id') {
                            processor_id = parser.getIntegerValue();
                        } else if (text == 'enum') {
                            enum_Z = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Shipping_method_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Shipments {
        public String guid {get;set;} 
        public String shipment_guid {get;set;} 
        public String dateObj {get;set;} 
        public String track {get;set;} 
        public Integer quantity {get;set;} 
        public Shipping_method shipping_method {get;set;} 

        public Shipments(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'guid') {
                            guid = parser.getText();
                        } else if (text == 'shipment_guid') {
                            shipment_guid = parser.getText();
                        } else if (text == 'dateObj') {
                            dateObj = parser.getText();
                        } else if (text == 'track') {
                            track = parser.getText();
                        } else if (text == 'quantity') {
                            quantity = parser.getIntegerValue();
                        } else if (text == 'shipping_method') {
                            shipping_method = new Shipping_method(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Shipments consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Shipments_Z {
        public String guid {get;set;} 
        public String id {get;set;} 
        public Integer cost {get;set;} 
        public String dateObj {get;set;} 
        public Boolean approved {get;set;} 
        public Boolean delivered {get;set;} 
        public Boolean shipped {get;set;} 
        public Boolean new_Z {get;set;} // in json: new
        public Boolean closed {get;set;} 
        public String status {get;set;} 
        public String lu_dt {get;set;} 
        public String cr_dt {get;set;} 
        public Address_Z address {get;set;} 
        public Shipping_method_Z shipping_method {get;set;} 

        public Shipments_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'guid') {
                            guid = parser.getText();
                        } else if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'cost') {
                            cost = parser.getIntegerValue();
                        } else if (text == 'dateObj') {
                            dateObj = parser.getText();
                        } else if (text == 'approved') {
                            approved = parser.getBooleanValue();
                        } else if (text == 'delivered') {
                            delivered = parser.getBooleanValue();
                        } else if (text == 'shipped') {
                            shipped = parser.getBooleanValue();
                        } else if (text == 'new') {
                            new_Z = parser.getBooleanValue();
                        } else if (text == 'closed') {
                            closed = parser.getBooleanValue();
                        } else if (text == 'status') {
                            status = parser.getText();
                        } else if (text == 'lu_dt') {
                            lu_dt = parser.getText();
                        } else if (text == 'cr_dt') {
                            cr_dt = parser.getText();
                        } else if (text == 'address') {
                            address = new Address_Z(parser);
                        } else if (text == 'shipping_method') {
                            shipping_method = new Shipping_method_Z(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Shipments_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Object_emails {

        public Object_emails(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        {
                            System.debug(LoggingLevel.WARN, 'Object_emails consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Country_region {
        public Integer id {get;set;} 
        public String cd {get;set;} 
        public String label {get;set;} 

        public Country_region(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getIntegerValue();
                        } else if (text == 'cd') {
                            cd = parser.getText();
                        } else if (text == 'label') {
                            label = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Country_region consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Shipping_method {
        public Integer id {get;set;} 
        public Integer processor_id {get;set;} 
        public String enum_Z {get;set;} // in json: enum
        public String cd {get;set;} 
        public String label {get;set;} 
        public String label_short {get;set;} 

        public Shipping_method(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getIntegerValue();
                        } else if (text == 'processor_id') {
                            processor_id = parser.getIntegerValue();
                        } else if (text == 'enum') {
                            enum_Z = parser.getText();
                        } else if (text == 'cd') {
                            cd = parser.getText();
                        } else if (text == 'label') {
                            label = parser.getText();
                        } else if (text == 'label_short') {
                            label_short = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Shipping_method consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Order_item {
        public Boolean cancelled {get;set;} 
        public List<Attributes> attributes {get;set;} 
        public List<Object_emails> object_emails {get;set;} 
        public List<Object_emails> object_activities {get;set;} 
        public List<Object_emails> object_events {get;set;} 
        public String guid {get;set;} 
        public String iso_currency_cd {get;set;} 
        public Integer line_id {get;set;} 
        public String cd {get;set;} 
        public String description {get;set;} 
        public String description_localized {get;set;} 
        public Integer quantity {get;set;} 
        public Integer quantity_ordered {get;set;} 
        public Integer quantity_allocated {get;set;} 
        public Integer quantity_fulfilled {get;set;} 
        public Integer extended_price {get;set;} 
        public Boolean gift {get;set;} 
        public Boolean dropship {get;set;} 
        public Integer tax_rate {get;set;} 
        public Boolean tax_shipping {get;set;} 
        public Boolean tax_handling {get;set;} 
        public Boolean approved {get;set;} 
        public Boolean taxable {get;set;} 
        public String unit_tax {get;set;} 
        public String product_unit_tax {get;set;} 
        public String unit_shipping {get;set;} 
        public String unit_shipping_tax {get;set;} 
        public String unit_handling {get;set;} 
        public String unit_handling_tax {get;set;} 
        public String unit_insurance {get;set;} 
        public Integer price_adjustment {get;set;} 
        public String unit_price_adjustment {get;set;} 
        public String unit_price_adjustment_tax {get;set;} 
        public String unit_order_price_adjustment {get;set;} 
        public String unit_order_price_adjustment_tax {get;set;} 
        public String lu_dt {get;set;} 
        public String cr_dt {get;set;} 
        public Catalog catalog {get;set;} 
        public Item item {get;set;} 
        public List<Shipments> shipments {get;set;} 
        public List<Object_emails> price_adjustments {get;set;} 
        public List<Object_emails> price_adjustment_distributions {get;set;} 
        public Integer unit_price {get;set;} 
        public Double tax {get;set;} 
        public Double product_tax {get;set;} 

        public Order_item(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'cancelled') {
                            cancelled = parser.getBooleanValue();
                        } else if (text == 'attributes') {
                            attributes = arrayOfAttributes(parser);
                        } else if (text == 'object_emails') {
                            object_emails = arrayOfObject_emails(parser);
                        } else if (text == 'object_activities') {
                            object_activities = arrayOfObject_emails(parser);
                        } else if (text == 'object_events') {
                            object_events = arrayOfObject_emails(parser);
                        } else if (text == 'guid') {
                            guid = parser.getText();
                        } else if (text == 'iso_currency_cd') {
                            iso_currency_cd = parser.getText();
                        } else if (text == 'line_id') {
                            line_id = parser.getIntegerValue();
                        } else if (text == 'cd') {
                            cd = parser.getText();
                        } else if (text == 'description') {
                            description = parser.getText();
                        } else if (text == 'description_localized') {
                            description_localized = parser.getText();
                        } else if (text == 'quantity') {
                            quantity = parser.getIntegerValue();
                        } else if (text == 'quantity_ordered') {
                            quantity_ordered = parser.getIntegerValue();
                        } else if (text == 'quantity_allocated') {
                            quantity_allocated = parser.getIntegerValue();
                        } else if (text == 'quantity_fulfilled') {
                            quantity_fulfilled = parser.getIntegerValue();
                        } else if (text == 'extended_price') {
                            extended_price = parser.getIntegerValue();
                        } else if (text == 'gift') {
                            gift = parser.getBooleanValue();
                        } else if (text == 'dropship') {
                            dropship = parser.getBooleanValue();
                        } else if (text == 'tax_rate') {
                            tax_rate = parser.getIntegerValue();
                        } else if (text == 'tax_shipping') {
                            tax_shipping = parser.getBooleanValue();
                        } else if (text == 'tax_handling') {
                            tax_handling = parser.getBooleanValue();
                        } else if (text == 'approved') {
                            approved = parser.getBooleanValue();
                        } else if (text == 'taxable') {
                            taxable = parser.getBooleanValue();
                        } else if (text == 'unit_tax') {
                            unit_tax = parser.getText();
                        } else if (text == 'product_unit_tax') {
                            product_unit_tax = parser.getText();
                        } else if (text == 'unit_shipping') {
                            unit_shipping = parser.getText();
                        } else if (text == 'unit_shipping_tax') {
                            unit_shipping_tax = parser.getText();
                        } else if (text == 'unit_handling') {
                            unit_handling = parser.getText();
                        } else if (text == 'unit_handling_tax') {
                            unit_handling_tax = parser.getText();
                        } else if (text == 'unit_insurance') {
                            unit_insurance = parser.getText();
                        } else if (text == 'price_adjustment') {
                            price_adjustment = parser.getIntegerValue();
                        } else if (text == 'unit_price_adjustment') {
                            unit_price_adjustment = parser.getText();
                        } else if (text == 'unit_price_adjustment_tax') {
                            unit_price_adjustment_tax = parser.getText();
                        } else if (text == 'unit_order_price_adjustment') {
                            unit_order_price_adjustment = parser.getText();
                        } else if (text == 'unit_order_price_adjustment_tax') {
                            unit_order_price_adjustment_tax = parser.getText();
                        } else if (text == 'lu_dt') {
                            lu_dt = parser.getText();
                        } else if (text == 'cr_dt') {
                            cr_dt = parser.getText();
                        } else if (text == 'catalog') {
                            catalog = new Catalog(parser);
                        } else if (text == 'item') {
                            item = new Item(parser);
                        } else if (text == 'shipments') {
                            shipments = arrayOfShipments(parser);
                        } else if (text == 'price_adjustments') {
                            price_adjustments = arrayOfObject_emails(parser);
                        } else if (text == 'price_adjustment_distributions') {
                            price_adjustment_distributions = arrayOfObject_emails(parser);
                        } else if (text == 'unit_price') {
                            unit_price = parser.getIntegerValue();
                        } else if (text == 'tax') {
                            tax = parser.getDoubleValue();
                        } else if (text == 'product_tax') {
                            product_tax = parser.getDoubleValue();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Order_item consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Item_W {
        public String guid {get;set;} 
        public String cd {get;set;} 
        public String upc {get;set;} 
        public Integer quantity_on_hold {get;set;} 
        public Integer quantity_on_allocation {get;set;} 
        public Integer pieces_per_unit {get;set;} 
        public Integer pieces_per_shipping_unit {get;set;} 
        public Integer shipping_units {get;set;} 
        public Boolean available {get;set;} 
        public Boolean taxable {get;set;} 
        public Object_emails dimensions {get;set;} 
        public List<Object_emails> kit_items {get;set;} 

        public Item_W(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'guid') {
                            guid = parser.getText();
                        } else if (text == 'cd') {
                            cd = parser.getText();
                        } else if (text == 'upc') {
                            upc = parser.getText();
                        } else if (text == 'quantity_on_hold') {
                            quantity_on_hold = parser.getIntegerValue();
                        } else if (text == 'quantity_on_allocation') {
                            quantity_on_allocation = parser.getIntegerValue();
                        } else if (text == 'pieces_per_unit') {
                            pieces_per_unit = parser.getIntegerValue();
                        } else if (text == 'pieces_per_shipping_unit') {
                            pieces_per_shipping_unit = parser.getIntegerValue();
                        } else if (text == 'shipping_units') {
                            shipping_units = parser.getIntegerValue();
                        } else if (text == 'available') {
                            available = parser.getBooleanValue();
                        } else if (text == 'taxable') {
                            taxable = parser.getBooleanValue();
                        } else if (text == 'dimensions') {
                            dimensions = new Object_emails(parser);
                        } else if (text == 'kit_items') {
                            kit_items = arrayOfObject_emails(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Item_W consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Ship_tos_W {
        public String phone {get;set;} 
        public String email {get;set;} 
        public Address address {get;set;} 
        public List<Shipping_groups_W> shipping_groups {get;set;} 

        public Ship_tos_W(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'phone') {
                            phone = parser.getText();
                        } else if (text == 'email') {
                            email = parser.getText();
                        } else if (text == 'address') {
                            address = new Address(parser);
                        } else if (text == 'shipping_groups') {
                            shipping_groups = arrayOfShipping_groups_W(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Ship_tos_W consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Shipping_groups {
        public Shipping_method shipping_method {get;set;} 
        public List<Order_item> order_item {get;set;} 

        public Shipping_groups(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'shipping_method') {
                            shipping_method = new Shipping_method(parser);
                        } else if (text == 'order_item') {
                            order_item = arrayOfOrder_item(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Shipping_groups consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Ship_tos_Y {
        public String phone {get;set;} 
        public String email {get;set;} 
        public Address address {get;set;} 
        public List<Shipping_groups_Y> shipping_groups {get;set;} 

        public Ship_tos_Y(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'phone') {
                            phone = parser.getText();
                        } else if (text == 'email') {
                            email = parser.getText();
                        } else if (text == 'address') {
                            address = new Address(parser);
                        } else if (text == 'shipping_groups') {
                            shipping_groups = arrayOfShipping_groups_Y(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Ship_tos_Y consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Ship_tos_X {
        public String phone {get;set;} 
        public String email {get;set;} 
        public Address address {get;set;} 
        public List<Shipping_groups_X> shipping_groups {get;set;} 

        public Ship_tos_X(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'phone') {
                            phone = parser.getText();
                        } else if (text == 'email') {
                            email = parser.getText();
                        } else if (text == 'address') {
                            address = new Address(parser);
                        } else if (text == 'shipping_groups') {
                            shipping_groups = arrayOfShipping_groups_X(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Ship_tos_X consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Item_Z {
        public String guid {get;set;} 
        public String cd {get;set;} 
        public String upc {get;set;} 
        public Integer quantity_on_hold {get;set;} 
        public Integer quantity_on_allocation {get;set;} 
        public Integer pieces_per_unit {get;set;} 
        public Integer pieces_per_shipping_unit {get;set;} 
        public Integer shipping_units {get;set;} 
        public Boolean available {get;set;} 
        public Boolean taxable {get;set;} 
        public String master_guid {get;set;} 
        public String master_item_cd {get;set;} 
        public Object_emails dimensions {get;set;} 
        public List<Object_emails> kit_items {get;set;} 

        public Item_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'guid') {
                            guid = parser.getText();
                        } else if (text == 'cd') {
                            cd = parser.getText();
                        } else if (text == 'upc') {
                            upc = parser.getText();
                        } else if (text == 'quantity_on_hold') {
                            quantity_on_hold = parser.getIntegerValue();
                        } else if (text == 'quantity_on_allocation') {
                            quantity_on_allocation = parser.getIntegerValue();
                        } else if (text == 'pieces_per_unit') {
                            pieces_per_unit = parser.getIntegerValue();
                        } else if (text == 'pieces_per_shipping_unit') {
                            pieces_per_shipping_unit = parser.getIntegerValue();
                        } else if (text == 'shipping_units') {
                            shipping_units = parser.getIntegerValue();
                        } else if (text == 'available') {
                            available = parser.getBooleanValue();
                        } else if (text == 'taxable') {
                            taxable = parser.getBooleanValue();
                        } else if (text == 'master_guid') {
                            master_guid = parser.getText();
                        } else if (text == 'master_item_cd') {
                            master_item_cd = parser.getText();
                        } else if (text == 'dimensions') {
                            dimensions = new Object_emails(parser);
                        } else if (text == 'kit_items') {
                            kit_items = arrayOfObject_emails(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Item_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Catalog {
        public String guid {get;set;} 
        public String cd {get;set;} 
        public String label {get;set;} 

        public Catalog(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'guid') {
                            guid = parser.getText();
                        } else if (text == 'cd') {
                            cd = parser.getText();
                        } else if (text == 'label') {
                            label = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Catalog consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Item_Y {
        public String guid {get;set;} 
        public String cd {get;set;} 
        public Integer quantity_on_hold {get;set;} 
        public Integer quantity_on_allocation {get;set;} 
        public Integer wholesale_price {get;set;} 
        public Integer pieces_per_unit {get;set;} 
        public Integer pieces_per_shipping_unit {get;set;} 
        public Integer shipping_units {get;set;} 
        public Boolean available {get;set;} 
        public Boolean taxable {get;set;} 
        public Object_emails dimensions {get;set;} 
        public List<Object_emails> kit_items {get;set;} 

        public Item_Y(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'guid') {
                            guid = parser.getText();
                        } else if (text == 'cd') {
                            cd = parser.getText();
                        } else if (text == 'quantity_on_hold') {
                            quantity_on_hold = parser.getIntegerValue();
                        } else if (text == 'quantity_on_allocation') {
                            quantity_on_allocation = parser.getIntegerValue();
                        } else if (text == 'wholesale_price') {
                            wholesale_price = parser.getIntegerValue();
                        } else if (text == 'pieces_per_unit') {
                            pieces_per_unit = parser.getIntegerValue();
                        } else if (text == 'pieces_per_shipping_unit') {
                            pieces_per_shipping_unit = parser.getIntegerValue();
                        } else if (text == 'shipping_units') {
                            shipping_units = parser.getIntegerValue();
                        } else if (text == 'available') {
                            available = parser.getBooleanValue();
                        } else if (text == 'taxable') {
                            taxable = parser.getBooleanValue();
                        } else if (text == 'dimensions') {
                            dimensions = new Object_emails(parser);
                        } else if (text == 'kit_items') {
                            kit_items = arrayOfObject_emails(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Item_Y consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Item_X {
        public String guid {get;set;} 
        public String cd {get;set;} 
        public String upc {get;set;} 
        public Integer quantity_on_hold {get;set;} 
        public Integer pieces_per_unit {get;set;} 
        public Integer pieces_per_shipping_unit {get;set;} 
        public Integer shipping_units {get;set;} 
        public Boolean available {get;set;} 
        public Boolean taxable {get;set;} 
        public String master_guid {get;set;} 
        public String master_item_cd {get;set;} 
        public Object_emails dimensions {get;set;} 
        public List<Object_emails> kit_items {get;set;} 

        public Item_X(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'guid') {
                            guid = parser.getText();
                        } else if (text == 'cd') {
                            cd = parser.getText();
                        } else if (text == 'upc') {
                            upc = parser.getText();
                        } else if (text == 'quantity_on_hold') {
                            quantity_on_hold = parser.getIntegerValue();
                        } else if (text == 'pieces_per_unit') {
                            pieces_per_unit = parser.getIntegerValue();
                        } else if (text == 'pieces_per_shipping_unit') {
                            pieces_per_shipping_unit = parser.getIntegerValue();
                        } else if (text == 'shipping_units') {
                            shipping_units = parser.getIntegerValue();
                        } else if (text == 'available') {
                            available = parser.getBooleanValue();
                        } else if (text == 'taxable') {
                            taxable = parser.getBooleanValue();
                        } else if (text == 'master_guid') {
                            master_guid = parser.getText();
                        } else if (text == 'master_item_cd') {
                            master_item_cd = parser.getText();
                        } else if (text == 'dimensions') {
                            dimensions = new Object_emails(parser);
                        } else if (text == 'kit_items') {
                            kit_items = arrayOfObject_emails(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Item_X consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Shipping_groups_Z {
        public Shipping_method shipping_method {get;set;} 
        public List<Order_item_Z> order_item {get;set;} 

        public Shipping_groups_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'shipping_method') {
                            shipping_method = new Shipping_method(parser);
                        } else if (text == 'order_item') {
                            order_item = arrayOfOrder_item_Z(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Shipping_groups_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public List<Details> details {get;set;} 

    public OrderDetails(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'details') {
                        details = arrayOfDetails(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'OrderDetail consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public class Details {
        public List<Attributes> attributes {get;set;} 
        public List<Object_emails> object_emails {get;set;} 
        public List<Object_emails> object_activities {get;set;} 
        public List<Object_emails> object_events {get;set;} 
        public String guid {get;set;} 
        public Integer currency_rate {get;set;} 
        public Integer taxation_policy_type_id {get;set;} 
        public String id {get;set;} 
        public String label {get;set;} 
        public Datetime dateObj {get;set;} 
        public String checkout_date {get;set;} 
        public String paid_date {get;set;} 
        public String fulfilled_date {get;set;} 
        public Integer subtotal {get;set;} 
        public Double subtotal_tax {get;set;} 
        public Double tax {get;set;} 
        public Boolean shipping_item_based {get;set;} 
        public Integer shipping {get;set;} 
        public Double total {get;set;} 
        public Integer total_allocated {get;set;} 
        public Integer total_shipped {get;set;} 
        public Double amount_attached {get;set;} 
        public Boolean suppress_combining {get;set;} 
        public Boolean customer_complete {get;set;} 
        public Boolean shipping_complete {get;set;} 
        public Boolean complete {get;set;} 
        public String payment_account_guid {get;set;} 
        public Boolean authorized {get;set;} 
        public Boolean approved {get;set;} 
        public Boolean allocated {get;set;} 
        public Boolean fulfilled {get;set;} 
        public Boolean visible {get;set;} 
        public Boolean closed {get;set;} 
        public Boolean filed {get;set;} 
        public String status {get;set;} 
        public String lu_dt {get;set;} 
        public String cr_dt {get;set;} 
        public String lu_guid {get;set;} 
        public Boolean scrub_failed {get;set;} 
        public Type_Z type_Z {get;set;} // in json: type
        public Catalog catalog {get;set;} 
        public CurrencyObj CurrencyObj {get;set;} 
        public Customer customer {get;set;} 
        public Bill_to bill_to {get;set;} 
        public List<Ship_tos> ship_tos {get;set;} 
        public List<Object_emails> payment_methods {get;set;} 
        public List<Object_emails> payments {get;set;} 
        public List<Shipments_Z> shipments {get;set;} 
        public List<Object_emails> price_adjustments {get;set;} 
        public List<Object_emails> invoices {get;set;} 
        public List<Object_emails> return_orders {get;set;} 

        public Details(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'attributes') {
                            attributes = arrayOfAttributes(parser);
                        } else if (text == 'object_emails') {
                            object_emails = arrayOfObject_emails(parser);
                        } else if (text == 'object_activities') {
                            object_activities = arrayOfObject_emails(parser);
                        } else if (text == 'object_events') {
                            object_events = arrayOfObject_emails(parser);
                        } else if (text == 'guid') {
                            guid = parser.getText();
                        } else if (text == 'currency_rate') {
                            currency_rate = parser.getIntegerValue();
                        } else if (text == 'taxation_policy_type_id') {
                            taxation_policy_type_id = parser.getIntegerValue();
                        } else if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'label') {
                            label = parser.getText();
                        } else if (text == 'dateObj') {
                            dateObj = parser.getDatetimeValue();
                        } else if (text == 'checkout_date') {
                            checkout_date = parser.getText();
                        } else if (text == 'paid_date') {
                            paid_date = parser.getText();
                        } else if (text == 'fulfilled_date') {
                            fulfilled_date = parser.getText();
                        } else if (text == 'subtotal') {
                            subtotal = parser.getIntegerValue();
                        } else if (text == 'subtotal_tax') {
                            subtotal_tax = parser.getDoubleValue();
                        } else if (text == 'tax') {
                            tax = parser.getDoubleValue();
                        } else if (text == 'shipping_item_based') {
                            shipping_item_based = parser.getBooleanValue();
                        } else if (text == 'shipping') {
                            shipping = parser.getIntegerValue();
                        } else if (text == 'total') {
                            total = parser.getDoubleValue();
                        } else if (text == 'total_allocated') {
                            total_allocated = parser.getIntegerValue();
                        } else if (text == 'total_shipped') {
                            total_shipped = parser.getIntegerValue();
                        } else if (text == 'amount_attached') {
                            amount_attached = parser.getDoubleValue();
                        } else if (text == 'suppress_combining') {
                            suppress_combining = parser.getBooleanValue();
                        } else if (text == 'customer_complete') {
                            customer_complete = parser.getBooleanValue();
                        } else if (text == 'shipping_complete') {
                            shipping_complete = parser.getBooleanValue();
                        } else if (text == 'complete') {
                            complete = parser.getBooleanValue();
                        } else if (text == 'payment_account_guid') {
                            payment_account_guid = parser.getText();
                        } else if (text == 'authorized') {
                            authorized = parser.getBooleanValue();
                        } else if (text == 'approved') {
                            approved = parser.getBooleanValue();
                        } else if (text == 'allocated') {
                            allocated = parser.getBooleanValue();
                        } else if (text == 'fulfilled') {
                            fulfilled = parser.getBooleanValue();
                        } else if (text == 'visible') {
                            visible = parser.getBooleanValue();
                        } else if (text == 'closed') {
                            closed = parser.getBooleanValue();
                        } else if (text == 'filed') {
                            filed = parser.getBooleanValue();
                        } else if (text == 'status') {
                            status = parser.getText();
                        } else if (text == 'lu_dt') {
                            lu_dt = parser.getText();
                        } else if (text == 'cr_dt') {
                            cr_dt = parser.getText();
                        } else if (text == 'lu_guid') {
                            lu_guid = parser.getText();
                        } else if (text == 'scrub_failed') {
                            scrub_failed = parser.getBooleanValue();
                        } else if (text == 'type') {
                            type_Z = new Type_Z(parser);
                        } else if (text == 'catalog') {
                            catalog = new Catalog(parser);
                        } else if (text == 'CurrencyObj') {
                            CurrencyObj = new CurrencyObj(parser);
                        } else if (text == 'customer') {
                            customer = new Customer(parser);
                        } else if (text == 'bill_to') {
                            bill_to = new Bill_to(parser);
                        } else if (text == 'ship_tos') {
                            ship_tos = arrayOfShip_tos(parser);
                        } else if (text == 'payment_methods') {
                            payment_methods = arrayOfObject_emails(parser);
                        } else if (text == 'payments') {
                            payments = arrayOfObject_emails(parser);
                        } else if (text == 'shipments') {
                            shipments = arrayOfShipments_Z(parser);
                        } else if (text == 'price_adjustments') {
                            price_adjustments = arrayOfObject_emails(parser);
                        } else if (text == 'invoices') {
                            invoices = arrayOfObject_emails(parser);
                        } else if (text == 'return_orders') {
                            return_orders = arrayOfObject_emails(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Details consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Ship_tos_Z {
        public String phone {get;set;} 
        public String email {get;set;} 
        public Address address {get;set;} 
        public List<Shipping_groups_Z> shipping_groups {get;set;} 

        public Ship_tos_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'phone') {
                            phone = parser.getText();
                        } else if (text == 'email') {
                            email = parser.getText();
                        } else if (text == 'address') {
                            address = new Address(parser);
                        } else if (text == 'shipping_groups') {
                            shipping_groups = arrayOfShipping_groups_Z(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Ship_tos_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Ship_tos {
        public String phone {get;set;} 
        public String email {get;set;} 
        public Address address {get;set;} 
        public List<Shipping_groups> shipping_groups {get;set;} 

        public Ship_tos(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'phone') {
                            phone = parser.getText();
                        } else if (text == 'email') {
                            email = parser.getText();
                        } else if (text == 'address') {
                            address = new Address(parser);
                        } else if (text == 'shipping_groups') {
                            shipping_groups = arrayOfShipping_groups(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Ship_tos consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Country {
        public Integer id {get;set;} 
        public String enum_Z {get;set;} // in json: enum
        public String cd {get;set;} 
        public String label {get;set;} 

        public Country(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getIntegerValue();
                        } else if (text == 'enum') {
                            enum_Z = parser.getText();
                        } else if (text == 'cd') {
                            cd = parser.getText();
                        } else if (text == 'label') {
                            label = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Country consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Address_Z {
        public String attention {get;set;} 
        public String address1 {get;set;} 
        public String city {get;set;} 
        public String postal_code {get;set;} 
        public Country_region country_region {get;set;} 
        public Country_Z country {get;set;} 

        public Address_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'attention') {
                            attention = parser.getText();
                        } else if (text == 'address1') {
                            address1 = parser.getText();
                        } else if (text == 'city') {
                            city = parser.getText();
                        } else if (text == 'postal_code') {
                            postal_code = parser.getText();
                        } else if (text == 'country_region') {
                            country_region = new Country_region(parser);
                        } else if (text == 'country') {
                            country = new Country_Z(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Address_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Bill_to {
        public String phone {get;set;} 
        public String email {get;set;} 
        public Address address {get;set;} 

        public Bill_to(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'phone') {
                            phone = parser.getText();
                        } else if (text == 'email') {
                            email = parser.getText();
                        } else if (text == 'address') {
                            address = new Address(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Bill_to consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    
    public static OrderDetails parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new OrderDetails(parser);
    }
    
    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT || 
                curr == System.JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == System.JSONToken.END_OBJECT ||
                curr == System.JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }
    


    private static List<Order_item_W> arrayOfOrder_item_W(System.JSONParser p) {
        List<Order_item_W> res = new List<Order_item_W>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Order_item_W(p));
        }
        return res;
    }




    private static List<Order_item_X> arrayOfOrder_item_X(System.JSONParser p) {
        List<Order_item_X> res = new List<Order_item_X>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Order_item_X(p));
        }
        return res;
    }



    private static List<Order_item> arrayOfOrder_item(System.JSONParser p) {
        List<Order_item> res = new List<Order_item>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Order_item(p));
        }
        return res;
    }




    private static List<Attributes> arrayOfAttributes(System.JSONParser p) {
        List<Attributes> res = new List<Attributes>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Attributes(p));
        }
        return res;
    }




    private static List<Shipments_Z> arrayOfShipments_Z(System.JSONParser p) {
        List<Shipments_Z> res = new List<Shipments_Z>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Shipments_Z(p));
        }
        return res;
    }






    private static List<Details> arrayOfDetails(System.JSONParser p) {
        List<Details> res = new List<Details>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Details(p));
        }
        return res;
    }


    private static List<Values> arrayOfValues(System.JSONParser p) {
        List<Values> res = new List<Values>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Values(p));
        }
        return res;
    }






    private static List<Ship_tos_Y> arrayOfShip_tos_Y(System.JSONParser p) {
        List<Ship_tos_Y> res = new List<Ship_tos_Y>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Ship_tos_Y(p));
        }
        return res;
    }




    private static List<Shipping_groups_Y> arrayOfShipping_groups_Y(System.JSONParser p) {
        List<Shipping_groups_Y> res = new List<Shipping_groups_Y>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Shipping_groups_Y(p));
        }
        return res;
    }


    private static List<Shipments> arrayOfShipments(System.JSONParser p) {
        List<Shipments> res = new List<Shipments>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Shipments(p));
        }
        return res;
    }


    private static List<Ship_tos_W> arrayOfShip_tos_W(System.JSONParser p) {
        List<Ship_tos_W> res = new List<Ship_tos_W>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Ship_tos_W(p));
        }
        return res;
    }


    private static List<Object_emails> arrayOfObject_emails(System.JSONParser p) {
        List<Object_emails> res = new List<Object_emails>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Object_emails(p));
        }
        return res;
    }




    private static List<Shipping_groups_W> arrayOfShipping_groups_W(System.JSONParser p) {
        List<Shipping_groups_W> res = new List<Shipping_groups_W>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Shipping_groups_W(p));
        }
        return res;
    }


    private static List<Values_Z> arrayOfValues_Z(System.JSONParser p) {
        List<Values_Z> res = new List<Values_Z>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Values_Z(p));
        }
        return res;
    }


    private static List<Ship_tos_Z> arrayOfShip_tos_Z(System.JSONParser p) {
        List<Ship_tos_Z> res = new List<Ship_tos_Z>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Ship_tos_Z(p));
        }
        return res;
    }



    private static List<Ship_tos> arrayOfShip_tos(System.JSONParser p) {
        List<Ship_tos> res = new List<Ship_tos>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Ship_tos(p));
        }
        return res;
    }


    private static List<Ship_tos_X> arrayOfShip_tos_X(System.JSONParser p) {
        List<Ship_tos_X> res = new List<Ship_tos_X>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Ship_tos_X(p));
        }
        return res;
    }

    private static List<Order_item_Z> arrayOfOrder_item_Z(System.JSONParser p) {
        List<Order_item_Z> res = new List<Order_item_Z>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Order_item_Z(p));
        }
        return res;
    }



    private static List<Order_item_Y> arrayOfOrder_item_Y(System.JSONParser p) {
        List<Order_item_Y> res = new List<Order_item_Y>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Order_item_Y(p));
        }
        return res;
    }





    private static List<Shipping_groups_X> arrayOfShipping_groups_X(System.JSONParser p) {
        List<Shipping_groups_X> res = new List<Shipping_groups_X>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Shipping_groups_X(p));
        }
        return res;
    }




    private static List<Shipping_groups_Z> arrayOfShipping_groups_Z(System.JSONParser p) {
        List<Shipping_groups_Z> res = new List<Shipping_groups_Z>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Shipping_groups_Z(p));
        }
        return res;
    }


    private static List<Shipping_groups> arrayOfShipping_groups(System.JSONParser p) {
        List<Shipping_groups> res = new List<Shipping_groups>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Shipping_groups(p));
        }
        return res;
    }



}