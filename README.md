# Basic URL shortener

This is basic url shortener, what do you expect? 

App available at: http://jealrock-url-shortener.herokuapp.com/

## Additional Features

### Expiring

Shortened links are deleted from the DB after 14 days after creation.
    
### API

There is 2 api calls available, to reach them you need to send `post` or `get` request
to url's:

1. `http://jealrock-url-shortener.herokuapp.com/api/truncate`

    **With params:**

    * `original`(required) - original URL
    * `shortened`(optional) - desired path in shortened URL. For example if value of this parameter is `my_shortened_params`, then shortened URL will be: `http://jealrock-url-shortener.herokuapp.com/my_shortened_param`
    * `user_token`(optional) - token obtained after using this call. If provided, saves the URL pair with association to this token.

    **Returns json** `{'status': status, "data": data }`
    where:
    * `status` - could be `ok` or `fail`
    * `data` - if status is `ok` then contains `original` and `shortened` fields of newly created link, otherwise contains array of errors  


2. `http://jealrock-url-shortener.herokuapp.com/api/get`

    **With params:**
    
    * `original`(optional) - original URL
    * `user_token`(required) - token obtained after using `truncate` api call. Needed to confirm that you are owner of the shortened links
    
    **Returns json** `{'status': status, "data": data }` where:
    * `status` - could be `ok` or `fail`
    * `data` - if status is `ok` then contains array of url pairs with `visits_count` and `expiring_at` fields finded by given parameters, otherwise contains single error as `string`