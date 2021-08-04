#  SWAPI_Playgrounds

In this project students will send HTTP requests in Postman and then in Xcode Playgrounds.
In the finished playground, they will perform a fetch for a Person and then a series of fetches for each Film in which the person appears.

Before we being, one disclaimer: These instructions are designed to work with the Star Wars API, based on how the API documentation is laid out at the time we last edited these instructions. Unfortunately, if SWAPI were to change how their API works, our instructions may no longer be correct. If you notice that any of these instructions no longer line up with how the API works, please notify an instructor so we can get an update put in.

## Part Zero - Familiarity with the Documentation

* Find which endpoints to hit for people and films
* Look at a sample response (JSON)
* Determine how to structure your model

All data in this project is retrieved from **https://swapi.dev/**. Because your project depends entirely on communication to the server, you need to determine two things:
- How/where to talk to the server (outgoing)
- How to understand the response (incoming)

1. Visit the above URL and look at the documentation. The base URL is prominently displayed on a label. `https://swapi.dev/api/`. All requests to the server will begin with that URL.
2. The sample request has two components added to it - `people/`, the person endpoint we'll be hitting, and `1/` the "ID" for a particular person. In this case, Luke Skywalker.
3. You have your Person endpoint, but you still need the Film endpoint. At the top-right, hit "Documentation" and then look for "Films".
4. It has the same base URL but this time the endpoint is named `films/`. According to the documentation, the Film endpoint also takes an ID.
5. You now have both of your endpoints.


## Part One - Postman

### Character

* Install Postman if you haven't already and open up a new request.

* Paste the full URL for a Person and hit Send. If successful, Postman will print out JSON person information.
*If you aren't getting correct info, make sure your URL is formatted correctly. `https://swapi.dev/api/people/{CHARACTER_ID}`*

* The field "films" is an array of URL strings. Copy one of these to your clipboard and open a new tab in Postman.

* Paste the film URL and hit Send. The response JSON is your Film model.

* You now have both JSON responses and are ready to declare your models in Swift.

## Part Two - Models

* In a new Swift playground, create a Person struct. Person is a Swift representation of JSON data, so its properties need to be based on the JSON you received in Postman.

* Give Person `name: String` and `films: [URL]` properties. Add any other properties you would also like to decode. Make sure to spell them identically to the JSON.

* Create a Film struct and, using the JSON, give it properties for `title`, `opening_crawl` and `release_date`.
*It's ok that your property names are written in snake_case. In the future we'll learn strategies to avoid this.*

* Conform both of your types to `Decodable`.

## Part Three - SwapiService

### GET Person

* Below your two custom types, create a class named `SwapiService`. This class will be responsible for fetching data from SWAPI and parsing it into your models.

* Since both fetches use the same base URL, add it to the top level of your SwapiService.
`static private let baseURL = URL(string: "https://swapi.dev/api/")`

* Declare a static function "fetchPerson" that takes an id of type `Int` and a completion block.
```
static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
    // 1 - Prepare URL
    
    // 2 - Contact server
    
    // 3 - Handle errors
    
    // 4 - Check for data
    
    // 5 - Decode Person from JSON
}
```


* Step one is to prepare your URL. Unwrap the base URL and in the `else` clause, call `completion(nil)`.

* Declare `finalURL` by calling `baseURL.appendingPathComponent()` and pass in the rest of the Person endpoint path.

* To contact the server, call `URLSession.shared.dataTask(with:completion:)`. Pass in your URL and then hover over the completion block and hit "return" to expand it.

* Add `.resume()` to the closing bracket of your completion block.

* Name the arguments `data`, `_` and `error`. 

* The next step is to handle errors inside the data task. Use `if-let` to unwrap the optional error. Print it out and call `completion(nil)` if there is one. Any time completion is called, `return` from the function as well.

* Use `guard let` to unwrap the data. As before, call completion in the `else` clause.

*Because decoding is a throwing function, the rest of the data task will take place inside of a `do-catch` block.*
* In the `do` portion. Declare an instance of `JSONDecoder` and name it "decoder".

* Call the decoder to decode a Person from the data. You have to `try` in case it throws an error.
`let person = try decoder.decode(Person.self, from: data)`

* If person successfully decodes, complete with it.

* In the `catch` block, print out the error and complete with `nil`.

* Test out your fetch function by calling it and printing out the resulting Person. If it fails, your prior error handling should print an error describing why.
```
SwapiService.fetchPerson(id: 10) { person in
    if let person = person {
        print(person)
    }
}
```

### GET Film

* Declare a static function that takes in a URL and completion block of type `(Film?) -> Void`.
```
static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
    // 1 - Contact server
    
    // 2 - Handle errors
    
    // 3 - Check for data
    
    // 4 - Decode Film from JSON
}
```

*This function takes in a completed URL, so you wont need to do any additional preparation on it.*

* Call `URLSession.shared.dataTask(with:completion:)`. Pass in the url, expand it and give the same argument names as before.

* Call `.resume()` at the end of the completion block.

* Use `if-let` to unwrap the error and `guard let` to unwrap data. Don't forget to call `completion(nil)` in both cases and `return`.

* Time to decode. Open up your `do-catch` and declare another `JSONDecoder`.

* Use the same syntax as before to decode a film. If successful, complete with it.

* Remember to handle errors and call completion in the `catch` block.

## Part Four - Perform GET Requests

### Separate Code

* Declare a function called `fetchFilm(url: URL)`. Inside of that function, call your SwapiService and fetch a film from the passed in url.

* Print out the result of the fetch.
```
func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { film in
        if let film = film {
            print(film)
        }
    }
}
```

### Final Product

* Below the print statement in your Person fetch. Create a `for` loop and call your new function for each URL in the person's films array.

* If everything has been done correctly to this point, you are now able to pass in any person id and see the character info + all films in which it appears.
