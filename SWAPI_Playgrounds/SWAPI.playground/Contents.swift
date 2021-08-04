import UIKit

struct Films: Decodable {
    let title: String
    let opening_crawl: String
    let release_date: String
}


struct Person: Decodable {
    let name: String
    let films: [URL]
}

class SwapiService {
    
    static private let baseURL = URL(string: "https://swapi.dev/api/people/")
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        
        //https://swapi.dev/api/people/
        
        guard let baseURL = baseURL else { return }
        print("made it here 1")
        let finalURL = baseURL.appendingPathComponent("\(id)")
        print(finalURL)
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            
            
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                return completion(nil)
            }
            
            guard let data = data else { return completion(nil) }
            
            
            do {
                let person = try JSONDecoder().decode(Person.self, from: data)
                print("made it here 2")
                return completion(person)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                return completion(nil)
            }
        }.resume()
    }

    static func fetchFilm(url: URL?, completion: @escaping (Films?) -> Void) {
        guard let finalURL = url else { return completion(nil) }
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            
            
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                return completion(nil)
            }
            
            guard let data = data else { return completion(nil) }
            
            
            do {
                let person = try JSONDecoder().decode(Films.self, from: data)
                print("made it here 2")
                return completion(person)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                return completion(nil)
            }
        }.resume()
    }
}
func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { film in
        if let film = film {
            print("************")
            print(film.title)
            print(film.release_date)
            print(film.opening_crawl)
            print("_____________")
        }
    }
}
SwapiService.fetchPerson(id: 34) { person in
    if let person = person {
        print(person)
        for film in person.films {
            fetchFilm(url: film)
        }
    }
}
