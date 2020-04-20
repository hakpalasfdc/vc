global class ArticleBatchIterable implements iterable<string>
{
    global Iterator<string> Iterator()
    {
		return new ArticleBatchIterator();
    }
}