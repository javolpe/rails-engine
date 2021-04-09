# README

### Rails Engine is a mock back end for an E-Commerce site that allows you to query for Merchants and Items sorted in different ways.
Some endpoints are more straight forward such as "Finding all Merchants" while others have some Business Intelligence logic involved in the endpoint such as "Get Merhants with most Revenue". No API key is needed to access the data.  This projet is for demostration purposes only and is not yet hosted publicly online so for now it will have to be run locally to work.


#### Endpoints

Get all merchants:
`http://localhost:3000/api/v1/merchants`
Will return all merchants, no params needed.

Get one merchant: 
`http://localhost:3000/api/v1/merchants/{{merchant_id}}`
Will return a single merchant with that merchants id passed in as a query param.  Returns the merchants id and name.

Get a merchant's items:
`http://localhost:3000/api/v1/merchants/{{merchant_id}}/items`
Takes a param of merchant id and will return back all of that merchant's items. Returns the item's name, description, merchant id and price.

Get all items:
`http://localhost:3000/api/v1/items`
No params needed, returns all items. Will return back all of that merchant's items. Returns the item's name, description, merchant id and price.

Get one item:
`http://localhost:3000/api/v1/items/{{item_id}}`
Param of item id needed, will return back all of that merchant's items. Returns the item's name, description, merchant id and price.
