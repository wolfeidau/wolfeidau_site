+++
tags = [ "Development", "aws", "dynamodb" ]
date = "2017-05-25T22:22:47+10:00"
title = "So you want to use DynamoDB?"

+++

Over the last few months I have been working on a project which uses [DynamoDB](https://aws.amazon.com/dynamodb/) almost exclusively for persistence, this has been a big challenge for everyone on the team. As a developer, most of us are comfortable using a Relational database management system (RDBMS) systems, so the move to a primitive key value store has been fun, but we have learnt a lot. To try and capture some of these learnings I have written this article, hopefully it will help those who embark on a similar journey.

## Why DynamoDB?

Some of the advantages DynamoDB offers:

* A Key/Value model where the values are any number of fields
* Simplified data access
* Low operational overhead
* Cost, a well tuned DynamoDB costs a few dollars a month to operate

As a developer getting starting with DynamoDB you need to know about:

1. Eventual consistency, this is integral to how DynamoDB achieves it's cost, resilience and scalability. Simple things such as writing a record, then retrieving it straight afterwards require some logic to cope with records which aren't visible yet.
2. Performing `select * from Table` is not recommended when working with DynamoDB, this will trigger scan operations which are less efficient than other operations in DynamoDB. It should be only used on small tables.

Using any key/value store can be tricky at first, especially if you’re used to relational databases. I have put together a list of recommendations and tips which will hopefully help those starting out with this product.

## Retries

When you insert data into DynamoDB not every shard will immediately see your data, an attempt to read the data from the table may not get the value your looking for. If your inserting a new row, then attempting to read immediately afterwards you may get an empty response. 

To mitigate this you will need to implement retries, ideally with a back off to avoid exhausting your provisioned throughput.

Global secondary indexes (GSIs) further complicate this, as these are also updated eventually, in our experience even more eventually than the base table. Again be aware when inserting rows you want to access straight afterwards you may need to check if a row is present in the index with a similar retry.

## Data Modelling

The first big thing you need to understand is that DynamoDB doesn't have relationships, in most cases it will be better to start by storing related data denormalised in a given record using the document feature of the client APIs. The reason we do this is it can be difficult keeping related data across tables in sync. 

I recommend keeping everything denormalised in a single record for as long as you can.

## Pagination

Although most of the clients provided by amazon have a concept of paging built in, this is really forward only, which makes building a classic paginated list quite a bit harder. This is best illustrated with some excerpts from the DynamoDB API.

Firstly `QueryInput` from the golang AWS SDK we have the ability to pass in an `ExclusiveStartKey`.

```
type QueryInput struct {
...
    // The primary key of the first item that this operation will evaluate. Use
    // the value that was returned for LastEvaluatedKey in the previous operation.
    //
    // The data type for ExclusiveStartKey must be String, Number or Binary. No
    // set data types are allowed.
    ExclusiveStartKey map[string]*AttributeValue `type:"map"`
...
}
```

And in the `QueryOutput` we have the `LastEvaluatedKey`.

```
type QueryOutput struct {
...
    // The primary key of the item where the operation stopped, inclusive of the
    // previous result set. Use this value to start a new operation, excluding this
    // value in the new request.
    //
    // If LastEvaluatedKey is empty, then the "last page" of results has been processed
    // and there is no more data to be retrieved.
    //
    // If LastEvaluatedKey is not empty, it does not necessarily mean that there
    // is more data in the result set. The only way to know when you have reached
    // the end of the result set is when LastEvaluatedKey is empty.
    LastEvaluatedKey map[string]*AttributeValue `type:"map"`
...
}
```

Given all we have are some keys, which may or may not be deleted it is very difficult to build a classic paged view.

So it has become clear to me we need to embrace a new strategy for displaying pages of results, luckily lots of others have run into this issue and the common pattern is to:

1. Use infinite scrolling, similar to twitter and other social media sites.
2. Maintain the state in the client with a cache of pages which have previously been loaded.

For more information on this see [The End of Pagination](https://blog.codinghorror.com/the-end-of-pagination/).

## Sorting

Just a small note on sorting, in more complicated tables you will need to add indexes purely to sort data in a specific way.

Also within the AWS api sorting uses the rather interestingly named `ScanIndexForward`.

```
    // If ScanIndexForward is true, DynamoDB returns the results in the order in
    // which they are stored (by sort key value). This is the default behavior.
    // If ScanIndexForward is false, DynamoDB reads the results in reverse order
    // by sort key value, and then returns the results to the client.
    ScanIndexForward *bool `type:"boolean"`
```

## You are not alone

These challenges presented by DynamoDB not unique, NoSQL databases such as Riak, and Cassandra, share some of the same limitations, again to enable resilience and scalability. When searching for ideas, suggestions or strategies to deal with it you may find answers around these open source projects.

## In Closing

I think it is important to note that learning DynamoDB will broaden your horizons, and in some ways change the way you look at persistence, this in my view is a good thing.