global class ArticleBatchIterator implements Iterator<string>
{
	List<string> strRecTypes{get; set;}
   	Integer i {get; set;}

   	public ArticleBatchIterator()
   	{
    	strRecTypes = new List<string>{'Additional_Benefits',
            'C_G_Article',
            'Core_Benefit',
            'External_Publication',
            'Multi_Topic',
            'Multi_Topic_Details',
            'Open_Enrollment',
            'Procedure',
            'Single_Topic',
            'Support_Queue',
            'Universal_Service'};
       	i = 0;
   	}

    global boolean hasNext()
    {
        if(i >= strRecTypes.size())
        {
            return false;
        } else {
            return true;
        }
    }

    global string next()
    {
        if(i > strRecTypes.size())
        {
            return null;
        }
        i++;
        return strRecTypes[i-1];
    }
}