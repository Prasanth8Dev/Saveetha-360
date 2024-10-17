//
//  APIWrapper.swift
//  Saveetha 360
//
//  Created by Prasanth S on 14/10/24.
//

import Foundation
import Combine

enum APIError: Error {
    case invalidResponse
    case requestFailed
    case decodingError
}

class APIWrapper {
    static let shared = APIWrapper()

    
    func postRequestMethod<T: Decodable>(url: URL, body: [String: Any], responseType: T.Type) -> AnyPublisher<T, Error> {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Convert body to JSON data
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { output -> Data in
                    // Print the raw response data as a string
                    if let jsonString = String(data: output.data, encoding: .utf8) {
                        print("Response Data: \(jsonString)")
                    } else {
                        print("Unable to convert data to string")
                    }
                    
                    // Return the data to be decoded
                    return output.data
                }
                .tryCatch { error -> AnyPublisher<Data, Error> in
                    print("Error in request: \(error)")
                    // Re-throw the error
                    throw error
                }
                .tryMap { data -> T in
                    do {
                        // Try to decode the data into the expected type
                        let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                        return decodedResponse
                    } catch {
                        // Handle decoding error
                        print("Decoding failed with error: \(error)")
                        print("Raw Response Data: \(String(data: data, encoding: .utf8) ?? "Invalid data")")
                        throw APIError.decodingError
                    }
                }
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        }
}


//return URLSession.shared.dataTaskPublisher(for: request)
//    .tryMap { output in
//        guard let httpResponse = output.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//            throw APIError.invalidResponse
//        }
//        return output.data
//    }
//    .decode(type: T.self, decoder: JSONDecoder())
//    .receive(on: RunLoop.main)
//    .eraseToAnyPublisher()
