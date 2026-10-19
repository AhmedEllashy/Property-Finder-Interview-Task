//
//  NetworkService.swift
//  paratice-live-coding
//
//  Created by Ahmad Ellashy on 15/10/2026.
//
import Foundation

protocol NetworkServiceProtocol {
    func fetch<T: Codable>(request: APIRequest) async throws -> T
}

class NetworkService: NetworkServiceProtocol {
    var session: URLSession
    var decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    func fetch<T: Codable>(request: APIRequest) async throws -> T {
       let urlRequest = try createURLRequest(request: request)
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.invalidResponse }
        switch httpResponse.statusCode {
            
        case 200..<300 : break
        case 401: throw NetworkError.auth
        case 403: throw NetworkError.forbidden(message: "Access denied")
        default: throw NetworkError.badStatusCode
        }
        
        do {
            let response = try decoder.decode(T.self, from: data)
            return response
        } catch {
            // DecodingError's description already includes the coding path and context.
            print("Decoding \(T.self) failed:", error)
            throw NetworkError.decode
        }

    }
    
    private func createURLRequest(request: APIRequest) throws -> URLRequest {
 
        guard var components = URLComponents(
            string: request.baseURL
        ) else {
                  throw NetworkError.invalidURL
              }
        components.scheme = "https"
        components.path = components.path + request.path
        
        if let query = request.query, !query.isEmpty {
            components.queryItems = query.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        
        guard let url = components.url else { throw NetworkError.invalidURL }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        if let body = request.body, !body.isEmpty {
            let data = try JSONSerialization.data(withJSONObject: body)
            urlRequest.httpBody = data
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return urlRequest
    }
}

protocol APIRequest {
    var path: String { get }
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var query: [String: Any]? { get }
    var body: [String: Any]? { get }
}

extension APIRequest {
    var baseURL: String { "https://simplejsoncms.com/api" }
    var method: HTTPMethod { .GET }
    var query: [String: Any]? { nil }
    var body: [String: Any]? { nil }
}

enum HTTPMethod: String {
    case POST
    case GET
    case PUT
    case DELETE
}
