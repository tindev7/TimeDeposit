//
//  Fetcher.swift
//  TimeDeposit
//
//  Created by Martin Nugraha on 13/07/24.
//

import Foundation



final class Fetcher {
    
    func fetchTimeDeposit(completion: @escaping (Result<[TimeDepositModel], Error>) -> Void) {
        guard let url: URL = URL(string: URLConstants.timeDepositUrl) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(Response.self, from: data)
                completion(.success(decodedData.data))
            } catch let decodeError {
                completion(.failure(decodeError))
            }
        }
        
        task.resume()
    }
}
