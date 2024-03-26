import Foundation
import CryptoKit

extension String {
    var md5: String {
       Insecure.MD5.hash(data: self.data(using: .utf8)!).map { String(format: "%02hhx", $0) }.joined()
    }
}

let publicKey = "b451b8ec0d74a130bbc44bff9b41e7a0"
let privateKey = "b27da1936beedfcc3d727be8393339edfdb76ceb"
let ts = 1
let hash = (String(ts) + privateKey + publicKey).md5

func getData(urlRequest: String) {
    guard let url = URL(string: urlRequest) else {
        print("\nInvalid URL")
        return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("\nError:", error.localizedDescription)
        } else if let response = response as? HTTPURLResponse {
            guard let data = data else {
                print("\nNo data received")
                return
            }
            if let dataAsString = String(data: data, encoding: .utf8) {
                print("\nResponse status code:", response.statusCode)
                print("\nData received from server:", dataAsString)
            } else {
                print("\nUnable to convert data to string")
            }
        }
    }.resume()
}

getData(urlRequest: "https://dog.ceo/api/breeds/image/random")  // code 200
getData(urlRequest: "https://dog.ceo/api/breeds/image/random1") // code 404
getData(urlRequest: "https://dog1.ceo/api/breeds/image/random") // Error: hostname not found
getData(urlRequest: "")                                         // Invalid URL

// Task *

getData(urlRequest: "http://gateway.marvel.com/v1/public/comics?ts=\(ts)&apikey=\(publicKey)&hash=\(hash)")    // code 200
getData(urlRequest: "http://gateway.marvel.com/v1/public/comics?ts=\(ts)&apikey=\(publicKey)&hash=\(hash)1")   // code 401
getData(urlRequest: "http://gateway.marvel.com/v1/public/comics?ts1=\(ts)&apikey=\(publicKey)&hash=\(hash)")   // code 409
getData(urlRequest: "http://gateway1.marvel.com/v1/public/comics?ts=\(ts)&apikey=\(publicKey)&hash=\(hash)")   // Error: hostname not found
