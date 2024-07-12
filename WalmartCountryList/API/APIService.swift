//
//  APIService.swift
//  WalmartCountryList
//
//  Created by Shobhakar on 7/10/24.
//

import Foundation

protocol APIServiceProtocol {
    var error: APIError? { get set }
    var url: String { get }
    func getData<T: Decodable>(urlString: String, dataType: T.Type) async throws -> T
}

extension APIServiceProtocol {
    func apiError(from response: URLResponse) -> APIError? {
        guard let urlResponse = response as? HTTPURLResponse else { return .badRequest }
        
        switch urlResponse.statusCode {
        case 200..<300:
            return nil
        default:
            return .badResponse(statusCode: urlResponse.statusCode)
        }
    }
}

final class APIService: APIServiceProtocol {
    
    let url =  CountryUrl.URLs.countriesURL
    var error: APIError?
    
    private init() {}
    static let shared = APIService()

    func getData<T: Decodable>(urlString: String, dataType: T.Type) async throws -> T where T : Decodable {
        guard let url = URL(string: urlString) else {
            throw APIError.badURL
        }
        
        let request = URLRequest(url: url)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw APIError.badResponse(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0)
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return decodedData
            } catch {
                throw APIError.decoderError
            }
        } catch {
            throw APIError.badRequest
        }
    }
}
